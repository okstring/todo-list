//
//  TODOTableViewDataSource.swift
//  TODOList
//
//  Created by Issac on 2021/04/06.
//

import UIKit

class SectionViewDataSource: NSObject {
    var deleteCard: ((IndexPath, Card) -> ())?
    var appearViewModel: CardOutputViewModel!
    
    func setAppearViewModel(of viewModel: CardOutputViewModel) {
        self.appearViewModel = viewModel
    }
}

extension SectionViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let cards = self.appearViewModel.cards
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionCell.identifier, for: indexPath) as? SectionCell else { return SectionCell() }
        let cards = self.appearViewModel.cards
        cell.subject.text = cards[indexPath.section].title
        cell.body.text = cards[indexPath.section].contents
        cell.backgroundColor = .white
        cell.body.sizeToFit()

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let card = self.appearViewModel.cards[indexPath.row]
            deleteCard?(indexPath, card)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
}
