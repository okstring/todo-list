//
//  ActionType.swift
//  TODOList
//
//  Created by Issac on 2021/04/16.
//

import Foundation

enum ActionType: String {
    case ADD
    case UPDATE
    case DELETE
    case MOVE
    
    var sectionTitle: String {
        switch self {
        case .ADD: return "등록"
        case .UPDATE: return "수정"
        case .DELETE: return "삭제"
        case .MOVE: return "이동"
        }
    }
}
