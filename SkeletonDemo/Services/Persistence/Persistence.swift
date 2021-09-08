//
//  Persistence.swift
//
//  Created by Sufiyan Yasa on 08/09/2021.
//

import Foundation
import CoreData
import os

extension NSNotification.Name {
  
}

class AppGroupPersistentContainer: NSPersistentCloudKitContainer {
  #if os(iOS)
  // app group only works on iOS
  override open class func defaultDirectoryURL() -> URL {
    let identifier = Constants.Persistence.AppGroupID
    var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)
    storeURL = storeURL?.appendingPathComponent(Constants.Persistence.sqllite)
    return storeURL!
  }
  #endif
}

final class Persistence {

  static let shared = Persistence()

  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentCloudKitContainer = {
    let container = AppGroupPersistentContainer(name: Constants.Persistence.container)
    if let storeDescription = container.persistentStoreDescriptions.first {
      storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
    }
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        Logger.database.error("Unresolved error \(error, privacy: .public), \(error.userInfo, privacy: .public)")
        #if DEBUG
        fatalError("Unresolved error \(error), \(error.userInfo)")
        #endif
      }
    })
    return container
  }()

  var context: NSManagedObjectContext {
    let context = persistentContainer.viewContext
    context.automaticallyMergesChangesFromParent = true
    context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    return context
  }

  private init() {
    NotificationCenter.default.addObserver(self, selector: #selector(eventDidChange),
                                           name: NSPersistentCloudKitContainer.eventChangedNotification, object: nil)
  }

  @objc
  func eventDidChange(item: Notification) {
    Logger.database.info("event did change \(item, privacy: .public)")
  }

  // MARK: - Core Data Saving support

  func saveContext() {
    Logger.database.debug("\(#function, privacy: .public)")
    guard context.hasChanges else {
      return
    }
    if context.hasChanges {
      do {
        try context.save()
        Logger.database.debug("\(#function, privacy: .public) saved")
      } catch {
        let nserror = error as NSError
        Logger.database.error("Unresolved error \(nserror, privacy: .public), \(nserror.userInfo, privacy: .public)")
        #if DEBUG
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        #endif
      }
    }
  }
}
