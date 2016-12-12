//
//  Message.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/7/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize identifier = _identifier;
@synthesize time = _time;
@synthesize content = _content;
@synthesize sender = _sender;
@synthesize status = _status;

- (instancetype) init
{
    return [self initWithId: nil
                       time: 0
             messageContent: nil];
}

- (instancetype) initWithId: (NSString *)       identifier
                       time: (NSDate *)         time
             messageContent: (MessageContent *) content
{
    self = [super init];
    if (self != nil) {
        _identifier = identifier;
        _time = time;
        _content = content;
        _sender = nil;
        _status = Sending;
    }
    return self;
}

- (instancetype) copyWithZone: (NSZone *) zone
{
    Message *copiedObject = [[[self class] alloc]
                             initWithId:     self.identifier
                             time:           self.time
                             messageContent: self.content];
    return copiedObject;
}

@end
