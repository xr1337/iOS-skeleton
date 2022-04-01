//
//  UserDefaultsBackedCloud.swift
//  WebsiteUpWidget
//
//  Created by Sufiyan Yasa on 25/07/2021.
//

import Foundation
import os
import Constants
import Logger

class UserDefaultsBackedCloud {
  static let shared = UserDefaultsBackedCloud()

  private init() {
    // register updates on cloud
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(ubiquitousKeyValueStoreDidChange(_:)),
                                           name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                           object: NSUbiquitousKeyValueStore.default)

    if NSUbiquitousKeyValueStore.default.synchronize() == false {
      #if DEBUG
      fatalError("This app was not built with the proper entitlement requests.")
      #endif
    }
  }

  @objc
  func ubiquitousKeyValueStoreDidChange(_ notification: Notification) {
    Logger.app.info("User preference changes [\(notification, privacy: .public)]")
    guard let userInfo = notification.userInfo else { return }
    guard let reasonForChange = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int else { return }
    guard let keys = userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] else { return }

    for key in keys {
      let valueItem = NSUbiquitousKeyValueStore.default.object(forKey: key )
      Logger.app.info("User preference reasonForChange: \(reasonForChange, privacy: .public) ")
      Logger.app.info("User preference value changes [\(key, privacy: .public)]")

      let storage = UserDefaults.init(suiteName: Constants.Persistence.AppGroupID) ?? .standard
      storage.setValue(valueItem, forKey: key)
    }
  }
}
