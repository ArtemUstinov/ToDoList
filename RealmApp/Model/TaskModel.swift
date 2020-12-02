//
//  TaskModel.swift
//  RealmApp
//
//  Created by Артём Устинов on 28.11.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import RealmSwift

class TaskList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
}

