import Foundation

public struct Storage {

  // MARK: - File system

  static var fileManager: FileManager = {
    let manager = FileManager.default
    return manager
  }()

  public static let applicationDirectory: String = {
    let paths: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
    let basePath: Any? = (paths.count > 0) ? paths.firstObject : nil
    return basePath as! String;
  }()

  fileprivate static func build(path: URLStringConvertible, createPath: Bool = false) -> String {
    var buildPath = path.string
    if path.string != Storage.applicationDirectory {
      buildPath = "\(Storage.applicationDirectory)/\(path.string)"

      let folderPath = NSString(string: buildPath).deletingLastPathComponent

      if folderPath != Storage.applicationDirectory {
        do {
          try fileManager.createDirectory(atPath: folderPath,
            withIntermediateDirectories: true,
            attributes: nil)
        } catch { }
      }
    }

    return buildPath
  }

  // MARK: - Loading

  public static func load(path: URLStringConvertible) -> Any? {
    let loadPath = Storage.build(path: path)
    return fileManager.fileExists(atPath: loadPath)
      ? NSKeyedUnarchiver.unarchiveObject(withFile: loadPath)
      : nil
  }

  public static func load(contentsAtPath path: URLStringConvertible, _ error: NSErrorPointer? = nil) -> String? {
    let loadPath = Storage.build(path: path)
    let contents: NSString?
    do {
      contents = try NSString(contentsOfFile: loadPath,
            encoding: String.Encoding.utf8.rawValue)
    } catch { contents = nil }

    return contents as? String
  }

  public static func load(dataAtPath path: URLStringConvertible) -> Data? {
    let loadPath = Storage.build(path: path)
    return fileManager.fileExists(atPath: loadPath)
      ? (try? Data(contentsOf: URL(fileURLWithPath: loadPath)))
      : nil
  }

  public static func load(JSONAtPath path: URLStringConvertible) -> Any? {
    var object: Any?

    if let data = load(dataAtPath: path) {
      do {
        object = try JSONSerialization.jsonObject(with: data,
          options: .mutableContainers)
      } catch _ {
        object = nil
      }
    }

    return object
  }

  // MARK: - Saving

  public static func save(object: Any, path: URLStringConvertible = Storage.applicationDirectory, closure: (_ error: NSError?) -> Void) {
    let savePath = Storage.build(path: path, createPath: true)
    let data: Data = NSKeyedArchiver.archivedData(withRootObject: object)
    var error: NSError?

    do {
      try data.write(to: URL(fileURLWithPath: savePath),
        options: NSData.WritingOptions.atomic)
    } catch let error1 as NSError {
      error = error1
    }

    closure(error)
  }

  public static func save(contents: String, path: URLStringConvertible = Storage.applicationDirectory, closure: (_ error: NSError?) -> Void) {
    let savePath = Storage.build(path: path, createPath: true)
    var error: NSError?

    do {
      try (contents as NSString).write(toFile: savePath, atomically: true, encoding: String.Encoding.utf8.rawValue)
    } catch let error1 as NSError {
      error = error1
    }

    closure(error)
  }

  public static func save(data: Data, path: URLStringConvertible = Storage.applicationDirectory, closure: (_ error: NSError?) -> Void) {
    let savePath = Storage.build(path: path, createPath: true)
    var error: NSError?

    do {
      try data.write(to: URL(fileURLWithPath: savePath), options: .atomic)
    } catch let error1 as NSError {
      error = error1
    }

    closure(error)
  }

  public static func save(JSON: Any, path: URLStringConvertible = Storage.applicationDirectory, closure: (_ error: NSError?) -> Void) {
    var error: NSError?

    do {
      let data = try JSONSerialization.data(withJSONObject: JSON,
        options: [])
        save(data: data, path: path, closure: closure)
    } catch let error1 as NSError {
      error = error1
      closure(error)
    }
  }

  // MARK: - Helper Methods

  public static func exists(atPath path: URLStringConvertible) -> Bool {
    let loadPath = Storage.build(path: path)
    return fileManager.fileExists(atPath: loadPath)
  }

  public static func remove(atPath path: URLStringConvertible) {
    let loadPath = Storage.build(path: path)

    do {
      try fileManager.removeItem(atPath: loadPath)
    } catch { }
  }
}

public protocol URLStringConvertible {
  var url: URL { get }
  var string: String { get }
}

extension String: URLStringConvertible {

  public var url: URL {
    let aURL = URL(string: self)!
    return aURL
  }

  public var string: String {
    return self
  }
}
