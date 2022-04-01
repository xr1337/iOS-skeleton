//
//  AppTarget.swift
//  
//
//  Created by Sufiyan Yasa on 01/04/2022.
//

import Foundation

public enum AppTarget: String, CaseIterable {
  case app
  case safariExtension

  public static func currentAppTarget() -> AppTarget {
    let bundle = Bundle.main.bundleIdentifier
    switch bundle {
      case "[[CHANGEME]]" : return app
      case "[[CHANGEME]].Extension": return safariExtension
      default: return app
    }
  }
}

