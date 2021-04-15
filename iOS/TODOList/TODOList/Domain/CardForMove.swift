//
//  CardForMove.swift
//  TODOList
//
//  Created by Issac on 2021/04/15.
//

import Foundation

struct CardForMove {
    var cloumnId: Int
    
    enum CodingKeys: String, CodingKey {
        case columnId = "column_id"
    }
}
