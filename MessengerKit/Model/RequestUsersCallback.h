//
//  RequestUsersCallback.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#ifndef RequestUsersCallback_h
#define RequestUsersCallback_h
#include <messenger/callbacks.h>

class RequestUsersCallback : public messenger::IRequestUsersCallback {
public:
    
    virtual void OnOperationResult(messenger::operation_result::Type result, const messenger::UserList& users) override {
        if (m_handler) {
            m_handler(result, users);
        }
    }
    
    void (^m_handler)(messenger::operation_result::Type, const messenger::UserList&) = 0;

};

#endif /* RequestUsersCallback_h */
