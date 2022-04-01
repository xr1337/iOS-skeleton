//
//  AppTint.swift
//  
//
//  Created by Sufiyan Yasa on 01/04/2022.
//

import Foundation
import OrderedCollections
import UIKit

public enum AppTint {}

public extension AppTint {
  static let settingsKey = "AppTint"
  static let colors: OrderedDictionary<String, UIColor> = [
    "Red": .systemRed,
    "Pink": .systemPink,
    "Blue": .systemBlue,
    "Teal": .systemTeal,
    "Yellow": .systemYellow,
    "Orange": .systemOrange,
    "Green": .systemGreen,
    "Purple": .systemPurple,
    "Indigo": .systemIndigo,
    "Gray": .systemGray,
    "Primary": .label,
    "Secondary": .secondaryLabel,
    "Tertiary": .tertiaryLabel
  ]
}
