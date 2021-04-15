//
//  CardForPost.swift
//  TODOList
//
//  Created by Issac on 2021/04/15.
//

import Foundation

//MARK: - POST
struct CardForPost {
    var title: String
    var contents: String
    var columnId: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case contents
        case columnId = "column_id"
    }
}
