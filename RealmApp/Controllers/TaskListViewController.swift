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
    
    //MARK: - IBOutlets:
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Private properties:
    private var taskLists: Results<TaskList>?
    private var isEditingMode = false
    
    //MARK: - Override methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskLists = StorageManager.shared.realm?.objects(TaskList.self)
        
//        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
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

//MARK: TableViewDataSource
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

//MARK: TableViewDelegate
extension TaskListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let taskList = taskLists?[indexPath.row] else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            
            StorageManager.shared.deleteTaslList(taskList: taskList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, isDone) in
            print("SHOW")
            self.showAlert(taskList: taskList) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (_, _, isDone) in
            StorageManager.shared.isDone(taskList: taskList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
        return configuration
    }
}


//MARK: AlertController
extension TaskListViewController {
    
    private func showAlert(taskList: TaskList? = nil, completion: (() -> Void)? = nil) {
        
        let title = taskList != nil ? "Update the task" : "Add the new task"
        
        let alert = AlertController(title: title,
                                    message: "What do you want to add?",
                                    preferredStyle: .alert)
        
        alert.action(with: taskList) { newValue in
            if let taskList = taskList, let completion = completion {
                print("YES")
                StorageManager.shared.editTaskList(taskList: taskList, newValue: newValue)
                completion()
            } else {
                StorageManager.shared.saveTaskList(newValue: newValue)
                let indexPath = IndexPath(row: (self.taskLists?.count ?? 0) - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        present(alert, animated: true)
    }
}

