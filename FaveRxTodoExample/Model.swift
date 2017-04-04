//
//  Todo.swift
//  FaveRxTodoExample
//
//  Created by Daliso Ngoma on 04/04/2017.
//  Copyright © 2017 Daliso Ngoma. All rights reserved.
//

import Foundation

class Todo: NSObject, NSCoding {
    
    
    let id: String
    let text: String
    let date: NSDate
    var status: NSNumber // Should be bool, using NSNumber for now.
    
    init(text: String) {
        self.id = UUID().uuidString
        self.text = text
        self.date = NSDate()
        self.status = 0
    }
    
    private init(id: String, text: String, date: NSDate, status: NSNumber) {
        self.id = id
        self.text = text
        self.date = date
        self.status = 0
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard let id = decoder.decodeObject(forKey: "id") as? String,
            let text = decoder.decodeObject(forKey: "text") as? String,
            let date = decoder.decodeObject(forKey: "date") as? NSDate,
            let status = decoder.decodeObject(forKey: "status") as? NSNumber
            else { return nil }
        
        self.init(
            id: id,
            text: text,
            date: date,
            status: status
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.text, forKey: "text")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.status, forKey: "status")
    }
}
