//
//  Bundle+Extension.swift
//
//  Created by Sufiyan Yasa on 01/12/2021.
//

import Foundation
import UIKit

public extension Bundle {
  
  public var icon: UIImage? {
    if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
       let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
       let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
       let lastIcon = iconFiles.last {
      return UIImage(named: lastIcon)
    }
    return nil
  }
}
