//
//  Constants.swift

// swiftlint:disable line_length

import Foundation

public enum Constants {
  public enum App {}
  public enum RevenueCat {}
  public enum Persistence {}
  public enum DeepLink {}
}

public extension Constants.App {
  static var feedbackLink = "mailto:me@sufiyanyasa.com?subject=[[CHANGEME]]"
  static var storeURL = "[[CHANGEME]]"
  static var privacyURL = "[[CHANGEME]]"
  static var tocURL = "[[CHANGEME]]"
}

public extension Constants.Persistence {
  static var AppGroupID = "[[CHANGEME]]"
  static var sqllite = "[[CHANGEME]].sqlite"
  static var container = "[[CHANGEME]]"
}

public extension Constants.DeepLink {
  static var scheme = "[[CHANGEME]]"
}
