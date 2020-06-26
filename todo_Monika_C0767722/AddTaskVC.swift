//
//  AddTaskVC.swift
//  todo_Monika_C0767722
//
//  Created by S@i on 2020-06-26.
//  Copyright © 2020 S@i. All rights reserved.
//

import UIKit
import CoreData
//Enum For Task
enum Task: String {
    case addTask = "Add", editTask = "Edit"
}


class AddTaskVC: UIViewController {

    @IBOutlet var txtTitle: UITextField!
    @IBOutlet var txtDesc: UITextField!
    @IBOutlet var txtStartDate: UITextField!
    let datePicker = UIDatePicker()
    var listToDo : ToDoListTVC?
    private var taskToDo: TaskToDo?
    private var type: Task = .addTask
    private let persistenceManager = PersistenceManager.shared
   
    class func navigateScreen(With type: Task, and todo: TaskToDo? = nil) -> AddTaskVC {
           let control = self.navigateScreen as! AddTaskVC
           control.type = type
           control.taskToDo = todo
           return control
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func createDatePicker(){
    
    //assign datepicker to our textfield
    txtStartDate.inputView = datePicker
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
