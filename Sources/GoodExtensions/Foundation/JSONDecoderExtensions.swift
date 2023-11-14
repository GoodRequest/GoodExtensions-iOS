//
//  JSONDecoderExtensions.swift
//  GoodExtensions
//
//  Created by Filip Šašala on 14/11/2023.
//

import Foundation

public extension JSONDecoder {

    @_disfavoredOverload func decode<T>(_ type: T.Type, from data: Data?) throws -> T where T : Decodable {
        guard let nonNullData = data else { throw DecodingError.valueNotFound(type, DecodingError.Context(
            codingPath: [],
            debugDescription: "No data"
        )) }
        return try self.decode(type, from: nonNullData)
    }

}
