//
//  SectionViewController.swift
//  TODOList
//
//  Created by Issac on 2021/04/06.
//

import UIKit

class SectionViewController: UIViewController {
    static let storyboardID = "sectionViewController"
    
    @IBOutlet weak private var TODOTableView: UITableView!
    @IBOutlet private var sectionViewDataSource: SectionViewDataSource!
    @IBOutlet private var sectionViewDelegate: SectionViewDelegate!
    @IBOutlet weak private var sectionTitle: UILabel!
    @IBOutlet weak private var TODOCount: UILabel!
    @IBOutlet weak private var addButton: UIButton!
    private var sectionMode: SectionMode?
    private var appearViewModel: CardOutputViewModel!
    private var changeCardViewModel: CardInputViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTODOTableView()
        guard let sectionMode = sectionMode else { return }
        self.appearViewModel = SectionViewModel(mode: sectionMode)
        self.changeCardViewModel = CardViewModel()
        self.sectionViewDataSource.setAppearViewModel(of: self.appearViewModel)
        self.initHTTPMethodHandler()
        self.setTitleText()
        self.setTODOCount()
    }
    
    private func initHTTPMethodHandler() {
        self.changeCardViewModel.modifyCardHandler = { card in
            self.appearViewModel.modifyCard(card: card)
            DispatchQueue.main.async {
                self.TODOTableView.reloadData()
            }
        }
        
        self.changeCardViewModel.addCardHandler = { card in
            self.appearViewModel.frontEnqueue(card: card)
            DispatchQueue.main.async {
                self.setTODOCount()
                self.TODOTableView.reloadData()
            }
        }
        
        self.changeCardViewModel.errorAddCardHandler = { errorMessage in
            self.appearViewModel.appearError(of: errorMessage)
        }
        
        self.appearViewModel.getDataHandler = {
            DispatchQueue.main.async {
                self.setTODOCount()
                self.TODOTableView.reloadData()
            }
        }
        
        self.sectionViewDataSource.deleteCard = { indexPath, card in
            self.appearViewModel.removeCard(at: indexPath.section)
            self.changeCardViewModel.deleteCard(card: card)
            
        }
        
        self.sectionViewDelegate.presentModifyVieControllerHandler = { index in
            self.setInstanceViewController(mode: .modify, cardIndex: index)
        }
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
        setInstanceViewController(mode: .add)
    }
    
    private func setTODOCount() {
        self.TODOCount.text = "\(self.appearViewModel.cards.count)"
    }
    
    private func setTitleText() {
        guard let mode = self.sectionMode else { return }
        self.sectionTitle.text = mode.sectionTitle
        self.sectionTitle.sizeToFit()
    }
    
    private func setTODOTableView() {
        self.TODOTableView.rowHeight = UITableView.automaticDimension
        self.TODOTableView.estimatedRowHeight = 500
        self.TODOTableView.dragInteractionEnabled = true
        self.TODOTableView.dragDelegate = self
        self.TODOTableView.dropDelegate = self
        self.TODOTableView.dragInteractionEnabled = true
        
    }
    
    func setSectionMode(mode: SectionMode) {
        self.sectionMode = mode
    }
    
    private func setInstanceViewController(mode: PopupViewController.SubmitType, cardIndex: Int? = nil) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: PopupViewController.identifier) as! PopupViewController
        viewController.modalPresentationStyle = .overCurrentContext
        guard let sectionMode = sectionMode else { return }
        viewController.setSectionMode(mode: sectionMode)
        viewController.setViewModel(inputViewModel: self.changeCardViewModel, outputViewModel: self.appearViewModel)
        viewController.setSubmitType(of: mode)
        if mode == .modify {
            guard let index = cardIndex else { return }
            let willModifyCard = self.appearViewModel.cards[index]
            viewController.receiveModifyCard(of: willModifyCard)
        }
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true, completion: nil)
    }
    
}

struct DragItem {
    var appearViewControll: CardOutputViewModel
    var indexPath: IndexPath
    var tableView: UITableView
    var countHandler: (() -> ())?
}

extension SectionViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let provider = NSItemProvider()
        let item = UIDragItem(itemProvider: provider)
        let countHandler: (() -> ())? = { self.setTODOCount() }
        item.localObject = DragItem(appearViewControll: self.appearViewModel, indexPath: indexPath, tableView: tableView, countHandler: countHandler)
        return [item]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        switch coordinator.proposal.operation {
        case .move:
            let destinationIndexPath: IndexPath
            
            let section = coordinator.destinationIndexPath!.section
            
            destinationIndexPath = IndexPath(row: 0, section: section)
            
            let item = coordinator.items.first!
            let dragItem = item.dragItem.localObject as! DragItem
            let appearViewModel = dragItem.appearViewControll
            
            let card = appearViewModel.cards[dragItem.indexPath.section]
            
            appearViewModel.removeCard(at: dragItem.indexPath.section)
            self.appearViewModel.insertCard(of: card, at: destinationIndexPath.section + 1)
            
            self.TODOTableView.performBatchUpdates {
                dragItem.tableView.deleteSections([dragItem.indexPath.section], with: .automatic)
                tableView.insertSections([destinationIndexPath.section + 1], with: .automatic)
            }
            
            self.setTODOCount()
            dragItem.countHandler?()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
