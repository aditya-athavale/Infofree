//
//  AppointmentsData.h
//  InfoFreeNew
//
//  Created by Aditya Athvale on 11/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointmentsData : NSObject

@property(nonatomic, strong) NSString *userAppointmentDescription, *userAppointmentId, *userAppointmentIsActive, *userAppointmentLocation, *userAppointmentTitle, *prospectType, *userId;

@property(nonatomic, strong) NSDate *userAppointmentStartDate, *userAppointmentEndDate;

@property(nonatomic, strong) NSMutableArray *attendees;

-(NSDictionary *)getAppointmentsDictionary;

@end
