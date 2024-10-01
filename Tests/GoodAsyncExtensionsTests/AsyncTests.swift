//
//  AsyncTests.swift
//  GoodAsyncExtensionsTests
//
//  Created by Filip Šašala on 24/06/2024.
//

import XCTest
import Combine
import GoodAsyncExtensions

final class GoodAsyncExtensionsTests: XCTestCase {

    func testUnsafeBlockingSync() {
        func asyncFunction() async {
            try! await Task.sleep(nanoseconds: UInt64(1e9))
            print("async")
        }

        let expectation1 = expectation(description: "First")
        let expectation2 = expectation(description: "Second")
        let expectation3 = expectation(description: "Third")
        let expectation4 = expectation(description: "Fourth")

        expectation1.fulfill()
        unsafeBlockingSync {
            expectation2.fulfill()
            await asyncFunction()
            expectation3.fulfill()
        }
        expectation4.fulfill()

        wait(for: [expectation1, expectation2, expectation3, expectation4], enforceOrder: true)
    }

}
