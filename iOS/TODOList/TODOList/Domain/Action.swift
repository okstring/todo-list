//
//  History.swift
//  TODOList
//
//  Created by Issac on 2021/04/15.
//

import Foundation

struct Action: Codable {
    var cardTitle: String
    var columnFrom: Int
    var columnTo: Int
    var actionType: String
    var createdDateTime: Date
}

