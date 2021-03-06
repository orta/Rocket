import Foundation
import Logger
import PackageConfig
import RocketLib
import Yams

let logger = Logger()

guard CommandLine.arguments.count > 1 else {
    logger.logError("You need to provive the version number that you want release")
    exit(1)
}

let version = CommandLine.arguments[1]

var stepsDictionary: [String: Any]!

if let rocketYamlPath = RocketFileFinder.rocketFilePath() {
    let string = try String(contentsOfFile: rocketYamlPath)
    guard let loadedDictionary = try Yams.load(yaml: string) as? [String: Any] else {
        logger.logError("Invalid YAML")
        exit(1)
    }

    stepsDictionary = loadedDictionary
} else if let rocketConfig = getPackageConfig()["rocket"] as? [String: Any] {
    stepsDictionary = rocketConfig
} else {
    logger.logError("Steps not found")
}

let versionExporter = VersionExporter()
versionExporter.exportVersion(version)

let stepExecutors = StepsParser.parseSteps(fromDictionary: stepsDictionary, logger: logger)
stepExecutors.forEach { $0.executeStep(version: version, logger: logger) }
