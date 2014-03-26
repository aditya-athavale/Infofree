//
//  CalendarIntegrationHandler.h
//  InfoFreeNew
//
//  Created by Aditya Athvale on 11/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@protocol CalendarIntegrationDelegate <NSObject>

@optional

-(void)addEventFinishedSuccessfully;
-(void)deleteEventFinishedSuccessfully;
-(void)getEventListFinishedSuccessfullyWithList:(NSArray *)events;
-(void)operationFailed;

@end



@interface CalendarIntegrationHandler : NSObject <EKEventEditViewDelegate>

@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;

@property (nonatomic, weak)NSObject <CalendarIntegrationDelegate> *delegate;


-(void)addEventToCalendar:(NSDictionary *)dict;
-(void)deleteEvent:(NSString *)eventId;
-(void)getEventList;
-(void)addEventsListToCalendar:(NSArray *)eventsList;



@end
