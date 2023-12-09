//
//  ViewController.swift
//  SkeletonDemo
//
//  Created by Sufiyan Yasa on 08/09/2021.
//

import UIKit
import Inject

// A simple view controller as the root view.
// I prefer to add navigation/tabbars as a child to this viewcontroller
class ViewController: UIViewController {
  
  override func loadView() {
    let myView = UIView()
    myView.backgroundColor = .orange

    view = myView
  }

}

