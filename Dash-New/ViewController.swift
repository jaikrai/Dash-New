//
//  ViewController.swift
//  Dash-New
//
//  Created by iMac on 4/8/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit
import CoreData
import Intents

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var boardName = [Board]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Boards"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(onPlushTapped(_:)))
        
        let fetchRequest: NSFetchRequest<Board> = Board.fetchRequest()
        do{
          let boardName = try PersistenceService.context.fetch(fetchRequest)
            self.boardName = boardName
            for board in self.boardName{
                if board.id == nil{
                    PersistenceService.context.delete(board)
                }
            }
            self.boardName.removeAll(where: {$0.id == nil})
            self.tableView?.reloadData()
            
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        donateInteraction()
        
       
    }
    
    func donateInteraction() {
        let intent = MotivateIntent()
        
        intent.suggestedInvocationPhrase = "Motivate Me"
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print(error)
                } else {
                    print("Successfully donated interaction")
                }
            }
        }
    }

    
        @IBAction func onPlushTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Vision Board", message: "Enter the name of the your vision board", preferredStyle: .alert)
       
        
        // Create the action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            let title = alert.textFields!.first!.text!

            let board = Board(context: PersistenceService.context)
            board.title = title
            board.id = UUID().uuidString
            print(board.id)
            PersistenceService.saveContext()
            self?.boardName.append(board)
            self?.tableView.reloadData()
        }
        saveAction.isEnabled = false
            
        // Add a text field
        alert.addTextField { (textField) in
        textField.placeholder = "Title"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notif in
            if let text = textField.text, !text.isEmpty {
                saveAction.isEnabled = true
            } else {
                saveAction.isEnabled = false
    
            }
        }
    }

        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    




// -------------------------------------------------------------------------
// MARK: - Table view data source


    
    func  numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "boardCell", for: indexPath)
       // if cell == nil {
        //cell = UITableViewCell(style: .subtitle, reuseIdentifier: "boardCell")
        
        cell.textLabel?.text = boardName[indexPath.row].title
        
        return cell
    }
//    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Segue to the second view controller
        performSegue(withIdentifier: "ViewBoard", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete {
            PersistenceService.context.delete(self.boardName[indexPath.row])
            PersistenceService.saveContext()
        }
        
        let fetchRequest: NSFetchRequest<Board> = Board.fetchRequest()
        do{
            let temp = try PersistenceService.context.fetch(fetchRequest)
            self.boardName = temp
            self.tableView?.reloadData()
            
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        // get a reference to the second view controller
        if let VC = segue.destination as? DetailViewController {
            VC.boardId = boardName[(tableView.indexPathForSelectedRow?.row)!].id!
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
            VC.hidesBottomBarWhenPushed = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)

    }
    
}

