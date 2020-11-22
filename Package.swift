// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "swift-httpcookie-codable",
  products: [
    .library(name: "HttpCookieCodable", targets: ["HttpCookieCodable"]),
  ],
  targets: [
    .target(name: "HttpCookieCodable"),
    .testTarget(
      name: "HttpCookieCodableTests",
      dependencies: ["HttpCookieCodable"]
    ),
  ]
)
