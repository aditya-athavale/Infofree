//
//  UserData.m
//  InfoFreeNew
//
//  Created by Aditya Athvale on 25/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "UserData.h"

@interface UserData ()

@end


@implementation UserData

UserData *sharedUserData;

@synthesize authenticationToken, userId, password;


+(UserData *)sharedUserData
{
    if(!sharedUserData)
    {
        sharedUserData = [[UserData alloc] init];
    }
    return sharedUserData;
}

-(NSArray *)getAllContacts
{
    NSMutableArray *arrRecords = [NSMutableArray array];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    int groupId = [self checkAndCreateGroup:addressBook];
    ABRecordRef group = ABAddressBookGetGroupWithRecordID(addressBook, groupId);
    CFArrayRef cfmembers = ABGroupCopyArrayOfAllMembers(group);
    if(cfmembers)
    {
        NSUInteger count = CFArrayGetCount(cfmembers);
        for(NSUInteger idx=0; idx<count; ++idx)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            ABRecordRef person = CFArrayGetValueAtIndex(cfmembers, idx);
            
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
            CFStringRef contactId = ABRecordCopyValue(person, kABPersonNoteProperty);
            
            NSMutableArray *arrPhones = [NSMutableArray array];
            
            for(int i =0 ; i<ABMultiValueGetCount(multiPhones); i++)
            {
                [arrPhones addObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(multiPhones, i)];
            }
            
            ABMultiValueRef multiMails = ABRecordCopyValue(person, kABPersonEmailProperty);
            NSMutableArray *arrMails = [NSMutableArray array];
            
            for(int i =0 ; i<ABMultiValueGetCount(multiMails); i++)
            {
                [arrMails addObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(multiMails, i)];
            }
            
            [dict setValue:arrPhones forKey:@"PhoneNumbers"];
            [dict setValue:arrMails forKey:@"EmailAddresses"];
            [dict setValue:(__bridge NSString *)firstName forKey:@"FirstName"];
            [dict setValue:(__bridge NSString *)lastName forKey:@"LastName"];
            [dict setValue:(__bridge NSString *)contactId forKey:@"ContactId"];
            
            [arrRecords addObject:dict];
            
        }
    }
    return arrRecords;
}


-(int)checkAndCreateGroup:(ABAddressBookRef)addressBook
{
    bool foundIt = NO;
    NSNumber *groupNum;
    CFArrayRef mygroups = ABAddressBookCopyArrayOfAllGroups(addressBook);
    CFIndex numGroups = CFArrayGetCount(mygroups);
    for(CFIndex idx=0; idx<numGroups; ++idx) {
        ABRecordRef mygroupItem = CFArrayGetValueAtIndex(mygroups, idx);
        
        CFStringRef name = (CFStringRef)ABRecordCopyValue(mygroupItem, kABGroupNameProperty);
        bool isMatch = [@"Info Free Contacts" isEqualToString:(__bridge NSString *)name];
        CFRelease(name);
        
        if(isMatch) {
            
            groupNum = [NSNumber numberWithInt:ABRecordGetRecordID(mygroupItem)];
            //            [self setObject:groupNum forKey:kGroupID];
            foundIt = YES;
            break;
        }
    }
    CFRelease(mygroups);
    
    if(!foundIt) {
        
        ABRecordRef mygroupItem = ABGroupCreate();
        CFErrorRef error;
        
        if(ABRecordSetValue(mygroupItem, kABGroupNameProperty, @"Info Free Contacts", &error))
        {
            ABAddressBookAddRecord (addressBook, mygroupItem, &error);
            ABAddressBookSave(addressBook, &error);
            
            groupNum = [NSNumber numberWithInt:ABRecordGetRecordID(mygroupItem)];
            
            //[self setObject:groupNum forKey:kGroupID];
        }
        else
        {
            NSLog(@"%@", error);
        }
        CFRelease(mygroupItem);
    }
    return [groupNum intValue];
}


@end
