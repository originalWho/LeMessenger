//
//  Messenger.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "Messenger.h"
#import "Configuration+Interop.h"
#import "LoginCallback.h"
#import "RequestUsersCallback.h"
#import "NSString+Interop.h"
#import "SecurityPolicy+Interop.h"
#import "MessagesObserver.h"
#import "User+Interop.h"
#import "NSMutableArray+Interop.h"
#include <future>
#include <messenger/messenger.h>

@interface Messenger()
{
    std::shared_ptr<messenger::IMessenger>  _nativeMessenger;
    std::shared_ptr<LoginCallback>          _loginCallback;
    std::shared_ptr<RequestUsersCallback>   _requestUsersCallback;
    std::shared_ptr<MessagesObserver>       _messagesObserver;
    std::promise<messenger::UserList>       _userList;
}

@property (assign) bool isConnected;
@end

@implementation Messenger

+ (instancetype) shared
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    static Configuration *config = [[Configuration alloc] initWithServerUrl:@"127.0.0.1" serverPort:0];
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initWithMessengerSettings:config];
    });
    
    return _sharedInstance;
}

- (instancetype) initWithMessengerSettings: (Configuration *) configuration
{
    self = [super init];
    
    if (self != nil) {
        _nativeMessenger = messenger::GetMessengerInstance([configuration messengerSettingsStruct]);
        _loginCallback = std::make_shared<LoginCallback>();
        _requestUsersCallback = std::make_shared<RequestUsersCallback>();
        _messagesObserver = std::make_shared<MessagesObserver>();
    }
    
    return self;
}

- (void) loginWithUserId: (NSString *)                userId
                password: (NSString *)                password
              completion: (void (^)(OperationResult)) completion
{
    [self loginWithUserId: userId
                 password: password
           securityPolicy: nil
               completion: completion];
}

- (void) loginWithUserId: (NSString *)                userId
                password: (NSString *)                password
          securityPolicy: (SecurityPolicy *)          securityPolicy
              completion: (void (^)(OperationResult)) completion
{
    _loginCallback->m_handler = ^(OperationResult result) {
        if (completion) {
            completion(result);
        }
        if (result == OperationResult::Ok) {
            self.isConnected = true;
        }
    };
    
    messenger::SecurityPolicy policy;
    
    _nativeMessenger->Login([userId stdString],
                            [password stdString],
                            policy,
                            &*_loginCallback);
    _nativeMessenger->RegisterObserver(&*_messagesObserver);
}

- (void) requestActiveUsers: (void (^)(OperationResult, NSMutableArray *)) completion
{
    _requestUsersCallback->m_handler = ^(messenger::operation_result::Type result,
                                         const messenger::UserList& users) {
        if (result == messenger::operation_result::Type::Ok) {
            _userList.set_value(users);
        }
        
        if (completion) {
            switch (result) {
                case messenger::operation_result::Ok:
                    completion(OperationResult::Ok, [NSMutableArray userList:_userList.get_future().get()]);
                    break;
                case messenger::operation_result::AuthError:
                    completion(OperationResult::AuthError, nil);
                    break;
                case messenger::operation_result::NetworkError:
                    completion(OperationResult::NetworkError, nil);
                    break;
                case messenger::operation_result::InternalError:
                    completion(OperationResult::InternalError, nil);
                    break;
            }
        }
        
    };
    _nativeMessenger->RequestActiveUsers(&*_requestUsersCallback);
}

- (void) sendMessage: (NSString *)          recepientId
             content: (MessageContent *)    content
          completion: (void (^)(Message *)) completion
{
    
}

- (void) sendMessageSeen: (NSString *) recepientId
               messageId: (NSString *) messageId
{
    
}

- (void) disconnect {
    _nativeMessenger->Disconnect();
    _nativeMessenger->UnregisterObserver(&*_messagesObserver);
}

@end
