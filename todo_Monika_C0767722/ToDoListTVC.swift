//
//  ToDoListTVC.swift
//  todo_Monika_C0767722
//
//  Created by S@i on 2020-06-25.
//  Copyright © 2020 S@i. All rights reserved.
//

import UIKit
import CoreData

var delegate: AppDelegate?
var context: NSManagedObjectContext?
var dateFormatter: DateFormatter?

class ToDoListTVC: UITableViewController, UISearchBarDelegate {

    //  MARK: variables
   // var toDoListTVC: ToDoListTVC?
    var oldTasks: [Task] = []
    var tasks: [Task] = []
    var isAsc = true
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    var selectedTask : Task?
    var isNewTask: Bool = true
     var taskToDo = [TaskToDo]()
    
    var selectedFolder: Folder? {
        didSet {
            loadNotes()
        }
    }
    // create a context
   //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //  MARK: outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
   
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
          searchBar.delegate = self
        dateFormatter = DateFormatter()
        dateFormatter!.dateFormat = "dd M, YY"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(resetFocus))
        navigationController?.navigationBar.addGestureRecognizer(tap)
      
       
    }
    func loadNotes(with request: NSFetchRequest<TaskToDo> = TaskToDo.fetchRequest(), predicate: NSPredicate? = nil) {
       //        let request: NSFetchRequest<Note> = Note.fetchRequest()
               let folderPredicate = NSPredicate(format: "parentFolder.name=%@", selectedFolder!.name!)
               request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
               if let addtionalPredicate = predicate {
                   request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [folderPredicate, addtionalPredicate])
               } else {
                   request.predicate = folderPredicate
               }
               
               do {
                taskToDo = try context.fetch(request) 
               } catch {
                   print("Error loading notes \(error.localizedDescription)")
               }
               
               tableView.reloadData()
           }
    @objc func resetFocus() {
           searchBar.resignFirstResponder()
       }
    
    //  MARK: sort by title
    @IBAction func onSortByTitle(_ sender: UIBarButtonItem) {
        isAsc.toggle()
        tasks = fetchSavedData(isDate: false, isAsc: isAsc)
        tableView.reloadData()
    }
    
    //  MARK: sort by date
    @IBAction func onSortByDate(_ sender: UIBarButtonItem) {
        isAsc.toggle()
        tasks = fetchSavedData(isDate: true, isAsc: isAsc)
        tableView.reloadData()
    }
    
    //  MARK: view will appear
    override func viewWillAppear(_ animated: Bool) {
        isNewTask = true
        tasks = []
        searchBar.text = ""
        tasks = fetchSavedData(isAsc: isAsc)
        tableView.reloadData()
    }
    
    //  MARK: on search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tasks = []
        if !searchText.isEmpty {
            tasks = fetchSavedData(search: searchText, isAsc: isAsc)
            tableView.reloadData()
        }else{
            tasks = fetchSavedData(isAsc: isAsc)
        }
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell{

            let position = indexPath.row
            let task = tasks[position]
            cell.configureCell(todo: task,searchText: searchBar.searchTextField.text!)
            return cell
        }

        return UITableViewCell()
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pos = indexPath.row
        let task = self.tasks[pos]
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (act, v, nil) in
            act.backgroundColor = .red
            self.tasks.remove(at: pos)
            
            //  update database
            deleteTaskData(tasks: [task])
            
            tableView.reloadData()
        }
        
        let increase = UIContextualAction(style: .normal, title: "Add a day") { (act, v, nil) in
            act.backgroundColor = .green
          
            task.workeddays = task.workeddays! + 1
            
           if task.workeddays! <= task.totalDays!{
            
                self.tasks[pos] = task
                
                //  update database
                deleteTaskData(tasks: [task])
               
                saveTask(tasks: [task])
                tableView.reloadData()
            }
           
        }
        
        var acts : UISwipeActionsConfiguration?
       if task.totalDays!  > task.workeddays! {
         acts = UISwipeActionsConfiguration(actions: [delete,increase])
        }else{
           acts = UISwipeActionsConfiguration(actions: [delete])
        }
        return acts
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           print("inside prepare")
           if let addTaskVC = segue.destination as? AddTaskVC {
               if let cell = sender as? TaskTableViewCell{
                   addTaskVC.toDoListTVC = self
                   let pos = tableView.indexPath(for: cell)?.row
                   selectedTask = tasks[pos!]
                  
               }
               
           }
       }
       
       
       @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
           let sourceViewController = unwindSegue.source
           // Use data from the view controller which initiated the unwind segue
           
       }

}
   


