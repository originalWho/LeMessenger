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
        
    }
    
    virtual void OnMessageReceived(const messenger::UserId& senderId, const messenger::Message& msg) override {
        
    }
    
    void (^m_handler)(const messenger::MessageId& msgId, messenger::message_status::Type status) = 0;
};

#endif /* MessagesObserver_h */
