//
//  GRResultTests.swift
//  
//
//  Created by Dominik Pethö on 12/8/21.
//
import XCTest
import GoodStructs

final class GRResultTests: XCTestCase {

    enum TestError: Error, Equatable {
        
        case invalid
        case unknown
        
    }
    
    let grSuccessResult = GRResult<Int, TestError>.success(10)
    let grFailureResult = GRResult<Int, TestError>.failure(.invalid)
    let grLoadingResult = GRResult<Int, TestError>.loading
    
    func testUnwrapSuccessValueFromSuccessResult() {
        let value = try? grSuccessResult.unwrapSuccess()
        XCTAssert(value == 10)
    }
    
    func testUnwrapSuccessValueFromFailureResult() {
        let value = try? grFailureResult.unwrapSuccess()
        XCTAssert(value == nil)
    }
    
    func testUnwrapFailureValueFromSuccessResult() {
        let value = try? grSuccessResult.unwrapFailure()
        XCTAssert(value == nil)
    }
    
    func testUnwrapFailureValueFromFailureResult() {
        let value = try? grFailureResult.unwrapFailure()
        XCTAssert(value == .invalid)
    }
    
    func testIsSuccessConditionsForAllTypeOfResults() {
        XCTAssert(grSuccessResult.isSuccess && !grFailureResult.isSuccess && !grLoadingResult.isSuccess)
    }
    
    func testIsFailureConditionsForAllTypeOfResults() {
        XCTAssert(!grSuccessResult.isFailure && grFailureResult.isFailure && !grLoadingResult.isFailure)
    }
    
    func testIsLoadingConditionsForAllTypeOfResults() {
        XCTAssert(!grSuccessResult.isLoading && !grFailureResult.isLoading && grLoadingResult.isLoading)
    }
    
    func testMapFunctionForSuccessType() {
        let value = try? grSuccessResult.map { $0 * 2 }.unwrapSuccess()
        XCTAssert(value == 20)
    }
    
    func testMapFunctionForFailureType() {
        let value = try? grFailureResult.map { $0 * 2 }.unwrapSuccess()
        XCTAssert(value == nil)
    }
    
    func testMapErrorFunctionForSuccessType() {
        let error = try? grSuccessResult.mapError { _ in TestError.unknown }.unwrapFailure()
        XCTAssert(error == nil)
    }
    
    func testMapErrorFunctionForFailureType() {
        let error = try? grFailureResult.mapError { _ in TestError.unknown }.unwrapFailure()
        XCTAssert(error == .unknown)
    }
    
}
