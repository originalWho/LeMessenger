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
    let encryption = EncryptionController.shared
    var unseenMessages : Int = 0
    
    static let shared : MessageController = {
        let instance = MessageController()
        return instance
    }()
    
    func sendMessage(recepient: User?, content: AnyObject?, completion: @escaping () -> Void) {
        let messageContent = MessageContent.init()
        
        let userId = recepient?.userId!
        
        switch recepient!.securityPolicy.encryptionAlgo {
        case .None:
            messageContent.encrypted = false
            break
        case .RSA_1024:
            messageContent.encrypted = true
            break
        }
        
        var data: Data?
        
        if content is String {
            messageContent.type = .Text
            data = (content as! String).data(using: .utf8)
        } else if content is UIImage {
            messageContent.type = .Image
            let image = content as! UIImage
            data = UIImageJPEGRepresentation(image, 0.6)
        } else {
            messageContent.type = .Video
            //Convert to video
        }
        
        if messageContent.encrypted {
            let publicKey = recepient?.securityPolicy.encryptionPubKey
            messageContent.data = encryption.encrypt(messageData: data, publicKey: publicKey)
        } else {
            messageContent.data = data
        }
        
        messenger?.sendMessage(userId, content: messageContent, completion: { (message) in
            message?.sender = "You"
            self.storage.messages[userId!]?.append(message!)
            self.storage.messageToUser[message!.identifier] = userId
            completion()
        })
    }
    
    func receiveMessage(notification : Notification) {
        guard let message = notification.object as? Message else {
            print("Unable to receive a message: message is nil")
            return
        }
        
        if message.content.encrypted {
            message.content.data = encryption.decrypt(messageData: message.content.data)
        }
        
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
                for message in self.storage.messages[user!]!.reversed() {
                    if message.identifier == id && message.sender == "You" {
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
