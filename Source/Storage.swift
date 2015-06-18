import UIKit

public struct Storage {

  // MARK: - File system

  static var fileManager = {
    return NSFileManager.defaultManager()
    }()

  static let applicationDirectory: String = {
    let paths:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    let basePath: AnyObject? = (paths.count > 0) ? paths.firstObject : nil
    return basePath as! String;
  }()

  private static func buildPath(path: URLStringConvertible, createPath: Bool = false) -> String {
    var buildPath = path.string
    if path.string != Storage.applicationDirectory {
      buildPath = "\(Storage.applicationDirectory)/\(path.string)"

      let folderPath = buildPath.stringByDeletingLastPathComponent

      if folderPath != Storage.applicationDirectory {
        var error: NSError?
        fileManager.createDirectoryAtPath(folderPath,
          withIntermediateDirectories: true,
          attributes: nil,
          error: &error)
      }
    }

    return buildPath
  }

  // MARK: - Loading

  public static func load(path: URLStringConvertible) -> AnyObject? {
    let loadPath = Storage.buildPath(path)
    return fileManager.fileExistsAtPath(loadPath)
      ? NSKeyedUnarchiver.unarchiveObjectWithFile(loadPath)
      : nil
  }

  public static func load(contentsAtPath path: URLStringConvertible, _ error: NSErrorPointer? = nil) -> String? {
    let loadPath = Storage.buildPath(path)
    let contents = NSString(contentsOfFile: loadPath,
      encoding: NSUTF8StringEncoding,
      error: error != nil ? error! : nil)

    return contents as? String
  }

  public static func load(dataAtPath path: URLStringConvertible) -> NSData? {
    let loadPath = Storage.buildPath(path)
    return fileManager.fileExistsAtPath(loadPath)
      ? NSData(contentsOfFile: loadPath)
      : nil
  }

  // MARK: - Saving

  public static func save(# object: AnyObject, _ path: URLStringConvertible = Storage.applicationDirectory, closure: (error: NSError?) -> Void) {
    let savePath = Storage.buildPath(path, createPath: true)
    let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(object)
    var error: NSError?

    data.writeToFile(savePath,
      options: NSDataWritingOptions.DataWritingAtomic,
      error: &error)

    closure(error: error)
  }

  public static func save(# contents: String, _ path: URLStringConvertible = Storage.applicationDirectory, closure: (error: NSError?) -> Void) {
    let savePath = Storage.buildPath(path, createPath: true)
    var error: NSError?

    (contents as NSString).writeToFile(savePath, atomically: true, encoding: NSUTF8StringEncoding, error: &error)

    closure(error: error)
  }
}

public protocol URLStringConvertible {
  var url: NSURL { get }
  var string: String { get }
}

extension String: URLStringConvertible {

  public var url: NSURL {
    return NSURL(string: self)!
  }

  public var string: String {
    return self
  }
}
