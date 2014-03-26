//
//  TasksViewController.h
//  InfoFreeNew
//
//  Created by Aditya Athvale on 11/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarNetworkHandler.h"
#import "TasksData.h"

@interface TasksViewController : UIViewController <CalendarConnectionDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *table;
    NSMutableArray *arrData;
}


@end
