//
//  SessionManager.swift
//  TODOList
//
//  Created by 양준혁 on 2021/04/07.
//

import Foundation

protocol DataManageable {
    var iso8601Full: DateFormatter { get }
    func decoding<T: Decodable>(decodable: T.Type, data: Data, completion: @escaping (Result<T, NetworkError>) -> Void)
    func encoding<T: Encodable>(encodable: T, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

class DataManager: DataManageable {
    var iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()
    
    func decoding<T: Decodable>(decodable: T.Type, data: Data, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(iso8601Full)
        do {
            let decodeData = try decoder.decode(decodable, from: data)
            completion(.success(decodeData))
        } catch {
            completion(.failure(.decodingJSON))
        }
    }
    
    func encoding<T: Encodable>(encodable: T, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(iso8601Full)
        do {
            let encodeData = try encoder.encode(encodable)
            completion(.success(encodeData))
        } catch {
            completion(.failure(.decodingJSON))
        }
    }
}
