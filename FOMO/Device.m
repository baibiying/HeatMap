//
//  Device.m
//  
//
//  Created by Edward Arenberg on 2/6/12.
//  Copyright (c) 2012 EPage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"
#import "NSString+MyUUID.h"

#define kUserDefaultInstallationID              @"InstallationID"

@interface Device()
{
//#define kAppName @"YourAppName"
    NSString *bundleName;
}

@end


@implementation Device

static Device *instance = nil;

+ (Device *) sharedInstance
{
  	if (!instance) 
	{
		instance = [[Device alloc] init];
        instance->bundleName = [[NSBundle mainBundle] bundleIdentifier];
	}
	return instance;	 
}

- (id)init
{
    if (!instance) {
        self = [super init];
        if (self) {
            instance = self;
        }
    }
    return instance;
}

- (NSString*) UUID
{
    NSString *installationID = [instance getPasteboardID];
    NSString *settingsInstallationID = [instance getSettingsID];
    if(installationID == nil && settingsInstallationID == nil)
    {
        //Create new (saves to pasteboard and settings)
        installationID = [instance makeInstallationID];
    }
    else if(installationID == nil)
    {
        //Save to the pasteboard
        [instance savePasteboardID:settingsInstallationID];
        installationID = settingsInstallationID;
    }
    else if(settingsInstallationID == nil)
    {
        //Save to settings
        [instance saveSettingsID:installationID];
    }
    return installationID;
}


#pragma mark - Private Instance Methods

-(NSString*)createUUID
{
    return [NSString UUID];
}

-(NSString*)getPasteboardID
{
    NSString *pasteBoardID = nil;
    UIPasteboard *pb = [UIPasteboard pasteboardWithName:bundleName create:NO];
    id item = [pb dataForPasteboardType:@"InstallationID"];
    pb = nil;
    if(item)
    {
        pasteBoardID = [NSString stringWithString:[NSKeyedUnarchiver unarchiveObjectWithData:item]];
    }
    return pasteBoardID;
}
-(NSString*)getSettingsID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pasteBoardID = [defaults stringForKey:kUserDefaultInstallationID];
    return pasteBoardID;
}
-(void)savePasteboardID:(NSString*)uniqueID
{
    UIPasteboard *pb = [UIPasteboard pasteboardWithName:bundleName create:YES];
    [pb setPersistent:YES];
    [pb setData:[NSKeyedArchiver archivedDataWithRootObject:uniqueID] forPasteboardType:kUserDefaultInstallationID];
    pb = nil;
}
-(void)saveSettingsID:(NSString*)uniqueID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:uniqueID forKey:kUserDefaultInstallationID];
    [defaults synchronize];
}
-(NSString *)makeInstallationID
{
    //Create
    NSString *installationID = [instance createUUID];
    
    //Save to the pasteboard
    [instance savePasteboardID:installationID];
    
    //Save to settings
    [instance saveSettingsID:installationID];
    
    //Return
    return installationID;
}


@end
