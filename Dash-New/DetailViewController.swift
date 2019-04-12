//
//  File.swift
//  Dash-New
//
//  Created by iMac on 4/10/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    var board1: Board?
    
    // This variable will hold the data being passed from the First View Controller
//    var receivedData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(receivedData)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
