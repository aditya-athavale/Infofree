//
//  ProspectsHandler.h
//  InfoFree
//
//  Created by Aditya Athvale on 25/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicConnectionHandler.h"
#import "ProspectData.h"
#import "UserData.h"
#import "SBJson.h"

typedef enum operation
{
    OPERATION_GET_PROSPECT_LIST,
    OPERATION_GET_PROSPECT_DETAILS,
    
    OPERATION_ADD_PROSPECT,
    OPERATION_DELETE_PROSPECT,
    OPERATION_EDIT_PROSPECT,
    
    OPERATION_EDIT_PROSPECT_CONTACT,
    OPERATION_EDIT_PROSPECT_BUSINESS,
    OPERATION_EDIT_PROSPECT_ADDITIONAL_INFO,
    
    OPERATION_ADD_PROSPECT_BUSINESS,
    OPERATION_ADD_PROSPECT_ADDITIONAL_INFO,
    OPERATION_ADD_PROSPECT_CONTACT,

    OPERATION_DELETE_PROSPECT_BUSINESS,
    OPERATION_DELETE_PROSPECT_ADDITIONAL_INFO,
    OPERATION_DELETE_PROSPECT_CONTACT,
    
}Operation;

@protocol ProspectConnectionDelegate <NSObject>

-(void)didFinishSuccesfullyWithData:(NSArray *)data forOperation:(int)operationCode;
-(void)didFinishSuccesfullyWithProspectData:(ProspectData *)data forOperation:(int)operationCode;
-(void)didFinishSuccessfullyWithStringData:(NSString *)data forOperation:(int)operationCode;
- (void)didFailWithError:(NSError *)error forOperation:(int)operationCode;

@end


@interface ProspectsHandler : NSObject <BasicConnectionDelegate>

@property (nonatomic, strong) id <ProspectConnectionDelegate> delegate;
@property(nonatomic) BOOL useFilters;
@property(nonatomic) int pageCount, startindex;
@property(nonatomic, strong)NSMutableArray *arrTags;
@property(nonatomic, strong)NSString *address;
@property(nonatomic, strong)NSString *lead;
@property(nonatomic, strong)NSString *status;
@property(nonatomic, strong)NSString *lastDeletedRecord;
@property(nonatomic, strong) BasicConnectionHandler *connectionHandler;

@property(nonatomic)int flag;


//+(ProspectsHandler *)getSharedProspectsHandler;
-(void)getProspectList;
-(void)addProspect:(ProspectData *)prospectData;
-(void)deleteProspect:(ProspectData *)prospectData;
-(void)getProspectDetails:(NSString *)prospectId;

-(void)syncProspectsWithAddressBook:(NSArray *)arrProspects;

-(void)editProspectDetails:(NSString *)prospectId forFieldName:(NSString *)fieldName withNewValue:(NSString *)newValuel;
-(void)editProspectContactDetails:(NSString *)prospectId andContactId:(NSString *)contactId forFieldName:(NSString *)fieldName withNewValue:(NSString *)newValue;
-(void)editProspectBusinessDetails:(NSString *)prospectId andBusinessId:(NSString *)businessId forFieldName:(NSString *)fieldName withNewValue:(NSString *)newValue;
-(void)editProspectAdditionalInfoDetails:(NSString *)prospectId additionalINfoId:(NSString *)additionalInfoId forFieldName:(NSString *)fieldName withNewValue:(NSString *)newValue;

-(void)addAdditionalInfoDetails:(ProspectAdditionalInfo *)additionalInfo ForProspect:(NSString *)prospectId;

@end
