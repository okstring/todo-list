//
//  SessionManager.swift
//  TODOList
//
//  Created by 양준혁 on 2021/04/07.
//

import Foundation

class DecodingManager {
    static func decoding<T: Decodable>(decodable: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decoding = try decoder.decode(decodable, from: data)
            return decoding
        } catch {
            return nil
        }
    }
}
