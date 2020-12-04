//
//  StorageManager.swift
//  RealmApp
//
//  Created by Артём Устинов on 28.11.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import RealmSwift

class StorageManager {
    
    //MARK: SingleTon
    static let shared = StorageManager()
    
    //MARK: - Public properties:
    let realm = try? Realm()
    var isDone = false
    
    //MARK: TaskList methods:
    func saveTaskList(newValue: String) {
        guard let realm = realm else { return }
        let task = TaskList()
        task.name = newValue
        write {
            realm.add(task)
        }
    }
    
    func editTaskList(taskList: TaskList, newValue: String) {
        write {
            taskList.name = newValue
        }
    }
    
    func deleteTaslList(taskList: TaskList) {
        guard let realm = realm else { return }
        let tasks = taskList.tasks
        write {
            realm.delete(tasks)
            realm.delete(taskList)
        }
    }
    
    func isDone(taskList: TaskList) {
        isDone = !isDone
        write {
            taskList.tasks.setValue(isDone, forKey: "isComplete")
        }
    }
    
    //MARK: Task methods:
    func saveTask(newTask: String, in newNote: String, taskList: TaskList?) {
        let task = Task(value: [newTask, newNote])
        write {
            taskList?.tasks.append(task)
        }
    }
    
    func delete(task: Task) {
        guard let realm = realm else { return }
        write {
            realm.delete(task)
        }
    }
    
    func editTask(task: Task, with newValue: String, and newNote: String) {
        write {
            task.name = newValue
            task.note = newNote
        }
    }
    
    func isDoneTask(task: Task) {
        write {
            task.isComplete.toggle()
        }
    }
    
    //MARK: - Private methods:
    private func write(_ completion: () -> Void) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private init() {}
}



