//
//  MyTodo.swift
//  MyTodoList
//
//  Created by 高杉秀有平 on 2016/07/15.
//  Copyright © 2016年 高杉秀有平. All rights reserved.
//

import Foundation

class MyTodo: NSObject, NSCoding {
    var todoTitle: String?
    var todoDone: Bool = false

    init(title: String?, done: Bool = false) {
        todoTitle = title
        todoDone = done
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObjectForKey("todoTitle") as? String
        todoDone = aDecoder.decodeBoolForKey("todoDone")
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(todoTitle, forKey: "todoTitle")
        aCoder.encodeBool(todoDone, forKey: "todoDone")
    }
}
