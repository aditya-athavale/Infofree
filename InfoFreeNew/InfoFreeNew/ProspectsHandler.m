//
//  ProspectsHandler.m
//  InfoFree
//
//  Created by Aditya Athvale on 25/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "ProspectsHandler.h"

@interface ProspectsHandler ()

@property(nonatomic, strong) NSMutableArray *arrProspects;

@property(nonatomic, strong) ProspectData *prospect;
@property(nonatomic)Operation operationCode;

@end

@implementation ProspectsHandler

//+(ProspectsHandler *)getSharedProspectsHandler
//{
//    if(!sharedProspectsHandler)
//    {
//        sharedProspectsHandler = [[ProspectsHandler alloc] init];
//        sharedProspectsHandler.pageCount = 25;
//        sharedProspectsHandler.startindex = 0;
//        sharedProspectsHandler.connectionHandler = [[BasicConnectionHandler alloc] init];
//        [sharedProspectsHandler.connectionHandler setDelegate:sharedProspectsHandler];
//    }
//    return sharedProspectsHandler;
//}

-(ProspectsHandler *)init
{
    self = [super init];
    if(self)
    {
        self.connectionHandler = [[BasicConnectionHandler alloc] init];
        [self.connectionHandler setDelegate:self];
        self.pageCount = 25;
        self.startindex = 0;
    }
    return self;
}


-(void)getProspectList
{
    self.operationCode = OPERATION_GET_PROSPECT_LIST;
    
    NSString *str = [[UserData sharedUserData] userId];
//    str = @"2";
    
    self.startindex = 0;
    self.pageCount = 25;
    
    NSMutableDictionary *dictStatus = [NSMutableDictionary dictionaryWithObject:@"true" forKey:@"defaultStateAll"];
    [dictStatus setValue:NULL forKey:@"isHot"];
    [dictStatus setValue:NULL forKey:@"isWarm"];
    [dictStatus setValue:NULL forKey:@"isCold"];
    [dictStatus setValue:NULL forKey:@"isLead"];
    [dictStatus setValue:NULL forKey:@"isCustomer"];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:NULL forKey:@"location"];
    [dict setValue:NULL forKey:@"query"];
    [dict setValue:NULL forKey:@"duration"];
    [dict setValue:dictStatus forKey:@"status"];
    [dict setValue:str forKey:@"userId"];
    [dict setValue:NULL forKey:@"contactFilter"];
    [dict setValue:NULL forKey:@"defaultStateAll"];
    [dict setValue:NULL forKey:@"businessFilter"];
    [dict setValue:NULL forKey:@"alphaFilter"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    
    
//    NSLog(@"JSON Sent: %@",[jsonWriter stringWithObject:dict]);
    
    [self.connectionHandler setUrl:[NSString stringWithFormat:PROSPECTS_URL, str, [self startindex], [self pageCount]]];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:[jsonWriter dataWithObject:dict]];
}

-(void)getProspectDetails:(NSString *)prospectId
{
    self.operationCode = OPERATION_GET_PROSPECT_DETAILS;
    [self.connectionHandler setUrl:[NSString stringWithFormat:PROSPECT_DETAILS_URL, prospectId]];
    [self.connectionHandler initiateGetRequestHandler];
}

-(void)addProspect:(ProspectData *)prospectData
{
    self.operationCode = OPERATION_ADD_PROSPECT;
    [self.connectionHandler setUrl:ADD_PROSPECTS_URL];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:[prospectData getJSONProspectData]];
    
}

-(void)deleteProspect:(ProspectData *)prospectData
{
    self.operationCode = OPERATION_DELETE_PROSPECT;
    [self.connectionHandler setUrl:[NSString stringWithFormat:DELETE_PROSPECT_URL, [[UserData sharedUserData] userId],prospectData.prospectId, @"N"]];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:nil];
}

-(void)editProspectDetails:(NSString *)prospectId forFieldName:(NSString *)fieldName withNewValue:(NSString *)newValue
{
    self.operationCode = OPERATION_EDIT_PROSPECT;
    [self.connectionHandler setUrl:[NSString stringWithFormat:EDIT_PROSPECT_DETAILS, [[UserData sharedUserData] userId],prospectId, newValue, fieldName]];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:nil];
}


#pragma mark- Prospects contacts

-(void)editProspectContactDetails:(NSString *)prospectId andContactId:(NSString *)contactId forFieldName:(NSString *)fieldName withNewValue:(NSString *)newValue
{
    self.operationCode = OPERATION_EDIT_PROSPECT_CONTACT;
    [self.connectionHandler setUrl:[NSString stringWithFormat:EDIT_PROSPECT_CONTACT_DETAILS, [[UserData sharedUserData] userId],prospectId, contactId, newValue, fieldName]];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:nil];
}

-(void)deleteContactDetails:(NSString *)contactIdId forProspect:(NSString *)prospectId
{
    self.operationCode = OPERATION_DELETE_PROSPECT_CONTACT;
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:nil];
}


#pragma mark- Prospect Business details

-(void)editProspectBusinessDetails:(NSString *)prospectId andBusinessId:(NSString *)businessId forFieldName:(NSString *)fieldName withNewValue:(NSString *)newValue
{
    self.operationCode = OPERATION_EDIT_PROSPECT_BUSINESS;
    [self.connectionHandler setUrl:[NSString stringWithFormat:EDIT_PROSPECT_BUSINESS_DETAILS, [[UserData sharedUserData] userId],prospectId, businessId, newValue, fieldName]];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:nil];
}

-(void)deleteBusinessDetails:(NSString *)BusinessDetailsId forProspect:(NSString *)prospectId
{
    self.operationCode = OPERATION_DELETE_PROSPECT_BUSINESS;
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:nil];
}

#pragma mark- Prospect Additional info

-(void)editProspectAdditionalInfoDetails:(NSString *)prospectId additionalINfoId:(NSString *)additionalInfoId forFieldName:(NSString *)fieldName withNewValue:(NSString *)newValue
{
    self.operationCode = OPERATION_EDIT_PROSPECT_ADDITIONAL_INFO;
    [self.connectionHandler setUrl:[NSString stringWithFormat:EDIT_PROSPECT_ADDITIONALINFO_DETAILS, [[UserData sharedUserData] userId] ,prospectId, additionalInfoId, newValue, fieldName]];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:nil];
}

-(void)addAdditionalInfoDetails:(ProspectAdditionalInfo *)additionalInfo ForProspect:(NSString *)prospectId
{
    self.operationCode = OPERATION_ADD_PROSPECT_ADDITIONAL_INFO;
    ProspectAdditionalInfo *info = [[ProspectAdditionalInfo alloc] init];
    info.prospectAdditionalInfoCreatedDate = [NSDate date];
    info.prospectAdditionalInfoLastUpdatedDate = [NSDate date];
    info.prospectAdditionalInformation = @"Additional information details.";
    info.prospectAdditionalInformationIsActive = @"Y";
    info.prospectAdditionalInformationTitle = @"Test";
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    [self.connectionHandler setUrl:[NSString stringWithFormat:ADD_ADDITIONAL_INFO]];
   [self.connectionHandler initiatePostRequestHandlerWithPostParameters:[jsonWriter dataWithObject:[info getAdditionalInfoDictionary]]];
}
-(void)deleteAdditionalInfo:(NSString *)additionalInfoId forProspect:(NSString *)prospectId
{
    self.operationCode = OPERATION_DELETE_PROSPECT_ADDITIONAL_INFO;
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:nil];
}

#pragma mark-Connection Delegates

-(void)didFinishSuccesfullyWithData:(NSArray *)dataArr
{
    self.arrProspects = [NSMutableArray array];
    [self praseProspectArray:dataArr];
    if([self.delegate respondsToSelector:@selector(didFinishSuccesfullyWithData:forOperation:)])
    {
        [self.delegate didFinishSuccesfullyWithData:self.arrProspects forOperation:self.operationCode];
    }
}

-(void)didFinishSuccesfullyWithDictionaryData:(NSDictionary *)data
{
    if(self.operationCode == OPERATION_ADD_PROSPECT)
    {
        if([[NSString stringWithFormat:@"%d",[[data valueForKey:@"prospectId"] intValue]] isEqualToString:@"0"])
        {
            if([self.delegate respondsToSelector:@selector(didFailWithError:)])
            {
                NSError *error = [[NSError alloc] initWithDomain:@"Prospect Addition failed" code:105 userInfo:nil];
                [self.delegate didFailWithError:error forOperation:self.operationCode];
            }
        }
        else
        {
            if([self.delegate respondsToSelector:@selector(didFinishSuccesfullyWithProspectData:forOperation:)])
            {
                [self.delegate didFinishSuccesfullyWithProspectData:[self parseProspect:data] forOperation:self.operationCode];
            }
        }
    }
    else if(self.operationCode == OPERATION_ADD_PROSPECT_BUSINESS)
    {
        
    }
    else if(self.operationCode == OPERATION_ADD_PROSPECT_ADDITIONAL_INFO)
    {
        
    }
    else if(self.operationCode == OPERATION_ADD_PROSPECT_CONTACT)
    {
        
    }
    else if(self.operationCode == OPERATION_GET_PROSPECT_DETAILS)
    {
        if([self parseProspect:data])
        {
            if([self.delegate respondsToSelector:@selector(didFinishSuccesfullyWithProspectData:forOperation:)])
            {
                [self.delegate didFinishSuccesfullyWithProspectData:[self parseProspect:data] forOperation:self.operationCode];
            }
        }
        else if([self.delegate respondsToSelector:@selector(didFailWithError:)])
        {
            NSError *error = [[NSError alloc] initWithDomain:@"Prospect Addition failed" code:105 userInfo:nil];
            [self.delegate didFailWithError:error forOperation:self.operationCode];
        }
    }
}

-(void)didFinisheSuccessfullyWithStringData:(NSString *)string
{
    if(self.operationCode == OPERATION_DELETE_PROSPECT)
    {
        if([string isEqualToString:@"true"])
        {
            if([self.delegate respondsToSelector:@selector(didFinishSuccessfullyWithStringData:forOperation:)])
           {
               [self.delegate didFinishSuccessfullyWithStringData:string forOperation:self.operationCode];
           }
        }
        else
        {
            if([self.delegate respondsToSelector:@selector(didFailWithError:)])
            {
                [self.delegate didFailWithError:nil forOperation:self.operationCode];
            }
        }
    }
    else if(self.operationCode == OPERATION_DELETE_PROSPECT_ADDITIONAL_INFO)
    {
        
    }
    else if(self.operationCode == OPERATION_DELETE_PROSPECT_BUSINESS)
    {
        
    }
    else if(self.operationCode == OPERATION_DELETE_PROSPECT_CONTACT)
    {
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Error in network connection!!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)didFailWithError:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(didFailWithError:forOperation:)])
    {
        [self.delegate didFailWithError:error forOperation:self.operationCode];
    }
}

#pragma mark- Parsers

-(void)praseProspectArray:(NSArray *)dataArr
{
    for(int i = 0; i < dataArr.count; i++)
    {
        if([[dataArr objectAtIndex:i] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *data = (NSDictionary *)[dataArr objectAtIndex:i];
            ProspectData *prospect = [self parseProspect:data];//[[ProspectData alloc] init];
            [self.arrProspects addObject:prospect];
        }
        else
        {
            self.lastDeletedRecord = [dataArr objectAtIndex:[dataArr count] -1];
        }
    }
}

-(ProspectData *)parseProspect:(NSDictionary *)data
{
    ProspectData *prosepectData = [[ProspectData alloc] init];
    prosepectData.prospectName = [data objectForKey:@"prospectFirstName"];
    if([data objectForKey:@"prospectId"] != [NSNull null])
        prosepectData.prospectId = [data objectForKey:@"prospectId"];
    
    if([data objectForKey:@"userId"] != [NSNull null])
        prosepectData.prospectUserId = [data objectForKey:@"userId"];
    
    //        if([data objectForKey:@"customerCreatedDate"] != (id)[NSNull null])
    //        {
    //            prosepectData.customerCreatedDate = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"customerCreatedDate"] longValue]];
    //        }
    //        if([data objectForKey:@"customerLastUpdatedDate"] != (id)[NSNull null])
    //            prosepectData.customerLastUpdatedDate = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"customerLastUpdatedDate"] longValue]];
    //
    //        if([data objectForKey:@"prospectCreatedDate"] != (id)[NSNull null])
    //            prosepectData.prospectCreatedDate = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"prospectCreatedDate"] longValue]];
    
    if([data objectForKey:@"prospectSource"] != [NSNull null])
        prosepectData.prospectSource = [data objectForKey:@"prospectSource"];
    
    if([data objectForKey:@"importFailureMessage"] != [NSNull null])
        prosepectData.importFailureMessage = [data objectForKey:@"importFailureMessage"];
    
    if([data valueForKey:@"prospectType"])
    {
        if([[data valueForKey:@"prospectType"] isEqualToString:@"C"])
        {
            prosepectData.prospectType = ProspectTypeC;
        }
        else if([[data valueForKey:@"prospectType"] isEqualToString:@"B"])
        {
            prosepectData.prospectType = ProspectTypeB;
        }
        else if([[data valueForKey:@"prospectType"] isEqualToString:@"O"])
        {
            prosepectData.prospectType = ProspectTypeO;
        }
    }
    if([data valueForKey:@"prospectStatusType"])
    {
        if([[data valueForKey:@"prospectStatusType"] isEqualToString:@"lead"])
        {
            prosepectData.prospectStatus = ProspectStatusLead;
        }
        else if([[data valueForKey:@"prospectStatusType"] isEqualToString:@"cold"])
        {
            prosepectData.prospectStatus = ProspectStatusCold;
        }
        else if([[data valueForKey:@"prospectStatusType"] isEqualToString:@"warm"])
        {
            prosepectData.prospectStatus = ProspectStatusWarm;
        }
        else if([[data valueForKey:@"prospectStatusType"] isEqualToString:@"hot"])
        {
            prosepectData.prospectStatus = ProspectStatusHot;
        }
        else if([[data valueForKey:@"prospectStatusType"] isEqualToString:@"customer"])
        {
            prosepectData.prospectStatus = ProspectStatusCustomer;
        }
    }
    
    prosepectData.prospectContact = [[ContactInfo alloc] init];
    if([data objectForKey:@"prospectTwitterId"] != [NSNull null])
        prosepectData.prospectContact.twitterHandle = [data objectForKey:@"prospectTwitterId"];
    
    if([data objectForKey:@"skypeId"] != [NSNull null])
        prosepectData.prospectContact.skypeId = [data objectForKey:@"skypeId"];
    
    if([data objectForKey:@"prospectFacebookId"] != [NSNull null])
        prosepectData.prospectContact.facebookId = [data objectForKey:@"prospectFacebookId"];
    
    if([data objectForKey:@"prospectLinkedinId"] != [NSNull null])
        prosepectData.prospectContact.linkedinId = [data objectForKey:@"prospectLinkedinId"];
    
    prosepectData.prospectContact.phoneNumbers = [NSMutableArray array];
    if([data objectForKey:@"prospectPhoneNo"] != [NSNull null])
        [prosepectData.prospectContact.phoneNumbers addObject:[data valueForKey:@"prospectPhoneNo"]];
    if([data objectForKey:@"prospectMobileNo"] != [NSNull null])
        [prosepectData.prospectContact.phoneNumbers addObject:[data valueForKey:@"prospectMobileNo"]];
    
    prosepectData.prospectContact.mailIds = [NSMutableArray array];
    if([data objectForKey:@"prospectMailId"] != [NSNull null])
        [prosepectData.prospectContact.mailIds addObject:[data valueForKey:@"prospectMailId"]];
    if([data objectForKey:@"prospectMailId2"] != [NSNull null])
        [prosepectData.prospectContact.mailIds addObject:[data valueForKey:@"prospectMailId2"]];
    
    prosepectData.prospectContact.address = [[Address alloc] init];
    if([data objectForKey:@"prospectAddressLine1"] != [NSNull null])
        prosepectData.prospectContact.address.addressLine1 = [data valueForKey:@"prospectAddressLine1"];
    
    if([data objectForKey:@"prospectAddressLine2"] != [NSNull null])
        prosepectData.prospectContact.address.addressLine2 = [data valueForKey:@"prospectAddressLine2"];
    
    if([data objectForKey:@"prospectCity"] != [NSNull null])
        prosepectData.prospectContact.address.city = [data valueForKey:@"prospectCity"];
    
    if([data objectForKey:@"prospectState"] != [NSNull null])
        prosepectData.prospectContact.address.state = [data valueForKey:@"prospectState"];
    
    if([data objectForKey:@"prospectZipCode"] != [NSNull null])
        prosepectData.prospectContact.address.zipCode = [data valueForKey:@"prospectZipCode"];
    
    if([data objectForKey:@"prospectGeoLongitude"] != [NSNull null])
        prosepectData.prospectContact.address.longitude = [[data valueForKey:@"prospectGeoLongitude"] intValue];
    
    if([data objectForKey:@"prospectGeoLatitude"] != [NSNull null])
        prosepectData.prospectContact.address.latitude = [[data valueForKey:@"prospectGeoLatitude"] intValue];
    
    if([data objectForKey:@"prospectContacts"] != (id)[NSNull null])
    {
        prosepectData.prospectContacts = [NSMutableArray array];
        NSArray *arr = [data objectForKey:@"prospectContacts"];
        for(NSDictionary *dict in arr)
        {
            ProspectContacts *contact = [[ProspectContacts alloc] init];
            contact.contactAge = [dict valueForKey:@"contactAge"];
            if([dict objectForKey:@"contactCreatedDate"] != (id)[NSNull null])
                contact.contactCreatedDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"contactCreatedDate"] longValue]];
            
            //                if([dict objectForKey:@"contactDob"] != (id)[NSNull null])
            //                    contact.contactDob = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"contactDob"] longValue]];
            _prospect.prospectName = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"contactFirstName"], [dict valueForKey:@"contactLastName"]];
            
            contact.contactFirstName = [dict valueForKey:@"contactFirstName"];
            contact.contactGender = [dict valueForKey:@"contactGender"];
            contact.contactHomeValue = [dict valueForKey:@"contactHomeValue"];
            contact.contactIncome = [dict valueForKey:@"contactIncomes"];
            contact.contactIsActive = [dict valueForKey:@"contactIsActive"];
            contact.contactIsPrimary = [dict valueForKey:@"contactIsPrimary"];
            contact.contactLastName = [dict valueForKey:@"contactLastName"];
            if([dict objectForKey:@"contactLastUpdatedDate"] != (id)[NSNull null])
                contact.contactLastUpdatedDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"contactLastUpdatedDate"] longValue]];
            contact.contactLengthAtResidence = [dict valueForKey:@"contactLengthAtResidence"];
            contact.contactMailId = [dict valueForKey:@"contactMailId"];
            contact.contactMailId2 = [dict valueForKey:@"contactMailId2"];
            contact.contactMaritalStatus = [dict valueForKey:@"contactMaritalStatus"];
            contact.contactMobileNo = [dict valueForKey:@"contactMobileNo"];
            contact.contactPhoneNo = [dict valueForKey:@"contactPhoneNo"];
            contact.contactTitle = [dict valueForKey:@"contactTitle"];
            contact.contactWebUrl = [dict valueForKey:@"contactWebUrl"];
            contact.contactId = [dict valueForKey:@"contactId"];
            [prosepectData.prospectContacts addObject:contact];
        }
    }
    
    
    if([data objectForKey:@"prospectAppointments"] != (id)[NSNull null])
        prosepectData.prospectAppointments = [NSMutableArray arrayWithArray:[data valueForKey:@"prospectAppointments"]];
    
    if([data objectForKey:@"userActivities"] != (id)[NSNull null])
        prosepectData.userActivities = [NSMutableArray arrayWithArray:[data valueForKey:@"userActivities"]];
    
    if([data objectForKey:@"prospectNoteDTO"] != (id)[NSNull null])
        prosepectData.prospectNoteDTO = [NSMutableArray arrayWithArray:[data valueForKey:@"prospectNoteDTO"]];
    
    if([data objectForKey:@"prospectAdditionalInfo"] != (id)[NSNull null])
    {
        prosepectData.prospectAdditionalInfo = [NSMutableArray array];
        NSArray *arr = [data valueForKey:@"prospectAdditionalInfo"];
        for (NSDictionary *dict in arr)
        {
            ProspectAdditionalInfo *additionalInfo = [[ProspectAdditionalInfo alloc] init];
            if([dict objectForKey:@"prospectAdditionalInfoCreatedDate"] != (id)[NSNull null])
                additionalInfo.prospectAdditionalInfoCreatedDate  = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"prospectAdditionalInfoCreatedDate"] longValue]];
            
            if([dict objectForKey:@"prospectAdditionalInfoLastUpdatedDate"] != (id)[NSNull null])
                additionalInfo.prospectAdditionalInfoLastUpdatedDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"prospectAdditionalInfoLastUpdatedDate"] longValue]];
            
            additionalInfo.prospectAdditionalInformation = [dict valueForKey:@"prospectAdditionalInformation"];
            additionalInfo.prospectAdditionalInformationIsActive = [dict valueForKey:@"prospectAdditionalInformationIsActive"];
            additionalInfo.prospectAdditionalInformationTitle = [dict valueForKey:@"prospectAdditionalInformationTitle"];
            
            [prosepectData.prospectAdditionalInfo addObject:additionalInfo];
        }
    }
    if([data objectForKey:@"prospectTasks"] != (id)[NSNull null])
        prosepectData.prospectTasks = [NSMutableArray arrayWithArray:[data valueForKey:@"prospectTasks"]];
    
    if([data objectForKey:@"addFailureMessages"] != (id)[NSNull null])
        prosepectData.addFailureMessages = [NSMutableArray arrayWithArray:[data valueForKey:@"addFailureMessages"]];
    
    if([data objectForKey:@"prospectTags"] != (id)[NSNull null])
        prosepectData.prospectTags = [NSMutableArray arrayWithArray:[data valueForKey:@"prospectTags"]];
    
    if([data objectForKey:@"businessDetail"] != (id)[NSNull null])
    {
        NSDictionary *dict = [data objectForKey:@"businessDetail"];
        ProspectBusinessDetail *business = [[ProspectBusinessDetail alloc] init];
        business.businessCreditProfile = [dict valueForKey:@"businessCreditProfile"];
        business.businessEmployeeSize = [dict valueForKey:@"businessEmployeeSize"];
        if([dict objectForKey:@"businessLastUpdatedDate"] != (id)[NSNull null])
            business.businessLastUpdatedDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"businessLastUpdatedDate"] longValue]];
        
        if([dict objectForKey:@"businessCreatedDate"] != (id)[NSNull null])
            business.businessCreatedDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"businessCreatedDate"] longValue]];
        business.businessName = [dict valueForKey:@"businessName"];
        business.businessPrimaryLineOfBusiness = [dict valueForKey:@"businessPrimaryLineOfBusiness"];
        business.businessPrimarySIC = [dict valueForKey:@"businessPrimarySIC"];
        business.businessSalesVolume = [dict valueForKey:@"businessSalesVolume"];
        business.businessWebUrl = [dict valueForKey:@"businessWebUrl"];
        business.businessYearEstablished = [dict valueForKey:@"businessYearEstablished"];
        [prosepectData setProspectBusinessDetails:business];
    }
    return prosepectData;
}


-(void)syncProspectsWithAddressBook:(NSArray *)arrProspects
{
    for (ProspectData *prospect in arrProspects)
    {
        [prospect syncContactWithAddressBook];
    }
}

@end
