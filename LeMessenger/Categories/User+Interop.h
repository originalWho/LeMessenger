//
//  User+Interop.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "NSString+Interop.h"
#import "SecurityPolicy+Interop.h"
#include <messenger/types.h>

@interface User (Interop)

- (instancetype) initWithUserStruct: (const messenger::User &) user;

- (messenger::User) userStruct;

@end
