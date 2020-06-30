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

   
      var taskToDo: TaskToDo?
  
    var pickDate : Date?
     var delegate: TasksTODoViewController?
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
       
        if let toDoListTVC = taskToDo{
            btnSave.title = "Update"
           // let task = toDoListTVC.selectedTask
            txttitle.text = toDoListTVC.title
            txtDesc.text = toDoListTVC.desc
            let dformatter = DateFormatter()
            dformatter.dateFormat = "MMM d,YYYY"
            let stDate = dformatter.string(from: toDoListTVC.dateTime!)
            startDate.text = stDate
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
    
   @IBAction func saveTask(_ sender: Any) {
          if(validations())
          {
              if taskToDo == nil
              {
                delegate?.saveTask(title: txttitle.text!, desc: txtDesc.text!, endDate: datePicker.date)
                  
              }
              else
              {
                taskToDo?.title = txttitle!.text!
                taskToDo?.desc = txtDesc.text
                taskToDo?.dateTime = datePicker.date
                delegate?.updateTask()
              }
              navigationController?.popViewController(animated: true)
          }
      }
    

    

   
    func validations() -> Bool {
        if (txttitle.text!.isEmpty) || (txtDesc.text!.isEmpty) {
                   
                   let alert = UIAlertController(title: "Empty field!", message: "Please enter data to save...", preferredStyle: .actionSheet)
                   alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (act) in
                       alert.dismiss(animated: true, completion: nil)
                   }))
                   
                   present(alert, animated: true, completion: nil)
                   return false
               }
               return true
    }
    
   
}
