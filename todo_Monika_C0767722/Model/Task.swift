//
//  TAsk.swift
//  todo_Monika_C0767722
//
//  Created by S@i on 2020-06-26.
//  Copyright © 2020 S@i. All rights reserved.
//

import Foundation
import CoreData

class Task {
    internal init(title: String?, desc: String?, dateTime: Date?, workeddays: Int = 0, totalDays: Int = 0) {
        self.title = title
        self.dateTime = dateTime
        self.desc = desc
        self.workeddays = workeddays
        self.totalDays = totalDays
    }
    
    var title: String?
    var dateTime: Date?
    var desc: String?
    var workeddays: Int?
    var totalDays: Int?
    
  
    
}
