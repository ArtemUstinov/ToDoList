//
//  AlertController.swift
//  RealmApp
//
//  Created by Артём Устинов on 28.11.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    
    func action(with taskList: TaskList?, completion: @escaping (String) -> Void) {
        
        let doneButton = taskList != nil ? "Update" : "Save"
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let task = self.textFields?.first?.text, !task.isEmpty else { return }
            completion(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addTextField { textField in
            textField.placeholder = "Task"
            textField.text = taskList?.name
        }
        
        addAction(saveAction)
        addAction(cancelAction)
    }
    
    func action(task: Task?, completion: @escaping (String, String) -> Void) {
        
        let doneButton = task != nil ? "Update" : "Save"
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let taskName = self.textFields?.first?.text, !taskName.isEmpty else { return }
            
            if let note = self.textFields?.last?.text, !note.isEmpty {
                completion(taskName, note)
            } else {
                completion(taskName, "")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        addTextField { textField in
            textField.placeholder = "New task"
            textField.text = task?.name
        }
        addTextField { textField in
            textField.placeholder = "New note"
            textField.text = task?.note
        }
        addAction(saveAction)
        addAction(cancelAction)
    }
}
