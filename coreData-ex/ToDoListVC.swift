//
//  ToDoListVC.swift
//  coreData-ex
//
//  Created by Ali Esmaeili on 7/15/23.
//

import UIKit
import CoreData

class ToDoListVC: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var models = [ToDoListItem]()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "✔︎ ToDo List"
        
        view.addSubview(tableView)
        getAllItems()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(didTapAdd))
        
      //  navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
    }
    
    // MARK: Functions
    @objc private func didTapAdd() {
        
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                
                return
            }
            
            self?.createItem(name: text)
        }))
        
        present(alert,animated: true)
    }
    
    func getAllItems() {
        
        do {
            
            let request = ToDoListItem.fetchRequest() as NSFetchRequest<ToDoListItem>
            
            let sort = NSSortDescriptor(key: "createdAt", ascending: true)
            request.sortDescriptors = [sort]

            self.models = try context.fetch(request)
           // models = try context.fetch(ToDoListItem.fetchRequest())

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            
            print("error hetAllItems")
        }
    }
    
    func createItem(name: String) {
        
        let newItem = ToDoListItem(context: context)
        
        newItem.name = name
        newItem.createdAt = Date()
        
        do {
            
            try context.save()
            getAllItems()
            
        } catch {
            
            print("error createItem")
        }
    }
    
    func deleteItem(item: ToDoListItem) {
        
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
            
        } catch {
            
            print("error DeleteItem")
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String) {
        
        item.name = newName
        
        do {
            try context.save()
            getAllItems()
            
        } catch {
            
            print("error UpdateItem")
        }
    }
}

// MARK: Extension
extension ToDoListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = model.name
        //cell.textLabel?.text = (String(describing: model.createdAt))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "✘") {(action, view, comletionHandler) in
            
            //which person to remove
            let personToRemove = self.models[indexPath.row]
            
            //Remove the Person
            self.context.delete(personToRemove)
            
            //Save the data
            do {
                try self.context.save()
                
            } catch {
                
                print("Error Deleting Data!")
            }
            
            //Re-fetch the Data
            self.getAllItems()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                
                guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                    
                    return
                }
                
                self?.updateItem(item: item, newName: text)
            }))
            
            self.present(alert,animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            
            self?.deleteItem(item: item)
        }))
        
        present(sheet,animated: true)
    }
}
