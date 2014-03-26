//
//  BasicConnectionHandler.m
//  InfoFree
//
//  Created by Aditya Athvale on 24/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#import "BasicConnectionHandler.h"
#import "Constants.h"

@implementation BasicConnectionHandler

BasicConnectionHandler *sharedHandler;

-(void)initiatePostRequestHandlerWithPostParameters:(NSData *)postparameters
{
    if(receivedData)
    {
        receivedData = nil;
    }
    if(self.url)
    {
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        
        [req setValue:@"application/JSON" forHTTPHeaderField:@"Content-Type"];
        [req setHTTPMethod:@"POST"];
        if(postparameters)
        {
            [req setHTTPBody:postparameters];
        }
        if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
        {
            connection = [NSURLConnection connectionWithRequest:req delegate:self];
        }
        else
        {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"Network Not Available" forKey:@"Description"];
            NSError *error = [[NSError alloc] initWithDomain:@"Custom Error Domain" code:101 userInfo:dict];
            
            if([self.delegate respondsToSelector:@selector(didFailWithError:)])
            {
                [self.delegate didFailWithError:error];
            }
        }
    }
    else
    {
        NSLog(@"Error!!\nNo URL specified!!");
        NSDictionary *dict = [NSDictionary dictionaryWithObject:@"No URL specified" forKey:@"Description"];
        NSError *error = [[NSError alloc] initWithDomain:@"Custom Error Domain" code:102 userInfo:dict];
        
        if([self.delegate respondsToSelector:@selector(didFailWithError:)])
        {
            [self.delegate didFailWithError:error];
        }

    }
}

-(void)initiateGetRequestHandler
{
    if(self.url)
    {
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [req setValue:@"application/JSON" forHTTPHeaderField:@"Content-Type"];
        [req setHTTPMethod:@"GET"];
        if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
        {
            connection = [NSURLConnection connectionWithRequest:req delegate:self];
        }
        else
        {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"Network Not Available" forKey:@"Description"];
            NSError *error = [[NSError alloc] initWithDomain:@"Custom Error Domain" code:101 userInfo:dict];
            
            if([self.delegate respondsToSelector:@selector(didFailWithError:)])
            {
                [self.delegate didFailWithError:error];
            }
        }
    }
    else
    {
        NSLog(@"Error!!\nNo URL specified!!");
        NSDictionary *dict = [NSDictionary dictionaryWithObject:@"No URL specified" forKey:@"Description"];
        NSError *error = [[NSError alloc] initWithDomain:@"Custom Error Domain" code:102 userInfo:dict];
        
        if([self.delegate respondsToSelector:@selector(didFailWithError:)])
        {
            [self.delegate didFailWithError:error];
        }
    }
}


#pragma mark-Connection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(!receivedData)
        receivedData = [[NSMutableData alloc] init];
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSObject *obj = [parser objectWithData:receivedData];
    if([obj isKindOfClass:[NSArray class]])
    {
        if([self.delegate respondsToSelector:@selector(didFinishSuccesfullyWithData:)])
        {
            [self.delegate didFinishSuccesfullyWithData:(NSArray *)obj];
        }
    }
    else if([obj isKindOfClass:[NSDictionary class]])
    {
       if([self.delegate respondsToSelector:@selector(didFinishSuccesfullyWithDictionaryData:)])
        {
            [self.delegate didFinishSuccesfullyWithDictionaryData:(NSDictionary *)obj];
        }
    }
    else
    {
        NSString* newStr = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        if([self.delegate respondsToSelector:@selector(didFinisheSuccessfullyWithStringData:)])
        {
            [self.delegate didFinisheSuccessfullyWithStringData:newStr];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error!!");
    if([self.delegate respondsToSelector:@selector(didFailWithError:)])
    {
        [self.delegate didFailWithError:error];
    }
}

@end
