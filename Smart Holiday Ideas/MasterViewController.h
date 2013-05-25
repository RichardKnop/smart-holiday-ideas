//
//  MasterViewController.h
//  Smart Holiday Ideas
//
//  Created by Richard Knop on 25/05/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DatabaseService.h"

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DatabaseService *databaseService;
@property (strong, nonatomic) NSMutableArray *travelDestinations;

@end
