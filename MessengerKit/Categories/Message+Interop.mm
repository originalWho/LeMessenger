//
//  Message+Interop.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/8/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "Message+Interop.h"
#import "MessageContent+Interop.h"
#import "NSString+Interop.h"

@implementation Message (Interop)

- (instancetype) initWithMessageStruct: (const messenger::Message &) messageStruct
{
    return [self initWithId: [NSString stringWithUTF8String:          messageStruct.identifier.c_str()]
                       time: [NSDate   dateWithTimeIntervalSince1970: messageStruct.time]
             messageContent: [[[MessageContent class] alloc] initWithContentStruct: messageStruct.content]
            ];
}

- (messenger::Message) messageStruct
{
    messenger::Message message;
    message.identifier = [self.identifier stdString];
    message.content = [self.content messageContentStruct];
    message.time = (std::time_t) [self.time timeIntervalSince1970];
    return message;
}

@end
