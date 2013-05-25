//
//  TravelDestination.h
//  Smart Holiday Ideas
//
//  Created by Richard Knop on 25/05/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelDestination : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *shortDescrption;
@property (strong, nonatomic) NSString *longDescription;
@property (strong, nonatomic) NSString *officialWebsite;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

@end
