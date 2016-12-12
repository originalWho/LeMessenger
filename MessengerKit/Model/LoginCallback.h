//
//  LoginCallback.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#ifndef LoginCallback_h
#define LoginCallback_h
#include <messenger/callbacks.h>

class LoginCallback : public messenger::ILoginCallback {
public:

    virtual void OnOperationResult(messenger::operation_result::Type result) override {
        if (m_handler) {
            m_handler(result);
        }
    }
    
    void (^m_handler)(messenger::operation_result::Type) = 0;
};
#endif /* LoginCallback_h */
