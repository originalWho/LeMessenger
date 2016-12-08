//
//  MessageContent.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/7/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Types.h"

@protocol MessageContent <NSObject, NSCopying>

@property (nonatomic, readonly)         MessageContentType  type;
@property (nonatomic, readonly)         bool                encrypted;
@property (nonatomic, readonly, strong) NSData              *data;

@end

@interface MessageContent : NSObject<MessageContent>

- (instancetype) initWithMessageContentType: (MessageContentType)   type
                                  encrypted: (bool)                 encrypted
                                       data: (NSData *)             data
NS_DESIGNATED_INITIALIZER;

@end
