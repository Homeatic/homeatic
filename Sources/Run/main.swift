import WebFront
import Library
import Files
import Foundation
let arguments = CommandLine.arguments

let folderPath: String = {
    if arguments.count > 1 {
        return arguments[1]
    } else {
        return "~/.homeatic"
    }
}()

try! FileSystem(using: .default).createFolderIfNeeded(at: folderPath)

guard let folder = try? Folder(path: folderPath) else {
    Log.fatalError("Can't read or create configuration folder at path \(folderPath)")
}


let homeatic = App(configurationFolder: folder)
homeatic.run()

if let webConfig = homeatic.webServerConfiguration {
    try app(.detect(), configuration: webConfig).run()
} else {
    RunLoop.main.run()
}
