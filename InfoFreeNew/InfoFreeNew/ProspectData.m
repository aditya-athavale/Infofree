//
//  ProspectData.m
//  InfoFree
//
//  Created by Aditya Athvale on 25/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "ProspectData.h"
#import <AddressBook/AddressBook.h>
#import "UserData.h"
#import "SBJson.h"

@interface ProspectData ()

@property(nonatomic) ABAddressBookRef addressBook;

@end

@implementation ProspectData

-(void)syncContactWithAddressBook
{
    _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    int groupId = [self checkAndCreateGroup:_addressBook];
    
    ProspectContacts *primaryContact;
    
    for (ProspectContacts *contact in self.prospectContacts)
    {
//        if((contact.contactIsPrimary != [NSNull null]) && [contact.contactIsPrimary isEqualToString:@"Y"])
        {
            primaryContact = contact;
        }
    }
    if([self ifContactExist:groupId])
    {
        ABRecordRef person = ABPersonCreate();
        
        if (primaryContact.contactFirstName)
        {
            ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)primaryContact.contactFirstName, nil);
        }
        if(primaryContact.contactLastName)
        {
            ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)primaryContact.contactLastName, nil);
        }
        
        if (primaryContact.contactTitle)
        {
            ABRecordSetValue(person, kABPersonJobTitleProperty,(__bridge CFTypeRef)(primaryContact.contactTitle), nil);
        }
        if(primaryContact.contactId)
        {
            ABRecordSetValue(person, kABPersonNoteProperty,(__bridge CFStringRef)([NSString stringWithFormat:@"%@  ",primaryContact.contactId]), nil);
        }
        
//    if (personNote) {
//        ABRecordSetValue(person, kABPersonNoteProperty, (__bridge CFTypeRef)(personNote), nil);
//    }
        
//    if (dataRef) {
//        ABPersonSetImageData(person, (__bridge CFDataRef)dataRef,&cfError);
//    }
        
        if (primaryContact.contactWebUrl)
        {
            ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(urlMultiValue, (__bridge CFStringRef) primaryContact.contactWebUrl, kABPersonHomePageLabel, NULL);
            ABRecordSetValue(person, kABPersonURLProperty, urlMultiValue, nil);
            CFRelease(urlMultiValue);
        }
        
        if (self.prospectContact.mailIds)
        {
            ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            for (int i = 0; i < self.prospectContact.mailIds.count; i++)
            {
                ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFStringRef) [self.prospectContact.mailIds objectAtIndex:i], kABWorkLabel, NULL);
            }
            
            ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, nil);
            CFRelease(emailMultiValue);
        }
        
        if (self.prospectContact.phoneNumbers)
        {
            ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);

            for (NSString *venuePhoneNumberString in self.prospectContact.phoneNumbers)
            {
                ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFStringRef) venuePhoneNumberString, kABPersonPhoneMainLabel, NULL);
            }
            ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
            CFRelease(phoneNumberMultiValue);
        }
            
            // add address
        
        ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
        
        if (self.prospectContact.address)
        {
            addressDictionary[(NSString *) kABPersonAddressStreetKey] = [NSString stringWithFormat:@"%@\n%@", self.prospectContact.address.addressLine1, self.prospectContact.address.addressLine2];
            addressDictionary[(NSString *)kABPersonAddressCityKey] = self.prospectContact.address.city;
    //        if (stateName)
    //            addressDictionary[(NSString *)kABPersonAddressStateKey] = stateName;
            addressDictionary[(NSString *)kABPersonAddressZIPKey] = self.prospectContact.address.zipCode;
    //        if (country)
    //            addressDictionary[(NSString *)kABPersonAddressCountryKey] = country;
            
            ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFDictionaryRef) addressDictionary, kABWorkLabel, NULL);
            ABRecordSetValue(person, kABPersonAddressProperty, multiAddress, NULL);
            CFRelease(multiAddress);
        }
            
        //Add person Object to addressbook Object.
        ABAddressBookAddRecord(_addressBook, person, nil);
        
        CFErrorRef error = nil;
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            ABAddressBookAddRecord(_addressBook, person, &error);
            ABAddressBookSave(_addressBook, &error);
            
            ABRecordRef group = ABAddressBookGetGroupWithRecordID(_addressBook, groupId);//ABAddressBookGetPersonWithRecordID(addressBook, [self checkAndCreateGroup:addressBook]);
            if(ABGroupAddMember(group, person, &error))
            {
                if (ABAddressBookSave(_addressBook, &error))
                {
                    NSLog(@"\nPerson Saved successfuly");
                } else {
                    NSLog(@"\n Error Saving person to AddressBook %@",error);
                }
            }
        }
        else
        {
            NSLog(@"No Authorization");
            ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error)
            {
                if (granted)
                {
                    
                    ABAddressBookAddRecord(_addressBook, person, &error);
                    ABAddressBookSave(_addressBook, &error);
                    
                    ABRecordRef group = ABAddressBookGetGroupWithRecordID(_addressBook, groupId);//ABAddressBookGetPersonWithRecordID(addressBook, [self checkAndCreateGroup:addressBook]);
                    if(ABGroupAddMember(group, person, &error))
                    {
                        if (ABAddressBookSave(_addressBook, &error))
                        {
                            NSLog(@"\nPerson Saved successfuly");
                        } else {
                            NSLog(@"\n Error Saving person to AddressBook %@",error);
                        }
                    }                

                }
                else
                {
                    // Show an alert here if user denies access telling that the contact cannot be added because you didn't allow it to access the contacts
                }
            });
        }
    }
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

-(BOOL)ifContactExist:(int)groupId
{
    ABRecordRef group = ABAddressBookGetGroupWithRecordID(_addressBook, groupId);
    CFArrayRef cfmembers = ABGroupCopyArrayOfAllMembers(group);
    
    if(cfmembers) {
        NSUInteger count = CFArrayGetCount(cfmembers);
        for(NSUInteger idx=0; idx<count; ++idx)
        {
            ABRecordRef person = CFArrayGetValueAtIndex(cfmembers, idx);
            
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for (NSString *venuePhoneNumberString in self.prospectContact.phoneNumbers)
            {
                for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++)
                {
                    if([venuePhoneNumberString isEqualToString: (__bridge NSString *)ABMultiValueCopyValueAtIndex(multiPhones, i)])
                    {
                        NSLog(@"Number exists:");
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}


-(NSData *)getJSONProspectData
{
    /*
     PROSPECT TYPE CODE
     PROSPECT SOURCE
     PORSPECT USER ID
     PROSPECT STATUS
     PROSPECT IS ACTIVE
     CREATED DATE
     UPDATED DATE
     */
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:[[UserData sharedUserData] userId] forKey:@"userId"];
    NSString *prospectType= @"";
    if(self.prospectType == ProspectTypeB)
    {
        prospectType = @"B";
    }
    else if(self.prospectType == ProspectTypeC)
    {
        prospectType = @"C";
    }
    else if(self.prospectType == ProspectTypeO)
    {
        prospectType = @"O";
    }
    
    NSString *prospectStatus= @"";
    if(self.prospectStatus == ProspectStatusLead)
    {
        prospectStatus = @"lead";
    }
    else if(self.prospectStatus == ProspectStatusWarm)
    {
        prospectType = @"warm";
    }
    else if(self.prospectStatus == ProspectStatusCold)
    {
        prospectType = @"cold";
    }
    else if(self.prospectStatus == ProspectStatusCustomer)
    {
        prospectStatus = @"customer";
    }
    
    [dict setValue:prospectType forKey:@"prospectType"];
    [dict setValue:prospectStatus forKey:@"prospectStatusType"];
    
    if(self.prospectSource)
        [dict setValue:self.prospectSource forKey:@"prospectSource"];
    else
        [dict setValue:@"" forKey:@"prospectSource"];
    
    if(self.prospectContact.phoneNumbers)
    {
         [dict setValue:[self.prospectContact.phoneNumbers objectAtIndex:0] forKey:@"prospectPhoneNo"];
         [dict setValue:[self.prospectContact.phoneNumbers objectAtIndex:1] forKey:@"prospectMobileNo"];
    }
    else
    {
        [dict setValue:@"" forKey:@"prospectPhoneNo"];
        [dict setValue:@"" forKey:@"prospectMobileNo"];
    }
    if(self.prospectContact.address)
    {
        if(self.prospectContact.address.city)
            [dict setValue:self.prospectContact.address.city forKey:@"prospectCity"];
        else
            [dict setValue:@"" forKey:@"prospectCity"];
        if(self.prospectContact.address.state)
            [dict setValue:self.prospectContact.address.state forKey:@"prospectState"];
        else
            [dict setValue:@"" forKey:@"prospectState"];
        if(self.prospectContact.address.zipCode)
            [dict setValue:self.prospectContact.address.zipCode forKey:@"prospectZipCode"];
        else
            [dict setValue:@"" forKey:@"prospectZipCode"];
        if(self.prospectContact.address.addressLine1)
            [dict setValue:self.prospectContact.address.addressLine1 forKey:@"prospectAddressLine1"];
        else
            [dict setValue:@"" forKey:@"prospectAddressLine1"];
        if(self.prospectContact.address.addressLine2)
            [dict setValue:self.prospectContact.address.addressLine2 forKey:@"prospectAddressLine2"];
        else
            [dict setValue:@"" forKey:@"prospectAddressLine2"];
        
//        if(self.prospectContact.address.country)
//            [dict setValue:self.prospectContact.address.country forKey:@"country"];
//        else
//            [dict setValue:@"" forKey:@"country"];

    }
    
    [dict setValue:@"0" forKey:@"prospectGeoLatitude"];
    [dict setValue:@"0" forKey:@"prospectGeoLongitude"];
    
    if(self.prospectContact.mailIds)
    {
        [dict setValue:[self.prospectContact.mailIds objectAtIndex:0] forKey:@"prospectMailId"];
        [dict setValue:[self.prospectContact.mailIds objectAtIndex:1] forKey:@"prospectMailId2"];
    }
    else
    {
        [dict setValue:@"" forKey:@"prospectMailId"];
        [dict setValue:@"" forKey:@"prospectMailId2"];
    }
    
    if(self.prospectCreatedDate)
        [dict setValue:[self getFormattedDate:self.prospectCreatedDate] forKey:@"prospectCreatedDate"];
    else
        [dict setValue:@"" forKey:@"prospectCreatedDate"];
    
    if(self.prospectLastUpdatedDate)
        [dict setValue:[self getFormattedDate:self.prospectLastUpdatedDate] forKey:@"prospectLastUpdatedDate"];
    else
        [dict setValue:@"" forKey:@"prospectLastUpdatedDate"];
    
    if(self.prospectIsActive)
        [dict setValue:self.prospectIsActive forKey:@"prospectIsActive"];
    else
        [dict setValue:@"" forKey:@"prospectIsActive"];
    
    if(self.prospectContacts)
        [dict setValue:self.prospectContacts forKey:@"prospectContacts"];
    else
        [dict setValue:@"" forKey:@"prospectContacts"];
    
    if(self.prospectAdditionalInfo)
        [dict setValue:self.prospectAdditionalInfo forKey:@"prospectAdditionalInfo"];
    else
        [dict setValue:@"" forKey:@"prospectAdditionalInfo"];
    
    if(self.prospectBusinessDetails)
        [dict setValue:self.prospectBusinessDetails forKey:@"businessDetail"];
    else
        [dict setValue:@"" forKey:@"businessDetail"];
    
    [dict setValue:[[UserData sharedUserData] userId] forKey:@"userId"];
    
    
    NSDictionary *contact = [NSDictionary dictionaryWithObjects:
                              [NSArray arrayWithObjects:
                               [self getFormattedDate:[NSDate date]], [self getFormattedDate:[NSDate date]], @"", @"", @"Aditya", @"", @"", @"Y", @"Y", @"Athavale", @"Male", @"", @"", @"", @"Single", @"", @"", @"", @"CEO", nil]
                                forKeys:[NSArray arrayWithObjects:@"contactCreatedDate", @"contactLastUpdatedDate", @"contactAge", @"contactDob", @"contactFirstName", @"contactHomeValue", @"contactIncome", @"contactIsActive", @"contactIsPrimary", @"contactLastName", @"contactGender", @"contactLengthAtResidence", @"contactMailId", @"contactMailId2", @"contactMaritalStatus", @"contactMobileNo", @"contactPhoneNo", @"contactWebUrl", @"contactTitle", nil]];
    
    NSDictionary *aditionalInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Info", @"Y", @"Additional Info title", [self getFormattedDate:[NSDate date]], [self getFormattedDate:[NSDate date]], nil] forKeys:[NSArray arrayWithObjects:@"prospectAdditionalInformation", @"prospectAdditionalInformationIsActive", @"prospectAdditionalInformationTitle", @"prospectAdditionalInfoCreatedDate", @"prospectAdditionalInfoLastUpdatedDate", nil]];
    
    NSDictionary *businessDetail = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Aditya Athavale CEO", @"8111001", @"", @"1-2 Years", @"1-4 Employees", @"", @"", @"Good", [self getFormattedDate:[NSDate date]], [self getFormattedDate:[NSDate date]],  nil] forKeys:[NSArray arrayWithObjects:@"businessName", @"businessPrimarySIC", @"businessPrimaryLineOfBusiness", @"businessYearEstablished", @"businessEmployeeSize", @"businessWebUrl", @"businessSalesVolume", @"businessCreditProfile", @"businessCreatedDate", @"businessLastUpdatedDate", nil]];
    
    [dict setValue:[NSArray arrayWithObject:contact] forKey:@"prospectContacts"];
    [dict setValue:[NSArray arrayWithObject:aditionalInfo] forKey:@"prospectAdditionalInfo"];
    [dict setValue:businessDetail forKey:@"businessDetail"];
    

    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    
    NSLog(@"%@", [jsonWriter stringWithObject:dict]);
    
    return [jsonWriter dataWithObject:dict];
}

-(NSString *)getFormattedDate :(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

@end


@implementation ProspectContacts

-(ProspectContacts *)init
{
    self = [super init];
    if(self)
    {
        self.contactFirstName = @"";
        self.contactHomeValue = @"";
        self.contactIncome = @"";
        self.contactIsActive = @"Y";
        self.contactIsPrimary = @"Y";
        self.contactLastName = @"";
        self.contactGender = @"";
        self.contactLengthAtResidence = @"";
        self.contactMailId = @"";
        self.contactMailId2 = @"";
        self.contactMaritalStatus = @"";
        self.contactMobileNo = @"";
        self.contactPhoneNo = @"";
        self.contactWebUrl = @"";
        self.contactTitle = @"";
        self.contactAge = @"";
        self.contactId = @"";
  
    }
    return self;
}


-(NSDictionary *)getContactsDictionary
{
    NSDictionary *contact = [NSDictionary dictionaryWithObjects:
                             [NSArray arrayWithObjects:
                                  /*[self getFormattedDate:self.contactCreatedDate],
                                  [self getFormattedDate:self.contactLastUpdatedDate],*/
                                  self.contactAge,
                                  /*[self getFormattedDate:self.contactDob],*/
                                  self.contactFirstName,
                                  self.contactHomeValue,
                                  self.contactIncome,
                                  self.contactIsActive,
                                  self.contactIsPrimary,
                                  self.contactLastName,
                                  self.contactGender,
                                  self.contactLengthAtResidence,
                                  self.contactMailId,
                                  self.contactMailId2,
                                  self.contactMaritalStatus,
                                  self.contactMobileNo,
                                  self.contactPhoneNo,
                                  self.contactWebUrl,
                                  self.contactTitle,
                                  self.contactId, nil]
                            forKeys:[NSArray arrayWithObjects:
                                     /*@"contactCreatedDate",
                                     @"contactLastUpdatedDate",*/
                                     @"contactAge",
                                     /*@"contactDob",*/
                                     @"contactFirstName",
                                     @"contactHomeValue",
                                     @"contactIncome",
                                     @"contactIsActive",
                                     @"contactIsPrimary",
                                     @"contactLastName",
                                     @"contactGender",
                                     @"contactLengthAtResidence",
                                     @"contactMailId",
                                     @"contactMailId2",
                                     @"contactMaritalStatus",
                                     @"contactMobileNo",
                                     @"contactPhoneNo",
                                     @"contactWebUrl",
                                     @"contactTitle",
                                     @"contactId", nil]];
    return contact;
}

-(NSString *)getFormattedDate :(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

@end

@implementation ProspectBusinessDetail

-(NSDictionary *)getBusinessDetailsDictionary
{
    NSDictionary *businessDetail = [NSDictionary dictionaryWithObjects:
                                    [NSArray arrayWithObjects:
                                     self.businessName,
                                     self.businessPrimarySIC,
                                     self.businessPrimaryLineOfBusiness,
                                     self.businessYearEstablished,
                                     self.businessEmployeeSize,
                                     self.businessWebUrl,
                                     self.businessSalesVolume,
                                     self.businessCreditProfile,
                                     [self getFormattedDate:self.businessCreatedDate],
                                     [self getFormattedDate:self.businessLastUpdatedDate],  nil]
                                   forKeys:[NSArray arrayWithObjects:
                                            @"businessName",
                                            @"businessPrimarySIC",
                                            @"businessPrimaryLineOfBusiness",
                                            @"businessYearEstablished",
                                            @"businessEmployeeSize",
                                            @"businessWebUrl",
                                            @"businessSalesVolume",
                                            @"businessCreditProfile",
                                            @"businessCreatedDate",
                                            @"businessLastUpdatedDate", nil]];
    return businessDetail;
}

-(NSString *)getFormattedDate :(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}


@end

@implementation ProspectAdditionalInfo

-(NSDictionary *)getAdditionalInfoDictionary
{
    NSDictionary *aditionalInfo =
        [NSDictionary dictionaryWithObjects:
         [NSArray arrayWithObjects:
            @"1",
              self.prospectAdditionalInformation,
              self.prospectAdditionalInformationIsActive,
              self.prospectAdditionalInformationTitle,
              [self getFormattedDate:self.prospectAdditionalInfoCreatedDate],
              [self getFormattedDate:self.prospectAdditionalInfoLastUpdatedDate], nil]
        forKeys:[NSArray arrayWithObjects:
                 @"prospectId",
                 @"prospectAdditionalInformation",
                 @"prospectAdditionalInformationIsActive",
                 @"prospectAdditionalInformationTitle",
                 @"prospectAdditionalInfoCreatedDate",
                 @"prospectAdditionalInfoLastUpdatedDate", nil]];

    return aditionalInfo;
}

-(NSString *)getFormattedDate :(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}


@end



@implementation ContactInfo

@end

@implementation Address

@end



