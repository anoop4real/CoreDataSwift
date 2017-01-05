//
//  ItemsViewController.swift
//  CoreDataSwift
//
//  Created by anoopm on 27/12/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

import UIKit
import CoreData

class ItemsViewController: UIViewController {

    @IBOutlet var itemsTableView:UITableView!
    var selectedList:NSManagedObject?
    var dataStore = DataStore.sharedStore
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addItem() -> Void {
        
        let alertController = UIAlertController.init(title: "Add Items", message: "Enter To Do Item", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (_) in
            
        }
        
        let saveAction = UIAlertAction.init(title: "Save", style: .default) {[weak self] (_) in
            
            let todoListNameTextfield = alertController.textFields!.first! as UITextField
            if !(todoListNameTextfield.text?.isEmpty)!{
                
                self?.dataStore.createItemsWith(name: todoListNameTextfield.text!, in: (self?.selectedList)!)
                self?.dataStore.fetchAllTodoLists()
                DispatchQueue.main.async {
                    //After saving, reload the data
                    self?.itemsTableView.reloadData()
                }
                
            }
        }
        
        alertController.addTextField { (textField) in
            
            textField.placeholder = "Enter Item Name"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true) {
            
        }
    }

}

extension ItemsViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list = selectedList as! List
        return (list.items?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)

        var items = fetchItemsFromSelectedList()
        let item = items[indexPath.row] as! Item
//        let list = dataStore.todolists[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "name") as! String?
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete){
            var items = fetchItemsFromSelectedList()
            let item = items[indexPath.row] as! Item
            dataStore.deleteObject(object: item)
            DispatchQueue.main.async {
                //After saving, reload the data. Since this is a test app i use reloaddata else we can reload only the index.
                tableView.reloadData()
            }
        }
    }
    
    func fetchItemsFromSelectedList() ->Array<Any>{
                let list = selectedList as! List
        let array = Array(list.items!)
        return array
    }
    
}
