//
//  Networking.swift
//  TODOList
//
//  Created by 양준혁 on 2021/04/07.
//

import Foundation

class Networking {
    let session: URLSession
    let baseURL: String
    
    init(baseURL: String) {
        session = .shared
        self.baseURL = baseURL
    }
    
    func getToDoList(completionHandler: @escaping (Data)->Void) {
        guard let url = URL(string: baseURL) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard let data = data else { return }
            let decodedData = DecodingManager.decoding(decodable: <#T##Decodable.Protocol#>, data: data)
            completionHandler(decodedData)
        }
        task.resume()
    }
    
    func postToDoList(comletionHandler: @escaping (Data)->Void) {
        guard let url = URL(string: baseURL) else { return }
        var urlRequest = URLRequest(url: url)
        let encodedData = EncodingManager.encoding(encodable: <#T##Encodable#>)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = encodedData
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            let decodedData = DecodingManager.decoding(decodable: <#T##Decodable.Protocol#>, data: data)
            comletionHandler(data)
        }
        task.resume()
    }
}
