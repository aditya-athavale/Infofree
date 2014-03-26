//
//  ProspectsViewController.m
//  InfoFree
//
//  Created by Aditya Athvale on 25/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "ProspectsViewController.h"
#import "CalendarIntegrationHandler.h"

@interface ProspectsViewController ()

@end

@implementation ProspectsViewController

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
    
    //[self addNewProspect];
    handler = [[ProspectsHandler alloc] init];
    [handler setDelegate:self];
////    //[handler addAdditionalInfoDetails:nil ForProspect:@"2"];
    // Do any additional setup after loading the view.
////    //[handler addAdditionalInfoDetails:nil ForProspect:@"2"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [handler getProspectList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-Table View delegates

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrProspects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    ProspectData *prospect = [arrProspects objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Prospect Id: %@",prospect.prospectId];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isGoingfromTable = YES;
    [self performSegueWithIdentifier:@"ProspectDetailsSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    if(isGoingfromTable)
    {
        NSIndexPath *indexPath = [table indexPathForCell:sender];
        ProspectDetailsViewController *pd = [segue destinationViewController];
        pd.prospect = [arrProspects objectAtIndex:indexPath.row];
        isGoingfromTable = NO;
    }
}

#pragma mark- Handler Delegates

-(void)didFinishSuccesfullyWithData:(NSArray *)data forOperation:(int)operationCode
{
    arrProspects = [NSMutableArray arrayWithArray:data];
    
    for(ProspectData *prospect in arrProspects)
    {
        CLLocationCoordinate2D cord = CLLocationCoordinate2DMake(prospect.prospectContact.address.latitude, prospect.prospectContact.address.longitude);
        myAnnotation *annotation = [[myAnnotation alloc] initWithCoordinate:cord title:[NSString stringWithFormat:@"%@\n%@", prospect.prospectId, prospect.prospectContact.address.city]];
        [mapView addAnnotation:annotation];
    }
    
    
    [table reloadData];
}

-(void)didFailWithError:(NSError *)error forOperation:(int)operationCode
{
    [[[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Error occoured!!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
}

-(void)didFinishSuccesfullyWithProspectData:(ProspectData *)data forOperation:(int)operationCode
{
    [[[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Error occoured in downloading prospect List" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
}

-(void)didFinishSuccessfullyWithStringData:(NSString *)data forOperation:(int)operationCode
{
    NSLog(@"Success");
}

-(IBAction)nextButtonPressed:(id)sender
{
//    handler = [ProspectsHandler getSharedProspectsHandler];
//    [handler setDelegate:self];
    [handler setStartindex:handler.startindex + handler.pageCount];
    [handler getProspectList];
}

-(IBAction)prevButtonPressed:(id)sender
{
//    handler = [ProspectsHandler getSharedProspectsHandler];
//    [handler setDelegate:self];
    if((handler.startindex-handler.pageCount) > 0)
    {
        [handler setStartindex:handler.startindex - handler.pageCount];
        [handler getProspectList];
    }
}

-(IBAction)syncProspectsWithAddressBookPressed:(id)sender
{
    [handler syncProspectsWithAddressBook:arrProspects];
}
-(void)addNewProspect
{
    ProspectData *prospect = [[ProspectData alloc] init];
    
    prospect.prospectName = @"Aditya Athavale";
    
//    prospect.prospectTags = [[NSMutableArray alloc] initWithArray:[[txtTags text] componentsSeparatedByString:@","]];
    
    prospect.prospectStatus = ProspectStatusLead;
    
    prospect.prospectIsActive = @"Y";
    
    prospect.prospectCreatedDate = [NSDate date];
    prospect.prospectLastUpdatedDate = [NSDate date];
    
    prospect.prospectContact = [[ContactInfo alloc] init];
    prospect.prospectContact.phoneNumbers = [NSMutableArray arrayWithObjects:@"9167294242", @"9167284242", nil];
    prospect.prospectContact.facebookId = @"Facebook Id";
    prospect.prospectContact.twitterHandle = @"Twitter Id";
    
    prospect.prospectContact.address = [[Address alloc] init];
    prospect.prospectContact.address.addressLine1 = @"Address Line 1";
    prospect.prospectContact.address.addressLine2 = @"Address Line 2";
    prospect.prospectContact.address.city = @"City";
    prospect.prospectContact.address.state = @"State";
    prospect.prospectContact.address.country = @"Country";
    prospect.prospectContact.address.zipCode = @"421301";

    
    prospect.prospectType = ProspectTypeC;
    
    prospect.prospectCreatedDate = [NSDate date];
    prospect.prospectLastUpdatedDate = [NSDate date];
    
    [prospect syncContactWithAddressBook];
    
}


@end
