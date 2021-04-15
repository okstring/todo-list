//
//  WillTODOViewModel.swift
//  TODOList
//
//  Created by Issac on 2021/04/07.
//

import Foundation

protocol CardOutputViewModel {
    var cards: [Card] { get }
    var getDataHandler: (() -> ())? { get set }
    func frontEnqueue(card: Card)
    func insertCard(of card: Card, at index: Int)
    func removeCard(at index: Int)
    func appearError(of error: String)
}

class SectionViewModel: CardOutputViewModel {
    private(set) var cards: [Card]
    private(set) var error: String // 임시추가
    
    private var mode: SectionMode
    var getDataHandler: (() -> ())?
    var cardsNetworkCenter: NetworkingCards
    
    init(mode: SectionMode) {
        self.mode = mode
        self.cardsNetworkCenter = CardsNetworkCenter()
        self.error = ""
        self.cards = [Card]()
        
        cardsNetworkCenter.getCards { (kindOfCardsResult) in
            switch kindOfCardsResult {
            case .success(let kindOfCards):
                self.cards = kindOfCards[self.mode.rawValue, default: [Card]()]
                self.passingData()
            case .failure(let error):
                print(error)
                self.error = error.localizedDescription
            }
        }
        
    }
    
    func frontEnqueue(card: Card) {
        self.cards.insert(card, at: 0)
        self.passingData()
    }
    
    func insertCard(of card: Card, at index: Int) {
        print(index)
        self.cards.insert(card, at: index)
    }
    
    func removeCard(at index: Int) {
        self.cards.remove(at: index)
    }
    
    func appearError(of error: String) {
        self.error = error
    }
    
    private func passingData() {
        getDataHandler?()
    }
}
