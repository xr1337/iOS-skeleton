import UIKit

// A simple view controller as the root view.
// I prefer to add navigation/tabbars as a child to this viewcontroller
public class ViewController: UIViewController {

  public init() {
    super.init(nibName: nil, bundle: nil)
  }

  public required init?(coder: NSCoder) {
    fatalError()
  }

  public override func loadView() {
    let myView = UIView()
    myView.backgroundColor = .orange

    view = myView
  }

}

