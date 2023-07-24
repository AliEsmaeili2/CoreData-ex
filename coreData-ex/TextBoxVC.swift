//
//  TextBoxVC.swift
//  coreData-ex
//
//  Created by Ali Esmaeili on 7/23/23.
//

import UIKit
import CoreData

class TextBoxVC: UIViewController {
    
    // Core Data Managed Object Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDataAndDisplay()
    }
    
    @IBAction func ButtonTapped(_ sender: UIButton) {
        
        saveDataToCoreData()
        fetchDataAndDisplay()
    }
    
    func saveDataToCoreData() {
        
        let newData = TextBoxCD(context: context)
        newData.userNameCD = userName.text
        newData.passwordCD = Password.text
        
        if let numberText = number.text, let numberValue = Int64(numberText) {
            
            newData.numberCD = numberValue
        }
        
        print("Saving data: \(newData)")
        
        do {
            try context.save()
            print("Data saved to Core Data successfully.")
            
        } catch {
            print("Error saving data to Core Data: \(error.localizedDescription)")
        }
    }
    
    func fetchDataAndDisplay() {
        
        do {
            
            let fetchRequest: NSFetchRequest<TextBoxCD> = TextBoxCD.fetchRequest()
            let results = try context.fetch(fetchRequest)
            
            print("Fetched results count: \(results.count)")
            
            if let data = results.last {
                
                let displayData = "userName: \(data.userNameCD ?? "")\nPassword: \(data.passwordCD ?? "")\nPhoneNumber: \(data.numberCD)"
                
                print("Fetched data: \(displayData)")
                textView.text = displayData
                
            } else {
                print("No data found in Core Data.")
            }
            
        } catch {
            print("Error fetching data from Core Data: \(error.localizedDescription)")
        }
    }
}
