//
//  Messenger.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Configuration.h"
#import "SecurityPolicy.h"
#import "Types.h"
#import "Message.h"
#import "MessageContent.h"
#import "MessageStatusNotification.h"

@interface Messenger : NSObject

+ (instancetype) shared;

- (instancetype) initWithMessengerSettings: (Configuration *) configuration;

- (void) loginWithUserId: (NSString *)                  userId
                password: (NSString *)                  password
          securityPolicy: (SecurityPolicy *)            securityPolicy
              completion: (void (^)(OperationResult))   completion;

- (void) requestActiveUsers: (void (^)(OperationResult, NSMutableArray *))completion;

- (void) sendMessage: (NSString *)          recepientId
             content: (MessageContent *)    content
          completion: (void (^)(Message *)) completion;

- (void) sendMessageSeen: (NSString *) recepientId
               messageId: (NSString *) messageId;

- (void) disconnect;

@end
