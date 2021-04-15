//
//  Networking.swift
//  TODOList
//
//  Created by 양준혁 on 2021/04/07.
//

import Foundation

protocol Networkable {
    var dataManager: DataManageable { get }
    func getToDoList(url: String, completionHandler: @escaping ([Card])->Void)
    func postToDoList(url: String, card: Card, comletionHandler: @escaping (Card) -> Void)
}

class Networking: Networkable {
    var dataManager: DataManageable
    
    init() {
        self.dataManager = DataManager()
    }
    
    func getToDoList(url: String, completionHandler: @escaping ([Card])->Void) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        SessionManger.request(urlRequest: request) { (data) in
            guard let decodedData = self.dataManager.decoding(decodable: BundleOfCards.self, data: data) else { return }
            completionHandler(decodedData.cards)
        }
    }
    
    func postToDoList(url: String, card: Card, comletionHandler: @escaping (Card) -> Void) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        let encodedData = self.dataManager.encoding(encodable: card)
        request.httpMethod = "POST"
        request.httpBody = encodedData
        SessionManger.request(urlRequest: request) { (data) in
            guard let card = self.dataManager.decoding(decodable: Card.self, data: data) else { return }
            comletionHandler(card)
        }
    }
    
}
