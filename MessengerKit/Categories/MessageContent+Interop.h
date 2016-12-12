//
//  MessageContent+Interop.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/8/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <messenger/types.h>
#import "MessageContent.h"

@interface MessageContent (Interop)

- (instancetype) initWithContentStruct: (const messenger::MessageContent &) content;

- (messenger::MessageContent) messageContentStruct;

@end
