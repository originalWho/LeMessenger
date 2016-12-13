//
//  ChatViewController.swift
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/6/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//



import UIKit

class ChatViewController: UIViewController {
    
    let storage = Storage.shared
    
    var user : User?
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var emptyChatLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = user?.userId
        subscribeToMessagesNotifications()
        subscribeToKeyboardNotifications()
        reload(scrollToBottom: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.isEnabled = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        for message in self.storage.messages[user!.userId]! {
            if message.sender == user?.userId && !message.seen {
                message.seen = true
                MessageController.shared.sendMessageSeen(recepientId: user!.userId, messageId: message.identifier)
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: AnyObject) {
        let message = messageTextField.text!
        MessageController.shared.sendMessage(recepient: (user?.userId)!, content: message as AnyObject) {
            self.messageTextField.text = ""
            self.sendButton.isEnabled = false
            self.reload(scrollToBottom: true)
        }
    }
    
    @IBAction func sendPhoto(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true) {
            self.reload(scrollToBottom: true)
        }
    }
    
    @IBAction func enableSendButton(_ sender: AnyObject) {
        sendButton.isEnabled = !(messageTextField.text?.isEmpty)!
    }
    
    func receiveMessage(notification : Notification) {
        reload(scrollToBottom: true)
        let message = notification.object as! Message
        if message.sender == user?.userId {
            MessageController.shared.sendMessageSeen(recepientId: user!.userId, messageId: message.identifier)
        }
    }
    
    func messageStatusChanged(notification : Notification) {
        reload(scrollToBottom: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
        unsubscribeToMessagesNotifications()
    }
    
    func reload(scrollToBottom scroll : Bool, animated : Bool = false) {
        performUIUpdatesOnMain {
            self.tableView.reloadData()
            if scroll && self.storage.messages[self.user!.userId]!.count > 0 {
                let indexPath = IndexPath(row: self.storage.messages[self.user!.userId]!.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
        }
    }
}

extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.storage.messages[user!.userId]!.count > 0 {
            emptyChatLabel.isHidden = true
            tableView.separatorStyle = .singleLine
            return self.storage.messages[user!.userId]!.count
        } else {
            emptyChatLabel.isHidden = false
            tableView.separatorStyle = .none
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.storage.messages[user!.userId]![(indexPath as NSIndexPath).row]
        let time = message.time
        let formatter = DateFormatter.init()
        formatter.dateFormat = "hh:mm"
        let formatedTime = formatter.string(from: time!)
        
        switch message.content.type {
        case .Text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageTableViewCell
            cell.messageText.text = String.init(data: message.content.data, encoding: .utf8)
            cell.userText.text = message.sender
            cell.timeText.text = formatedTime
            cell.statusImage.image = UIImage(named: "\(message.status.rawValue)")
            return cell
        case .Image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageImageCell") as! MessageImageTableViewCell
            cell.imageMessage.image = UIImage.init(data: message.content.data, scale: 1.0)
            cell.userText.text = message.sender
            cell.timeText.text = formatedTime
            cell.statusImage.image = UIImage(named: "\(message.status.rawValue)")
            return cell
        case .Video:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            MessageController.shared.sendMessage(recepient: user!.userId!, content: image, completion: {
                
            })
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ChatViewController {
    
    func subscribeToMessagesNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMessage(notification:)), name: NSNotification.Name(rawValue: "MessageReceived"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(messageStatusChanged(notification:)), name: NSNotification.Name(rawValue: "MessageStatusChanged"), object: nil)
    }
    
    func unsubscribeToMessagesNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MessageReceived"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MessageStatusChanged"), object: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.keyboardDismissMode = .onDrag
    }
    
    func keyboardWillShow(_ notification:Notification) {
        let keyboardHeight = getKeyboardHeight(notification)
        let offset = getOffset(notification)
        if keyboardHeight == offset {
            self.view.frame.origin.y -= keyboardHeight
        } else {
            self.view.frame.origin.y += keyboardHeight - offset
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if self.view.frame.origin.y < 0 {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    func getOffset(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let offset = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return offset.cgRectValue.height
    }
    
}

extension ChatViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage(self)
        return true
    }
}

class MessageTableViewCell : UITableViewCell {
    
    @IBOutlet weak var messageText: UILabel!
    
    @IBOutlet weak var userText: UILabel!
    
    @IBOutlet weak var timeText: UILabel!

    @IBOutlet weak var statusImage: UIImageView!
}

class MessageImageTableViewCell : UITableViewCell {
    
    @IBOutlet weak var userText: UILabel!
    
    @IBOutlet weak var timeText: UILabel!
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var imageMessage: UIImageView!
}
