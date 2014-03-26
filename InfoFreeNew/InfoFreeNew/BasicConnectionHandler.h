//
//  BasicConnectionHandler.h
//  InfoFree
//
//  Created by Aditya Athvale on 24/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SBJson.h"
#import "Reachability.h"

@protocol BasicConnectionDelegate <NSObject>

-(void)didFinishSuccesfullyWithData:(NSArray *)data;
-(void)didFinishSuccesfullyWithDictionaryData:(NSDictionary *)data;
-(void)didFinisheSuccessfullyWithStringData:(NSString *)string;
- (void)didFailWithError:(NSError *)errors;

@end

@interface BasicConnectionHandler : NSObject <NSURLConnectionDelegate>
{
    NSURLConnection *connection;
    NSMutableData *receivedData;
}

@property (nonatomic, strong) id <BasicConnectionDelegate> delegate;
@property(nonatomic, strong)NSString *url;

-(void)initiatePostRequestHandlerWithPostParameters:(NSData *)postparameters;
-(void)initiateGetRequestHandler;

@end
