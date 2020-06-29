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
class AddTaskVC: UIViewController {

    var toDoListTVC: ToDoListTVC?
    var pickDate : Date?
    @IBOutlet var txttitle: UITextField!
    
    @IBOutlet var txtDesc: UITextField!

    @IBOutlet var lblCurrent: UILabel!
    
    @IBOutlet var btnSave: UIBarButtonItem!
    

    @IBOutlet var startDate: UITextField!
   
    @IBOutlet var endDate: UITextField!
    let datePicker = UIDatePicker()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        let tap = UITapGestureRecognizer(target: self, action: #selector(resetFocus))
        view.addGestureRecognizer(tap)
        if let toDoListTVC = toDoListTVC{
            btnSave.title = "Update"
            let task = toDoListTVC.selectedTask
            txttitle.text = task?.title
            txtDesc.text = task?.desc
            startDate.text = "\(String(describing: task!.dateTime!))"
          //  endDate.text = "\(String(describing: task?.totalDays))"
            
          
        }
        let date = Date()
                   // date
                   let dformatter = DateFormatter()
                   dformatter.dateFormat = "d MMM"
                   let stDate = dformatter.string(from: date)
                   
                   // day
                   let eformatter = DateFormatter()
                   eformatter.dateFormat = "EEEE"
                   let stDay = eformatter.string(from: date)
                   
                   lblCurrent.text = currentDate()
    }
    func currentDate() -> String{
        let date = Date()
        // date
        let dformatter = DateFormatter()
        dformatter.dateFormat = "d MMM"
        let stDate = dformatter.string(from: date)
        print(stDate)
        // day
        let eformatter = DateFormatter()
        eformatter.dateFormat = "EEEE"
        let stDay = eformatter.string(from: date)
        
        return String(format: "%@, %@", stDay, stDate)
        
    }
    @objc func resetFocus() {
           txttitle.resignFirstResponder()
           txtDesc.resignFirstResponder()
       }
    func createDatePicker(){
     
            //format for datepicker display
            datePicker.datePickerMode = .date
            datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            //assign datepicker to our textfield
            startDate.inputView = datePicker
       
            //create a toolbar
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            //add a done button on this toolbar
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
            
            toolbar.setItems([doneButton], animated: true)
            
            startDate.inputAccessoryView = toolbar
           
        }
     
    @objc func doneClicked(){
     
            //format for displaying the date in our textfield
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            startDate.text = dateFormatter.string(from: datePicker.date)
            pickDate = datePicker.date
            self.view.endEditing(true)
        
    }
    
   
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        let date = Date()
        // date
       
        let diff = Calendar.current.dateComponents([.day], from: Date(), to: datePicker.date)
        print("\(diff.day!)")
      
        let task = Task(title: txttitle.text, desc: txtDesc.text, dateTime: datePicker.date, workeddays: 0, totalDays: Int(diff.day!))
        
    
        
        if let toDoListTVC = toDoListTVC{
            deleteTaskData(tasks: [toDoListTVC.selectedTask!])
            toDoListTVC.selectedTask = nil
            toDoListTVC.isNewTask = true
            
        }
        
        saveTask(tasks: [task])
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (txttitle.text!.isEmpty) || (txtDesc.text!.isEmpty) {
            
            let alert = UIAlertController(title: "Empty field!", message: "Please enter data to save...", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (act) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
            return false
        }
        if(!txttitle.text!.isEmpty && toDoListTVC == nil && !fetchSavedData(search: txttitle.text!, isSame: true).isEmpty) {
        let alert = UIAlertController(title: "Same title!", message: "Can't have same titles", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (act) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
   
}
