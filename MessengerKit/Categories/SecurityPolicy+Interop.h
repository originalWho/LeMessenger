//
//  SecurityPolicy+Interop.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecurityPolicy.h"
#include <messenger/types.h>

@interface SecurityPolicy (Interop)

- (instancetype) initWithPolicyStruct: (const messenger::SecurityPolicy &) securityPolicy;

- (messenger::SecurityPolicy) securityPolicyStruct;

@end
