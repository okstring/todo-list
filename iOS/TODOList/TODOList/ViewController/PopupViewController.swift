//
//  AddTODOViewController.swift
//  TODOList
//
//  Created by Issac on 2021/04/08.
//

import UIKit

class PopupViewController: UIViewController, UITextFieldDelegate {
    enum SubmitType {
        case add
        case modify
    }
    
    static let identifier = "AddView"
    @IBOutlet weak private var subjectField: ObservingTextField!
    @IBOutlet weak private var bodyField: ObservingTextField!
    @IBOutlet weak private var writeButton: SubmitButton!
    @IBOutlet weak private var mainLabel: UILabel!
    private var sectionMode: SectionMode?
    private var submitType: SubmitType!
    private var writeViewModel: CardInputViewModel!
    private var appearViewModel: CardOutputViewModel!
    private var modifyCard: Card!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtonCheckingTargets()
        self.initSubmitType()
        self.bind()
        self.subjectField.becomeFirstResponder()
        
    }
    
    func initSubmitType() {
        switch submitType {
        case .add: self.setAddView()
        case .modify: self.setModifyView()
        default: return
        }
    }
    
    func setSubmitType(of type: SubmitType) {
        self.submitType = type
    }
    
    func setViewModel(inputViewModel: CardInputViewModel, outputViewModel: CardOutputViewModel) {
        self.writeViewModel = inputViewModel
        self.appearViewModel = outputViewModel
    }
    
    func receiveModifyCard(of card: Card) {
        self.modifyCard = card
    }
    
    private func bind() {
        self.subjectField.bind(to: writeViewModel.subject)
        self.bodyField.bind(to: writeViewModel.body)
        self.writeViewModel.subject.changeValue(to: self.subjectField.text ?? "")
        self.writeViewModel.body.changeValue(to: self.bodyField.text ?? "")
    }
    
    private func addButtonCheckingTargets() {
        self.subjectField.addTarget(self, action: #selector(checkWriteButton), for: .editingChanged)
        self.bodyField.addTarget(self, action: #selector(checkWriteButton), for: .editingChanged)
    }
    
    @IBAction func touchCancelButton(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    func setAddView() {
        self.mainLabel.text = "새로운 카드 등록"
        self.writeButton.removeTarget(nil, action: nil, for: .allEvents)
        self.writeButton.setTitle("등록", for: .normal)
        self.writeButton.setTitle("등록", for: .disabled)
        self.writeButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
    }
    
    @objc func addAction() {
        guard let mode = sectionMode else { return }
        self.writeViewModel.addCard(mode: mode)
        dismiss(animated: false, completion: nil)
    }
    
    
    func setModifyView() {
        self.mainLabel.text = "카드 수정"
        self.subjectField.text = self.modifyCard.title
        self.bodyField.text = self.modifyCard.contents
        self.writeButton.removeTarget(nil, action: nil, for: .allEvents)
        self.writeButton.setTitle("수정", for: .normal)
        self.writeButton.setTitle("수정", for: .disabled)
        self.writeButton.addTarget(self, action: #selector(modifyAction), for: .touchUpInside)
    }
    
    @objc func modifyAction() {
        guard let mode = sectionMode else { return }
        self.writeViewModel.modifyCard(mode: mode, id: modifyCard.id)
        dismiss(animated: false, completion: nil)
    }
    
    @objc func checkWriteButton() {
        if subjectField.text == "" || bodyField.text == "" {
            writeButton.isEnabled = false
        } else {
            writeButton.isEnabled = true
        }
    }
    
    func setSectionMode(mode: SectionMode) {
        self.sectionMode = mode
    }
}
