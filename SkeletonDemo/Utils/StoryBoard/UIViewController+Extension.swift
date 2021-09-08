//
//  UIViewController+Extension.swift
//
//  Created by Sufiyan Yasa on 13/07/2021.
//

import UIKit

// swiftlint:disable force_cast
extension UIViewController {
  static func loadFrom<T>(storyBoardName: String, identifier: String) -> T {
    let vcStoryBord = UIStoryboard.init(name: storyBoardName, bundle: nil)
    let viewController = vcStoryBord.instantiateViewController(identifier: identifier)
    return viewController as! T
  }
}
// swiftlint:enable force_cast

extension UIViewController {

  func setLargeTitleDisplayMode(_ largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode) {
    switch largeTitleDisplayMode {
    case .automatic:
      guard let navigationController = navigationController else { break }
      if let index = navigationController.children.firstIndex(of: self) {
        setLargeTitleDisplayMode(index == 0 ? .always : .never)
      } else {
        setLargeTitleDisplayMode(.always)
      }
    case .always, .never:
      navigationItem.largeTitleDisplayMode = largeTitleDisplayMode
      // Even when .never, needs to be true otherwise animation will be broken on iOS11, 12, 13
      navigationController?.navigationBar.prefersLargeTitles = true
    @unknown default:
      assertionFailure("\(#function): Missing handler for \(largeTitleDisplayMode)")
    }
  }
}
