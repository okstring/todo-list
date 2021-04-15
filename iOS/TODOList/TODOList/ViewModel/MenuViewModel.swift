//
//  MenuViewModel.swift
//  TODOList
//
//  Created by Issac on 2021/04/16.
//

import Foundation

class MenuViewModel {
    let cardsNetworkCenter: NetworkingCards
    private(set) var actions: [ActionForView] {
        didSet {
            menuHandler?()
        }
    }
    var menuHandler: (() -> ())?
    private(set) var error: String
    
    init() {
        self.cardsNetworkCenter = CardsNetworkCenter()
        self.actions = [ActionForView]()
        self.error = ""
    }
    
    func getActions() {
        cardsNetworkCenter.getAction { (result) in
            switch result {
            case .success(let actions):
                self.actions = actions
            case .failure(let error):
                self.error = error.localizedDescription
            }
        }
    }
}
