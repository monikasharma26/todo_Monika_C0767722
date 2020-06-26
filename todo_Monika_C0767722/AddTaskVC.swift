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

    @IBOutlet var CurDate: UILabel!
    @IBOutlet var txtTitle: UITextField!
    @IBOutlet var txtDesc: UITextField!
    var edit = Bool()
    @IBOutlet var txtStartDate: UITextField!
    let datePicker = UIDatePicker()
    @IBOutlet var txtTotal: UITextField!
    
    var listToDo : ToDoListTVC?
    private var taskToDo: TaskToDo?
   
    @IBOutlet var saveBtn: UIBarButtonItem!
    private let persistenceManager = PersistenceManager.shared
   
    private var todo: TaskToDo? {
        didSet {
            guard let todo = todo else { return }
            txtTitle.text = todo.title
            txtTotal.text = "\(todo.totalDays)"
            txtDesc.text = todo.desc
         //   txtStartDate.text = todo.d
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        createDatePicker()
        initViews()
        // Do any additional setup after loading the view.
    }
    
    private func initViews() {
       
        if(edit == true){
            
        //   CurDate.text = \"(taskToDo?.dateTime)"
            txtTitle.text = taskToDo?.title ?? ""
            txtTotal.text = "\(taskToDo?.totalDays ?? 0)"
            
            txtDesc.text = taskToDo?.desc ?? ""
            
        }
        else{
            
            let date = Date()
            // date
            let dformatter = DateFormatter()
            dformatter.dateFormat = "d MMM"
            let stDate = dformatter.string(from: date)
            
            // day
            let eformatter = DateFormatter()
            eformatter.dateFormat = "EEEE"
            let stDay = eformatter.string(from: date)
            
            CurDate.text = currentDate()
        }
    }
    func currentDate() -> String{
          let date = Date()
          // date
          let dformatter = DateFormatter()
          dformatter.dateFormat = "d MMM YY"
          let stDate = dformatter.string(from: date)
          
          // day
          let eformatter = DateFormatter()
          eformatter.dateFormat = "EEEE"
          let stDay = eformatter.string(from: date)
          
          return String(format: "%@, %@", stDay, stDate)
          
      }
    func createDatePicker(){
     //format for datepicker display
           datePicker.datePickerMode = .date
           
           //assign datepicker to our textfield
           txtStartDate.inputView = datePicker
           
           //create a toolbar
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
           //add a done button on this toolbar
           let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
           
           toolbar.setItems([doneButton], animated: true)
           
           txtStartDate.inputAccessoryView = toolbar
       }
    
    @objc func doneClicked(){
    
           //format for displaying the date in our textfield
           let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = .medium
           dateFormatter.timeStyle = .none
           
           txtStartDate.text = dateFormatter.string(from: datePicker.date)
           self.view.endEditing(true)
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
