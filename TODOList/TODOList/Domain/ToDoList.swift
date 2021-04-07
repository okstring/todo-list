//
//  ToDoList.swift
//  TODOList
//
//  Created by 양준혁 on 2021/04/06.
//

import Foundation

class ToDoList {
    private var toDo: ToDo
    private var doing: Doing
    private var done: Done
    private var timeline: Timeline
    
    
    init(toDo: ToDo, doing: Doing, done: Done, timeline: Timeline) {
        self.toDo = toDo
        self.doing = doing
        self.done = done
        self.timeline = timeline
    }
    
    
    func addTimeLine() {
        
    }
}
