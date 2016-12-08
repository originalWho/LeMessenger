//
//  LoginCallback.cpp
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#include "LoginCallback.hpp"
#include <messenger/callbacks.h>

class LoginCallbackImpl : public messenger::ILoginCallback {
public:
    virtual void OnOperationResult(messenger::operation_result::Type result) override {
        if (m_handler) {
            m_handler(result);
        }
    }
    
    void (^m_handler)(bool) = 0;
};
