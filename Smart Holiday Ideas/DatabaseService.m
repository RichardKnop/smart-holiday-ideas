//
//  DatabaseService.m
//  Smart Holiday Ideas
//
//  Created by Richard Knop on 25/05/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "DatabaseService.h"

#import "TravelDestination.h"
#import "Airport.h"
#import "TouristAttraction.h"
#import "Image.h"
#import "AverageMaximumTemperature.h"
#import "AverageMinimumTemperature.h"
#import "AverageRainfall.h"

@implementation DatabaseService

- (int)countTravelDestinations
{
    int count = 0;
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    NSString *query = @"SELECT COUNT(id) FROM travelDestination";
    FMResultSet *results = [db executeQuery:query];
    if ([results next]) {
        count = [results intForColumnIndex:0];
    }
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]); }
    [db close];
    
    return count;
}

- (NSMutableArray *) getTravelDestinations:(int)limit skip:(int)offset
{
    NSMutableArray *travelDestinations = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM travelDestination LIMIT %d OFFSET %d", limit, offset];
    FMResultSet *results = [db executeQuery:query];
    while ([results next]) {
        TravelDestination *travelDestination = [[TravelDestination alloc] init];
        travelDestination.id = [results stringForColumn:@"id"];
        travelDestination.shortDescrption = [results stringForColumn:@"shortDescription"];
        travelDestination.longDescription = [results stringForColumn:@"longDescription"];
        travelDestination.officialWebsite = [results stringForColumn:@"officialWebsite"];
        travelDestination.latitude = [NSNumber numberWithDouble:[results longForColumn:@"latitude"]];
        travelDestination.longitude = [NSNumber numberWithDouble:[results longForColumn:@"longitude"]];
        
        travelDestination.airports = [self getTravelDestnationAirports:travelDestination.id];
        travelDestination.touristAttractions = [self getTravelDestnationTouristAttractions:travelDestination.id];
        travelDestination.images = [self getTravelDestnationImages:travelDestination.id];
        travelDestination.averageMaximumTemperatures = [self getTravelDestnationAverageMaximumTemperatures:travelDestination.id];
        travelDestination.averageMinimumTemperatures = [self getTravelDestnationAverageMinimumTemperatures:travelDestination.id];
        travelDestination.averageRainfalls = [self getTravelDestnationAverageRainfalls:travelDestination.id];
        
        [travelDestinations addObject:travelDestination];
    }
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]); }
    [db close];
    
    return travelDestinations;
}

- (NSMutableArray *) getTravelDestnationAirports:(NSString *)travelDestinationId
{
    NSMutableArray *airports = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT a.id FROM airport a INNER JOIN travelDestinationAirport tda ON tda.airportId = a.id WHERE tda.travelDestinationId = '%@'", travelDestinationId];
    FMResultSet *results = [db executeQuery:query];
    while ([results next]) {
        Airport *airport = [[Airport alloc] init];
        airport.id = [results stringForColumn:@"id"];
        [airports addObject:airport];
    }
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]); }
    [db close];
    
    return airports;
}

- (NSMutableArray *) getTravelDestnationTouristAttractions:(NSString *)travelDestinationId
{
    NSMutableArray *attractions = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT ta.id FROM touristAttraction ta INNER JOIN travelDestinationTouristAttraction tdta ON tdta.touristAttractionId = ta.id WHERE tdta.travelDestinationId = '%@'", travelDestinationId];
    FMResultSet *results = [db executeQuery:query];
    while ([results next]) {
        TouristAttraction *atraction = [[TouristAttraction alloc] init];
        atraction.id = [results stringForColumn:@"id"];
        [attractions addObject:atraction];
    }
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]); }
    [db close];
    
    return attractions;
}

- (NSMutableArray *) getTravelDestnationImages:(NSString *)travelDestinationId
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT id FROM image WHERE travelDestinationId = '%@'", travelDestinationId];
    FMResultSet *results = [db executeQuery:query];
    while ([results next]) {
        Image *image = [[Image alloc] init];
        image.id = [results stringForColumn:@"id"];
        [images addObject:image];
    }
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]); }
    [db close];
    
    return images;
}

- (NSMutableArray *) getTravelDestnationAverageMaximumTemperatures:(NSString *)travelDestinationId
{
    NSMutableArray *temperatures = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT month, temperature FROM averageMaximumTemperature WHERE travelDestinationId = '%@'", travelDestinationId];
    FMResultSet *results = [db executeQuery:query];
    while ([results next]) {
        AverageMaximumTemperature *temperature = [[AverageMaximumTemperature alloc] init];
        temperature.month = [results stringForColumn:@"month"];
        temperature.temperature = [results doubleForColumn:@"temperature"];
        [temperatures addObject:temperature];
    }
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]); }
    [db close];
    
    return temperatures;
}

- (NSMutableArray *) getTravelDestnationAverageMinimumTemperatures:(NSString *)travelDestinationId
{
    NSMutableArray *temperatures = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT month, temperature FROM averageMinimumTemperature WHERE travelDestinationId = '%@'", travelDestinationId];
    FMResultSet *results = [db executeQuery:query];
    while ([results next]) {
        AverageMinimumTemperature *temperature = [[AverageMinimumTemperature alloc] init];
        temperature.month = [results stringForColumn:@"month"];
        temperature.temperature = [results doubleForColumn:@"temperature"];
        [temperatures addObject:temperature];
    }
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]); }
    [db close];
    
    return temperatures;
}

- (NSMutableArray *) getTravelDestnationAverageRainfalls:(NSString *)travelDestinationId
{
    NSMutableArray *rainfalls = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT month, rainfall FROM averageRainfall WHERE travelDestinationId = '%@'", travelDestinationId];
    FMResultSet *results = [db executeQuery:query];
    while ([results next]) {
        AverageRainfall *rainfall = [[AverageRainfall alloc] init];
        rainfall.month = [results stringForColumn:@"month"];
        rainfall.rainfall = [results doubleForColumn:@"rainfall"];
        [rainfalls addObject:rainfall];
    }
    if ([db hadError]) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]); }
    [db close];
    
    return rainfalls;
}

@end
