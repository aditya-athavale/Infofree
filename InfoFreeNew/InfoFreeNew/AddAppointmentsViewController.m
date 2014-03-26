//
//  AddAppointmentsViewController.m
//  InfoFreeNew
//
//  Created by Aditya Athvale on 20/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "AddAppointmentsViewController.h"
#import "AppointmentsData.h"
#import "UserData.h"
#import "ProspectData.h"

@interface AddAppointmentsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UITableView *attendeesTable;
@property (strong, nonatomic) AppointmentsData *appointment;
@property (strong, nonatomic) NSMutableArray *arrContacts, *arrAttendees;


@end

@implementation AddAppointmentsViewController

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
    
    self.arrContacts = [NSMutableArray array];
    self.arrAttendees = [NSMutableArray array];
    
    [self.arrContacts addObjectsFromArray:[[UserData sharedUserData] getAllContacts]];
    
    [self.attendeesTable setDataSource:self];
    [self.attendeesTable setDelegate:self];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveButtonPressed:(id)sender
{
    CalendarNetworkHandler *network = [[CalendarNetworkHandler alloc] init];
    [network setDelegate:self];
    network.connectionHandler = [[BasicConnectionHandler alloc] init];
    network.connectionHandler.delegate = network;
     self.appointment = [[AppointmentsData alloc] init];
    
    [_appointment setUserAppointmentTitle:self.txtTitle.text];
    [_appointment setUserAppointmentDescription:self.txtDescription.text];
    [_appointment setUserAppointmentLocation:self.txtLocation.text];
    [_appointment setUserAppointmentStartDate:self.startDatePicker.date];
    [_appointment setUserAppointmentEndDate:self.endDatePicker.date];
    [_appointment setUserAppointmentIsActive:@"Y"];
    [_appointment setAttendees:_arrAttendees];
    
    [network addAppointment:_appointment];
}

#pragma mark- Calendar Collection Delegate

-(void)didFinishSuccesfullyWithCalendarData:(NSArray *)data forOperation:(int)operationCode
{
    
}
- (void)didFailWithError:(NSError *)error forOperation:(int)operationCode
{
    NSLog(@"Error Adding to netwrok calendar.");
}

-(void)didFinishSuccessfullyWithAppointmentData:(AppointmentsData *)data forOperation:(int)operationCode
{
    NSMutableDictionary *dictNew = [[NSMutableDictionary alloc] init];
    [dictNew setValue:_appointment.userAppointmentTitle forKey:@"userAppointmentTitle"];
    [dictNew setValue:_appointment.userAppointmentLocation forKey:@"userAppointmentLocation"];
    [dictNew setValue:_appointment.userAppointmentStartDate forKey:@"userAppointmentStartDate"];
    [dictNew setValue:_appointment.userAppointmentEndDate forKey:@"userAppointmentEndDate"];
    
    CalendarIntegrationHandler *integration = [[CalendarIntegrationHandler alloc] init];
    [integration addEventToCalendar:dictNew];
}

-(void)didFinishSuccessfullyWithStringData:(NSString *)data forOperation:(int)operationCode

{
    NSLog(@"Error Adding to netwrok calendar.\nReceived String data!!");
}


#pragma mark- calendar integration delegates

-(void)addEventFinishedSuccessfully
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getEventListFinishedSuccessfullyWithList:(NSArray *)events
{
    
}
-(void)operationFailed
{
    NSLog(@"Error Adding to local calendar.");
}

#pragma mark- Table View Datasource
-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrContacts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.arrContacts objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    [cell.textLabel setText:[dict valueForKey:@"FirstName"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_arrContacts objectAtIndex:indexPath.row];
    ProspectContacts *contact = [[ProspectContacts alloc] init];
    [contact setContactId:[dict valueForKey:@"ContactId"]];
    
    [_arrAttendees addObject:[contact getContactsDictionary]];
}

@end
