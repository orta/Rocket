import Logger
import Foundation

final class TagExecutor: DefaultExecutor<TagParameters> {
    override func executeStep(version: String, logger: Logger) {        
        launchScript(content: "git tag \(version)", errorMessage: "Tag step failed with error", logger: logger)
    }
}
