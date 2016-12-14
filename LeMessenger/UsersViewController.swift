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

    let storage = Storage.shared
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Le Messenger"
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.05, green:0.36, blue:0.26, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        tableView.refreshControl = UIRefreshControl.init()
        tableView.refreshControl?.addTarget(self, action: #selector(requestUsers), for: UIControlEvents.valueChanged)
        subscribeToMessagesNotifications()
    }
    
    override func viewDidLoad() {
        requestUsers()
    }
    
    func requestUsers() {
        UserController.shared.requestUsers { (result) in
            self.reloadData(notification: nil)
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func reloadData(notification: Notification?) {
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
}

extension UsersViewController {
    func subscribeToMessagesNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: NSNotification.Name(rawValue: "MessageReceived"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: NSNotification.Name(rawValue: "MessageSent"), object: nil)
    }
    
    func unsubscribeToMessagesNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MessageReceived"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MessageSent"), object: nil)
    }
}


extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storage.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")!
        let user = self.storage.users[(indexPath as NSIndexPath).row]
        let lastMessage = self.storage.messages[user.userId]?.last
        cell.textLabel?.text = user.userId
        if lastMessage == nil {
            cell.detailTextLabel?.text = ""
        } else {
            switch lastMessage!.content.type {
            case .Text:
                cell.detailTextLabel?.text = String(data: lastMessage!.content.data, encoding: .utf8)
            case .Image:
                cell.detailTextLabel?.text = "📷 Image"
            case .Video:
                cell.detailTextLabel?.text = "🎥 Video"
            }
            if !lastMessage!.seen && lastMessage?.sender != "You" {
                cell.backgroundColor = UIColor(red:0.05, green:0.36, blue:0.26, alpha:0.2)
            } else {
                cell.backgroundColor = UIColor.clear
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.storage.users[(indexPath as NSIndexPath).row]
        let chatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatViewController.user = user
        self.navigationController!.pushViewController(chatViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}
