//
//  DatabaseService.h
//  Smart Holiday Ideas
//
//  Created by Richard Knop on 25/05/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface DatabaseService : NSObject

@property (strong, nonatomic) NSString *databasePath;

- (int)countTravelDestinations;

- (NSMutableArray *)getTravelDestinations:(int)limit skip:(int)offset;

- (NSMutableArray *)getTravelDestnationAirports:(NSString *)travelDestinationId;

- (NSMutableArray *)getTravelDestnationTouristAttractions:(NSString *)travelDestinationId;

- (NSMutableArray *)getTravelDestnationImages:(NSString *)travelDestinationId;

- (NSMutableArray *)getTravelDestnationAverageMaximumTemperatures:(NSString *)travelDestinationId;

- (NSMutableArray *)getTravelDestnationAverageMinimumTemperatures:(NSString *)travelDestinationId;

- (NSMutableArray *)getTravelDestnationAverageRainfalls:(NSString *)travelDestinationId;

@end
