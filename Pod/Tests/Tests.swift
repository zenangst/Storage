import UIKit
import XCTest

class Object: NSCoder {

  var property: String?

  required convenience init(coder decoder: NSCoder) {
    self.init()

    self.property = decoder.decodeObjectForKey("property") as? String
  }

  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.property, forKey: "property")
  }

}

class Tests: XCTestCase {

  func testSavingObjectWithFilename() {
    let object = Object()
    object.property = "My Property"
    Storage.save(object: object, "RootObject.extension") { error in
      XCTAssertNil(error)
    }
  }

  func testSavingObjectWithPathAndFilename() {
    let object = Object()
    object.property = "My Property"

    Storage.save(object: object, "Folder/RootObject.extension") { error in
      XCTAssertNil(error)
    }
  }

  func testSavingObjectWithDeepPathAndFilename() {
    let object = Object()
    object.property = "My Property"

    Storage.save(object: object, "Folder/SubFolder/RootObject.extension") { error in
      XCTAssertNil(error)
    }
  }

  func testSaveSavingAndLoadingObject() {
    let initialObject = Object()
    initialObject.property = "My Property"

    Storage.save(object: initialObject, "Folder/SaveObject.extension") { error in
      XCTAssertNil(error)
    }

    let loadedObject = Storage.load("Folder/SaveObject.extension") as? Object
    if loadedObject != nil {
      XCTAssertEqual(initialObject.property!, loadedObject!.property!)
    }
  }

  func testSaveAndLoadContentsToFile() {
    let path = "Folder/test.txt"
    let expectedString = "My string"

    Storage.save(contents: expectedString, path) { error in
      XCTAssertNil(error)
    }

    let loadedString = Storage.load(contentsAtPath: path)
    XCTAssertEqual(expectedString, loadedString!)
  }

  func testSaveAndLoadDataToFile() {
    let path = "Folder/test.txt"
    let string = "My string"
    let expectedData = string.dataUsingEncoding(NSUTF8StringEncoding)!

    Storage.save(data: expectedData, path) { error in
      XCTAssertNil(error)
    }

    let loadedData = Storage.load(dataAtPath: path)
    XCTAssertEqual(expectedData, loadedData!)
  }

  func testSaveAndLoadJSONToFile() {
    let path = "Folder/test.json"
    let expectedObject = [
      "key": "value",
      "list": ["key": "value"]
    ]

    Storage.save(JSON: expectedObject, path) { error in
      XCTAssertNil(error)
    }

    let loadedObject = Storage.load(JSONAtPath: path) as? NSDictionary
    XCTAssertEqual(expectedObject, loadedObject!)
  }

  func testExistsAtPath() {
    let path = "Folder/test.txt"
    let string = "My string"

    Storage.save(contents: string, path) { error in
      XCTAssertNil(error)
    }

    XCTAssertTrue(Storage.existsAtPath(path))
  }

  func testRemoveAtPath() {
    let path = "Folder/test.txt"
    let string = "My string"

    Storage.save(contents: string, path) { error in
      XCTAssertNil(error)
    }
    XCTAssertTrue(Storage.existsAtPath(path))

    var error: NSError?
    Storage.removeAtPath(path, &error)
    XCTAssertNil(error)

    XCTAssertFalse(Storage.existsAtPath(path))
  }
}
