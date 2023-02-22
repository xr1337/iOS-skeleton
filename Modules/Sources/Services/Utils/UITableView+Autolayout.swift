//
//  UITableView+Autolayout.swift
//
//  Created by Sufiyan Yasa on 25/11/2021.
//

import Foundation
import UIKit

public extension UITableView {
  
  func layoutTableHeaderView() {
    guard let headerView = tableHeaderView else { return }
    headerView.translatesAutoresizingMaskIntoConstraints = false
    
    let headerWidth = headerView.bounds.size.width
    let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]",
                                                                   metrics: ["width": headerWidth],
                                                                   views: ["headerView": headerView])
    
    layoutView(headerView, withTemporaryConstraints: temporaryWidthConstraints)
    headerView.translatesAutoresizingMaskIntoConstraints = true
  }
  
  func layoutTableFooterView() {
    guard let footerView = tableFooterView else { return }
    footerView.translatesAutoresizingMaskIntoConstraints = false
    
    let footerWidth = footerView.bounds.size.width
    let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[footerView(width)]",
                                                                   metrics: ["width": footerWidth],
                                                                   views: ["footerView": footerView])
    
    layoutView(footerView, isHeaderView: false, withTemporaryConstraints: temporaryWidthConstraints)
    footerView.translatesAutoresizingMaskIntoConstraints = true
  }
  
  private func layoutView(_ view: UIView, isHeaderView: Bool = true, withTemporaryConstraints widthConstraints: [NSLayoutConstraint]) {
    view.addConstraints(widthConstraints)
    
    view.setNeedsLayout()
    view.layoutIfNeeded()
    
    let headerHeight = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    
    var frame = view.frame
    frame.size.height = headerHeight
    view.frame = frame
    
    if isHeaderView {
      tableHeaderView = view
    } else {
      tableFooterView = view
    }
    
    view.removeConstraints(widthConstraints)
  }
}
