//
//  AppIconSelectionViewController.swift
//  ProductBarcodeScanner
//
//  Created by Sufiyan Yasa on 18/09/2021.
//

import Foundation
import UIKit
import SwifterSwift

#if DEBUG
import SwiftUI
import PreviewView

struct AppIconSelector_Previews: PreviewProvider {
  static var previews: some View {
    NavigationControllerPreview {
      return [viewController]
    }
    .edgesIgnoringSafeArea(.all)
    .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
  }
  
  static var viewController: UIViewController {
    return AppIconSelectionViewController()
  }
}
#endif

class AppIconSelectionViewController: UIViewController {
  
  var iconCollectionView: UICollectionView!
  
  override func loadView() {
    let myView = UIView()
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumInteritemSpacing = 0
    flowLayout.minimumLineSpacing = 12
    flowLayout.scrollDirection = .vertical
    iconCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    myView.addSubview(iconCollectionView)
    iconCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    iconCollectionView.delegate = self
    iconCollectionView.dataSource = self
    iconCollectionView.register(cellWithClass: UICollectionViewCell.self)
    iconCollectionView.backgroundColor = .systemBackground
    view = myView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Change App Icon"
  }
  
}

extension AppIconSelectionViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.visibleCells.forEach { $0.isSelected = false}
    if UIApplication.shared.supportsAlternateIcons {
      let iconName = indexPath.row == 0 ? nil : "AppIcon-\(indexPath.row)"
      UIApplication.shared.setAlternateIconName(iconName)
    }
  }
}

extension AppIconSelectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = view.bounds.width
    return CGSize(width: (screenWidth/3)-6, height: (screenWidth/3)-6)
  }
}

extension AppIconSelectionViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    9
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withClass: UICollectionViewCell.self, for: indexPath)
    
    let iconView = UIImageView(image: UIImage(named: "AppIcon-\(indexPath.row)"))
    cell.backgroundView = iconView
    
    let selectedBackgroundView = UIView()
    let checkMark = UIImageView(image: .init(systemName: "checkmark.square.fill"))
    checkMark.autoresizingMask = [.flexibleRightMargin]
    selectedBackgroundView.addSubview(checkMark)
    selectedBackgroundView.tintColor = .black
    selectedBackgroundView.backgroundColor = .clear
    selectedBackgroundView.layer.borderWidth = 5
    selectedBackgroundView.layer.borderColor = UIColor.black.cgColor
    cell.selectedBackgroundView = selectedBackgroundView
    
    return cell
  }
  
}
