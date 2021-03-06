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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Calendar", style: .plain, target: self, action: #selector(goToCal(_:)))
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
    
    @IBAction func goToCal(_ sender: Any){
        let url = URL(string: "calshow://")! as URL
        UIApplication.shared.open(url, options: [:] , completionHandler: nil)
    }
    
    func donateInteraction() {
        let intent = MotivateIntent()
        intent.suggestedInvocationPhrase = "Motivate Me"
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print(error)
                }
            }
        }
    }

    
    @IBAction func onPlushTapped(_ sender: Any) {
        let alert = UIAlertController(title: "New Vision Board", message: "Enter the name of your vision board.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            let title = alert.textFields!.first!.text!
            let board = Board(context: PersistenceService.context)
            board.title = title
            board.id = UUID().uuidString
            PersistenceService.saveContext()
            self?.boardName.append(board)
            self?.tableView.reloadData()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Board Name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                    
                }
            }
        }
        saveAction.isEnabled = false
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }

    func  numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "boardCell", for: indexPath)
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 3
        cell.textLabel?.text = boardName[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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

