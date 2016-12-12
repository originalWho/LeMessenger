//
//  MessageContent+Interop.m
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/8/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

#import "MessageContent+Interop.h"

@implementation MessageContent (Interop)

- (instancetype) initWithContentStruct: (const messenger::MessageContent &) content
{
    MessageContentType type;
    switch (content.type) {
        case messenger::message_content_type::Type::Text:
            type = Text;
            break;
        case messenger::message_content_type::Type::Image:
            type = Image;
            break;
        case messenger::message_content_type::Type::Video:
            type = Video;
            break;
    }
    NSUInteger size = sizeof(unsigned char) * content.data.size();
    NSData *data = [NSData dataWithBytes: (const void *) content.data.data()
                   length:size];
    
    //NSData *data = [[[NSData class] alloc] initWithBytes: (const void *) content.data.data()
    //                                            length: content.data.size()
    //                                           encoding: NSUTF8StringEncoding];
    return [self initWithMessageContentType: type
                                  encrypted: content.encrypted
                                       data: data];
}

- (messenger::MessageContent) messageContentStruct
{
    messenger::MessageContent content;
    content.encrypted = self.encrypted;
    switch (self.type) {
        case Text:
            content.type = messenger::message_content_type::Type::Text;
            break;
        case Image:
            content.type = messenger::message_content_type::Type::Image;
            break;
        case Video:
            content.type = messenger::message_content_type::Type::Video;
            break;
    }
    unsigned char *bytes = (unsigned char *) [self.data bytes];
    std::vector<unsigned char>::size_type size = strlen((const char *) bytes);
    std::copy(bytes, bytes + size, std::back_inserter(content.data));
    return content;
}

@end
