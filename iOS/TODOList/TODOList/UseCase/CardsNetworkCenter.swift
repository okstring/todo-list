//
//  LoadCards.swift
//  TODOList
//
//  Created by Issac on 2021/04/11.
//

import Foundation

protocol NetworkingCards {
    func getCards(action: @escaping (Result<Dictionary<Int, [Card]>, NetworkError>) -> Void)
    func postCards(cardForPost: CardForPost, action: @escaping (Result<Card, NetworkError>) -> Void)
}

class CardsNetworkCenter: NetworkingCards {
    typealias KindOfCards = Dictionary<Int, [Card]>
    
    let networking: Networkable
    
    init() {
        self.networking = Networking()
    }
    
    func getCards(action: @escaping (Result<KindOfCards, NetworkError>) -> Void) {
        let url = "http://13.124.169.220:8080/api/cards/show"
        self.networking.getToDoList(url: url) { (cardsResult) in
            switch cardsResult {
            case .success(let cards):
                let allStatus = self.manufactureCards(rowCards: cards)
                action(.success(allStatus))
            case .failure(let error):
                action(.failure(error))
            }
        }
    }
    
    func postCards(cardForPost: CardForPost, action: @escaping (Result<Card, NetworkError>) -> Void) {
        let url = "http://13.124.169.220:8080/api/cards/create"
        self.networking.postToDoList(url: url, card: cardForPost) { (cardResult) in
            switch cardResult {
            case .success(let card):
                action(.success(card))
            case .failure(let error):
                action(.failure(error))
            }
        }
    }
    
    //TODO: move(PUT), update(PUT), delete(DELETE) 배포 후 추가 예정
    
}

extension CardsNetworkCenter {
    private func manufactureCards(rowCards: [Card]) -> KindOfCards {
        var sortedCards = KindOfCards()
        for card in rowCards {
            sortedCards[card.columnType, default: [Card]()].append(card)
        }
        return sortCard(cards: sortedCards)
    }
    
    private func sortCard(cards: KindOfCards) -> KindOfCards {
        var sortedCards = cards
        for cards in sortedCards {
            sortedCards[cards.key] = cards.value.sorted(by: { $0.createdDateTime > $1.createdDateTime })
        }
        return sortedCards
    }
}
