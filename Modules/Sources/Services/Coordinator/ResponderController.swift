//
//  ResponderController.swift
//
//  Created by Sufiyan Yasa on 14/07/2021.
//

import Foundation
import UIKit

/// A Box object that wraps Swift value types for Responder chain transport
public class ResponderBox: NSObject {
  @nonobjc private let value: Any

  @nonobjc public init<T>(_ value: T) {
    self.value = value
    super.init()
  }

  @nonobjc public func value<T>(_: T.Type = T.self) -> T {
    guard let value = value as? T else {
      fatalError("Invalid value. Expected \(T.self), found \(type(of: self.value))")
    }

    return value
  }
}

/// A mediate viewcontroller that links responder chains between modal VCs
class ResponderController: UIViewController {
  private let nextOverride: UIResponder
  private let child: UIViewController

  init(containing: UIViewController, nextResponder: UIResponder) {
    self.nextOverride = nextResponder
    self.child = containing
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    addChild(child)
    view.addSubview(child.view)

    child.view.frame = view.bounds
    child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    child.didMove(toParent: self)
  }
  override var next: UIResponder? {
    return nextOverride
  }
}

extension UIViewController {
  /// Wrap modals within ResponderController to ensure responder chain is linked
  func presentModal(_ viewControllerToPresent: UIViewController, animated flag: Bool,
                    modalPresentationStyle: UIModalPresentationStyle = .automatic, completion: (() -> Void)? = nil) {
    let wrapper = ResponderController(containing: viewControllerToPresent, nextResponder: self)
    wrapper.modalPresentationStyle = modalPresentationStyle
    present(wrapper, animated: flag, completion: completion)
  }
  
  func presentModalSheet(_ viewControllerToPresent: UIViewController, animated flag: Bool,
                         configurationHandler: ((inout UISheetPresentationController) -> Void)? = nil, completion: (() -> Void)? = nil) {
    let wrapper = ResponderController(containing: viewControllerToPresent, nextResponder: self)
    if var sheet = wrapper.sheetPresentationController {
      if let configurationHandler = configurationHandler {
        configurationHandler(&sheet)
      } else {
        sheet.detents = [.medium(), .large()]
        sheet.largestUndimmedDetentIdentifier = .medium
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.prefersEdgeAttachedInCompactHeight = true
        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        sheet.prefersGrabberVisible = true
      }
      
    }
    present(wrapper, animated: flag, completion: completion)
  }

}
