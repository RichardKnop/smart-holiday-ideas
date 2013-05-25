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
#import "TravelDestination.h"

@interface DatabaseService : NSObject

@property (strong, nonatomic) NSString *databasePath;

- (NSMutableArray *)getTravelDestinations:(NSInteger)limit offset:(NSInteger)offset;

@end
