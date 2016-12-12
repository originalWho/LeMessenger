//
//  ServerSettingsViewController.swift
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/11/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

import UIKit

class ServerSettingsViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var portTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! Dictionary<String, AnyObject>
        let url = configuration["Server url"] as! String
        let port = configuration["Server port"] as! Int
        urlTextField.text = url
        portTextField.text = "\(port)"
    }
    
    @IBAction func doneAction(_ sender: AnyObject) {
        let url = urlTextField.text!
        let port = Int(portTextField.text!)
        //FIND A WAY TO UPDATE
        var configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! Dictionary<String, AnyObject>
        configuration["Serverl url"] = url as AnyObject?
        configuration["Server port"] = port as AnyObject?
        dismiss(animated: true, completion: nil)
    }
}
