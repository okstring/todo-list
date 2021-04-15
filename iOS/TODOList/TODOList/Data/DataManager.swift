//
//  SessionManager.swift
//  TODOList
//
//  Created by 양준혁 on 2021/04/07.
//

import Foundation

protocol DataManageable {
    var iso8601Full: DateFormatter { get }
    func decoding<T: Decodable>(decodable: T.Type, data: Data) -> T?
    func encoding<T: Encodable>(encodable: T) -> Data?
}

class DataManager: DataManageable {
    var iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()
    
    func decoding<T: Decodable>(decodable: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(iso8601Full)
        return try? decoder.decode(decodable, from: data)
    }
    
    func encoding<T: Encodable>(encodable: T) -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(iso8601Full)
        return try? encoder.encode(encodable)
    }
}
