//
//  Persistence.swift
//
//  Created by Sufiyan Yasa on 08/09/2021.
//

import Constants
import CoreData
import Foundation
import SYDarwinNotification
import os
import SYLogger

extension DarwinNotification.Name {
  static let didUpdateStoreEvent: DarwinNotification.Name = .init("[[CHANGME]].didUpdateStoreEvent")
}

class AppGroupPersistentContainer: NSPersistentCloudKitContainer {
  #if os(iOS)
    // app group only works on iOS
    override open class func defaultDirectoryURL() -> URL {
      let identifier = Constants.Persistence.AppGroupID
      var storeURL = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: identifier)
      storeURL = storeURL?.appendingPathComponent(Constants.Persistence.sqllite)
      return storeURL!
    }
  #endif
}

public final class Persistence {

  public static let shared = Persistence()

  // MARK: - Core Data stack
  let persistentContainer: NSPersistentCloudKitContainer
  let persistentHistoryObserver: PersistentHistoryObserver
  let appTarget = AppTarget.currentAppTarget()

  static func createPersistentCoordinator(inMemory: Bool) -> NSPersistentCloudKitContainer {
    let container = AppGroupPersistentContainer(name: Constants.Persistence.container)
    if let storeDescription = container.persistentStoreDescriptions.first {
      storeDescription.setOption(
        true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
      storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
      if inMemory {
        storeDescription.url = URL(fileURLWithPath: "/dev/null")
        storeDescription.shouldAddStoreAsynchronously = false
      }
    }
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        Logger.database.error(
          "Unresolved error \(error, privacy: .public), \(error.userInfo, privacy: .public)")
        #if DEBUG
          fatalError("Unresolved error \(error), \(error.userInfo)")
        #endif
      }
    })
    return container
  }

  var context: NSManagedObjectContext {
    let context = persistentContainer.viewContext
    context.transactionAuthor = appTarget.rawValue
    context.name = "view_context"
    return context
  }

  init(inMemory: Bool = false) {
    persistentContainer = Self.createPersistentCoordinator(inMemory: inMemory)
    Logger.database.info(
      "Creating history observer for \(self.appTarget.rawValue, privacy: .public)")
    persistentHistoryObserver = .init(
      target: appTarget, persistentContainer: persistentContainer,
      userDefaults: UserDefaults.standard)
    persistentHistoryObserver.startObserving()
  }

  @objc
  func eventDidChange(item: Notification) {
    Logger.database.info("event did change \(item, privacy: .public)")
  }

  // MARK: - Core Data Saving support

  public func saveContext() {
    Logger.database.debug("\(#function, privacy: .public)")
    guard context.hasChanges else {
      return
    }
    do {
      try context.save()
      Logger.database.debug("\(#function, privacy: .public) saved")
    } catch {
      let nserror = error as NSError
      Logger.database.error(
        "Unresolved error \(nserror, privacy: .public), \(nserror.userInfo, privacy: .public)")
      #if DEBUG
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      #endif
    }
  }
}
