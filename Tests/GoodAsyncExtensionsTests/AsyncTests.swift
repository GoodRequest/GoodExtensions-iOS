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

    func testSimpleAsync() async {
        let future = Future<Int, Never> { promise in
            promise(.success(10))
        }

        let result = await future.async()
        XCTAssertEqual(result, 10)
    }

    func testSimpleFutureAsync() async {
        let future = Future {
            async let variable = 10
            return await variable
        }

        let result = await future.async()
        XCTAssertEqual(result, 10)
    }

}
