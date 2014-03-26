//
//  TasksData.h
//  InfoFreeNew
//
//  Created by Aditya Athvale on 11/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TasksData : NSObject

@property(nonatomic, strong)NSString *prospectId, *prospectName, *prospectType, *userId, *userTask, *userTaskId, *userTaskIsActive, *userTaskIsComplete, *userTaskTitle;

@property(nonatomic, strong)NSDate *userTaskCompleteDate, *userTaskDueDate;

-(NSDictionary *)getTasksDictionary;

@end
