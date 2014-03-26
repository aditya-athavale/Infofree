//
//  AppointmentsCell.m
//  InfoFreeNew
//
//  Created by Aditya Athvale on 26/03/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "AppointmentsCell.h"

@implementation AppointmentsCell

@synthesize lblDescription,lblEnd, lblStart, lblTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
