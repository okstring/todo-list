//
//  CardForPost.swift
//  TODOList
//
//  Created by Issac on 2021/04/15.
//

import Foundation

//MARK: - POST
class CardForPost: NSObject, Codable {
    var title: String
    var contents: String
    var columnType: Int
    
    init(title: String, contents: String, columnType: Int) {
        self.title = title
        self.contents = contents
        self.columnType = columnType
    }
    
}
