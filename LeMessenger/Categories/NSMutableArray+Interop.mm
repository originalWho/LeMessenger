//
//  NSMutableArray+Interop.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/8/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "NSMutableArray+Interop.h"
#include "User+Interop.h"

@implementation NSMutableArray (Interop)

+ (NSMutableArray *) userList: (const messenger::UserList &) users
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity: 10];
    for (int i = 0; i < users.size(); i++) {
        messenger::User userStruct = users.at(i);
        User *user = [[[User class] alloc] initWithUserStruct:userStruct];
        [array addObject: user];
    }
    return array;
}

@end
