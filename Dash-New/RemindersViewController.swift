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
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Affirmations"
        let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addName(_:)))
        let reminders = UIBarButtonItem(title: "Reminders", style: .plain, target: self, action: #selector(goToCal(_:)))
        self.navigationItem.rightBarButtonItem = add
        self.navigationItem.leftBarButtonItem = reminders
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        do{
            let temp = try PersistenceService.context.fetch(fetchRequest)
            self.people = temp
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
            
            let nameTextField = alert.textFields?.first
            let nameToSave = nameTextField!.text!
            let person = Person(context: PersistenceService.context)
            person.name = nameToSave
            self.people.append(person)
            self.tableView.reloadData()
            PersistenceService.saveContext()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.textFields?[0].placeholder = "Affirmation"
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension RemindersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        
        let person = people[indexPath.row]
        
        cell.textLabel?.text = person.value(forKey: "name") as! String?
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indextPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete {
            PersistenceService.context.delete(self.people[indexPath.row])
            PersistenceService.saveContext()
        }
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        do{
            let temp = try PersistenceService.context.fetch(fetchRequest)
            self.people = temp
            self.tableView?.reloadData()
            
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        
    }
}

