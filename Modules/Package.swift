// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swifterSwift = Target.Dependency.product(name: "SwifterSwift", package: "SwifterSwift")
let swiftCollections = Target.Dependency.product(name: "OrderedCollections", package: "swift-collections")

let constants = BuildItem(name: "Constants")
let darwinNotification = BuildItem(service: "DarwinNotification", dependencies: [constants.asDependency])
let services = [
  constants,
  BuildItem(service: "UserDefaultsBacked", dependencies: [constants.asDependency]),
  BuildItem(service: "Logger"),
  darwinNotification,
  BuildItem(service: "Coordinator"),
  BuildItem(service: "Persistence", dependencies: [darwinNotification.asDependency]),
]

let modelAppearance = BuildItem(model: "Appearance", dependencies:[swiftCollections])
let models = [
  modelAppearance
]

let featureSettings = BuildItem(feature: "Settings", dependencies:[swifterSwift, modelAppearance.asDependency])
let features = [
  featureSettings
]


let package = Package(
  name: "SkeletonDemo",
  platforms: [
    .iOS(.v15)
  ],
  products: [services, models, features].flatMap { $0 }.map(\.library),
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "https://github.com/SwifterSwift/SwifterSwift.git", branch: "master"),
    .package(url: "https://github.com/apple/swift-collections", branch: "main"),
  ],
  targets: [services, features, models].flatMap{ $0 }.map(\.target)
)

struct BuildItem {
  let name: String
  let asDependency: Target.Dependency
  let dependencies: [Target.Dependency]
  let resources: [Resource]
  let path: String?
  
  init(name: String, path: String? = nil, dependency: Target.Dependency? = nil, dependencies: [Target.Dependency] = [], resources: [Resource] = []) {
    self.name = name
    self.path = path
    self.asDependency = dependency ?? .init(stringLiteral: name)
    self.dependencies = dependencies
    self.resources = resources
  }
  
  init(service: String, dependencies: [Target.Dependency] = [], resources: [Resource] = []) {
    self.init(name: service, path: "Sources/Services/\(service)", dependencies: dependencies, resources: resources)
  }
  init(feature: String, dependencies: [Target.Dependency] = [], resources: [Resource] = []) {
    self.init(name: "Feature\(feature)", path: "Sources/Features/\(feature)", dependencies: dependencies, resources: resources)
  }
  init(model: String, dependencies: [Target.Dependency] = [], resources: [Resource] = []) {
    self.init(name: "Model\(model)", path: "Sources/Models/\(model)", dependencies: dependencies, resources: resources)
  }
  
  var library: Product {
    Product.library(name: name, targets: [name])
  }
  var target: Target {
    Target.target(name: name, dependencies: dependencies, path: path, resources: resources)
  }
  var testTarget: Target {
    Target.testTarget(name: name, dependencies: dependencies, path: path, resources: resources)
  }
}

