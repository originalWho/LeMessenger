//
//  Configuration+Interop.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "Configuration+Interop.h"

@implementation Configuration (Interop)

- (instancetype) initWithMessengerSettingsStruct:(const messenger::MessengerSettings &) messengerSettingsStruct {
    return [self initWithServerUrl:[NSString stringWithUTF8String:messengerSettingsStruct.serverUrl.c_str()]
                        serverPort:[NSNumber numberWithUnsignedShort:messengerSettingsStruct.serverPort]];
}

- (void) fillMessengerSettingsStruct:(messenger::MessengerSettings &) messengerSettingsStruct {
    if (self.serverUrl != nil) {
        messengerSettingsStruct.serverUrl = [self.serverUrl UTF8String];
    }
    if (self.serverPort != nil) {
        messengerSettingsStruct.serverPort = [self.serverPort unsignedShortValue];
    }
}

- (messenger::MessengerSettings) messengerSettingsStruct {
    messenger::MessengerSettings settings;
    settings.serverUrl = std::string([self.serverUrl UTF8String]);
    settings.serverPort = [self.serverPort unsignedShortValue];
    return settings;
}

@end
