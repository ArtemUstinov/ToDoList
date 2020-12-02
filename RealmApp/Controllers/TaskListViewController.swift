//
//  TaskListViewController.swift
//  RealmApp
//
//  Created by Артём Устинов on 27.11.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var taskLists: Results<TaskList>?
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskLists = StorageManager.shared.realm?.objects(TaskList.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let taskTableVC = segue.destination as! TaskTableViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        taskTableVC.taskList = taskLists?[indexPath.row]
    }
    
    
    //MARK: - IBActions:
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        isEditingMode = !isEditingMode
        tableView.setEditing(isEditingMode, animated: true)
    }
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        showAlert()
    }
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            taskLists = taskLists?.sorted(byKeyPath: "name")
        case 1:
            taskLists = taskLists?.sorted(byKeyPath: "date")
        default: print("You have a new segment")
        }
        tableView.reloadData()
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskLists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath)
        
        cell.textLabel?.text = taskLists?[indexPath.row].name
        cell.detailTextLabel?.text = "\(taskLists?[indexPath.row].tasks.count ?? 0)"
        
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //    func tableView(_ tableView: UITableView,
    //                   commit editingStyle: UITableViewCell.EditingStyle,
    //                   forRowAt indexPath: IndexPath) {
    //
    //    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            if let taskList = self.taskLists {
                StorageManager.shared.deleteTaslList(taskList: taskList[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            if let taskList = self.taskLists {
                
                let task = taskList[indexPath.row]
                
                self.showAlert(task: task) {
                    task.realm?.refresh()
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
}


//MARK: AlertController
extension TaskListViewController {
    
    private func showAlert(task: TaskList? = nil, completion: (() -> Void)? = nil) {
        
        let title = task != nil ? "Update the task" : "Add the new task"
        
        let alert = AlertController(title: title,
                                    message: "What do you want to add?",
                                    preferredStyle: .alert)
        
        alert.action(taskList: task) { newValue in
            if let title = task, let completion = completion {
                StorageManager.shared.editTaskList(taskList: title, newValue: newValue)
                completion()
            } else {
                StorageManager.shared.saveTaskList(newValue: newValue)
                self.tableView.insertRows(at: [IndexPath(row: (self.taskLists?.count ?? 0) - 1,
                                                         section: 0)], with: .automatic)
            }
        }
        present(alert, animated: true)
    }
}

