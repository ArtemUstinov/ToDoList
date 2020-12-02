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

        let task = indexPath.section == 0 ? currentTask?[indexPath.row] : completedTask?[indexPath.row]

        cell.textLabel?.text = task?.name
        cell.detailTextLabel?.text = task?.note
        
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
}
