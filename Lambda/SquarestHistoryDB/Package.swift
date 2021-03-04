// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SquarestHistoryDB",
	platforms: [
		.macOS(.v10_13),
	],
	products: [
		.executable(name: "SquarestHistoryDB", targets: ["SquarestHistoryDB"]),
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		// .package(url: /* package url */, from: "1.0.0"),
		.package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .upToNextMajor(from: "0.2.0")),
		.package(name: "AWSSDKSwift", url: "https://github.com/swift-aws/aws-sdk-swift.git", from: "4.0.0")
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages which this package depends on.
		.target(
			name: "SquarestHistoryDB",
			dependencies: [
				.product(name: "DynamoDB", package: "AWSSDKSwift"),
				.product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
				.product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime")
			]),
	]
)
