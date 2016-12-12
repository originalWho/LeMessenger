//
//  MessagesObserver.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#ifndef MessagesObserver_h
#define MessagesObserver_h
#include <messenger/observers.h>

class MessagesObserver : public messenger::IMessagesObserver {
public:
    
    virtual void OnMessageStatusChanged(const messenger::MessageId& msgId, messenger::message_status::Type status) override {
        if (statusChangedhandler) {
            statusChangedhandler(msgId, status);
        }
    }
    
    virtual void OnMessageReceived(const messenger::UserId& senderId, const messenger::Message& msg) override {
        if (receivedHandler) {
            receivedHandler(senderId, msg);
        }
    }
    
    void (^statusChangedhandler)(const messenger::MessageId& msgId, messenger::message_status::Type status) = 0;
    void (^receivedHandler)(const messenger::UserId& senderId, const messenger::Message& msg) = 0;
};

#endif /* MessagesObserver_h */
