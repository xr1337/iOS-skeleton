//
//  PersistentHistoryObserver.swift
//  CookieCleaner
//
//  Created by sufiyan yasa on 04/11/2021.
//

import Foundation
import CoreData
import os
// Mark :- Observer
public final class PersistentHistoryObserver {

  private let target: AppTarget
  private let userDefaults: UserDefaults
  private let persistentContainer: NSPersistentContainer

  /// An operation queue for processing history transactions.
  private lazy var historyQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()

  public init(target: AppTarget, persistentContainer: NSPersistentContainer, userDefaults: UserDefaults) {
    self.target = target
    self.userDefaults = userDefaults
    self.persistentContainer = persistentContainer
  }

  public func startObserving() {
    NotificationCenter.default.addObserver(self, selector: #selector(processStoreRemoteChanges), name: .NSPersistentStoreRemoteChange, object: persistentContainer.persistentStoreCoordinator)
  }

  /// Process persistent history to merge changes from other coordinators.
  @objc private func processStoreRemoteChanges(_ notification: Notification) {
    historyQueue.addOperation { [weak self] in
      self?.processPersistentHistory()
    }
  }

  @objc private func processPersistentHistory() {
    let context = persistentContainer.newBackgroundContext()
    context.performAndWait {
      do {
        let merger = PersistentHistoryMerger(backgroundContext: context, viewContext: persistentContainer.viewContext, currentTarget: target, userDefaults: userDefaults)
        try merger.merge()

        let cleaner = PersistentHistoryCleaner(context: context, targets: AppTarget.allCases, userDefaults: userDefaults)
        try cleaner.clean()
      } catch {
        Logger.database.error("Persistent History Tracking failed with error \(error.localizedDescription, privacy: .public)")
      }
    }
  }
}

struct PersistentHistoryMerger {

  let backgroundContext: NSManagedObjectContext
  let viewContext: NSManagedObjectContext
  let currentTarget: AppTarget
  let userDefaults: UserDefaults

  func merge() throws {
    let fromDate = userDefaults.lastHistoryTransactionTimestamp(for: currentTarget) ?? .distantPast
    let fetcher = PersistentHistoryFetcher(context: backgroundContext, fromDate: fromDate)
    let history = try fetcher.fetch()

    guard !history.isEmpty else {
      Logger.database.info("No history transactions found to merge for target \(currentTarget.rawValue, privacy: .public)")
      return
    }

    Logger.database.debug("Merging \(history.count) persistent history transactions for target \(currentTarget.rawValue, privacy: .public)")

    history.merge(into: backgroundContext)

    viewContext.perform {
      history.merge(into: self.viewContext)
    }

    guard let lastTimestamp = history.last?.timestamp else { return }
    userDefaults.updateLastHistoryTransactionTimestamp(for: currentTarget, to: lastTimestamp)
  }
}

struct PersistentHistoryFetcher {

  enum Error: Swift.Error {
    /// In case that the fetched history transactions couldn't be converted into the expected type.
    case historyTransactionConvertionFailed
  }

  let context: NSManagedObjectContext
  let fromDate: Date

  func fetch() throws -> [NSPersistentHistoryTransaction] {
    let fetchRequest = createFetchRequest()

    guard let historyResult = try context.execute(fetchRequest) as? NSPersistentHistoryResult, let history = historyResult.result as? [NSPersistentHistoryTransaction] else {
      throw Error.historyTransactionConvertionFailed
    }

    return history
  }

  func createFetchRequest() -> NSPersistentHistoryChangeRequest {
    let historyFetchRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: fromDate)

    if let fetchRequest = NSPersistentHistoryTransaction.fetchRequest {
      var predicates: [NSPredicate] = []

      if let transactionAuthor = context.transactionAuthor {
        /// Only look at transactions created by other targets.
        predicates.append(NSPredicate(format: "%K != %@", #keyPath(NSPersistentHistoryTransaction.author), transactionAuthor))
      }
      if let contextName = context.name {
        /// Only look at transactions not from our current context.
        predicates.append(NSPredicate(format: "%K != %@", #keyPath(NSPersistentHistoryTransaction.contextName), contextName))
      }

      fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
      historyFetchRequest.fetchRequest = fetchRequest
    }

    return historyFetchRequest
  }
}

struct PersistentHistoryCleaner {

  let context: NSManagedObjectContext
  let targets: [AppTarget]
  let userDefaults: UserDefaults

  /// Cleans up the persistent history by deleting the transactions that have been merged into each target.
  func clean() throws {
    guard let timestamp = userDefaults.lastCommonTransactionTimestamp(in: targets) else {
      Logger.database.debug("Cancelling deletions cleanup as there is no common transaction timestamp")
      return
    }

    let deleteHistoryRequest = NSPersistentHistoryChangeRequest.deleteHistory(before: timestamp)
    Logger.database.debug("Deleting persistent history using common timestamp \(timestamp, privacy: .public)")
    try context.execute(deleteHistoryRequest)

    targets.forEach { target in
      /// Reset the dates as we would otherwise end up in an infinite loop.
      userDefaults.updateLastHistoryTransactionTimestamp(for: target, to: nil)
    }
  }
}

extension Collection where Element == NSPersistentHistoryTransaction {

  /// Merges the current collection of history transactions into the given managed object context.
  /// - Parameter context: The managed object context in which the history transactions should be merged.
  func merge(into context: NSManagedObjectContext) {
    forEach { transaction in
      guard let userInfo = transaction.objectIDNotification().userInfo else { return }
      NSManagedObjectContext.mergeChanges(fromRemoteContextSave: userInfo, into: [context])
    }
  }
}
