//
//  CalendarNetworkHandler.m
//  InfoFreeNew
//
//  Created by Aditya Athvale on 11/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "CalendarNetworkHandler.h"
#import "UserData.h"

@interface CalendarNetworkHandler ()

@property(nonatomic)CalendarOperation operation;
//@property(nonatomic, strong) NSMutableArray *arrData;
//@property(nonatomic, strong) BasicConnectionHandler *connectionHandler;

@end


@implementation CalendarNetworkHandler

CalendarNetworkHandler *sharedCalendarNetworkHandler;

//+(CalendarNetworkHandler *)getSharedCalendarNetworkHandler
//{
//    if(!sharedCalendarNetworkHandler)
//    {
//        sharedCalendarNetworkHandler = [[CalendarNetworkHandler alloc] init];
//        sharedCalendarNetworkHandler.arrData = [[NSMutableArray alloc] init];
//        sharedCalendarNetworkHandler.connectionHandler = [[BasicConnectionHandler alloc] init];
//        [sharedCalendarNetworkHandler.connectionHandler setDelegate:sharedCalendarNetworkHandler];
//    }
//    return sharedCalendarNetworkHandler;
//}

-(CalendarNetworkHandler *)init
{
    self = [super init];
    if(self)
    {
        self.connectionHandler = [[BasicConnectionHandler alloc] init];
        self.arrData = [NSMutableArray array];
    }
    return self;
}

#pragma mark-Connection Delegates

-(void)didFinishSuccesfullyWithData:(NSArray *)dataArr
{
    if(self.operation == OPERATION_GET_TASK_LIST)
    {
        for (NSDictionary *dict in dataArr)
        {
            [self parseTask:dict];
        }
    }
    else if(self.operation == OPERATION_GET_APPOINTMENT_LIST)
    {
        for (NSDictionary *dict in dataArr)
        {
            [self parseAppointment:dict];
        }
    }
    if([self.delegate respondsToSelector:@selector(didFinishSuccesfullyWithCalendarData:forOperation:)])
    {
        [self.delegate didFinishSuccesfullyWithCalendarData:self.arrData forOperation:self.operation];
    }
}

-(void)didFinishSuccesfullyWithDictionaryData:(NSDictionary *)data
{
    if(self.operation == OPERATION_ADD_TASK)
    {
        [self parseTask:data];
        TasksData *appt = (TasksData *)[self.arrData objectAtIndex:0];
        if([appt.userTaskId intValue] != 0)
        {
            if([self.delegate respondsToSelector:@selector(didFinishSuccessfullyWithTaskData:forOperation:)])
            {
                [self.delegate didFinishSuccessfullyWithTaskData:appt forOperation:self.operation];
            }
        }
        else
        {
            if([self.delegate respondsToSelector:@selector(didFailWithError:forOperation:)])
            {
                [self.delegate didFailWithError:[NSError errorWithDomain:@"User Error" code:100 userInfo:nil] forOperation:self.operation];
            }
        }
    }
    else if(self.operation == OPERATION_ADD_APPOINTMENT)
    {
        [self parseAppointment:data];
        AppointmentsData *appt = (AppointmentsData *)[self.arrData objectAtIndex:0];
        if([appt.userAppointmentId intValue] != 0)
        {
            if([self.delegate respondsToSelector:@selector(didFinishSuccessfullyWithAppointmentData:forOperation:)])
            {
                [self.delegate didFinishSuccessfullyWithAppointmentData:appt forOperation:self.operation];
            }
        }
        else
        {
            if([self.delegate respondsToSelector:@selector(didFailWithError:forOperation:)])
            {
                [self.delegate didFailWithError:[NSError errorWithDomain:@"User Error" code:100 userInfo:nil] forOperation:self.operation];
            }
        }
    }
    else if(self.operation == OPERATION_DELETE_APPOINTMENT)
    {
        if([self.delegate respondsToSelector:@selector(didFinishSuccessfullyWithAppointmentData:forOperation:)])
        {
            [self.delegate didFinishSuccessfullyWithAppointmentData:nil forOperation:self.operation];
        }
    }
}

-(void)didFinisheSuccessfullyWithStringData:(NSString *)string
{
    if(self.operation == OPERATION_DELETE_TASK || self.operation == OPERATION_MARK_TASK_AS_COMPLETE || self.operation == OPERATION_MARK_TASK_AS_INCOMPELTE)
    {
        if([string isEqualToString:@"1"])
        {
            if([self.delegate respondsToSelector:@selector(didFinisheSuccessfullyWithStringData:)])
            {
                [self.delegate didFinishSuccessfullyWithStringData:string forOperation:self.operation];
            }
        }
        else
        {
            if([self.delegate respondsToSelector:@selector(didFailWithError:forOperation:)])
            {
                [self.delegate didFailWithError:nil forOperation:self.operation];
            }
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(didFailWithError:forOperation:)])
        {
            [self.delegate didFailWithError:nil forOperation:self.operation];
        }
    }
}

-(void)didFailWithError:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(didFailWithError:forOperation:)])
    {
        [self.delegate didFailWithError:error forOperation:self.operation];
    }
}

#pragma mark- Appointments

-(void)getAppointmentsListForUser:(NSString *)userId
{
    self.operation = OPERATION_GET_APPOINTMENT_LIST;
    [self.connectionHandler setUrl:[NSString stringWithFormat:FETCH_APPOINTMENTS_URL, userId]];
    [self.connectionHandler setDelegate:self];
    [self.connectionHandler initiateGetRequestHandler];
}

-(void)addAppointment:(AppointmentsData *)appointment
{
//    appointment.userId = @"2";
    appointment.userId = [[UserData sharedUserData] userId];
    
    self.operation = OPERATION_ADD_APPOINTMENT;
    
    NSDictionary *dict = [appointment getAppointmentsDictionary];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    
   // NSString *str = [jsonWriter stringWithObject:dict];
   // NSLog(@"Calendar JSON %@",str);
    
    NSData *requestData = [jsonWriter dataWithObject:dict];
    
    [self.connectionHandler setDelegate:self];
    [self.connectionHandler setUrl:[NSString stringWithFormat:ADD_APPOINTMENT_URL]];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:requestData];
}

-(void)deleteAppointment:(NSString *)appointmentId
{
    self.operation = OPERATION_DELETE_APPOINTMENT;
    [self.connectionHandler setUrl:[NSString stringWithFormat:DELETE_APPOINTMENT_URL]];
     [self.connectionHandler setDelegate:self];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:appointmentId forKey:@"userAppointmentId"];
    [dict setValue:[[UserData sharedUserData] userId] forKey:@"userId"];
    
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:[writer dataWithObject:dict]];
}


-(void)parseAppointment:(NSDictionary *)dict
{
    AppointmentsData *appointment = [[AppointmentsData alloc] init];
    
    appointment.userId = [dict valueForKey:@"userId"];
    appointment.userAppointmentDescription = [dict valueForKey:@"userAppointmentDescription"];
    appointment.userAppointmentId = [dict valueForKey:@"userAppointmentId"];
    appointment.userAppointmentIsActive = [dict valueForKey:@"userAppointmentIsActive"];
    appointment.userAppointmentLocation = [dict valueForKey:@"userAppointmentLocation"];
    appointment.userAppointmentTitle = [dict valueForKey:@"userAppointmentTitle"];
    appointment.attendees = [dict valueForKey:@"attendees"];
    
    NSLog(@"End Date: %f", [[dict valueForKey:@"userAppointmentEndDate"] doubleValue]);
    NSLog(@"Start Date: %f", [[dict valueForKey:@"userAppointmentStartDate"] doubleValue]);
    
    if([dict objectForKey:@"userAppointmentEndDate"] != [NSNull null])
        appointment.userAppointmentEndDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"userAppointmentEndDate"] doubleValue]/1000];
    
    if([dict objectForKey:@"userAppointmentStartDate"] != [NSNull null])
        appointment.userAppointmentStartDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"userAppointmentStartDate"] doubleValue]/1000];
    if(!self.arrData)
        self.arrData = [[NSMutableArray alloc] init];
    [self.arrData addObject:appointment];

}

#pragma mark- Tasks

-(void)getTasksListforUser:(NSString *)userId andPageNo:(int)pageNo
{
    self.operation = OPERATION_GET_TASK_LIST;
    if(self.connectionHandler)
    {
        [self.connectionHandler setDelegate:self];
        [self.connectionHandler setUrl:[NSString stringWithFormat:FETCH_TASKS_URL, userId, 0]];
        [self.connectionHandler initiateGetRequestHandler];
    }
}

-(void)addTask:(TasksData *)appointment
{
    TasksData *task = [[TasksData alloc] init];
    task.userId = [[UserData sharedUserData] userId];
    task.userTask = @"test Task";
    //task.userTaskCompleteDate = [NSDate date];
    task.userTaskDueDate = [NSDate date];
    //task.userTaskId = @"1";
    task.userTaskIsActive = @"Y";
    task.userTaskIsComplete = @"Y";
    task.userTaskTitle = @"Title";
    
    task.prospectId = @"202";
    //task.prospectName = @"Aditya";
    //task.prospectType = @"lead";
    
    self.operation = OPERATION_ADD_TASK;
    
    NSDictionary *dict = [task getTasksDictionary];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    
    NSLog(@"Task Data sent: %@",[jsonWriter stringWithObject:dict]);
    
    NSData *requestData = [jsonWriter dataWithObject:dict];
    [self.connectionHandler setDelegate:self];
    [self.connectionHandler setUrl:[NSString stringWithFormat:ADD_TASK_URL]];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:requestData];
}

-(void)markTaskAsComplete:(NSString *)taskId
{
    self.operation = OPERATION_MARK_TASK_AS_COMPLETE;
    
    [self.connectionHandler setDelegate:self];
    [self.connectionHandler setUrl:[NSString stringWithFormat:MARK_TASK_AS_COMPLETE_URL, taskId]];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:nil];
}

-(void)markTaskAsIncomplete:(NSString *)taskId
{
    self.operation = OPERATION_MARK_TASK_AS_INCOMPELTE;
    
    [self.connectionHandler setDelegate:self];
    [self.connectionHandler setUrl:[NSString stringWithFormat:MARK_TASK_AS_UNCOMPLETE_URL, taskId]];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:nil];
}

-(void)deleteTask:(NSString *)taskId
{
    self.operation = OPERATION_DELETE_TASK;
    
    [self.connectionHandler setDelegate:self];
    [self.connectionHandler setUrl:[NSString stringWithFormat:DELETE_TASK_URL, taskId]];
    [self.connectionHandler initiatePostRequestHandlerWithPostParameters:nil];
}

-(void)parseTask:(NSDictionary *)dict
{
    TasksData *task = [[TasksData alloc] init];
    
    task.userId = [dict valueForKey:@"userId"];
    task.prospectId = [dict valueForKey:@"prospectId"];
    task.prospectName = [dict valueForKey:@"prospectName"];
    task.prospectType = [dict valueForKey:@"prospectType"];
    task.userTask = [dict valueForKey:@"userTask"];
    task.userTaskId = [dict valueForKey:@"userTaskId"];
    task.userTaskIsActive = [dict valueForKey:@"userTaskIsActive"];
    task.userTaskIsComplete = [dict valueForKey:@"userTaskIsComplete"];
    task.userTaskTitle = [dict valueForKey:@"userTaskTitle"];
    
    if([dict objectForKey:@"userTaskDueDate"] != [NSNull null])
        task.userTaskDueDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"userTaskDueDate"] longValue]];
    
    if([dict objectForKey:@"userTaskCompleteDate"] != [NSNull null])
        task.userTaskCompleteDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"userTaskCompleteDate"] longValue]];
    if(!self.arrData)
        self.arrData = [[NSMutableArray alloc] init];
    
    [self.arrData addObject:task];
}

@end
