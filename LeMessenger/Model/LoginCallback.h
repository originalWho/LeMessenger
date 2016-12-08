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
            switch (result) {
                case messenger::operation_result::Type::Ok:
                    m_handler(OperationResult::Ok);
                    break;
                case messenger::operation_result::Type::AuthError:
                    m_handler(OperationResult::AuthError);
                    break;
                case messenger::operation_result::Type::NetworkError:
                    m_handler(OperationResult::NetworkError);
                    break;
                case messenger::operation_result::Type::InternalError:
                    m_handler(OperationResult::InternalError);
                    break;
                default:
                    break;
            }
        }
    }
    
    void (^m_handler)(OperationResult) = 0;
};
#endif /* LoginCallback_h */
