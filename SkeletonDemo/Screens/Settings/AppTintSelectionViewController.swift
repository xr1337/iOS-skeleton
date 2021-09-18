//
//  AppTintSelectionViewController.swift
//  ProductBarcodeScanner
//
//  Created by Sufiyan Yasa on 17/09/2021.
//

import Foundation
import UIKit
import OrderedCollections
import SwifterSwift

#if DEBUG
import SwiftUI
import PreviewView

struct AppTintSelectionVC_Previews: PreviewProvider {
  static var previews: some View {
    NavigationControllerPreview {
      return [viewController]
    }
    .edgesIgnoringSafeArea(.all)
    .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
  }
  
  static var viewController: UIViewController {
    AppTintSelectionViewController()
  }
}
#endif

enum AppTint {
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

class AppTintSelectionViewController: UIViewController {
  
  @UserDefaultsBacked(key: AppTint.settingsKey)
  var currentTintColor: String = "Blue"
  
  var selectionTableView: UITableView!
  
  override func loadView() {
    super.loadView()
    let view = UIView()
    selectionTableView = UITableView(frame: .zero, style: .insetGrouped)
    view.addSubview(selectionTableView)
    self.view = view
    
    selectionTableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    selectionTableView.delegate = self
    selectionTableView.dataSource = self
    selectionTableView.register(cellWithClass: UITableViewCell.self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    title = "App Tint"
  }
}

extension AppTintSelectionViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let key = AppTint.colors.keys[indexPath.row]
    tableView.visibleCells.forEach { $0.accessoryType = .none}
    let data = AppTint.colors[key]
    if let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = scenes.windows.first {
      window.tintColor = data
    }
    currentTintColor = key
    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
  }
}

extension AppTintSelectionViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    AppTint.colors.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self)
    let key = AppTint.colors.keys[indexPath.row]
    let color = AppTint.colors[key]
    let image = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate)
    cell.imageView?.image = image
    cell.textLabel?.text = key
    cell.tintColor = color
    cell.accessoryType = key == currentTintColor ? .checkmark: .none
    cell.selectionStyle = .none
    return cell
  }

}
