//
//  MessageStatusNotification.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/10/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Types.h"

@protocol MessageStatusNotification <NSObject, NSCopying>

@property (nonatomic, readonly, strong) NSString *messageId;
@property (nonatomic, readonly) MessageStatus messageStatus;

@end

@interface MessageStatusNotification : NSObject<MessageStatusNotification>

- (instancetype) initWithId: (NSString *) messageId
                     status: (MessageStatus) status;

@end
