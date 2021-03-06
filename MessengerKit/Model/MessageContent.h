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

@property (nonatomic)         MessageContentType  type;
@property (nonatomic)         bool                encrypted;
@property (nonatomic, strong) NSData              *data;

@end

@interface MessageContent : NSObject<MessageContent>

- (instancetype) initWithMessageContentType: (MessageContentType)   type
                                  encrypted: (bool)                 encrypted
                                       data: (NSData *)             data
NS_DESIGNATED_INITIALIZER;

@end
