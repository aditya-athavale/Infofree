//
//  AppointmentsData.m
//  InfoFreeNew
//
//  Created by Aditya Athvale on 11/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "AppointmentsData.h"
#import "UserData.h"

@implementation AppointmentsData

-(AppointmentsData *)init
{
    self = [super init];
    if(self)
    {
        self.userId = [[UserData sharedUserData] userId];
        self.userAppointmentIsActive = @"Y";
        self.userAppointmentLocation = @"";
        self.userAppointmentDescription = @"";
        self.userAppointmentTitle = @"";
        self.attendees = [NSMutableArray array];
    }
    return self;
}


-(NSDictionary *)getAppointmentsDictionary
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:
                          [NSArray arrayWithObjects:self.userId, self.userAppointmentDescription, self.userAppointmentIsActive, self.userAppointmentLocation, self.userAppointmentTitle, [self getFormattedDate:self.userAppointmentStartDate], [self getFormattedDate:[self userAppointmentEndDate]], self.attendees, nil]
                                                     forKeys:[NSArray arrayWithObjects:@"userId", @"userAppointmentDescription", @"userAppointmentIsActive", @"userAppointmentLocation", @"userAppointmentTitle", @"userAppointmentStartDate", @"userAppointmentEndDate", @"attendees", nil]];
    return dict;
}

-(NSString *)getFormattedDate :(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}


@end
