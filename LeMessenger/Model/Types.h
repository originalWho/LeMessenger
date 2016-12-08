//
//  Types.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/7/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#ifndef Types_h
#define Types_h

typedef NS_ENUM(NSUInteger, OperationResult) {
    Ok,
    AuthError,
    NetworkError,
    InternalError
};

typedef NS_ENUM(NSUInteger, MessageStatus) {
    Sending,
    Sent,
    FailedToSend,
    Delivered,
    Seen
};

typedef NS_ENUM(NSUInteger, MessageContentType) {
    Text,
    Image,
    Video
};

typedef NS_ENUM(NSUInteger, EncryptionAlgorithm) {
    None,
    RSA_1024
};


#endif /* Types_h */
