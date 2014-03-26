//
//  ProspectDetailsViewController.m
//  InfoFreeNew
//
//  Created by Aditya Athvale on 28/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "ProspectDetailsViewController.h"

@interface ProspectDetailsViewController ()

@end

@implementation ProspectDetailsViewController

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
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(self.prospect)
    {
        [self getProspectDetails];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveButtonPressed:(id)sender
{
    if(self.prospect)
    {
        if(!editDictionary)
            editDictionary = [NSMutableDictionary dictionary];
        if(![self.prospect.prospectSource isEqualToString:[txtType text]])
        {
            [editDictionary setValue:[txtType text] forKey:@"prospectSource"];
        }
        if(![_prospect.prospectContact.facebookId isEqualToString:[txtFacebook text]])
        {
            [editDictionary setValue:[txtFacebook text] forKey:@"prospectFacebookId"];
        }
        if(![_prospect.prospectContact.twitterHandle isEqualToString:[txtTwitter text]])
        {
            [editDictionary setValue:[txtTwitter text] forKey:@"prospectTwitterId"];
        }
        if(![_prospect.prospectContact.address.addressLine1 isEqualToString:[txtAddr1 text]])
        {
            [editDictionary setValue:[txtAddr1 text] forKey:@"prospectAddressLine1"];
        }
        if(![_prospect.prospectContact.address.addressLine2 isEqualToString:[txtAddr2 text]])
        {
            [editDictionary setValue:[txtAddr2 text] forKey:@"prospectAddressLine2"];
        }
        if(![_prospect.prospectContact.address.city isEqualToString:[txtCity text]])
        {
            [editDictionary setValue:[txtCity text] forKey:@"prospectCity"];
        }
        if(![(NSString *)_prospect.prospectContact.address.state isEqualToString:[txtState text]])
        {
            [editDictionary setValue:[txtState text] forKey:@"prospectState"];
        }
        if(![(NSString *)_prospect.prospectContact.address.country isEqualToString:[txtCountry text]])
        {
            [editDictionary setValue:[txtCountry text] forKey:@"prospectCountry"];
        }
        if(![(NSString *)_prospect.prospectContact.address.zipCode isEqualToString:[txtZip text]])
        {
            [editDictionary setValue:[txtZip text] forKey:@"prospectZipCode"];
        }
        if([editDictionary allKeys].count > 0)
        {
             _prospect.prospectLastUpdatedDate = [NSDate date];
            [editDictionary setValue:[NSDate date] forKey:@"prospectLastUpdatedDate"];
        }
        ProspectsHandler *handler = [[ProspectsHandler alloc] init];
        [handler setDelegate:self];
        //[handler editProspectContactDetails:_prospect.prospectId andContactId:_prospect.prospectId forFieldName:@"contactFirstName" withNewValue:@"Mangesh"];
        //[handler editProspectAdditionalInfoDetails:_prospect.prospectId additionalINfoId:@"" forFieldName:@"" withNewValue:@""];
        
        ProspectAdditionalInfo *additionalInfo = [[ProspectAdditionalInfo alloc] init];
        additionalInfo.prospectAdditionalInfoCreatedDate = [NSDate date];
        additionalInfo.prospectAdditionalInfoLastUpdatedDate = [NSDate date];
        additionalInfo.prospectAdditionalInformation = @"Additional Info New";
        additionalInfo.prospectAdditionalInformationIsActive = @"Y";
        additionalInfo.prospectAdditionalInformationTitle = @"Additional Info Title";
        
       // [handler addAdditionalInfoDetails:additionalInfo ForProspect:@"2"];
        

        [handler editProspectDetails:_prospect.prospectId forFieldName:@"prospectFacebookId" withNewValue:[editDictionary valueForKey:@"prospectFacebookId"]];
    }
    else
    {
        [self addNewProspect];
    }
}

-(void)getProspectDetails
{
    isGettingProspectData = YES;
    ProspectsHandler *handler = [[ProspectsHandler alloc] init];
    
    [handler setDelegate:self];
    [handler getProspectDetails:self.prospect.prospectId];
}

-(void)addNewProspect
{
    self.prospect = [[ProspectData alloc] init];
    
    _prospect.prospectName = [NSString stringWithFormat:@"%@ %@", [txtFirstName text], [txtLastName text]];
    
    _prospect.prospectTags = [[NSMutableArray alloc] initWithArray:[[txtTags text] componentsSeparatedByString:@","]];
    
    _prospect.prospectStatus = ProspectStatusLead;
   
    _prospect.prospectIsActive = @"Y";
    
    _prospect.prospectCreatedDate = [NSDate date];
    _prospect.prospectLastUpdatedDate = [NSDate date];
    
    _prospect.prospectContact = [[ContactInfo alloc] init];
    _prospect.prospectContact.phoneNumbers = [NSMutableArray arrayWithObjects:[txtPhone1 text], [txtPhone2 text] , nil];
    _prospect.prospectContact.facebookId = [txtFacebook text];
    _prospect.prospectContact.twitterHandle = [txtTwitter text];
    
    _prospect.prospectContact.address = [[Address alloc] init];
    _prospect.prospectContact.address.addressLine1 = [txtAddr1 text];
    _prospect.prospectContact.address.addressLine2 = [txtAddr2 text];
    _prospect.prospectContact.address.city = [txtCity text];
    _prospect.prospectContact.address.state = [txtState text];
    _prospect.prospectContact.address.country = [txtCountry text];
    _prospect.prospectContact.address.zipCode = [txtZip text];

    
    _prospect.prospectSource = [txtType text];
   
    _prospect.prospectType = ProspectTypeC;
   
    _prospect.prospectCreatedDate = [NSDate date];
    _prospect.prospectLastUpdatedDate = [NSDate date];
    
    
    ProspectsHandler *handler = [[ProspectsHandler alloc] init];
 
    [handler setDelegate:self];
    [handler addProspect:_prospect];
    
}

-(IBAction)deleteButtonPressed:(id)sender
{
    ProspectsHandler *handler = [[ProspectsHandler alloc] init];
    [handler setDelegate:self];
    [handler deleteProspect:_prospect];
}

-(IBAction)addToAddressBook:(id)sender
{
    [_prospect syncContactWithAddressBook];
}



#pragma mark- Prospect handler Delegatges

-(void)didFinishSuccesfullyWithData:(NSArray *)data forOperation:(int)operationCode
{
    [[[UIAlertView alloc] initWithTitle:@"Successs!!" message:@"Prospect Deleted Successfully!!" delegate:nil cancelButtonTitle:@"Great!! Good Work!! Thanks!!" otherButtonTitles:nil, nil] show];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didFinishSuccesfullyWithProspectData:(ProspectData *)data forOperation:(int)operationCode
{
    if(isGettingProspectData)
    {
        _prospect = data;
        isGettingProspectData = NO;
        [self loadTextFields];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Successs!!" message:@"Prospect Added Successfully!!" delegate:nil cancelButtonTitle:@"Great!! Good Work!! Thanks!!" otherButtonTitles:nil, nil] show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)didFinishSuccessfullyWithStringData:(NSString *)data forOperation:(int)operationCode
{
    NSLog(@"Success");
}


-(void)didFailWithError:(NSError *)error forOperation:(int)operationCode
{
    [[[UIAlertView alloc] initWithTitle:@"Error!!" message:@"Error Adding Prospect!!" delegate:nil cancelButtonTitle:@"Oh!! Better Luck Next Time!!" otherButtonTitles:nil, nil] show];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- Load Textfields

-(void)loadTextFields
{
    if(_prospect.prospectName && (id)_prospect.prospectName != [NSNull null])
    {
        [txtFirstName setText:_prospect.prospectName];
    }
    if(_prospect.prospectContact.address.addressLine1 && (id)_prospect.prospectContact.address.addressLine1 != [NSNull null])
    {
        [txtAddr1 setText:_prospect.prospectContact.address.addressLine1];
    }
    if(_prospect.prospectContact.address.addressLine2 && (id)_prospect.prospectContact.address.addressLine2 != [NSNull null])
    {
        [txtAddr2 setText:_prospect.prospectContact.address.addressLine2];
    }
    if(_prospect.prospectContact.address.city && (id)_prospect.prospectContact.address.city != [NSNull null])
    {
        [txtCity setText:_prospect.prospectContact.address.city];
    }
    if(_prospect.prospectContact.address.state && (id)_prospect.prospectContact.address.state != [NSNull null])
    {
        [txtState setText:_prospect.prospectContact.address.state];
    }
    if(_prospect.prospectContact.address.country && (id)_prospect.prospectContact.address.country != [NSNull null])
    {
        [txtCountry setText:_prospect.prospectContact.address.country];
    }
    if(_prospect.prospectContact.address.zipCode && (id)_prospect.prospectContact.address.zipCode != [NSNull null])
    {
        [txtZip setText:_prospect.prospectContact.address.zipCode];
    }
    
    if(_prospect.prospectContact.phoneNumbers && (id)_prospect.prospectContact.phoneNumbers != [NSNull null])
    {
        if(_prospect.prospectContact.phoneNumbers.count >=1)
        {
            if([_prospect.prospectContact.phoneNumbers objectAtIndex:0] != [NSNull null])
                [txtPhone1 setText:[_prospect.prospectContact.phoneNumbers objectAtIndex:0]];
        }
        if(_prospect.prospectContact.phoneNumbers.count >=2)
        {
            if([_prospect.prospectContact.phoneNumbers objectAtIndex:1] != [NSNull null])
                [txtPhone2 setText:[_prospect.prospectContact.phoneNumbers objectAtIndex:1]];
        }
    }
    if(_prospect.prospectContact.mailIds && (id)_prospect.prospectContact.mailIds != [NSNull null])
    {
        if(_prospect.prospectContact.mailIds.count >=1)
        {
            if([_prospect.prospectContact.mailIds objectAtIndex:0] != [NSNull null])
                [txtMail1 setText:[_prospect.prospectContact.mailIds objectAtIndex:0]];
        }
        if(_prospect.prospectContact.mailIds.count >=2)
        {
            if([_prospect.prospectContact.mailIds objectAtIndex:1] != [NSNull null])
                [txtMail2 setText:[_prospect.prospectContact.mailIds objectAtIndex:1]];
        }
    }
    if(_prospect.prospectContact.facebookId && (id)_prospect.prospectContact.facebookId != [NSNull null])
    {
        [txtFacebook setText:_prospect.prospectContact.facebookId];
    }
    if(_prospect.prospectContact.twitterHandle && (id)_prospect.prospectContact.twitterHandle != [NSNull null])
    {
        [txtTwitter setText:_prospect.prospectContact.twitterHandle];
    }
    if(_prospect.prospectSource && (id)_prospect.prospectSource != [NSNull null])
    {
        [txtType setText:_prospect.prospectSource];
    }
}

@end
