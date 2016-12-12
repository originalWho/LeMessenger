//
//  SecurityPolicy.h
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/5/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Types.h"

@protocol SecurityPolicy <NSObject, NSCopying>

@property (nonatomic)         EncryptionAlgorithm encryptionAlgo;
@property (nonatomic, strong) NSData              *encryptionPubKey;

@end

@interface SecurityPolicy : NSObject <SecurityPolicy>

- (instancetype) initWithEncryptionAlgorithm: (EncryptionAlgorithm) encryptionAlgo
                            encryptionPubKey: (NSData *)            encryptionPubKey
NS_DESIGNATED_INITIALIZER;

@end
