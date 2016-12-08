//
//  Configuration+Interop.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Configuration.h"
#include <messenger/settings.h>

@interface Configuration (Interop)

- (instancetype) initWithMessengerSettingsStruct: (const messenger::MessengerSettings &) messengerSettingsStruct;

- (void) fillMessengerSettingsStruct: (messenger::MessengerSettings &) messengerSettingsStruct;

- (messenger::MessengerSettings) messengerSettingsStruct;

@end
