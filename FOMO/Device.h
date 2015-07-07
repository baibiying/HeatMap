//
//  Device.h
//  
//
//  Created by Edward Arenberg on 2/6/12.
//  Copyright (c) 2012 EPage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

+ (Device *) sharedInstance;
- (NSString*) UUID;

@end
