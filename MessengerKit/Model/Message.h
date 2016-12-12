//
//  Message.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/7/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageContent.h"

@protocol Message <NSObject, NSCopying>

@property (nonatomic, readonly, strong) NSString        *identifier;
@property (nonatomic, readonly, strong) NSDate          *time;
@property (nonatomic, readonly, strong) MessageContent  *content;
@property (nonatomic, strong)           NSString        *sender;
@property (nonatomic)                   MessageStatus   status;

@end

@interface Message : NSObject<Message>

- (instancetype) initWithId: (NSString *)       identifier
                       time: (NSDate *)         time
             messageContent: (MessageContent *) content
NS_DESIGNATED_INITIALIZER;

@end
