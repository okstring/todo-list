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
    var columnId: Int
    var createdDateTime: Date
    
    init(id: Int, title: String, contents: String, columnId: Int, createdDateTime: Date) {
        self.id = id
        self.title = title
        self.contents = contents
        self.columnId = columnId
        self.createdDateTime = createdDateTime
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case contents
        case columnId = "column_id"
        case createdDateTime = "created_date_time"
    }
    
    
    
}
