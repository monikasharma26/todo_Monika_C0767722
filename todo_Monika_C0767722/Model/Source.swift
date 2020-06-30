//
//  Source.swift
//  todo_Monika_C0767722
//
//  Created by S@i on 2020-06-26.
//  Copyright © 2020 S@i. All rights reserved.
//

import Foundation
import CoreData

func saveTask(tasks: [Task]) -> Bool {
    var data = false
    tasks.forEach { (t) in
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "TaskToDo", into: context!)
        newTask.setValue(t.title, forKey: "title")
        newTask.setValue(t.desc, forKey: "desc")
        newTask.setValue(t.dateTime, forKey: "dateTime")
        newTask.setValue(t.workeddays, forKey: "daysWorked")
        newTask.setValue(t.totalDays, forKey: "totalDays")
        
        do {
            try context!.save()
            data = true
        } catch {
            print(error)
        }
    }
    return data
}

func fetchSavedData(search: String = "", isDate: Bool = false, isAsc: Bool = true, isSame: Bool = false) -> [Task] {
    var taskList = [Task]()
    
    let req = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskToDo")
    if !isDate {
        req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: isAsc)]
    }else{
        req.sortDescriptors = [NSSortDescriptor(key: "dateTime", ascending: isAsc)]
    }
    
    if !search.isEmpty {
        if !isSame{
            let p1 = NSPredicate(format: "ANY title CONTAINS[c] %@", "\(search)")
            let p2 = NSPredicate(format: "ANY desc CONTAINS[c] %@", "\(search)")
            req.predicate = NSCompoundPredicate(type: .or, subpredicates: [p1, p2])
        }else{
            req.predicate = NSPredicate(format: "title = %@", "\(search)")
        }
        
        req.returnsObjectsAsFaults = false
    }
    
    do {
         let res = try context?.fetch(req)
               if !res!.isEmpty{
            (res as! [NSManagedObject]).forEach({ dt in
                let t = Task(title: dt.value(forKey: "title") as? String,
                             desc: dt.value(forKey: "desc") as? String,
                             dateTime: dt.value(forKey: "dateTime") as? Date,
                            // workeddays: dt.value(forKey: "daysWorked") as! Int,
                             totalDays: dt.value(forKey: "totalDays") as! Int)
                taskList.append(t)
            })
        }
    } catch {
        print(error)
    }
    
    return taskList
}

func deleteTaskData(tasks: [Task]) {
    tasks.forEach { (task) in
    
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskToDo")
        req.predicate = NSPredicate(format: "title = %@ ", task.title!)
        
        let delReq = NSBatchDeleteRequest(fetchRequest: req)
        do {
            try context!.execute(delReq)
        }
        catch { print(error) }
       
        
    }
}

func clearTaskData() {
    let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskToDo")
    let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
    do { try context!.execute(DelAllReqVar) }
    catch { print(error) }
}

func dateToString(_ dt: Date) -> String {
    if dt != nil{
        return dateFormatter?.string(from: dt) ?? ""
    }
    return ""
}

