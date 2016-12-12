//
//  Configuration.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MessengerSettings <NSObject, NSCopying>

@property (nonatomic, readonly, strong) NSString *serverUrl;
@property (nonatomic, readonly, strong) NSNumber *serverPort;

@end

@interface Configuration : NSObject<MessengerSettings>

- (instancetype) initWithServerUrl: (NSString *) serverUrl
                        serverPort: (NSNumber *) serverPort
NS_DESIGNATED_INITIALIZER;

@end
