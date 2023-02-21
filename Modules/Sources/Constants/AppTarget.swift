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
    let bundle = Bundle.main.bundleIdentifier?.lowercased()
    switch bundle {
    case Constants.App.bundleID : return app
    case "\(Constants.App.bundleID).Extension": return safariExtension
    default:
      fatalError("Wrong or missing bundle identifier for target")
    }
  }
}

