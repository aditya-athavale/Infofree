//
//  UserData.h
//  InfoFreeNew
//
//  Created by Aditya Athvale on 25/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface UserData : NSObject

@property(nonatomic, strong)NSString *userId, *password, *authenticationToken;

+(UserData *)sharedUserData;
-(NSArray *)getAllContacts;

@end
