//
//  SessionManager.swift
//  TODOList
//
//  Created by 양준혁 on 2021/04/07.
//

import Foundation

class SessionManger {
    static func request(urlRequest: URLRequest, completion: @escaping (Result<Data, NetworkError>)-> Void) {
        URLSession.init(configuration: .default).dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                return completion(.failure(.data))
            }
            completion(.success(data))
        }.resume()
    }
}
