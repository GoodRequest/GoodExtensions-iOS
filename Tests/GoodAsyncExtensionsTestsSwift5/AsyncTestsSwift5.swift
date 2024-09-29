//
//  AsyncTestsSwift5.swift
//  GoodExtensions
//
//  Created by Filip Šašala on 29/09/2024.
//

import XCTest
import Combine
import GoodAsyncExtensionsSwift5

#if swift(<6)
final class GoodAsyncExtensionsTestsSwift5: XCTestCase {

    func testTest() {
        func asyncFunction() async {
            try! await Task.sleep(nanoseconds: UInt64(1e9))
            print("async")
        }

        let expectation1 = expectation(description: "First")
        let expectation2 = expectation(description: "Second")
        let expectation3 = expectation(description: "Third")
        let expectation4 = expectation(description: "Fourth")

        expectation1.fulfill()
        let future = Future<Void, Never> {
            expectation3.fulfill()
            await asyncFunction()
            expectation4.fulfill()
        }
        expectation2.fulfill()

        let cancellable = future.sink { _ in
            print("finished")
        }

        wait(
            for: [expectation1, expectation2, expectation3, expectation4],
            timeout: 3,
            enforceOrder: true
        )
    }

}
#endif
