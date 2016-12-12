//
//  MessageStatusNotification.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/10/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "MessageStatusNotification.h"

@implementation MessageStatusNotification

@synthesize messageId = _messageId;
@synthesize messageStatus = _messageStatus;

- (instancetype) initWithId: (NSString *)   messageId
                     status: (MessageStatus)status
{
    self = [super init];
    if (self != nil) {
        _messageId = messageId;
        _messageStatus = status;
    }
    return self;
}

- (instancetype) copyWithZone: (NSZone *) zone
{
    MessageStatusNotification *copiedObject = [[[self class] alloc]
                                                initWithId: self.messageId
                                                    status: self.messageStatus
                                               ];
    return copiedObject;
}

@end
