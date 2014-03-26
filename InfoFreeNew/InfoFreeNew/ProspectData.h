//
//  ProspectData.h
//  InfoFree
//
//  Created by Aditya Athvale on 25/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    ProspectTypeC,
    ProspectTypeB,
    ProspectTypeO
}ProspectType;

typedef enum
{
    ProspectStatusLead,
    ProspectStatusHot,
    ProspectStatusCold,
    ProspectStatusCustomer,
    ProspectStatusWarm,
}ProspectStatus;


@interface Address : NSObject

@property(nonatomic)float longitude, latitude;
@property(nonatomic, strong)NSString *addressLine1;
@property(nonatomic, strong)NSString *addressLine2;
@property(nonatomic, strong)NSString *city, *state, *country;
@property(nonatomic, strong)NSString *zipCode;

@end


@interface ContactInfo : NSObject

@property(nonatomic, strong)NSMutableArray *mailIds;
@property(nonatomic, strong)NSMutableArray *phoneNumbers;
@property(nonatomic, strong)NSString *facebookId;
@property(nonatomic, strong)NSString *twitterHandle;
@property(nonatomic, strong)NSString *skypeId;
@property(nonatomic, strong)NSString *linkedinId;
@property(nonatomic, strong)Address *address;

@end





@interface ProspectContacts : NSObject

@property(nonatomic, strong)NSString *contactFirstName, *contactLastName, *contactGender, *contactLengthAtResidence, *contactMailId2, *contactMailId, *contactMobileNo, *contactPhoneNo, *contactWebUrl, *contactTitle, *contactMaritalStatus, *contactIsActive, *contactIsPrimary, *contactIncome, *contactHomeValue, *contactAge, *contactId;

@property(nonatomic, strong) NSDate *contactLastUpdatedDate, *contactCreatedDate, *contactDob;

-(NSDictionary *)getContactsDictionary;

@end


@interface ProspectAdditionalInfo : NSObject

@property(nonatomic, strong)NSString *prospectAdditionalInformation, *prospectAdditionalInformationIsActive, *prospectAdditionalInformationTitle;

@property(nonatomic, strong) NSDate *prospectAdditionalInfoLastUpdatedDate, *prospectAdditionalInfoCreatedDate;

-(NSDictionary *)getAdditionalInfoDictionary;

@end

@interface ProspectBusinessDetail : NSObject

@property(nonatomic, strong)NSString *businessName, *businessPrimarySIC, *businessPrimaryLineOfBusiness, *businessYearEstablished, *businessEmployeeSize, *businessWebUrl, *businessSalesVolume, *businessCreditProfile;

@property(nonatomic, strong) NSDate *businessCreatedDate, *businessLastUpdatedDate;


@end



@interface ProspectData : NSObject

@property(nonatomic, strong)NSString *prospectId;
@property(nonatomic, strong)NSString *prospectName;
@property(nonatomic, strong)ContactInfo *prospectContact;
//@property(nonatomic, strong)Address *prospectAddress;
@property(nonatomic, strong)NSDate *prospectCreatedDate;

@property(nonatomic, strong)NSDate *customerCreatedDate;
@property(nonatomic, strong)NSDate *customerLastUpdatedDate;

@property(nonatomic, strong)NSDate *prospectLastUpdatedDate;
@property(nonatomic, strong)NSString *prospectUserId;

@property(nonatomic)ProspectType prospectType;
@property(nonatomic)ProspectStatus prospectStatus;

@property(nonatomic)NSString *prospectState, *prospectActivity, *prospectActivityId, *userId, *prospectIsActive;

@property(nonatomic, strong) NSString *prospectSource, *importFailureMessage;

@property(nonatomic, strong) NSMutableArray *prospectTags, *prospectContacts, *prospectAppointments, *userActivities, *prospectNoteDTO, *prospectAdditionalInfo, *prospectTasks, *addFailureMessages;

@property(nonatomic, strong) ProspectBusinessDetail *prospectBusinessDetails;


-(NSData *)getJSONProspectData;

-(void)syncContactWithAddressBook;

@end






