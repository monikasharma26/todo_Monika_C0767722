//
//  DataManager.swift
//  todo_Monika_C0767722
//
//  Created by S@i on 2020-06-26.
//  Copyright © 2020 S@i. All rights reserved.
//


import Foundation
import CoreData

/*class PersistenceManager {
    
    private init() {}
    
    static let shared = PersistenceManager()
    
    var context: NSManagedObjectContext {
        return PersistenceManager.persistentContainer.viewContext
    }
    
    class func getContext() -> NSManagedObjectContext {
        return PersistenceManager.persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "todo_Monika_C0767722")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    class func saveContext () {
        let context = PersistenceManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
        func fetch<T: NSManagedObject>(type: T.Type, completion: @escaping ([T]) -> Void) {
            let request = NSFetchRequest<T>(entityName: String(describing: type))
            do {
                let objects = try context.fetch(request)
                completion(objects.reversed())
            } catch {
                completion([])
            }
        }
        
        func update<T: NSManagedObject>(type: T.Type, todo: NSManagedObject, completion: @escaping(_: NSManagedObject?) -> Void) {
            let request = NSFetchRequest<T>(entityName: String(describing: type))
            do {
                let objects = try context.fetch(request)
                for object in objects where object == todo {
                    completion(object)
                }
            } catch {
                completion(nil)
            }
        }
        
        func delete<T: NSManagedObject>(type: T.Type, todo: NSManagedObject, completion: @escaping(_: Bool) -> Void) {
            let request = NSFetchRequest<T>(entityName: String(describing: type))
            do {
                let objects = try context.fetch(request)
                for object in objects where object == todo {
                    context.delete(todo)
                    do {
                        try context.save()
                        completion(true)
                    } catch {
                        completion(false)
                    }
                }
            } catch {
                completion(false)
            }
        }
        
        func search<T: NSManagedObject>(type: T.Type, keyword: String, completion: @escaping(_: [T]) -> Void) {
            let request = NSFetchRequest<T>(entityName: String(describing: type))
            
            let predicate = NSPredicate(format: "title contains[cd] %@ OR desc contains[cd] %@", keyword, keyword)

            request.predicate = predicate
            
            do {
                let objects = try context.fetch(request)
                completion(objects.reversed())
            } catch {
                completion([])
            }
        }
        
    }
*/
