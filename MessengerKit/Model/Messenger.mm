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
#import "Message+Interop.h"
#import "MessageContent+Interop.h"
#include <future>
#include <messenger/messenger.h>

@interface Messenger()
{
    std::shared_ptr<messenger::IMessenger>  _nativeMessenger;
    std::shared_ptr<LoginCallback>          _loginCallback;
    std::shared_ptr<RequestUsersCallback>   _requestUsersCallback;
    std::shared_ptr<MessagesObserver>       _messagesObserver;
    messenger::UserList                     _userList;
}
@end

@implementation Messenger

+ (instancetype) shared
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    NSDictionary *configuration = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"Configuration"];
    static Configuration *config = [[[Configuration class] alloc] initWithServerUrl: configuration[@"Server url"]
                                                                         serverPort: configuration[@"Server port"]];
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
        _messagesObserver->receivedHandler = ^(const messenger::UserId& senderId, const messenger::Message& msg) {
            Message *receivedMessage = [[[Message class] alloc] initWithMessageStruct: msg];
            receivedMessage.sender = [NSString stringWithUTF8String: senderId.c_str()];
            [[NSNotificationCenter defaultCenter] postNotificationName: @"MessageReceived"
                                                                object: receivedMessage
            ];
        };
        _messagesObserver->statusChangedhandler = ^(const messenger::MessageId& msgId, messenger::message_status::Type status) {
            MessageStatus messageStatus;
            switch (status) {
                case messenger::message_status::Type::Sending:
                    messageStatus = Sending;
                    break;
                case messenger::message_status::Type::FailedToSend:
                    messageStatus = FailedToSend;
                    break;
                case messenger::message_status::Type::Sent:
                    messageStatus = Sent;
                    break;
                case messenger::message_status::Type::Delivered:
                    messageStatus = Delivered;
                    break;
                case messenger::message_status::Type::Seen:
                    messageStatus = Seen;
                    break;
            }
            MessageStatusNotification *notification = [[[MessageStatusNotification class] alloc]
                                                        initWithId: [NSString stringWithUTF8String: msgId.c_str()]
                                                            status: messageStatus];
            [[NSNotificationCenter defaultCenter] postNotificationName: @"MessageStatusChanged"
                                                                object: notification];
            
        };
    }
    
    return self;
}

- (void) loginWithUserId: (NSString *)                userId
                password: (NSString *)                password
          securityPolicy: (SecurityPolicy *)          securityPolicy
              completion: (void (^)(OperationResult)) completion
{
    _loginCallback->m_handler = ^(messenger::operation_result::Type result) {
        if (completion) {
            switch (result) {
                case messenger::operation_result::Type::Ok:
                    completion(Ok);
                    break;
                case messenger::operation_result::Type::AuthError:
                    completion(AuthError);
                    break;
                case messenger::operation_result::Type::NetworkError:
                    completion(NetworkError);
                    break;
                case messenger::operation_result::Type::InternalError:
                    completion(InternalError);
                    break;
            }
        }
    };
    
    _nativeMessenger->Login([userId stdString],
                            [password stdString],
                            [securityPolicy securityPolicyStruct],
                            &*_loginCallback);
    _nativeMessenger->RegisterObserver(&*_messagesObserver);
}

- (void) requestActiveUsers: (void (^)(OperationResult, NSMutableArray *)) completion
{
    _requestUsersCallback->m_handler = ^(messenger::operation_result::Type result,
                                         const messenger::UserList& users) {
        if (result == messenger::operation_result::Type::Ok) {
            _userList = users;
        }
        
        if (completion) {
            switch (result) {
                case messenger::operation_result::Ok:
                    completion(OperationResult::Ok, [NSMutableArray userList:_userList]);
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
    messenger::Message message = _nativeMessenger->SendMessage([recepientId stdString], [content messageContentStruct]);
    if (completion) {
        Message *sentMessage = [[[Message class] alloc] initWithMessageStruct: message];
        sentMessage.sender = @"You";
        [[NSNotificationCenter defaultCenter] postNotificationName: @"MessageSent"
                                                            object: nil];
        completion(sentMessage);
    }
}

- (void) sendMessageSeen: (NSString *) recepientId
               messageId: (NSString *) messageId
{
    _nativeMessenger->SendMessageSeen([recepientId stdString], [messageId stdString]);
}

- (void) disconnect {
    _nativeMessenger->Disconnect();
    _nativeMessenger->UnregisterObserver(&*_messagesObserver);
}

@end
