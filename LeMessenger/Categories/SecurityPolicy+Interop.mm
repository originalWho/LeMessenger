//
//  SecurityPolicy+Interop.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "SecurityPolicy+Interop.h"

@implementation SecurityPolicy (Interop)

+ (instancetype) initWithPolicyStruct: (const messenger::SecurityPolicy &) securityPolicy {
    SecurityPolicy *policy;
    return [policy initWithEncryptionAlgorithm:None
                              encryptionPubKey:nil];
}

- (messenger::SecurityPolicy) securityPolicyStruct {
    messenger::SecurityPolicy policy;
    switch (self.encryptionAlgo) {
        case None:
            policy.encryptionAlgo = messenger::encryption_algorithm::None;
            break;
        case RSA_1024:
            policy.encryptionAlgo = messenger::encryption_algorithm::RSA_1024;
        default:
            break;
    }
    return policy;
}

@end
