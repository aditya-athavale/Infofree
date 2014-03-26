//
//  ProspectDetailsViewController.h
//  InfoFreeNew
//
//  Created by Aditya Athvale on 28/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProspectData.h"
#import "ProspectsHandler.h"

@interface ProspectDetailsViewController : UIViewController <ProspectConnectionDelegate>
{
    IBOutlet UITextField *txtFirstName, *txtLastName, *txtPhone1, *txtPhone2, *txtMail1, *txtMail2, *txtFacebook, *txtTwitter, *txtType, *txtAddr1, *txtAddr2, *txtCity, *txtState, *txtCountry, *txtZip, *txtTags;
    
    NSMutableDictionary *editDictionary;
    BOOL isGettingProspectData;
}
@property(nonatomic, strong)ProspectData *prospect;

@end
