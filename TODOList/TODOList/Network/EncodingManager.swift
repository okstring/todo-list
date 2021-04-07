//
//  EncodingManager.swift
//  TODOList
//
//  Created by 양준혁 on 2021/04/07.
//

import Foundation

class EncodingManager {
    static func encoding<T: Encodable>(encodable: T) -> Data? {
        let encoder = JSONEncoder()
        do {
            let encoding = try encoder.encode(encodable)
            return encoding
        } catch {
            return nil
        }
    }
}
