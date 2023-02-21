// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Builders

typealias Features = [String: [Target.Dependency]]
struct SetupGroup: Builder {
  var prefixPath: String = ""
  var sourcePath: String = "Sources"
  var testSourcePath: String = "Tests"
  var items: Features = [:]
  var testItems: Features = [:]
  var mockItems: Features = [:]
}

protocol Builder {
  var prefixPath: String { get }
  var sourcePath: String { get }
  var testSourcePath: String { get }
  var items: Features { get }
  var testItems: Features { get }
  var mockItems: Features { get }
}

extension Builder {
  func makeProducts() -> [Product] {
    items.keys.map {
      .library(
        name: "\(prefixPath)\($0)",
        targets: ["\(prefixPath)\($0)"])
    }
  }
  
  func makeTargets() -> [Target] {
    items.enumerated().map { _, tuple in
      let name = "\(prefixPath)\(tuple.key)"
      return Target.target(
        name: name,
        dependencies: tuple.value,
        path: "\(sourcePath)/\(tuple.key)",
        resources: [])
    }
  }
  
  func makeTestTargets() -> [Target] {
    testItems.enumerated().map { _, tuple in
      let name = "\(prefixPath)\(tuple.key)"
      return Target.testTarget(
        name: name,
        dependencies: tuple.value,
        path: "\(testSourcePath)/\(tuple.key)",
        resources: [])
    }
  }
  
  func makeMockProducts() -> [Product] {
    mockItems.keys.map {
      .library(
        name: "\(prefixPath)\($0)Mock",
        targets: ["\(prefixPath)\($0)Mock"])
    }
  }
  
  func makeMockTargets() -> [Target] {
    mockItems.enumerated().map { _, tuple in
      let name = "\(prefixPath)\(tuple.key)Mock"
      return Target.target(
        name: name,
        dependencies: tuple.value + [],
        path: "Tests/Mocks/\(tuple.key)",
        resources: [])
    }
  }
}

// MARK: - 3rd party dependencies
let swifterSwift = Target.Dependency.product(name: "SwifterSwift", package: "SwifterSwift")
let swiftCollections = Target.Dependency.product(name: "OrderedCollections", package: "swift-collections")
let previewView = Target.Dependency.product(name: "PreviewView", package: "PreviewView")

// MARK: - Package Setup
let commonSetup = SetupGroup(items: [
  "Constants": []
])

let serviceGroup = SetupGroup(
  sourcePath: "Sources/Services",
  items: [
    "DarwinNotification": ["Constants"],
    "UserDefaultsBacked": ["Constants"],
    "Logger": [],
    "Coordinator": [],
    "Persistence": ["DarwinNotification"],
  ]
)
let modelGroup = SetupGroup(
  prefixPath: "Model",
  sourcePath: "Sources/Models",
  items: [
    "Appearance": [swiftCollections]
  ]
)
let featureGroup = SetupGroup(
  prefixPath: "Feature",
  sourcePath: "Sources/Features",
  items:[
    "Settings": ["ModelAppearance", swifterSwift]
  ]
)

let allModules = [commonSetup, serviceGroup, modelGroup, featureGroup]
let products = allModules.flatMap { $0.makeProducts() }
let targets = allModules.flatMap {$0.makeTargets()} + allModules.flatMap { $0.makeTestTargets() }

let package = Package(
  name: "SkeletonDemo",
  platforms: [
    .iOS(.v16)
  ],
  products: products,
  dependencies: [
    .package(url: "https://github.com/SwifterSwift/SwifterSwift.git", branch: "master"),
    .package(url: "https://github.com/apple/swift-collections", branch: "main"),
    .package(url: "https://github.com/theoriginalbit/PreviewView", branch: "main")
  ],
  targets: targets
)
