//
//  FilterHandler.m
//  InfoFreeNew
//
//  Created by Aditya Athvale on 28/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "FilterHandler.h"
#import "UserData.h"

@implementation FilterHandler

FilterHandler *sharedFilterHandler;

+(FilterHandler *)getSharedFilterHandler
{
    if (!sharedFilterHandler)
    {
        sharedFilterHandler = [[FilterHandler alloc] init];
        sharedFilterHandler.dictFilters = [[NSMutableDictionary alloc] init];
        [sharedFilterHandler.dictFilters setValue:[[UserData sharedUserData] userId] forKey:@"userId"];
        [sharedFilterHandler.dictFilters setValue:@"" forKey:@"LeadsFilter"];
        [sharedFilterHandler.dictFilters setValue:@"" forKey:@"TagsFilter"];
        [sharedFilterHandler.dictFilters setValue:@"" forKey:@"LocationFilter"];
        [sharedFilterHandler.dictFilters setValue:@"" forKey:@"StateFilter"];
    }
    return sharedFilterHandler;
}



@end
