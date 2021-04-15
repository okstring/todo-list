//
//  SectionViewController.swift
//  TODOList
//
//  Created by Issac on 2021/04/06.
//

import UIKit

protocol DataPassable: class {
    func passData() -> [Card]?
}

class SectionViewController: UIViewController, DataPassable {
    @IBOutlet weak private var TODOTableView: UITableView!
    @IBOutlet private var sectionViewDataSource: SectionViewDataSource!
    @IBOutlet weak private var sectionTitle: UILabel!
    @IBOutlet weak private var TODOCount: UILabel!
    @IBOutlet weak private var addButton: UIButton!
    private var sectionMode: SectionMode?
    private var appearViewModel: CardOutputViewModel!
    private var changeCardViewModel: CardInputViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sectionViewDataSource.dataSource = self
        self.setTODOTableView()
        guard let sectionMode = sectionMode else { return }
        self.appearViewModel = AppearViewModel(mode: sectionMode)
        self.changeCardViewModel = ChangeCardViewModel()
        self.initHTTPMethodHandler()
        self.setTitleText()
        self.setTODOCount()
    }
    
    private func initHTTPMethodHandler() {
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
        
        self.sectionViewDataSource.deleteCard = { card in
            self.changeCardViewModel.deleteCard(card: card)
        }
        
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
        let addView = self.storyboard?.instantiateViewController(withIdentifier: AddViewController.identifier) as! AddViewController
        addView.modalPresentationStyle = .overCurrentContext
        guard let sectionMode = sectionMode else { return }
        addView.setSectionMode(mode: sectionMode)
        addView.modalTransitionStyle = .crossDissolve
        present(addView, animated: true, completion: nil)
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
    
    func passData() -> [Card]? {
        return self.appearViewModel.cards
    }
    
    func setSectionMode(mode: SectionMode) {
        self.sectionMode = mode
    }
}

struct DragItem {
    var appearViewControll: CardOutputViewModel
    var indexPath: IndexPath
    var tableView: UITableView
}

extension SectionViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let provider = NSItemProvider()
        let item = UIDragItem(itemProvider: provider)
        item.localObject = DragItem(appearViewControll: self.appearViewModel, indexPath: indexPath, tableView: tableView)
        return [item]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        switch coordinator.proposal.operation {
        case .move:
            let destinationIndexPath: IndexPath
            
            if let indexPath = coordinator.destinationIndexPath {
                destinationIndexPath = indexPath
            } else {
                let section = tableView.numberOfSections
                destinationIndexPath = IndexPath(row: 0, section: section)
            }
            
            let item = coordinator.items.first!
            let dragItem = item.dragItem.localObject as! DragItem
            let appearViewModel = dragItem.appearViewControll
            
            let card = appearViewModel.cards[dragItem.indexPath.item]
            
            self.appearViewModel.insertCard(of: card, at: destinationIndexPath.item)
            appearViewModel.removeCard(at: dragItem.indexPath.section)
            
            self.TODOTableView.performBatchUpdates {
                tableView.insertSections([destinationIndexPath.section], with: .automatic)
                dragItem.tableView.deleteSections([dragItem.indexPath.section], with: .automatic)
            }
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
