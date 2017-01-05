//
//  ViewController.swift
//  CoreDataSwift
//
//  Created by anoopm on 20/11/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var listTableView:UITableView!
    var dataStore = DataStore.sharedStore
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        //dataStore.createListWith(name: "Test")
        dataStore.fetchAllTodoLists()
        listTableView.reloadData()
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addList() -> Void {
        
        let alertController = UIAlertController.init(title: "Add List", message: "Enter Name For List", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (_) in
            
        }
        
        let saveAction = UIAlertAction.init(title: "Save", style: .default) {[weak self] (_) in
            
            let todoListNameTextfield = alertController.textFields!.first! as UITextField
            if !(todoListNameTextfield.text?.isEmpty)!{
                
                self?.dataStore.createListWith(name: todoListNameTextfield.text!)
                self?.dataStore.fetchAllTodoLists()
                DispatchQueue.main.async {
                    //After saving, reload the data
                    self?.listTableView.reloadData()
                }

            }
        }
        
        alertController.addTextField { (textField) in
            
            textField.placeholder = "Enter List Name"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true) { 
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = listTableView.indexPathForSelectedRow else {
            
            fatalError("Couldnt find the clicked index path")
        }
        let selectedList = dataStore.todolists[indexPath.row]
        
        let itemsVC = segue.destination as! ItemsViewController
        itemsVC.selectedList = selectedList
        
        listTableView.deselectRow(at: indexPath, animated: true)
    }


}


extension ViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.todolists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let list = dataStore.todolists[indexPath.row]
        cell.textLabel?.text = list.value(forKey: "name") as! String?
        return cell;
    }
    
}
