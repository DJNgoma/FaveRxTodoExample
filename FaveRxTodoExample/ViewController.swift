//
//  ViewController.swift
//  FaveRxTodoExample
//
//  Created by Daliso Ngoma on 04/04/2017.
//  Copyright © 2017 Daliso Ngoma. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ViewController: UIViewController {

    let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButtonTouchUpInside() {
        viewModel.addTodo(withText: textField.text)
        textField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView
            .rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
        textField.delegate = self
        
        viewModel.dataSource
            .asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: "Cell")) {
                _, todo, cell in
                cell.textLabel?.text = todo.text
                cell.accessoryType = todo.status == 1 ? .checkmark : .none
        }
        .addDisposableTo(disposeBag)
        
        let textFieldIsValid = textField.rx.text.orEmpty
            .map { $0.characters.count >= 1 }
        
        textFieldIsValid
            .bindTo(addButton.rx.isEnabled)
            .disposed(by: disposeBag)

    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        return viewModel.tableViewSwipeActions()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleTodoStatus(atIndex: indexPath.row)
        
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.addTodo(withText: textField.text)
        textField.text = ""
        return true
    }
}
