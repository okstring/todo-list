//
//  AddTODOViewController.swift
//  TODOList
//
//  Created by Issac on 2021/04/08.
//

import UIKit

enum FormatType {
    case add, modify
}

protocol sendBackDelegate {
    func dataReceived(subject: String, body: String)
}

class AddViewController: UIViewController, UITextFieldDelegate {
    static let identifier = "AddView"
    @IBOutlet weak var formatTitle: UILabel!
    @IBOutlet weak private var subjectField: ObservingTextField!
    @IBOutlet weak private var bodyField: ObservingTextField!
    @IBOutlet weak private var writeButton: SubmitButton!
    private var formatType: FormatType?
    private var sectionMode: SectionMode?
    private var writeViewModel: CardInputViewModel!
    var delegate: sendBackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.addButtonCheckingTargets()
        self.subjectField.becomeFirstResponder()
        
        if formatType == .modify {
            setModifyMode()
        }
    }
    
    func setFormatType(type: FormatType) {
        self.formatType = type
    }
    
    func setModifyMode() {
        self.formatTitle.text = "카드 수정"
        self.subjectField.text = ""
        self.bodyField.text = ""
        self.writeButton.setTitle("수정", for: .normal)
    }
    
    func setAppearViewModel(of viewModel: CardInputViewModel) {
        self.writeViewModel = viewModel
    }
    
    private func bind() {
        self.subjectField.bind(to: writeViewModel.subject)
        self.bodyField.bind(to: writeViewModel.body)
    }
    
    private func addButtonCheckingTargets() {
        self.subjectField.addTarget(self, action: #selector(checkWriteButton), for: .editingChanged)
        self.bodyField.addTarget(self, action: #selector(checkWriteButton), for: .editingChanged)
    }
    
    @IBAction func touchCancelButton(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func touchSubmitButton(_ sender: UIButton) {
        if formatType == .add {
            guard let mode = sectionMode else { return }
            self.writeViewModel.addCard(mode: mode)
        } else {
            
        }
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
