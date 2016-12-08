//
//  NSString+Interop.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "NSString+Interop.h"

@implementation NSString (Interop)

- (messenger::UserId) stdString {
    return std::string([self UTF8String]);
}

@end
