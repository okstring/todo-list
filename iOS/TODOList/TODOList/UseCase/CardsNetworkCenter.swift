//
//  LoadCards.swift
//  TODOList
//
//  Created by Issac on 2021/04/11.
//

import Foundation

protocol NetworkingCards {
    func getCards(action: @escaping (Result<Dictionary<Int, [Card]>, NetworkError>) -> Void)
    func postCard(cardForPost: CardForPost, action: @escaping (Result<Card, NetworkError>) -> Void)
    func getAction(action: @escaping (Result<[ActionForView], NetworkError>) -> Void)
    func modifyCard(cardForModify: CardForModify, id: Int,  action: @escaping (Result<Card, NetworkError>) -> Void)
    func deleteCards(card: Card)
}

class CardsNetworkCenter: NetworkingCards {
    typealias KindOfCards = Dictionary<Int, [Card]>
    
    let networking: Networkable
    
    init() {
        self.networking = Networking()
    }
    
    func getCards(action: @escaping (Result<KindOfCards, NetworkError>) -> Void) {
        let url = "http://3.36.119.210:8080/api/cards/show"
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
    
    func postCard(cardForPost: CardForPost, action: @escaping (Result<Card, NetworkError>) -> Void) {
        let url = "http://3.36.119.210:8080/api/cards/create"
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
        let url = "http://3.36.119.210:8080/api/actions/show"
        self.networking.getHistory(url: url) { (actionResult) in
            switch actionResult {
            case .success(let actions):
                let actionForView = self.manufactureActions(rowActions: actions)
                action(.success(actionForView))
            case .failure(let error):
                action(.failure(error))
            }
        }
    }
    
    func modifyCard(cardForModify: CardForModify, id: Int,  action: @escaping (Result<Card, NetworkError>) -> Void) {
        let url = "http://3.36.119.210:8080/api/cards/\(id)/update"
        self.networking.modifyToDoList(url: url, card: cardForModify, completionHandler: { (cardResult) in
            switch cardResult {
            case .success(let card):
                action(.success(card))
            case .failure(let error):
                action(.failure(error))
            }
        })
    }
    
    func moveCard(cardForMove: CardForMove, id: Int,  action: @escaping (Result<Card, NetworkError>) -> Void) {
        let url = "http://3.36.119.210:8080/api/cards/\(id)/move"
        self.networking.moveToDoList(url: url, card: cardForMove, completionHandler: { (cardResult) in
            switch cardResult {
            case .success(let card):
                action(.success(card))
            case .failure(let error):
                action(.failure(error))
            }
        })
    }
    
    func deleteCards(card: Card) {
            let id = card.id
            let url = "http://3.36.119.210:8080/api/cards/\(id)/delete"
            self.networking.deleteToDoList(url: url)
            
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
                let beforeDate = makeBeforeDate(createdDate: action.createdDateTime)
                let title = action.cardTitle
                var imageName: String {
                    switch actionType {
                    case .ADD: return "plus.bubble.fill"
                    case .DELETE: return "delete.left.fill"
                    case .MOVE: return "arrowshape.turn.up.right.fill"
                    case .UPDATE: return "note.text"
                    }
                }
                return ActionForView(beforeSectionMode: beforeSectionMode,
                                     afterSectionMode: afterSectionMode,
                                     title: title,
                                     actionType: actionType.actionTitle,
                                     beforeDate: beforeDate,
                                     imageName: imageName)
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
        } else if subDate / 3600 < 24 {
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
            contents = "\(title)을 \(before)에서 \(after)로 \(actionType.actionTitle)하였습니다."
        default:
            contents = "\(after)에 \(title)을 \(actionType.actionTitle)하였습니다."
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
