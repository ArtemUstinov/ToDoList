//
//  TaskTableViewController.swift
//  RealmApp
//
//  Created by Артём Устинов on 27.11.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit
import RealmSwift

class TaskTableViewController: UITableViewController {
    
    //MARK: - Public properties:
    var taskList: TaskList?
    var currentTask: Results<Task>?
    var completedTask: Results<Task>?
    
    //MARK: - Override methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = taskList?.name
        
        currentTask = taskList?.tasks.filter("isComplete = false")
        completedTask = taskList?.tasks.filter("isComplete = true")
        
        
        let addButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        navigationItem.rightBarButtonItems = [addButtonItem ,editButtonItem]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTask?.count ?? 0 : completedTask?.count ?? 0
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        let task = indexPath.section == 0
            ? currentTask?[indexPath.row]
            : completedTask?[indexPath.row]
        
        cell.textLabel?.text = task?.name
        cell.detailTextLabel?.text = task?.note
        
        return cell
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let task = indexPath.section == 0 ?
            currentTask?[indexPath.row] : completedTask?[indexPath.row] else { return nil }
        let title = indexPath.section == 0 ? "Completed" : "Not completed"
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.shared.delete(task: task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, isDone) in
            self.showAlert(task: task) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let isCompletedAction = UIContextualAction(style: .normal, title: title) { (_, _, isDone) in
            StorageManager.shared.isDoneTask(task: task)
            
            let indexPathForCurrentTask = IndexPath(row: (self.currentTask?.count ?? 0) - 1, section: 0)
            let indexPathForCompletedTask = IndexPath(row: (self.completedTask?.count ?? 0) - 1, section: 1)
            let destinationSection = indexPath.section == 0 ?
                indexPathForCompletedTask : indexPathForCurrentTask
        
            tableView.moveRow(at: indexPath, to: destinationSection)
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        if title == "Completed"{
            isCompletedAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else {
            isCompletedAction.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        }
        
        return UISwipeActionsConfiguration(actions: [isCompletedAction, editAction, deleteAction])
    }
}

extension TaskTableViewController {
    
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Update task" : "New task"
        
        let alert = AlertController(title: title,
                                    message: "What do you want to add?",
                                    preferredStyle: .alert)
        
        alert.action(task: task) { (newTask, newNote) in
            if let task = task, let completion = completion {
                StorageManager.shared.editTask(task: task, with: newTask, and: newNote)
                completion()
            } else {
                StorageManager.shared.saveTask(newTask: newTask, in: newNote, taskList: self.taskList)
                let indexPath = IndexPath(row: (self.currentTask?.count ?? 0) - 1, section: 0 )
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        present(alert, animated: true)
    }
}
