//
//  Configuration.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration

@synthesize serverUrl = _serverUrl;
@synthesize serverPort = _serverPort;

- (instancetype) init
{
    return [self initWithServerUrl: @"127.0.0.1"
                        serverPort: 0];
}

- (instancetype) initWithServerUrl: (NSString *) serverUrl
                        serverPort: (NSNumber *) serverPort
{
    self = [super init];
    if (self != nil) {
        _serverUrl  = serverUrl;
        _serverPort = serverPort;
    }
    return self;
}

- (instancetype) copyWithZone:(NSZone *)zone
{
    Configuration *copiedObject = [[[self class] alloc]
                                       initWithServerUrl: self.serverUrl
                                       serverPort:        self.serverPort];
    return copiedObject;
}


@end
