//
//  SecurityPolicy.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "SecurityPolicy.h"

@implementation SecurityPolicy

@synthesize encryptionAlgo   = _encryptionAlgo;
@synthesize encryptionPubKey = _encryptionPubKey;

- (instancetype)init
{
    return [self initWithEncryptionAlgorithm: None
                            encryptionPubKey: nil];
}

- (instancetype) initWithEncryptionAlgorithm: (EncryptionAlgorithm) encryptionAlgo
                            encryptionPubKey: (NSData *)            encryptionPubKey
{
    self = [super init];
    if (self != nil) {
        _encryptionAlgo   = encryptionAlgo;
        _encryptionPubKey = encryptionPubKey;
    }
    return self;
}

- (instancetype) copyWithZone:(NSZone *) zone
{
    SecurityPolicy *copiedObject = [[[self class] alloc]
                                    initWithEncryptionAlgorithm: self.encryptionAlgo
                                    encryptionPubKey:            self.encryptionPubKey];
    return copiedObject;
}

@end
