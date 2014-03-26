//
//  FilterView.h
//  InfoFree
//
//  Created by Aditya Athvale on 27/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterView : UIView //<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIView *leadsAdded, *location, *status;
    IBOutlet UITableView *tagsTable;
}
@end
