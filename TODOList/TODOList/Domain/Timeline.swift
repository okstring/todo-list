//
//  TimeLine.swift
//  TODOList
//
//  Created by 양준혁 on 2021/04/07.
//

import Foundation

class Timeline {
    var feeds: [Feed]
    
    init() {
        feeds = []
    }
    
    func add(title: String, timeStamp: Date, actionState: ActionState) {
        let feed = Feed(cardTitle: title, timeStamp: timeStamp, actionState: actionState)
        self.feeds.append(feed)
    }
}
