//
//  myAnnotation.h
//  MapView
//
//  Created by dev27 on 5/30/13.
//  Copyright (c) 2013 codigator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface myAnnotation : NSObject <MKAnnotation>
@property (strong, strong) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;
@end
