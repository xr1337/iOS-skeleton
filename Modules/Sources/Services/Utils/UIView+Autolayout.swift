//
//  UIView+Autolayout.swift
//  ReaderSafari
//
//  Created by sufiyan yasa on 21/11/2021.
//

import Foundation
import UIKit

public extension UIView {
  @discardableResult
  func anchorByLanguage(
    top: NSLayoutYAxisAnchor? = nil,
    leading: NSLayoutXAxisAnchor? = nil,
    bottom: NSLayoutYAxisAnchor? = nil,
    trailing: NSLayoutXAxisAnchor? = nil,
    topConstant: CGFloat = 0,
    leadingConstant: CGFloat = 0,
    bottomConstant: CGFloat = 0,
    trailingConstant: CGFloat = 0,
    widthConstant: CGFloat = 0,
    heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
      // https://videos.letsbuildthatapp.com/
      translatesAutoresizingMaskIntoConstraints = false

      var anchors = [NSLayoutConstraint]()

      if let top = top {
        anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
      }

      if let leading = leading {
        anchors.append(leadingAnchor.constraint(equalTo: leading, constant: leadingConstant))
      }

      if let bottom = bottom {
        anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
      }

      if let trailing = trailing {
        anchors.append(trailingAnchor.constraint(equalTo: trailing, constant: -trailingConstant))
      }

      if widthConstant > 0 {
        anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
      }

      if heightConstant > 0 {
        anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
      }

      anchors.forEach { $0.isActive = true }

      return anchors
    }

}
