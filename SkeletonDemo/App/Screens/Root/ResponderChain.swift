//
//  ResponderChain.swift
//
//  Created by Sufiyan Yasa on 19/07/2021.
//

import Foundation
import UIKit

extension UIResponder {

  @objc func openSettings() {
    guard let next = next else {
      assertionFailure("⚠️ Unhandled action: \(#function), Last responder: \(self)")
      return
    }
    next.openSettings()
  }
}
