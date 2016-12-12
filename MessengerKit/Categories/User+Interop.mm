//
//  User+Interop.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "SecurityPolicy+Interop.h"
#import "User+Interop.h"

@implementation User (Interop)

- (instancetype) initWithUserStruct: (const messenger::User &) user
{
    return [self initWithUserId: [NSString       stringWithUTF8String:  user.identifier.c_str()]
                 securityPolicy: [[[SecurityPolicy class] alloc] initWithPolicyStruct: user.securityPolicy]
            ];
}

- (messenger::User) userStruct
{
    messenger::User user;
    user.identifier = [self.userId stdString];
    user.securityPolicy = [self.securityPolicy securityPolicyStruct];
    return user;
}

@end
