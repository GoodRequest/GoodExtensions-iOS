//
//  JSONDecoderExtensions.swift
//  GoodExtensions
//
//  Created by Filip Šašala on 14/11/2023.
//

import Foundation

public extension JSONDecoder {
    
    /// Allows decoding optional `Data?`. Saves a guard/if let on call site. See ``Foundation/JSONDecoder/decode(_:from:)`` for more.
    /// - Parameters:
    ///   - type: Custom type to be decoded.
    ///   - data: Data to decode from.
    /// - Returns: Throws `DecodingError.valueNotFound` when data is nil.
    @_disfavoredOverload func decode<T>(_ type: T.Type, from data: Data?) throws -> T where T : Decodable {
        guard let nonNullData = data else { throw DecodingError.valueNotFound(type, DecodingError.Context(
            codingPath: [],
            debugDescription: "No data"
        )) }
        return try self.decode(type, from: nonNullData)
    }

}
