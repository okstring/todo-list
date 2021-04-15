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
    func getAction(action: @escaping (Result<[ActionForView], NetworkError>) -> Void)
    func modifyCards(cardForModify: CardForModify, id: Int,  action: @escaping (Result<Card, NetworkError>) -> Void)
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
    
    func getAction(action: @escaping (Result<[ActionForView], NetworkError>) -> Void) {
        let url = "http://13.124.169.220:8080/api/actions/show"
        self.networking.getHistory(url: url) { (actionResult) in
            switch actionResult {
            case .success(let actions):
                let allStatus = self.manufactureActions(rowActions: actions)
                action(.success(allStatus))
            case .failure(let error):
                action(.failure(error))
            }
        }
    }
    
    func modifyCards(cardForModify: CardForModify, id: Int,  action: @escaping (Result<Card, NetworkError>) -> Void) {
        let url = "http://13.124.169.220:8080/api/cards/\(id)/update"
        self.networking.modifyToDoList(url: url, card: cardForModify, completionHandler: { (cardResult) in
            switch cardResult {
            case .success(let card):
                action(.success(card))
            case .failure(let error):
                action(.failure(error))
            }
        })
    }
    
}

extension CardsNetworkCenter {
    private func manufactureActions(rowActions: [Action]) -> [ActionForView] {
        let actions = rowActions
            .sorted(by: { $0.createdDateTime > $1.createdDateTime })
            .map { (action) -> ActionForView? in
                guard let beforeSectionMode = SectionMode(rawValue: action.columnFrom)?.sectionTitle else { return nil }
                guard let afterSectionMode = SectionMode(rawValue: action.columnTo)?.sectionTitle else { return nil }
                guard let actionType = ActionType(rawValue: action.actionType) else { return nil }
                let contents = makeActionContents(before: beforeSectionMode, after: afterSectionMode, title: action.cardTitle, actionType: actionType)
                let beforeDate = makeBeforeDate(createdDate: action.createdDateTime)
                return ActionForView(contents: contents, beforeDate: beforeDate)
            }.compactMap({ $0 })
        return actions
    }
    
    private func makeBeforeDate(createdDate: Date) -> String {
        var beforeDate = ""
        let subDate = Int(Date().timeIntervalSince1970 - createdDate.timeIntervalSince1970)
        if subDate < 60 {
            beforeDate = "\(subDate)초 전"
        } else if subDate / 60 < 60 {
            beforeDate = "\(subDate / 60)분 전"
        } else if subDate / 3600 < 60 {
            beforeDate = "\(subDate / 3600)시간 전"
        } else {
            beforeDate = "\(subDate / 86400)일 전"
        }
        return beforeDate
    }
    
    private func makeActionContents(before: String, after: String, title: String, actionType: ActionType) -> String {
        var contents = ""
        switch actionType {
        case .MOVE:
            contents = "\(title)을 \(before)에서 \(after)로 이동하였습니다."
        default:
            contents = "\(after)에 \(title)을 등록하였습니다."
        }
        return contents
    }
    
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
