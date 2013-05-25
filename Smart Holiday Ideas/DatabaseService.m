//
//  DatabaseService.m
//  Smart Holiday Ideas
//
//  Created by Richard Knop on 25/05/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "DatabaseService.h"

@implementation DatabaseService

- (NSMutableArray *) getTravelDestinations:(NSInteger)limit offset:(NSInteger)offset
{
    NSMutableArray *travelDestinations = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM travelDestination LIMIT %d OFFSET %d", offset, limit];
    FMResultSet *results = [db executeQuery:query];
    while ([results next]) {
        TravelDestination *travelDestination = [[TravelDestination alloc] init];
        travelDestination.id = [results stringForColumn:@"id"];
        travelDestination.shortDescrption = [results stringForColumn:@"shortDescrption"];
        travelDestination.longDescription = [results stringForColumn:@"longDescription"];
        travelDestination.officialWebsite = [results stringForColumn:@"officialWebsite"];
        travelDestination.latitude = [NSNumber numberWithDouble:[results longForColumn:@"latitude"]];
        travelDestination.longitude = [NSNumber numberWithDouble:[results longForColumn:@"longitude"]];
        [travelDestinations addObject:travelDestination];
    }
    [db close];
    return travelDestinations;
}


@end
