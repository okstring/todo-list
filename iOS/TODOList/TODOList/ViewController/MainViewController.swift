//
//  ViewController.swift
//  TODOList
//
//  Created by Issac on 2021/04/06.
//

import UIKit

class MainViewController: UIViewController {
    enum Segues: CaseIterable {
        static let willTODO = "WillTODO"
        static let doingTODO = "DoingTODO"
        static let completeTODO = "CompleteTODO"
    }
    @IBOutlet var backgroundView: UIView!
    var menuView: UIView!
    var closeButton: UIButton!
    var menuTableView: UITableView!
    private var menuViewModel: MenuViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.makeMenuView()
        self.makeTableView()
        self.setConstraintOfTableView()
        self.setCloseButton()
        self.menuViewModel = MenuViewModel()
        self.settingRecognitionWhenBackgroundTouched()
        self.menuViewModel.menuHandler = {
            DispatchQueue.main.async {
                self.menuTableView.reloadData()
            }
        }
    }
    
    @objc func tappedBackground() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.menuView.frame.origin.x = self.view.frame.maxX + 20
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.willTODO {
            guard let viewController = segue.destination as? SectionViewController else { return }
            viewController.setSectionMode(mode: .willTODO)
        } else if segue.identifier == Segues.doingTODO {
            guard let viewController = segue.destination as? SectionViewController else { return }
            viewController.setSectionMode(mode: .doingTODO)
        } else if segue.identifier == Segues.completeTODO {
            guard let viewController = segue.destination as? SectionViewController else { return }
            viewController.setSectionMode(mode: .completeTODO)
        }
    }

    @IBAction func touchSideMenuButton(_ sender: UIButton) {
        self.menuViewModel.getActions()
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.menuView.frame.origin.x = self.view.frame.maxX * 0.65
        }
    }
    
    @objc func closeMenuView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.menuView.frame.origin.x = self.view.frame.maxX + 20
        }
    }
    
    private func makeMenuView() {
        self.menuView = UIView()
        self.menuView.backgroundColor = .white
        self.menuView.frame.size.width = self.view.frame.width * 0.35
        self.menuView.frame.size.height = self.view.frame.height
        self.menuView.frame.origin.x = self.view.frame.maxX + 20
        self.menuView.layer.shadowColor = UIColor.gray.cgColor
        self.menuView.layer.shadowRadius = 10
        self.menuView.layer.shadowOpacity = 0.9
        self.view.addSubview(self.menuView)
    }
    
    private func makeTableView() {
        self.menuTableView = UITableView()
        self.menuTableView = UITableView(frame: CGRect(x: 40, y: 60, width: self.view.frame.width * 0.3 - 60, height: self.view.frame.height))
        self.menuTableView.separatorStyle = .none
        self.menuTableView.allowsSelection = false
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        
        let nibName = UINib(nibName: "HistoryCell", bundle: nil)
        self.menuTableView.register(nibName, forCellReuseIdentifier: "historyCell")
        self.menuView.addSubview(self.menuTableView)
    }
    
    private func setConstraintOfTableView() {
        self.menuTableView.translatesAutoresizingMaskIntoConstraints = false
        self.menuTableView.topAnchor.constraint(equalTo: self.menuView.topAnchor, constant: 60).isActive = true
        self.menuTableView.bottomAnchor.constraint(equalTo: self.menuView.bottomAnchor, constant: 0).isActive = true
        self.menuTableView.leadingAnchor.constraint(equalTo: self.menuView.leadingAnchor, constant: 40).isActive = true
        self.menuTableView.trailingAnchor.constraint(equalTo: self.menuView.trailingAnchor, constant: 40).isActive = true
    }
    
    private func setCloseButton() {
        guard let largeBold = UIImage(systemName: "xmark") else { return }
        self.closeButton = UIButton(frame: CGRect(x: self.menuView.frame.width - 50.75, y: 30.75, width: 40, height: 40))
        self.closeButton.tintColor = .black
        self.closeButton.setImage(largeBold, for: .normal)
        self.closeButton.addTarget(self, action: #selector(closeMenuView), for: .touchUpInside)
        self.menuView.addSubview(self.closeButton)
    }
    
    func settingRecognitionWhenBackgroundTouched() {
        self.backgroundView.becomeFirstResponder()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedBackground))
        self.backgroundView.addGestureRecognizer(tapRecognizer)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuViewModel.actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryCell else { return HistoryCell() }
        let action = self.menuViewModel.actions[indexPath.row]
        let attributedContents = makeAttributedText(of: action)
        cell.contents.attributedText = attributedContents
        cell.time.text = action.beforeDate
        cell.stateImageView.image = UIImage(systemName: action.imageName)
        cell.contents.sizeToFit()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}


extension MainViewController {
    func makeAttributedText(of action: ActionForView) -> NSMutableAttributedString {
        let attr = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        let attrBeforeColumns = NSMutableAttributedString(string: action.beforeSectionMode, attributes: attr)
        let attrAfterColumns = NSMutableAttributedString(string: action.afterSectionMode, attributes: attr)
        let attrTitle = NSMutableAttributedString(string: action.title, attributes: attr)
        let attrActionType = NSMutableAttributedString(string: action.actionType, attributes: attr)
        let attrAt = NSMutableAttributedString(string: "을 ")
        let attrFrom = NSMutableAttributedString(string: "에서 ")
        let attrWith = NSMutableAttributedString(string: "로 ")
        let attrTo = NSMutableAttributedString(string: "에 ")
        let attrDone = NSMutableAttributedString(string: "하였습니다.")
        let contents = NSMutableAttributedString(string: "")
        switch action.actionType {
        case "이동":
            contents.append(attrTitle)
            contents.append(attrAt)
            contents.append(attrBeforeColumns)
            contents.append(attrFrom)
            contents.append(attrAfterColumns)
            contents.append(attrWith)
            contents.append(attrActionType)
            contents.append(attrDone)
        default:
            contents.append(attrAfterColumns)
            contents.append(attrTo)
            contents.append(attrTitle)
            contents.append(attrAt)
            contents.append(attrActionType)
            contents.append(attrDone)
        }
        return contents
    }
}
