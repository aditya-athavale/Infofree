//
//  TasksData.m
//  InfoFreeNew
//
//  Created by Aditya Athvale on 11/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "TasksData.h"

@implementation TasksData

-(NSDictionary *)getTasksDictionary
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:
                          [NSArray arrayWithObjects:self.userId, self.prospectId, /*self.prospectName, self.prospectType,*/ self.userTask, /*[self getFormattedDate:[NSDate date]],*/ [self getFormattedDate:[NSDate date]], /*self.userTaskId,*/ self.userTaskIsActive, self.userTaskIsComplete, self.userTaskTitle, nil]
                                                     forKeys:[NSArray arrayWithObjects:@"userId", @"prospectId", /*@"prospectName", @"prospectType",*/ @"userTask", /*@"userTaskCompleteDate",*/ @"userTaskDueDate", /*@"userTaskId",*/ @"userTaskIsActive", @"userTaskIsComplete", @"userTaskTitle", nil]];
    return dict;
}

-(NSString *)getFormattedDate :(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}




@end
