//
//  Networking.swift
//  TODOList
//
//  Created by 양준혁 on 2021/04/07.
//

import Foundation


enum NetworkError: Error {
    case network
    case decodingJSON
    case encodingJSON
}



protocol Networkable {
    var dataManager: DataManageable { get }
    func getToDoList(url: String, completionHandler: @escaping (Result<[Card], NetworkError>) -> Void)
    func postToDoList(url: String, card: Card, completionHandler: @escaping (Result<Card, NetworkError>) -> Void)
}

class Networking: Networkable {
    var dataManager: DataManageable
    
    init() {
        self.dataManager = DataManager()
    }
    
    func getToDoList(url: String, completionHandler: @escaping (Result<[Card], NetworkError>) -> Void) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        SessionManger.request(urlRequest: request) { (sessionResult) in
            switch sessionResult {
            case .success(let data):
                
                self.dataManager.decoding(decodable: BundleOfCards.self, data: data, completion: { (JSONresult) in
                    switch JSONresult {
                    case .success(let bundleOfCard):
                        completionHandler(.success(bundleOfCard.cards))
                    case .failure(let JSONError):
                        completionHandler(.failure(JSONError))
                    }
                })
                
            case .failure(let networkError):
                completionHandler(.failure(networkError))
            }
        }
    }
    
    func postToDoList(url: String, card: Card, completionHandler: @escaping (Result<Card, NetworkError>) -> Void) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        let encodedData = self.dataManager.encoding(encodable: card)
        request.httpMethod = "POST"
        request.httpBody = encodedData
        
        SessionManger.request(urlRequest: request) { (sessionResult) in
            switch sessionResult {
            case .success(let data):
                
                self.dataManager.decoding(decodable: Card.self, data: data, completion: { (JSONresult) in
                    switch JSONresult {
                    case .success(let card):
                        completionHandler(.success(card))
                    case .failure(let JSONError):
                        completionHandler(.failure(JSONError))
                    }
                })
                
            case .failure(let networkError):
                completionHandler(.failure(networkError))
            }
        }
    }
    
}
