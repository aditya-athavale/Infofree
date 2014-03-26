//
//  FilterHandler.h
//  InfoFreeNew
//
//  Created by Aditya Athvale on 28/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterHandler : NSObject

@property(nonatomic, strong) NSMutableDictionary *dictFilters;

+(FilterHandler *)getSharedFilterHandler;

@end
