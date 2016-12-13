//
//  NotificationController.swift
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/13/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationController: NSObject, UNUserNotificationCenterDelegate {
    let storage = Storage.shared
    let center = UNUserNotificationCenter.current()
    let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
    let presentationOptions : UNNotificationPresentationOptions = [.alert, .badge, .sound]
    
    static let shared : NotificationController = {
        let instance = NotificationController()
        return instance
    }()
    
    func requestAuthorization() {
        center.requestAuthorization(options: authOptions) { (granted, error) in
            //enable disable features
        }
    }
    
    func notify(userId username: String?, message: String?, unseen: Int) {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                if username != nil {
                    content.title = username!
                }
                if message != nil {
                    content.body = message!
                }
                content.badge = unseen as NSNumber?
                if unseen != 0 {
                    content.sound = UNNotificationSound.default()
                }
                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(identifier: "messageReceived", content: content, trigger: trigger)
                self.center.removeAllPendingNotificationRequests()
                self.center.removeAllDeliveredNotifications()
                self.center.add(request, withCompletionHandler: nil)
            }
        }
    }
    
    func removeNotifications() {
        self.notify(userId: nil, message: nil, unseen: 0)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        completionHandler(presentationOptions)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        completionHandler()
    }
}
