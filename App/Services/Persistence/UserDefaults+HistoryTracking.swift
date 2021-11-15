//
//  UserDefaults+HistoryTracking.swift
//  CookieCleaner
//
//  Created by sufiyan yasa on 04/11/2021.
//

import Foundation

extension UserDefaults {

  func lastHistoryTransactionTimestamp(for target: AppTarget) -> Date? {
    let key = "lastHistoryTransactionTimeStamp-\(target.rawValue)"
    return object(forKey: key) as? Date
  }

  func updateLastHistoryTransactionTimestamp(for target: AppTarget, to newValue: Date?) {
    let key = "lastHistoryTransactionTimeStamp-\(target.rawValue)"
    set(newValue, forKey: key)
  }

  func lastCommonTransactionTimestamp(in targets: [AppTarget]) -> Date? {
    let timestamp = targets
      .map { lastHistoryTransactionTimestamp(for: $0) ?? .distantPast }
      .min() ?? .distantPast
    return timestamp > .distantPast ? timestamp : nil
  }
}
