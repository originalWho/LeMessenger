//
//  MessageContent.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/7/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "MessageContent.h"

@implementation MessageContent

@synthesize type      = _type;
@synthesize encrypted = _encrypted;
@synthesize data      = _data;

- (instancetype) init
{
    return [self initWithMessageContentType: Text
                                  encrypted: false
                                       data: nil];
}

- (instancetype) initWithMessageContentType: (MessageContentType) type
                                  encrypted: (bool)               encrypted
                                       data: (NSData *)           data
{
    self = [super init];
    if (self != nil) {
        _type = type;
        _encrypted = encrypted;
        _data = data;
    }
    return self;
}

- (instancetype) copyWithZone: (NSZone *) zone
{
    MessageContent *copiedObject = [[[self class] alloc]
                                    initWithMessageContentType: self.type
                                    encrypted:                  self.encrypted
                                    data:                       self.data];
    return copiedObject;
}

@end
