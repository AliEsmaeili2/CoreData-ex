//
//  ViewController.swift
//  coreData-ex
//
//  Created by Ali Esmaeili on 7/10/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[Person]?
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //get items from Coredata
        fetchPeople()
    }
    // MARK: Actions
    @IBAction func addTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Person", message: "what is their name?", preferredStyle: .alert)
        alert.addTextField()
        
        //configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) {(action) in
            
            //get the textfield for the alert
            let textField = alert.textFields![0]
            
            //create a person object
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.sex = "Female"
            
            //save the data
            do {
                try self.context.save()
                
            } catch {
                
                print("Error Saving Data!")
            }
            
            //Re-fetch the Data
            self.fetchPeople()
        }
        
        //add button
        alert.addAction(submitButton)
        
        //show Alert
        self.present(alert,animated: true,completion: nil)
    }
    
    // MARK: Functions
    func fetchPeople() {
        
        do {
            
            self.items = try context.fetch(Person.fetchRequest())
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
            
        } catch {
            
            print("Error fetchRequest!")
        }
    }
    
    // Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, comletionHandler) in
            
            //which person to remove
            let personToRemove = self.items![indexPath.row]
            
            //Remove the Person
            self.context.delete(personToRemove)
            
            //Save the data
            do {
                try self.context.save()
                
            } catch {
                
                print("Error Deleting Data!")
            }
            
            //Re-fetch the Data
            self.fetchPeople()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return the nuber of people
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get preson from array and set the label
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        let person = self.items![indexPath.row]
        
        cell.textLabel?.text = person.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = self.items![indexPath.row]
        
        let alert = UIAlertController(title: "Edit Person", message: "Edit Name:", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields![0]
        textField.text = person.name
        
        //configure button handler
        let SaveButton = UIAlertAction(title: "Save", style: .default) {(action) in
            
            //get the textfield for the alert
            let textField = alert.textFields![0]
            
            //Edit name
            person.name = textField.text
            
            //Save Data
            do {
                
                try self.context.save()
                
            } catch {
                
                print("Error Editing Data!")
            }
            
            //Re-fetch Data
            self.fetchPeople()
        }
        
        //add button
        alert.addAction(SaveButton)
        
        //show Alert
        self.present(alert,animated: true,completion: nil)
    }
}
