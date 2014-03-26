//
//  CalendarNetworkHandler.h
//  InfoFreeNew
//
//  Created by Aditya Athvale on 11/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BasicConnectionHandler.h"
#import "AppointmentsData.h"
#import "TasksData.h"
#import "Constants.h"

@protocol CalendarConnectionDelegate <NSObject>

-(void)didFinishSuccesfullyWithCalendarData:(NSArray *)data forOperation:(int)operationCode;
- (void)didFailWithError:(NSError *)error forOperation:(int)operationCode;

@optional

-(void)didFinishSuccessfullyWithAppointmentData:(AppointmentsData *)data forOperation:(int)operationCode;
-(void)didFinishSuccessfullyWithTaskData:(TasksData *)data forOperation:(int)operationCode;
-(void)didFinishSuccessfullyWithStringData:(NSString *)data forOperation:(int)operationCode;

@end


typedef enum
{
    OPERATION_GET_APPOINTMENT_LIST,
    OPERATION_GET_TASK_LIST,
    
    OPERATION_ADD_TASK,
    OPERATION_ADD_APPOINTMENT,
    
    OPERATION_DELETE_TASK,
    OPERATION_DELETE_APPOINTMENT,
    
    OPERATION_EDIT_TASK,
    OPERATION_EDIT_APPOINTMENT,
    
    OPERATION_MARK_TASK_AS_COMPLETE,
    OPERATION_MARK_TASK_AS_INCOMPELTE,
}CalendarOperation;

@interface CalendarNetworkHandler : NSObject <BasicConnectionDelegate>

@property(nonatomic, strong) NSMutableArray *arrData;
@property(nonatomic, strong) BasicConnectionHandler *connectionHandler;
@property(nonatomic, weak)NSObject<CalendarConnectionDelegate> *delegate;

//+(CalendarNetworkHandler *)getSharedCalendarNetworkHandler;

-(void)getAppointmentsListForUser:(NSString *)userId;
-(void)getTasksListforUser:(NSString *)userId andPageNo:(int)pageNo;

-(void)addAppointment:(AppointmentsData *)appointment;
-(void)addTask:(TasksData *)appointment;

-(void)markTaskAsComplete:(NSString *)taskId;
-(void)markTaskAsIncomplete:(NSString *)taskId;

-(void)deleteTask:(NSString *)taskId;
-(void)deleteAppointment:(NSString *)appointmentId;
@end
