//
//  UsersViewController.swift
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var users: NSMutableArray?

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Le Messenger"
        navigationController?.navigationBar.barTintColor = UIColor(red:0.05, green:0.36, blue:0.26, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLoad() {
        request()
    }
    
    func request() {
        let messenger = Messenger.shared()!
        messenger.requestActiveUsers { (result, array) in
            switch result {
            case .Ok:
                self.users = array
                break
            case .AuthError:
                break
            case .NetworkError:
                break
            case .InternalError:
                break
            }
        }
    }
    
    

}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")!
        let user = self.users?[(indexPath as NSIndexPath).row] as! User
        cell.textLabel?.text = user.userId
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users?[(indexPath as NSIndexPath).row] as! User
        let chatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatViewController.user = user.userId
        self.navigationController!.pushViewController(chatViewController, animated: true)
    }
}
