//
//  RemindersViewController.swift
//  Dash-New
//
//  Created by Jared Breedlove on 4/15/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit
import CoreData

class RemindersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var affirmations = [Affirmation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Affirmations"
        let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addName(_:)))
        let reminders = UIBarButtonItem(title: "Reminders", style: .plain, target: self, action: #selector(goToCal(_:)))
        self.navigationItem.rightBarButtonItem = add
        self.navigationItem.leftBarButtonItem = reminders
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        let fetchRequest: NSFetchRequest<Affirmation> = Affirmation.fetchRequest()
        do{
            let temp = try PersistenceService.context.fetch(fetchRequest)
            self.affirmations = temp
            self.tableView?.reloadData()
            
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    
    @objc func goToCal(_ sender: Any) {
        let url = URL(string: "calshow://")! as URL
        UIApplication.shared.open(url, options: [:] , completionHandler: nil)
    }
    
    
    
    @objc func addName(_ sender: Any) {
        print("Testing")
        let alert = UIAlertController(title: "New Affirmation",
                                      message: "Add a new Affirmation",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            let title = alert.textFields?.first?.text
            let affirmation = Affirmation(context: PersistenceService.context)
            affirmation.title = title
            self.affirmations.append(affirmation)
            self.tableView.reloadData()
            PersistenceService.saveContext()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Affirmation"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                    
                }
            }
        }
        saveAction.isEnabled = false
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension RemindersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return affirmations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        
        let affirmation = affirmations[indexPath.row]
        
        cell.textLabel?.text = affirmation.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indextPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete {
            PersistenceService.context.delete(self.affirmations[indexPath.row])
            PersistenceService.saveContext()
        }
        
        let fetchRequest: NSFetchRequest<Affirmation> = Affirmation.fetchRequest()
        do{
            let temp = try PersistenceService.context.fetch(fetchRequest)
            self.affirmations = temp
            self.tableView?.reloadData()
            
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        
    }
}

