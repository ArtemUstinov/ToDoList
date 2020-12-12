//
//  Extension + UITableViewCell.swift
//  RealmApp
//
//  Created by Артём Устинов on 04.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
     func configure(with taskList: TaskList?) {
    
        guard let currentTasks = taskList?.tasks.filter("isComplete = false") else { return }
        guard let completedTasks = taskList?.tasks.filter("isComplete = true") else { return }
        
        textLabel?.text = taskList?.name
        tintColor = .green
        
        if !currentTasks.isEmpty {
            detailTextLabel?.text = "\(currentTasks.count)"
            accessoryType = .none
        } else if !completedTasks.isEmpty {
            detailTextLabel?.text = nil
            accessoryType = .checkmark
        } else {
            detailTextLabel?.text = "\(currentTasks.count)"
            accessoryType = .none
        }
    }
}
