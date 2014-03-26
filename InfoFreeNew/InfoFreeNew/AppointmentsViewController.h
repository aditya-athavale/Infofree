//
//  AppointmentsViewController.h
//  InfoFreeNew
//
//  Created by Aditya Athvale on 11/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarNetworkHandler.h"
#import "CalendarIntegrationHandler.h"

@interface AppointmentsViewController : UIViewController <CalendarConnectionDelegate, UITableViewDelegate, UITableViewDataSource, CalendarIntegrationDelegate>
{
    IBOutlet UITableView *table;
    NSMutableArray *arrData;
}
@end
