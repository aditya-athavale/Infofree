//
//  AddAppointmentsViewController.h
//  InfoFreeNew
//
//  Created by Aditya Athvale on 20/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarNetworkHandler.h"
#import "CalendarIntegrationHandler.h"

@interface AddAppointmentsViewController : UIViewController <CalendarConnectionDelegate, CalendarIntegrationDelegate, UITableViewDataSource, UITableViewDelegate>

@end
