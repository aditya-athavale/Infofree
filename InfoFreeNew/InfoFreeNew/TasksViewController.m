//
//  TasksViewController.m
//  InfoFreeNew
//
//  Created by Aditya Athvale on 11/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "TasksViewController.h"
#import "UserData.h"

@interface TasksViewController ()

@property(nonatomic, strong)CalendarNetworkHandler *calendarNetworkHandler;

@end

@implementation TasksViewController

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
    
    arrData = [NSMutableArray array];

    self.calendarNetworkHandler = [[CalendarNetworkHandler alloc] init];
    self.calendarNetworkHandler.delegate = self;
    
//[self.calendarNetworkHandler getTasksListforUser:@"2" andPaneNo:0];
//    [self.calendarNetworkHandler markTaskAsIncomplete:@"10"];
//    [self.calendarNetworkHandler deleteTask:@"8"];
	// Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated
{
    [arrData removeAllObjects];
    [self.calendarNetworkHandler getTasksListforUser:[[UserData sharedUserData] userId] andPageNo:0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Calendar connectin handler delegates

-(void)didFinishSuccesfullyWithCalendarData:(NSArray *)data forOperation:(int)operationCode
{
    [arrData addObjectsFromArray:data];
    [table reloadData];
}

-(void)didFinishSuccessfullyWithTaskData:(TasksData *)data forOperation:(int)operationCode
{
    NSLog(@"Success");
}

-(void)didFinishSuccessfullyWithStringData:(NSString *)data forOperation:(int)operationCode
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
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    [cell.textLabel setNumberOfLines:10];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[(TasksData *)[arrData objectAtIndex:indexPath.row] getTasksDictionary]];
    
    return cell;
}



@end
