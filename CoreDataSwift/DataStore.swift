//
//  DataStore.swift
//  CoreDataSwift
//
//  Created by anoopm on 04/12/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

import Foundation
import CoreData
// Class to access and manipulate core data objects from UI.
class DataStore {
    static let sharedStore = DataStore()
    var todolists:[NSManagedObject] = []
    lazy var coreDataManager = CoreDataManager.sharedInstance
    
    // Create the top level list
    func createListWith(name:String) ->Void {
        
        if #available(iOS 10.0, *) {
            let list = List(context: coreDataManager.managedObjectContext)
            list.createdDate = NSDate()
            list.name = name
            
        } else {
            // Fallback on earlier versions
            let entityDescription = NSEntityDescription.entity(forEntityName: "List", in: coreDataManager.managedObjectContext)
            if let entityDesc = entityDescription{
                
                let list = List.init(entity: entityDesc, insertInto: coreDataManager.managedObjectContext)
                list.setValue(name, forKey: "name")
                list.setValue(NSDate(), forKey: "createdDate")
            }
        }
        coreDataManager.saveContext()
    }
    // Create items with in the list
    func createItemsWith(name:String, in list:NSManagedObject) ->Void {
        
        if #available(iOS 10.0, *) {
            let item = Item(context: coreDataManager.managedObjectContext)
            item.createdDate = NSDate()
            item.name = name
            (list as! List) .addToItems(item)
            
        } else {
            // Fallback on earlier versions
            let entityDescription = NSEntityDescription.entity(forEntityName: "Item", in: coreDataManager.managedObjectContext)
            if let entityDesc = entityDescription{
                
                let item = Item.init(entity: entityDesc, insertInto: coreDataManager.managedObjectContext)
                item.setValue(name, forKey: "name")
                item.setValue(NSDate(), forKey: "createdDate")
                (list as! List) .addToItems(item)
            }
        }
        coreDataManager.saveContext()
    }
    // Delete any managed object
    func deleteObject(object:NSManagedObject)->Void{
        
        coreDataManager.managedObjectContext.delete(object)
        coreDataManager.saveContext()
    }
    // Method to fetch all the todo lists
    func fetchAllTodoLists(){
        let fetchRequest:NSFetchRequest<List> = List.fetchRequest()
        let sortDescriptor = NSSortDescriptor.init(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            // Fallback on earlier versions
            let lists = try coreDataManager.managedObjectContext.fetch(fetchRequest)
            print("Count is \(lists.count)")
            // If there is some data, then convert it to [NSManagedObject] and load it
            if lists.count > 0{
                todolists = lists as [NSManagedObject]
            }
        }catch let error as NSError{
            
            print("\(error.description)")
        }catch{
            
        }
        
    }

}
