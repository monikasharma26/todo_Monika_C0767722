//
//  TaskTableViewCell.swift
//  todo_Monika_C0767722
//
//  Created by S@i on 2020-06-26.
//  Copyright © 2020 S@i. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet var TotalDaysLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
  
    
    @IBOutlet var desclbl: UILabel!
    
    @IBOutlet var daysLeft: UILabel!
    @IBOutlet var daysWorkedlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(todo: Task, searchText: String = "") {
          
           titleLbl.text = todo.title
            desclbl.text = todo.desc
        dateLbl.text = todo.dateTime!.toString()
        desclbl.text = "Total Days: \(String(describing: todo.totalDays!))"
    
      
        let daysleft = (todo.totalDays! - todo.workeddays!)
        if (daysleft <= 0)
        {
            daysLeft.textColor = UIColor.white
            let fontsize : CGFloat = 16
            daysLeft.font = UIFont.boldSystemFont(ofSize: fontsize)
            daysLeft.text = "Completed"
        }
        else{
            daysLeft.text = "Day's Left: \(String(todo.totalDays! - todo.workeddays!))"
        }
    
        if  let date = todo.dateTime
                   {
                       if date <= Date()
                       {
                          self.backgroundColor = .red
                       }
                       if Calendar.current.isDate(Date().addingTimeInterval(24*60*60), equalTo: date, toGranularity: .day)
                       {
                           self.backgroundColor = .green
                       }
                   }
                   else
                   {
                      self.backgroundColor = .white
                   }
       
    
    
}

}
