//
//  NSMutableArray+Interop.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/8/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <messenger/types.h>

@interface NSMutableArray (Interop)

+ (NSMutableArray *) userList: (const messenger::UserList &) users;

@end
