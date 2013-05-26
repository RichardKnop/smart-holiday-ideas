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
@property (strong, nonatomic) NSMutableArray *airports;
@property (strong, nonatomic) NSMutableArray *touristAttractions;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *averageMaximumTemperatures;
@property (strong, nonatomic) NSMutableArray *averageMinimumTemperatures;
@property (strong, nonatomic) NSMutableArray *averageRainfalls;

@end
