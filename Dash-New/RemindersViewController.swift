//
//  RemindersViewController.swift
//  Dash-New
//
//  Created by Jared Breedlove on 4/15/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class RemindersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var affirmations = [Affirmation]()
    var notification: [String] = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    var reminderList = [Reminder]()
    var time: Reminder!
    var hour: Int!
    var minute: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Affirmations"
        let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addName(_:)))
        let reminders = UIBarButtonItem(title: "Reminders", style: .plain, target: self, action: #selector(goToCal(_:)))
        self.navigationItem.rightBarButtonItem = add
        self.navigationItem.leftBarButtonItem = reminders
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let reminderRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        do{
            let rem = try PersistenceService.context.fetch(reminderRequest)
            if reminderList.count == 0{
                self.hour = 10
                self.minute = 0
            }else{
                time = rem.first
                self.hour = Int(time.hour)
                self.minute = Int(time.minute)
            }
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        let fetchRequest: NSFetchRequest<Affirmation> = Affirmation.fetchRequest()
        do{
            let temp = try PersistenceService.context.fetch(fetchRequest)
            self.affirmations = temp
            self.tableView?.reloadData()
            
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        var day = 1
        var sec = 0
        clearNotification()
        for i in 0...6 {
            notification(day: day, identifier: notification[i], sec: sec, hour: self.hour, minute: self.minute)
            day = day + 1
        }
    }
    
    func notification(day: Int, identifier: String, sec: Int, hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        if affirmations.count == 0{
            content.body = "Don't forget to check your vision boards!"
        } else{
            let randomAffirm = affirmations.randomElement()?.title
            content.body = "Don't forget to check your vision boards! \n" + randomAffirm!
        }
        content.title = "Daily Meditation"
        content.sound = UNNotificationSound.default
        content.threadIdentifier = "Local-not temp"
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.weekday = day
        dateComponents.second = sec
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil{
                print(error!)
            }
        }
    }
    
    func clearNotification(){
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    @objc func goToCal(_ sender: Any) {
        var day = 1
        var sec = 0
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let message = "\n\n\n\n\n\n"
        let alert = UIAlertController(title: "Select time for notification delivery", message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.isModalInPopover = true
        let pickerFrame = UIDatePicker(frame: CGRect(x: 5, y: 20, width: screenWidth - 20, height: 140))
        pickerFrame.tag = 555
        pickerFrame.datePickerMode = UIDatePicker.Mode.time
        alert.view.addSubview(pickerFrame)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let date = pickerFrame.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            self.hour = components.hour!
            self.minute = components.minute!
            print(self.hour!)
            print(self.minute!)
            if self.reminderList.count != 0{
                PersistenceService.context.delete(self.time)
            }
            let newTime = Reminder(context: PersistenceService.context)
            newTime.hour = Int32(self.hour)
            newTime.minute = Int32(self.minute)
            PersistenceService.saveContext()
            print(newTime.hour)
            print(newTime.minute)
            self.clearNotification()
            for i in 0...6 {
                self.notification(day: day, identifier: self.notification[i], sec: sec, hour: self.hour, minute: self.minute)
                day = day + 1
                sec = sec + 5
            }
        })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    
    @objc func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Affirmation", message: "Add a new Affirmation", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            let title = alert.textFields?.first?.text
            let affirmation = Affirmation(context: PersistenceService.context)
            affirmation.title = title
            self.affirmations.append(affirmation)
            self.tableView.reloadData()
            PersistenceService.saveContext()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 3
        
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

