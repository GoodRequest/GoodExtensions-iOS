import XCTest
import GRCompatible

final class BaseTests: XCTestCase {

    func testBaseType() {
        XCTAssert("Hello".gr.base != nil)
    }

}
