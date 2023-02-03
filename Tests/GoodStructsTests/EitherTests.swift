import XCTest
import GoodStructs

final class EitherTests: XCTestCase {

    func testEither() {
        let value = Either<Int,String>.left(5)
        XCTAssert(try! value.unwrapLeft() == 5)
        let value2 = Either<Int,String>.right("Hello")
        XCTAssert(try! value2.unwrap() == "Hello")
    }

    static var allTests = [
        ("testEither", testEither)
    ]
}
