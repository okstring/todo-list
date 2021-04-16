//
//  SectionViewDelegate.swift
//  TODOList
//
//  Created by Issac on 2021/04/12.
//

import UIKit

class SectionViewDelegate: NSObject {
    var presentModifyVieControllerHandler: ((Int) -> ())?
    var deleteCardwithContextMenu: ((IndexPath, Card) -> ())?
        var appearViewModel: CardOutputViewModel!
        
        func setAppearViewModel(of viewModel: CardOutputViewModel) {
            self.appearViewModel = viewModel
        }
}

extension SectionViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        footer.backgroundColor = .systemGray6
        return footer
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
                                            suggestedActions in
                                            let inspectAction =
                                                UIAction(title: NSLocalizedString("완료한 일로 이동", comment: "")) { action in
                                                    
                                                }
                                            let duplicateAction =
                                                UIAction(title: NSLocalizedString("수정하기", comment: "")) { action in
                                                    print(indexPath.section)
                                                    self.presentModifyVieControllerHandler?(indexPath.section)
                                                }
                                            let deleteAction =
                                                UIAction(title: NSLocalizedString("삭제하기", comment: ""),
                                                         attributes: .destructive) { action in
                                                    let card = self.appearViewModel.cards[indexPath.section]
                                                    self.deleteCardwithContextMenu?(indexPath, card)
                                                    DispatchQueue.main.async {
                                                        tableView.reloadData()
                                                    }
                                                }
                                            return UIMenu(title: "", children: [inspectAction, duplicateAction, deleteAction])
                                          })
    }
    
}
