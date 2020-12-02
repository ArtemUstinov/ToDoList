//
//  AlertController.swift
//  RealmApp
//
//  Created by Артём Устинов on 28.11.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    
    func action(taskList: TaskList?, completion: @escaping (String) -> Void) {
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = self.textFields?.first?.text, !task.isEmpty else { return }
            taskList?.name = task
            completion(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addTextField { textField in
            textField.placeholder = "Task"
            textField.text = (taskList as AnyObject).name
        }
        
        addAction(saveAction)
        addAction(cancelAction)
    }
}
