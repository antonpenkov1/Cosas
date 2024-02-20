//
//  ViewController.swift
//  Cosas
//
//  Created by Антон Пеньков on 17.02.2024.
//

import UIKit
import RealmSwift

protocol NewTaskViewControllerDelegate: AnyObject {
    func reloadData()
}

final class TasksListViewController: UITableViewController {

    // MARK: - Private Properties
    private var tasks: Results<ToDoTask>!
    private let storageManager = StorageManager.shared
    private let dataManager = DataManager.shared
    private let cellID = "task"
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .floralwhite
        setupNavigationBar()
        
        createTempData()
        tasks = storageManager.fetchTaskList()
    }

}

// MARK: - Private Methods
extension TasksListViewController {
    @objc func addNewTask() {
        let newTaskVC = TaskViewController()
        present(newTaskVC, animated: true)
    }
    
    private func createTempData() {
        if !UserDefaults.standard.bool(forKey: "done") {
            dataManager.createTempData { [unowned self] in
                UserDefaults.standard.setValue(true, forKey: "done")
                tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension TasksListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
        content.imageProperties.tintColor = UIColor(named: "DarkBlue")
        content.text = task.title
        cell.backgroundColor = .floralwhite
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TasksListViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = tasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            storageManager.delete(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { [unowned self] _, _, isDone in
            // TODO: -
            storageManager.done(task)
            tableView.reloadRows(at: [indexPath], with: .right)
            isDone(true)
        }
        
        deleteAction.backgroundColor = .floralRed
        doneAction.backgroundColor = .floralGreen
        
        return UISwipeActionsConfiguration(actions: [doneAction, deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: -
        let taskVC = TaskViewController()
        taskVC.task = tasks[indexPath.row]
        present(taskVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Setup UI
private extension TasksListViewController {
    func setupNavigationBar() {
        title = "Cosas"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.backgroundColor = .floralwhite
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.darkBlue]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkBlue]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .darkBlue
    }
}

extension TasksListViewController: NewTaskViewControllerDelegate {
    func reloadData() {
        
        tableView.reloadData()
    }
}
