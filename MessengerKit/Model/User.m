//
//  User.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userId          = _userId;
@synthesize securityPolicy  = _securityPolicy;

- (instancetype) init
{
    return [self initWithUserId: nil
                 securityPolicy: nil];
}

- (instancetype) initWithUserId: (NSString *)       userId
                 securityPolicy: (SecurityPolicy *) securityPolicy
{
    self = [super init];
    if (self != nil) {
        _userId         = userId;
        _securityPolicy = securityPolicy;
    }
    return self;
}

- (instancetype) copyWithZone: (NSZone *) zone
{
    User *copiedObject = [[[self class] alloc]
                          initWithUserId: self.userId
                          securityPolicy: self.securityPolicy];
    return copiedObject;
}

@end
