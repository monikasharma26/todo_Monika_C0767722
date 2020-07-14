//
//  TasksTODoViewController.swift
//  todo_Monika_C0767722
//
//  Created by S@i on 2020-06-24.
//  Copyright © 2020 S@i. All rights reserved.
//

import UIKit
import CoreData

class TasksTODoViewController: UIViewController,UISearchBarDelegate {

var selectedSort = 0
    
    var selectedCategory: Folder? {
        didSet {
            loadTask()
        }
    }
    @IBOutlet var toolbar: UIToolbar!
    var categoryName: String!
    let todoListContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasksArray = [TaskToDo]()
    var selectedTodo: TaskToDo?
    var todoToMove = [TaskToDo]()
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
  
    

 
    @IBOutlet var segmentSort: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        toolbar.isHidden = true
        setUpTableView()
        
    }
    @IBAction func sort(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
              case 0: selectedSort = 0
                  break
              case 1: selectedSort = 1
                  break
              default:
                  break
              }
              
              loadTask()
        
           tblView.reloadData()
    }
    
    @IBAction func addTask(_ sender: Any) {
         performSegue(withIdentifier: "addTaskSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? AddTaskVC {
            destination.delegate = self
            if selectedTodo != nil
            {
                destination.taskToDo = selectedTodo
            }
        }
        if let destination = segue.destination as? MoveViewController {
                destination.selectedTodo = todoToMove
        }
        
    }
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func unwindTaskToDO(_ unwindSegue: UIStoryboardSegue) {
           saveTask()
           loadTask()
           tblView.reloadData()
       }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                   
           let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
           loadTask(predicate: predicate)
           tblView.reloadData()
       }
       
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchBar.text?.count == 0 {
               loadTask()

               DispatchQueue.main.async {
                   searchBar.resignFirstResponder()
               }

           }
           loadTask()
           tblView.reloadData()
       }
       
       
       
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           loadTask()
           DispatchQueue.main.async {
               searchBar.resignFirstResponder()
           }
           tblView.reloadData()
           searchBar.resignFirstResponder()
       }
   
}


extension TasksTODoViewController {
    
    func loadTask(with request: NSFetchRequest<TaskToDo> = TaskToDo.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let sortBy = ["desc","title"]
        let todoPredicate = NSPredicate(format: "parentFolder.name=%@", selectedCategory!.name!)
        request.sortDescriptors = [NSSortDescriptor(key: sortBy[selectedSort], ascending: true)]
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [todoPredicate, addtionalPredicate])
        } else {
            request.predicate = todoPredicate
        }
        
        do {
            tasksArray = try todoListContext.fetch(request)
        } catch {
            print(error)
        }
        
    }
    
   
    
    func saveTask() {
        do {
            try todoListContext.save()
        } catch {
            print(error)
        }
    }
    
    func taskDone() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        let folderPredicate = NSPredicate(format: "name MATCHES %@", "Archive")
        request.predicate = folderPredicate
        do {
            let category = try context.fetch(request)
            self.selectedTodo?.parentFolder = category.first
            saveTask()
            tasksArray.removeAll { (Todo) -> Bool in
                Todo == selectedTodo!
            }
            tblView.reloadData()
        } catch {
            print(error)
        }
        
    }
   
    
    func saveTask(title: String,desc: String ,endDate: Date)
    {
        let todo = TaskToDo(context: todoListContext)
        todo.title = title
        todo.desc = desc
        todo.dateTime = endDate
        todo.endDate = Date()
        todo.parentFolder = selectedCategory
        saveTask()
        tasksArray.append(todo)
        tblView.reloadData()
    }
    
    func updateTask() {
        saveTask()
        tblView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedTodo = nil
    }
    
    func search()
    {
        
    }
  
}


extension TasksTODoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setUpTableView() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.rowHeight = UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        let task = tasksArray[indexPath.row]
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.desc
    
        if (Calendar.current.isDateInYesterday(task.dateTime!) && task.parentFolder?.name != "Archive") {
            cell.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
       else if (Calendar.current.isDateInToday(task.dateTime!) || Calendar.current.isDateInTomorrow(task.dateTime!) && task.parentFolder?.name != "Archive") {
            cell.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
        else{
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
       
        if(tasksArray.count != 0){
            toolbar.isHidden = false}
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            self.todoListContext.delete(self.tasksArray[indexPath.row])
            self.tasksArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
         delete.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        let addAday = UIContextualAction(style: .destructive, title: "Add Day") { (action, view, completion) in
        self.tasksArray[indexPath.row].dateTime =
                            self.tasksArray[indexPath.row].dateTime?.addingTimeInterval(24*60*60)
            self.updateTask()
            
            //print("sss\(self.tasksArray[indexPath.row].dateTime)")
            completion(true)
        }
        
       
        addAday.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        delete.image = UIImage(systemName: "trash.fill")
        addAday.image = UIImage(systemName: "plus.fill")
        return UISwipeActionsConfiguration(actions: [delete,addAday])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let move = UIContextualAction(style: .normal, title: "Move") { (action, view, completion) in
            self.todoToMove.append(self.tasksArray[indexPath.row])
            self.performSegue(withIdentifier: "moveTaskSegue", sender: nil)
        }
        let complete = UIContextualAction(style: .normal, title: "Complete") { (action, view, completion) in
                   self.selectedTodo = self.tasksArray[indexPath.row]
                   self.taskDone()
               }
        complete.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        move.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        return UISwipeActionsConfiguration(actions: [complete, move])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTodo = tasksArray[indexPath.row]
        performSegue(withIdentifier: "addTaskSegue", sender: self)
    }
    
}




