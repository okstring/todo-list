//
//  Card.swift
//  TODOList
//
//  Created by Issac on 2021/04/11.
//

import Foundation
import MobileCoreServices

class Card: NSObject, Codable {
    var id: Int
    var title: String
    var contents: String
    var columnType: Int
    var createdDateTime: Date
    
    init(id: Int, title: String, contents: String, columnType: Int, createdDateTime: Date) {
        self.id = id
        self.title = title
        self.contents = contents
        self.columnType = columnType
        self.createdDateTime = createdDateTime
    }
}
