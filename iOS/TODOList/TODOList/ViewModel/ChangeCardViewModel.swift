//
//  ImportViewModel.swift
//  TODOList
//
//  Created by Issac on 2021/04/08.
//

import Foundation

protocol CardInputViewModel {
    var addCardHandler: ((Card) -> Void)? { get set }
    var errorAddCardHandler: ((String) -> Void)? { get set }
    func addCard(mode: SectionMode)
    func deleteCard(card: Card)
}

class ChangeCardViewModel: CardInputViewModel {
    private(set) var subject: Observable<String>
    private(set) var body: Observable<String>
    private var cardsNetworkCenter: NetworkingCards
    
    var addCardHandler: ((Card) -> Void)?
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
        let card = CardFactory.makeCard(title: title, contents: contents, mode: mode)
        self.cardsNetworkCenter.postCards(card: card) { (cardResult) in
            switch cardResult {
            case .success(let card):
                self.addCardHandler?(card)
            case .failure(let error):
                self.errorAddCardHandler?(error.localizedDescription)
            }
        }
    }
    
    func deleteCard(card: Card) {
        //TODO: - DELETE
    }
}
