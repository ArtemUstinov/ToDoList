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
    
    //MARK: - Private properties:
    let realm = try? Realm()
    
    func saveTaskList(newValue: String) {
        
        let task = TaskList()
        task.name = newValue
        
        if let realm = realm {
            try? realm.write {
                realm.add(task)
            }
        }
    }
    
    func editTaskList(taskList: TaskList, newValue: String) {
        
        if let realm = realm {
            realm.beginWrite()
            taskList.name = newValue
            try? realm.commitWrite()
            realm.refresh()
            
            //            try? realm.write {
//                taskList.name = newValue
//                realm.refresh()
//            }
//            try? realm.commitWrite()
        }
    }
    
    func deleteTaslList(taskList: TaskList) {
        if let realm = realm {
            try? realm.write {
                    realm.delete(taskList)
                }
            }
        }
        
        private init() {}
}



