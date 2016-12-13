//
//  MessageController.swift
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/11/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

import UIKit

class MessageController : NSObject {
    
    let messenger = Messenger.shared()
    let storage = Storage.shared
    var unseenMessages : Int = 0
    
    static let shared : MessageController = {
        let instance = MessageController()
        return instance
    }()
    
    func sendMessage(recepient: String, content: AnyObject, completion: @escaping (Void) -> Void) {
        let messageContent = MessageContent.init()
        
        if AuthController.shared.encrypted {
            messageContent.encrypted = true
        } else {
            messageContent.encrypted = false
        }
        
        if content is String {
            messageContent.type = .Text
            messageContent.data = (content as! String).data(using: .utf8)
        } else if content is UIImage {
            messageContent.type = .Image
            let image = content as! UIImage
            messageContent.data = UIImageJPEGRepresentation(image, 0.6)
        } else {
            messageContent.type = .Video
            //Convert to video
        }
        messenger?.sendMessage(recepient, content: messageContent, completion: { (message) in
            message?.sender = "You"
            self.storage.messages[recepient]?.append(message!)
            self.storage.messageToUser[message!.identifier] = recepient
            //self.storage.sortUsersByLastMessage()
            completion()
        })
    }
    
    func receiveMessage(notification : Notification) {
        let message = notification.object as! Message
        if self.storage.messages[message.sender] == nil {
            self.storage.messages[message.sender] = [Message]()
        }
        self.storage.messages[message.sender]!.append(message)
        self.storage.messageToUser[message.identifier] = message.sender
        self.unseenMessages += 1
        let messageString : String
        switch message.content.type {
        case .Text:
            messageString = String(data: message.content.data, encoding: .utf8)!
            break
        case .Image:
            messageString = "📷 Image"
            break
        case .Video:
            messageString = "🎥 Video"
            break
        }        
        NotificationController.shared.notify(userId: message.sender, message: messageString, unseen: unseenMessages)
        //self.storage.sortUsersByLastMessage()
    }
 
    func changeMessageStatus(notification : Notification) {
        let statusNotification = notification.object as! MessageStatusNotification
        let id = statusNotification.messageId as String
        let status = statusNotification.messageStatus as MessageStatus
        if status == .Delivered || status == .Seen {
            let user = self.storage.messageToUser[id]
            if self.storage.messages[user!] == nil  {
                self.storage.messages[user!] = [Message]()
            } else {
                for message in self.storage.messages[user!]! {
                    if message.identifier == id {
                        message.status = status
                        return
                    }
                }
            }
        }
    }
    
    func sendMessageSeen(recepientId: String, messageId: String) {
        messenger?.sendMessageSeen(recepientId, messageId: messageId)
        NotificationController.shared.removeNotifications()
        for message in self.storage.messages[recepientId]!.reversed() {
            if message.seen {
                return
            }
            message.seen = true
            self.unseenMessages -= 1
        }
    }
    
    func subscribeToMessagesNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMessage(notification:)), name: NSNotification.Name(rawValue: "MessageReceived"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeMessageStatus(notification:)), name: NSNotification.Name(rawValue: "MessageStatusChanged"), object: nil)
    }
    
    func unsubscribeToMessagesNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MessageReceived"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MessageStatusChanged"), object: nil)
    }
}
