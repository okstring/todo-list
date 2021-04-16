//
//  ImportViewModel.swift
//  TODOList
//
//  Created by Issac on 2021/04/08.
//

import Foundation

protocol CardInputViewModel {
    var subject: Observable<String> { get }
    var body: Observable<String> { get }
    var addCardHandler: ((Card) -> Void)? { get set }
    var modifyCardHandler: ((Card) -> Void)? { get set }
    var errorAddCardHandler: ((String) -> Void)? { get set }
    func addCard(mode: SectionMode)
    func deleteCard(card: Card)
    func modifyCard(mode: SectionMode, id: Int)
}

class CardViewModel: CardInputViewModel {
    private(set) var subject: Observable<String>
    private(set) var body: Observable<String>
    private var cardsNetworkCenter: NetworkingCards
    
    var addCardHandler: ((Card) -> Void)?
    var modifyCardHandler: ((Card) -> Void)?
    var errorAddCardHandler: ((String) -> Void)?
    
    init(subject: String, body: String) {
        self.subject = Observable(value: subject)
        self.body = Observable(value: body)
        self.cardsNetworkCenter = CardsNetworkCenter()
    }
    
    convenience init() {
        self.init(subject: "", body: "")
        self.cardsNetworkCenter = CardsNetworkCenter()
    }
    
    func addCard(mode: SectionMode) {
        guard let title = subject.value else { return }
        guard let contents = body.value else { return }
        let cardForPost = CardForPost(title: title, contents: contents, columnType: mode.rawValue)
        self.cardsNetworkCenter.postCard(cardForPost: cardForPost) { (cardResult) in
            switch cardResult {
            case .success(let card):
                self.addCardHandler?(card)
            case .failure(let error):
                self.errorAddCardHandler?(error.localizedDescription)
            }
        }
    }
    
    func deleteCard(card: Card) {
        self.cardsNetworkCenter.deleteCards(card: card)
    }
    
    func modifyCard(mode: SectionMode, id: Int) {
        guard let title = subject.value else { return }
        guard let contents = body.value else { return }
        let cardForModify = CardForModify(title: title, contents: contents)
        self.cardsNetworkCenter.modifyCard(cardForModify: cardForModify, id: id) { (result) in
            switch result {
            case .success(let card):
                self.modifyCardHandler?(card)
            case .failure(let error):
                self.errorAddCardHandler?(error.localizedDescription)
            }
        }
    }
}
