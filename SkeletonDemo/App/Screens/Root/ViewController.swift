//
//  ViewController.swift
//  SkeletonDemo
//
//  Created by Sufiyan Yasa on 08/09/2021.
//

import UIKit

#if DEBUG
import SwiftUI
import PreviewView

struct Root_Previews: PreviewProvider {
  static var previews: some View {
    ViewControllerPreview(ViewController())
      .edgesIgnoringSafeArea(.all)
      .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
  }
}
#endif


// A simple view controller as the root view.
// I prefer to add navigation/tabbars as a child to this viewcontroller
class ViewController: UIViewController {
  
  override func loadView() {
    let myView = UIView()
    myView.backgroundColor = .red
    view = myView
  }

}

