//
//  Message+Interop.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/8/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#include <messenger/types.h>

@interface Message (Interop)

- (messenger::Message) messageStruct;

@end
