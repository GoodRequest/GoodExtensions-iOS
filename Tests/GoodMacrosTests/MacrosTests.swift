//
//  MacrosTests.swift
//  GoodExtensions-iOS
//
//  Created by Filip Šašala on 09/07/2024.
//

import SwiftUI
import XCTest

@_spi(ExperimentalLanguageFeature) import GoodMacros

final class MacrosTests: XCTestCase {

    func testUrlMacro() {
        let nullableUrl = URL(string: "https://goodrequest.com/")
        let url = #URL("https://goodrequest.com/")

        XCTAssert(url is URL)
        XCTAssert(nullableUrl is Optional<URL>)
    }

    func testLoggedMacro() {
        printHelloWorld()

        let testClass = LoggedTest(x: 10)
        testClass.x = 12
        testClass.printXY()
        testClass.dummy = "Hello"
        testClass.stateVar = "world"
    }

}

// MARK: - Test functions

extension MacrosTests {

    @Log func printHelloWorld() {
        defer {
            print("defer")
        }
        print("asdf")
        print("test")
        print("1234")
    }

}

// MARK: - Test class

@Logged class LoggedTest {

    init(x: Int) {
        self.x = x
    }

    var dummy: Any? {
        didSet {
            print("Did set dummy")
        }
    }

    var x: Int {
        willSet {
            print("Custom willSet")
        }
    }

    var doubleX: Int {
        get {
            return x * 2
        }
    }

    @State var stateVar: String = "X"

    func printXY() {
        let internalClass = LoggedTestInternalClass(y: x + 1)

        print(x)
        internalClass.y += 1
        print(internalClass.y)
    }

    @Logged internal class LoggedTestInternalClass {
        init(y: Int) {
            self.y = y
        }
        var y: Int
    }

}
