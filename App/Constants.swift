//
//  Constants.swift

// swiftlint:disable line_length

import Foundation

public enum AppTarget: String, CaseIterable {
  case app
  case safariExtension

  static func currentAppTarget() -> AppTarget {
    let bundle = Bundle.main.bundleIdentifier
    switch bundle {
      case "[[CHANGEME]]" : return app
      case "[[CHANGEME]].Extension": return safariExtension
      default: return app
    }
  }
}

enum Constants {
  enum App {
    static var feedbackLink = "mailto:me@sufiyanyasa.com?subject=[[CHANGEME]]"
    static var storeURL = "[[CHANGEME]]"
    static var privacyURL = "[[CHANGEME]]"
    static var tocURL = "[[CHANGEME]]"
  }

  enum RevenueCat {
  }

  enum Persistence {
    static var AppGroupID = "[[CHANGEME]]"
    static var sqllite = "[[CHANGEME]].sqlite"
    static var container = "[[CHANGEME]]"
  }

  enum DeepLink {
    static var scheme = "[[CHANGEME]]"
  }
}
