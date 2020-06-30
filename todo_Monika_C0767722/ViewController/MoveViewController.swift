//
//  MoveViewController.swift
//  todo_Monika_C0767722
//
//  Created by S@i on 2020-06-24
//  Copyright © 2020 S@i. All rights reserved.
//

import UIKit
import CoreData
class MoveViewController: UIViewController {
    
    var categories = [Folder]()
    var selectedTodo: [TaskToDo]? {
        didSet {
            loadCategories()
        }
    }
    @IBOutlet var tblview: UITableView!

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tblview.delegate = self
        tblview.dataSource = self
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}



extension MoveViewController {
    
    func loadCategories() {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        let categoryPredicate = NSPredicate(format: "NOT name MATCHES %@", selectedTodo?[0].parentFolder?.name ?? "")
        request.predicate = categoryPredicate
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data \(error.localizedDescription)")
        }
    }

}

extension MoveViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            for todo in self.selectedTodo! {
                todo.parentFolder = self.categories[indexPath.row]
            }
            self.performSegue(withIdentifier: "backtoScreen", sender: self)
        
    }
}

