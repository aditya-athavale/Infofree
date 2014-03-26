//
//  ProspectsViewController.h
//  InfoFree
//
//  Created by Aditya Athvale on 25/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProspectsHandler.h"
#import "ProspectDetailsViewController.h"
#import <MapKit/MapKit.h>
#import "myAnnotation.h"

@interface ProspectsViewController : UIViewController <ProspectConnectionDelegate, UITableViewDataSource, UITableViewDelegate>
{
    ProspectsHandler *handler;
    NSMutableArray *arrProspects;
    IBOutlet UITableView *table;
    BOOL isGoingfromTable;
    
    IBOutlet MKMapView *mapView;
}

-(IBAction)syncProspectsWithAddressBookPressed:(id)sender;

@end
