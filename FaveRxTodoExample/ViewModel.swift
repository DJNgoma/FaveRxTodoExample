//
//  ViewModel.swift
//  FaveRxTodoExample
//
//  Created by Daliso Ngoma on 04/04/2017.
//  Copyright © 2017 Daliso Ngoma. All rights reserved.
//

import Foundation
import RxSwift

struct ViewModel {
    
    
    private static func defaultItemsToDataSource() -> Variable<[Todo]> {
        return Variable([
            Todo(text: "One"),
            Todo(text: "Two"),
            Todo(text: "Three"),
            Todo(text: "Four"),
            Todo(text: "Five")
            ])
    }
    
    let dataSource: Variable<[Todo]> = {
        return ViewModel.retrieveData()
    }()
    
    func addTodo(withText text: String?) {
        addTodoToDatasource(withText: text)
    }
    
    func removeTodo(atIndex index: Int) {
        dataSource.value.remove(at: index)
        saveToDisk()
    }
    
    func toggleTodoStatus(atIndex index: Int) {
        dataSource.value[index].status = dataSource.value[index].status == 0 ? 1 : 0
        saveToDisk()
    }
    
    func saveToDisk() {
        var archiveArray: [Data] = []
        for todoObject in dataSource.value {
            let todoEncodedObject = NSKeyedArchiver.archivedData(withRootObject: todoObject)
            archiveArray.append(todoEncodedObject)
        }
        
        UserDefaults.standard.set(archiveArray, forKey: "todoArray")
    }
    
    private static func retrieveData() -> Variable<[Todo]> {
        let archivedArray: [Data]? = UserDefaults.standard.value(forKey: "todoArray") as? [Data]
        var unarchivedArray: [Todo] = []
        
        if let archivedArray = archivedArray {
            for data in archivedArray {
                let todoDecodedObject = NSKeyedUnarchiver.unarchiveObject(with: data) as! Todo
                unarchivedArray.append(todoDecodedObject)
            }
        } else {
            return ViewModel.defaultItemsToDataSource()
        }
        return Variable(unarchivedArray)
        
    }
    
    func addTodoToDatasource(withText text:String?) {
        if let text = text {
            dataSource.value.append(Todo(text: text))
            saveToDisk()
        } else {
            print("Text provided is invalid")
        }
    }
    
    func tableViewSwipeActions() -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action , indexPath) -> Void in
            self.removeTodo(atIndex: indexPath.row)
        })
        
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }
    
}

