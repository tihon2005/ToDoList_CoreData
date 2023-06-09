//
//  TableViewController.swift
//  ToDoList
//
//  Created by Tikhon Bazar on 27.04.23.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var tasks : [Tasks] = []
    
    @IBAction func deleteTasks(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Tasks> = Tasks.fetchRequest()
        if let tasks = try? context.fetch(fetchRequest){
            for task in tasks {
                context.delete(task)
            }
        }
        do {
            try context.save()
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    @IBAction func plusTasks(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Task", message: "Enter the Task", preferredStyle: .alert)
        let saveTask = UIAlertAction(title: "Save", style: .default, handler: {action in
            let tf = alertController.textFields?.first
            if let newTask = tf?.text{
                self.saveTask(withTitle: newTask)
                self.tableView.reloadData()
            }
        })
        alertController.addTextField()
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(saveTask)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    func saveTask(withTitle title: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
        let taskObject = Tasks(entity: entity, insertInto: context)
        taskObject.title = title
        do {
            try context.save()
            tasks.append(taskObject)
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Tasks> = Tasks.fetchRequest()
        do{
            tasks = try context.fetch(fetchRequest)
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        return cell
    }
   

}
