//
//  CategoryViewController.swift
//  todo_Monika_C0767722
//
//  Created by S@i on 2020-06-24.
//  Copyright © 2020 S@i. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class CategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var categoryContext: NSManagedObjectContext!
    var notificationArray = [TaskToDo]()
    
    var categoryName = UITextField()
    var category: [Folder] = [Folder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        categoryContext = appDelegate.persistentContainer.viewContext
        getData()
        setUp()
        createDefaultFolder()
        setUpNotifications()
    }
    
    @IBAction func addCategory(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: addCategoryName(textField:))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if(self.categoryName.text!.count < 1) {
                self.customeShowAlert()
                return
            }
            else {
                self.addNewCategory()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Alert!", message: "Please enter catogry name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func addCategoryName(textField: UITextField) {
        
        self.categoryName = textField
        self.categoryName.placeholder = "Enter Category Name"
        
    }

}

extension CategoryViewController {

    
    func createDefaultFolder() {
        let categoryNames = self.category.map {$0.name}
        guard !categoryNames.contains("Archive") else {return}
        let newCategory = Folder(context: self.categoryContext)
        newCategory.name = "Archive"
        self.category.append(newCategory)
        do {
            try categoryContext.save()
            tableView.reloadData()
        } catch {
            print((error.localizedDescription))
        }
    }
    
    
    func getData() {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            category = try categoryContext.fetch(request)
        } catch {
            print((error.localizedDescription))
        }
        tableView.reloadData()
        
    }
    
    func addNewCategory() {
        
        let categoryNames = self.category.map {$0.name}
        guard !categoryNames.contains(categoryName.text) else {self.showAlert(); return}
        let newCategory = Folder(context: self.categoryContext)
        newCategory.name = categoryName.text!
        self.category.append(newCategory)
        do {
            try categoryContext.save()
            tableView.reloadData()
        } catch {
            print((error.localizedDescription))
        }
        
    }
    
    func customeShowAlert() {
        let alert = UIAlertController(title: "Category Already Exists!", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TasksTODoViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = category[indexPath.row]
        }
    }
    
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {

    func setUp() {
        tableView.delegate = self
        tableView.dataSource = self
    }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let cat = category[indexPath.row]
        if cat.name == "Archive" {
            cell.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        }
        cell.textLabel?.text = cat.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
                self.categoryContext.delete(self.category[indexPath.row])
                self.category.remove(at: indexPath.row)
                do {
                    try self.categoryContext.save()
                } catch {
                    print("\(error.localizedDescription)")
                }
                self.tableView.reloadData()
                completion(true)
        }
        
        delete.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        delete.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TaskToDoSegue", sender: self)
    }
}


extension CategoryViewController {
    func setUpNotifications() {
        
        checkDueDates()
        print("tetettet\(notificationArray.count)")
        if notificationArray.count > 0 {
            for task in notificationArray {
                
                if let taskname = task.title {
                    print("TaskN NAme is \(taskname)")
                    let notificationCenter = UNUserNotificationCenter.current()
                    let notificationContent = UNMutableNotificationContent()
                    
                    notificationContent.title = "Due Task Reminder"
                    notificationContent.body = "Hello, Task \(taskname) is due tommorow Please Finish this task onTime"
                    notificationContent.sound = .default
                    let fromDate = Calendar.current.date(byAdding: .day, value: -1, to: task.dateTime!)!
                    let components = Calendar.current.dateComponents([.month, .day, .year], from: fromDate)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                    print("dsddsd \(trigger)")
                    let request = UNNotificationRequest(identifier: "\(taskname)", content: notificationContent, trigger: trigger)
                    notificationCenter.add(request) { (error) in
                        if error != nil {
                            print("test error is \(error!)")
                        }
                    }
                    print("Notoificacac Request \(request)")
                }
            }
        }
        
    }

    func checkDueDates() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<TaskToDo> = TaskToDo.fetchRequest()
        do {
            let notifications = try context.fetch(request)
            for task in notifications {
                if Calendar.current.isDateInTomorrow(task.dateTime!) {
                    notificationArray.append(task)
                    print("Notofication DUE Date \(notificationArray.count)")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}

