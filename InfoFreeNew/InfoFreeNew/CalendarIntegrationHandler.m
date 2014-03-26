//
//  CalendarIntegrationHandler.m
//  InfoFreeNew
//
//  Created by Aditya Athvale on 11/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "CalendarIntegrationHandler.h"
#import "AppointmentsData.h"


@interface CalendarIntegrationHandler()

@property(nonatomic, strong)EKEventStore *eventStore;
@property(nonatomic) BOOL calendarAccess;

@end

@implementation CalendarIntegrationHandler

-(void)addEventsListToCalendar:(NSArray *)eventsList
{
    for(NSDictionary *dict in eventsList)
    {
        [self addEventToCalendar:dict];
    }
}


-(void)addEventToCalendar:(NSDictionary *)dictNew
{
    for(EKEvent *event in [self eventsListFromLocalCalendar])
    {
        if([event.startDate isEqualToDate:[dictNew objectForKey:@"userAppointmentStartDate"]])
        {
            if([event.endDate isEqualToDate:[dictNew objectForKey:@"userAppointmentEndDate"]])
            {
                if([event.title isEqualToString:[dictNew valueForKey:@"userAppointmentTitle"]])
                {
                    NSLog(@"Appintment Exists!!");
                    return;
                }
            }
        }
    }
 
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    __block BOOL isSuccess;
    
    if(!self.calendarAccess)
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             if (error)
             {
                 NSLog(@"No Calendar Access");
             }
             else if (!granted)
             {
                 NSLog(@"No Calendar Access");
             }
             else
             {
                 self.calendarAccess =YES;
                 EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                 event.title=[dictNew objectForKey:@"userAppointmentTitle"];
                 event.location=[dictNew objectForKey:@"userAppointmentLocation"];
                 event.startDate =/*[self convertTimeStampToDate:*/[dictNew objectForKey:@"userAppointmentStartDate"];//];
                 event.endDate= /*[self convertTimeStampToDate:*/[dictNew objectForKey:@"userAppointmentEndDate"];//];
                 
                 [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                 NSError *err;
                 
                 NSLog(@"%@",dictNew);
                 
                 isSuccess = [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                 if(isSuccess)
                 {
                     if([self.delegate respondsToSelector:@selector(addEventFinishedSuccessfully)])
                     {
                         [self.delegate addEventFinishedSuccessfully];
                     }
                 }
                 else
                 {
                     NSLog(@"Error Adding event to calendar: %@",err);
                     if([self.delegate respondsToSelector:@selector(operationFailed)])
                     {
                         [self.delegate operationFailed];
                     }
                 }
             }
         }];
    }
    else
    {
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        event.title=[dictNew objectForKey:@"userAppointmentTitle"];
        event.location=[dictNew objectForKey:@"userAppointmentLocation"];
        event.startDate =/*[self convertTimeStampToDate:*/[dictNew objectForKey:@"userAppointmentStartDate"];//];
        event.endDate= /*[self convertTimeStampToDate:*/[dictNew objectForKey:@"userAppointmentEndDate"];//];

        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
        NSError *err;
        isSuccess = [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        if(isSuccess)
        {
            if([self.delegate respondsToSelector:@selector(addEventFinishedSuccessfully)])
            {
                [self.delegate addEventFinishedSuccessfully];
            }
        }
        else
        {
            if([self.delegate respondsToSelector:@selector(operationFailed)])
            {
                [self.delegate operationFailed];
            }
        }
    }
}


-(void)deleteEvent:(NSString *)eventId
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];

    NSPredicate *predicateForEvents = [eventStore predicateForEventsWithStartDate:[NSDate date] endDate:[[NSDate date] dateByAddingTimeInterval:3600] calendars:[NSArray arrayWithObject:[eventStore defaultCalendarForNewEvents]]];
    
    NSArray *events_Array = [eventStore eventsMatchingPredicate: predicateForEvents];
    //get array of events from the eventStore
    BOOL success;
    for (EKEvent *eventToCheck in events_Array)
    {
        if( [eventToCheck.title isEqualToString: @"Title"] || [eventToCheck.eventIdentifier isEqualToString:eventId])
        {
            NSError *err;
            success = [eventStore removeEvent:eventToCheck span:EKSpanThisEvent error:&err];
            break;
            
        }
    }
    if(success)
    {
        if([self.delegate respondsToSelector:@selector(deleteEventFinishedSuccessfully)])
        {
            [self.delegate deleteEventFinishedSuccessfully];
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(operationFailed)])
        {
            [self.delegate operationFailed];
        }
    }
}

-(NSDate*)convertTimeStampToDate:(NSString*)str{
    //NSInteger inter = [nsinte]
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:([str integerValue]/1000)];
    NSLog(@"date is: %@",date);
    return date;
}

-(EKEventEditViewController *)editEventFromCalendar:(NSString *)eventId
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    
    addController.eventStore = eventStore;
    addController.event= [eventStore eventWithIdentifier:eventId];
    addController.editViewDelegate = self;
    return addController;
}

-(void)getEventList
{
    
    NSArray *events = [self eventsListFromLocalCalendar];
    
    if(events && events.count > 0)
    {
        if([self.delegate respondsToSelector:@selector(getEventListFinishedSuccessfullyWithList:)])
        {
            [self.delegate getEventListFinishedSuccessfullyWithList:events];
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(operationFailed)])
        {
            [self.delegate operationFailed];
        }
    }
}


-(NSArray *)eventsListFromLocalCalendar
{
    EKEventStore *store = [[EKEventStore alloc] init];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create the start date components
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -10;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    
    // Create the end date components
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                            endDate:oneYearFromNow
                                                          calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [store eventsMatchingPredicate:predicate];
    return events;
}

#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
		  didCompleteWithAction:(EKEventEditViewAction)action
{
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller
{
    return nil;
}


@end
