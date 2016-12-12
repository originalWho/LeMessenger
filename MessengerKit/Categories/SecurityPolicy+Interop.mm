//
//  SecurityPolicy+Interop.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "SecurityPolicy+Interop.h"

@implementation SecurityPolicy (Interop)

- (instancetype) initWithPolicyStruct: (const messenger::SecurityPolicy &) securityPolicy {
    EncryptionAlgorithm algorithm;
    NSData *key;
    switch (securityPolicy.encryptionAlgo) {
        case messenger::encryption_algorithm::Type::None:
            algorithm = None;
            key = nil;
            break;
        case messenger::encryption_algorithm::Type::RSA_1024:
            algorithm = RSA_1024;
            NSUInteger size = sizeof(unsigned char) * securityPolicy.encryptionPubKey.size();
            key = [NSData dataWithBytes: (const void *) securityPolicy.encryptionPubKey.data()
                                 length: size];
            break;
    }
    
    return [self initWithEncryptionAlgorithm: algorithm
                            encryptionPubKey: key];
}

- (messenger::SecurityPolicy) securityPolicyStruct {
    messenger::SecurityPolicy policy;
    switch (self.encryptionAlgo) {
        case None:
            policy.encryptionAlgo = messenger::encryption_algorithm::None;
            break;
        case RSA_1024:
            policy.encryptionAlgo = messenger::encryption_algorithm::RSA_1024;
            unsigned char *bytes = (unsigned char *) [self.encryptionPubKey bytes];
            std::vector<unsigned char>::size_type size = strlen((const char *) bytes);
            std::copy(bytes, bytes + size, std::back_inserter(policy.encryptionPubKey));
            break;
    }
    return policy;
}

@end
