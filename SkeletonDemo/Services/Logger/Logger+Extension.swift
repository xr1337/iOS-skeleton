//
//  Logger+Extension.swift
//  WebsiteUpWidget
//
//  Created by Sufiyan Yasa on 20/07/2021.
//

import Foundation
import os

extension Logger {
  private static var subsystem = "[[CHANGEME]]"

  static let app = Logger(subsystem: subsystem, category: "UI")
  static let database = Logger(subsystem: subsystem, category: "Persistence")
  static let network = Logger(subsystem: subsystem, category: "Network")
  static let widget = Logger(subsystem: subsystem, category: "Widget")
  static let watch = Logger(subsystem: subsystem, category: "Watch")
}
