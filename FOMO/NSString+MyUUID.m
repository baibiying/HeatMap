//
//  NSString+MyUUID.m
//  
//
//  Created by Edward Arenberg on 3/25/12.
//  Copyright (c) 2012 EPage. All rights reserved.
//

#import "NSString+MyUUID.h"

@implementation NSString (MyUUID)

+ (NSString *)UUID
{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }
    return uuidString;
}


@end
