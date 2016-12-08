//
//  ChatViewController.swift
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/6/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    var user : String = ""

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
