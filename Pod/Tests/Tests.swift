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
}
