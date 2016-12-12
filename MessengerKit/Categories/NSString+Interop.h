//
//  NSString+Interop.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <messenger/types.h>

@interface NSString (Interop)

- (messenger::UserId) stdString;

@end
