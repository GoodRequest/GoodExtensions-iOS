import XCTest
import GoodExtensions
import GoodStructs

final class StringTests: XCTestCase {

    enum C {

        static let stringWithDiacritics = "Žilinskí šošóni"
        static let stringWithoutDiacritics = "Zilinski sosoni"

    }

    func testRemoveDiacritics() {
        let mutatedString = C.stringWithDiacritics.gr.removeDiacritics
        XCTAssert(
            mutatedString == C.stringWithoutDiacritics,
            "\(mutatedString) should be equal to \(C.stringWithoutDiacritics)"
        )
    }

}
