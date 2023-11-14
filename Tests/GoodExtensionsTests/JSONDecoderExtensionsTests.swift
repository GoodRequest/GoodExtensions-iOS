//
//  JSONDecoderExtensionsTests.swift
//  GoodExtensions
//
//  Created by Filip Šašala on 14/11/2023.
//

import XCTest
import GoodExtensions

final class JSONDecoderExtensionsTests: XCTestCase {

    private struct SampleStruct: Decodable {

        let sampleString: String

    }

    private let decoder: JSONDecoder = JSONDecoder()

    func testDecodeWithData() throws {
        let testSampleString = "Sample string content"
        let jsonString = "{\"sampleString\": \"\(testSampleString)\"}"
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            return XCTFail("Invalid testing data!")
        }

        let jsonStruct = try decoder.decode(SampleStruct.self, from: jsonData)

        XCTAssertEqual(jsonStruct.sampleString, testSampleString)
    }

    func testDecodeWithNoData() throws {
        let jsonData: Data? = nil

        XCTAssertThrowsError(try decoder.decode(SampleStruct.self, from: jsonData))
    }

    func testDecodeWithInvalidData() throws {
        let testSampleString = "Sample string content"
        let jsonString = "{\"invalidField\": \"\(testSampleString)\"}"
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            return XCTFail("Invalid testing data!")
        }

        let jsonStruct = try? decoder.decode(SampleStruct.self, from: jsonData)

        XCTAssertNil(jsonStruct)
    }

}
