//
//  AppointmentsViewController.m
//  InfoFreeNew
//
//  Created by Aditya Athvale on 11/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "AppointmentsViewController.h"
#import "AppointmentsCell.h"

@interface AppointmentsViewController ()

@property(nonatomic, strong)CalendarNetworkHandler *calendarNetworkHandler;
@property(nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation AppointmentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrData = [[NSMutableArray alloc] init];
   
    
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"01_offline" ofType:@"html" inDirectory:@""];
    
    NSURL *url = [NSURL URLWithString:strPath];
    NSData *htmlData = [NSData dataWithContentsOfFile:strPath];
    
    NSLog(@"%@",htmlData);

    
    
   NSLog(@"\n\n ******************************************** \n\n%@\n\n",url);
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
//    [self.webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];

    
    
//    NSURL *url = [NSURL fileURLWithPath:strPath];
//    NSLog(@"Printing file path: %@ %@",strPath,url);
//    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//
    //[self.calendarNetworkHandler.connectionHandler setDelegate:sharedCalendarNetworkHandler];
//    CalendarIntegrationHandler *integration = [[CalendarIntegrationHandler alloc] init];
    
//    [integration setDelegate:self];
//
////    [integration addEventToCalendar:nil];
//    [integration getEventList];
     self.calendarNetworkHandler = [[CalendarNetworkHandler alloc] init];
    self.calendarNetworkHandler.delegate = self;
    [self.calendarNetworkHandler getAppointmentsListForUser:@"2"];
    //[self.calendarNetworkHandler addAppointment:nil];
    //[self.calendarNetworkHandler deleteAppointment:@"1"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)syncEventsWithSystemCalendar:(id)sender
{
    NSMutableArray *arrEventsList = [NSMutableArray array];
    for(AppointmentsData *appt in arrData)
    {
        NSMutableDictionary *dictNew = [[NSMutableDictionary alloc] init];
        [dictNew setValue:appt.userAppointmentTitle forKey:@"userAppointmentTitle"];
        [dictNew setValue:appt.userAppointmentLocation forKey:@"userAppointmentLocation"];
        [dictNew setValue:appt.userAppointmentStartDate forKey:@"userAppointmentStartDate"];
        [dictNew setValue:appt.userAppointmentEndDate forKey:@"userAppointmentEndDate"];
        [arrEventsList addObject:dictNew];
    }
    CalendarIntegrationHandler *integration = [[CalendarIntegrationHandler alloc] init];
    [integration setDelegate:self];
    [integration addEventsListToCalendar:arrEventsList];

}

#pragma mark- Calendar connectin handler delegates

-(void)didFinishSuccesfullyWithCalendarData:(NSArray *)data forOperation:(int)operationCode
{
    [arrData addObjectsFromArray:data];
    
    for(AppointmentsData *appt in arrData)
    {
        NSMutableDictionary *dictNew = [[NSMutableDictionary alloc] init];
        [dictNew setValue:appt.userAppointmentTitle forKey:@"userAppointmentTitle"];
        [dictNew setValue:appt.userAppointmentLocation forKey:@"userAppointmentLocation"];
        [dictNew setValue:appt.userAppointmentStartDate forKey:@"userAppointmentStartDate"];
        [dictNew setValue:appt.userAppointmentEndDate forKey:@"userAppointmentEndDate"];
    }
    [table reloadData];
}
-(void)didFinishSuccessfullyWithAppointmentData:(AppointmentsData *)data forOperation:(int)operationCode
{
    NSLog(@"Success");
}
- (void)didFailWithError:(NSError *)error forOperation:(int)operationCode
{
    NSLog(@"Failure");
}

#pragma mark- Table View Delegates

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppointmentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    if(!cell)
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    AppointmentsData *appt = [arrData objectAtIndex:indexPath.row];
    [cell.lblTitle setText:appt.userAppointmentTitle];
    [cell.lblDescription setText:appt.userAppointmentDescription];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YYYY hh:mm"];
    [cell.lblEnd setText:[formatter stringFromDate:appt.userAppointmentEndDate]];
    [cell.lblStart setText:[formatter stringFromDate:appt.userAppointmentStartDate]];
    
    return cell;
}


#pragma mark- Integration handler delegates

-(void)addEventFinishedSuccessfully
{
    NSLog(@"Add Event Successful");
}

-(void)deleteEventFinishedSuccessfully
{
    NSLog(@"Delete Event Successful");
}

-(void)getEventListFinishedSuccessfullyWithList:(NSArray *)events
{
    for(EKEvent *event in events)
    {
        AppointmentsData *data = [[AppointmentsData alloc] init];
        data.userAppointmentStartDate = event.startDate;
        data.userAppointmentEndDate = event.endDate;
        data.userAppointmentLocation = event.location;
        data.userAppointmentDescription = event.description;
        data.userAppointmentTitle = event.title;
        [arrData addObject:data];
    }
    //[arrData addObjectsFromArray:events];
}


@end
