//
//  Logger+Extension.swift
//  WebsiteUpWidget
//
//  Created by Sufiyan Yasa on 20/07/2021.
//

import Foundation
import os
import OSLog

public extension Logger {
  private static var subsystem = "[[CHANGEME]]"
  
  static let app = Logger(subsystem: subsystem, category: "UI")
  static let database = Logger(subsystem: subsystem, category: "Persistence")
  static let network = Logger(subsystem: subsystem, category: "Network")
  static let widget = Logger(subsystem: subsystem, category: "Widget")
  static let watch = Logger(subsystem: subsystem, category: "Watch")
  
  static func getLogEntries() throws -> [OSLogEntryLog] {
    // Open the log store.
    let logStore = try OSLogStore(scope: .currentProcessIdentifier)
    // Get all the logs from the last hour.
    let oneHourAgo = logStore.position(date: Date().addingTimeInterval(-3600))
    let allEntries = try logStore.getEntries(at: oneHourAgo)
    
    // Filter the log to be relevant for our specific subsystem
    // and remove other elements (signposts, etc).
    return allEntries
      .compactMap { $0 as? OSLogEntryLog }
      .filter { $0.subsystem == subsystem }
  }
}

