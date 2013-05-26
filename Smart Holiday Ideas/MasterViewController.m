//
//  MasterViewController.m
//  Smart Holiday Ideas
//
//  Created by Richard Knop on 25/05/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "AppDelegate.h"
#import "TravelDestinationCell.h"
#import "TravelDestination.h"
#import "Image.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    // Database Service
    self.isLoadingMoreContent = FALSE;
    self.limit = 20;
    self.offset = 0;
    self.count = 40;
    self.imageCache = [[NSMutableDictionary alloc] initWithCapacity:self.count];

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.travelDestinations = [appDelegate.databaseService getTravelDestinations:self.limit skip:self.offset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.travelDestinations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TravelDestinationCell *travelDestinationCell = [tableView dequeueReusableCellWithIdentifier:@"TravelDestinationCell" forIndexPath:indexPath];
    TravelDestination *travelDestination = [self.travelDestinations objectAtIndex:indexPath.item];
    
    // Description
    [travelDestinationCell.description setEditable:FALSE];
    travelDestinationCell.description.text = travelDestination.shortDescrption;
    
    Image *firstImage = (Image *)[travelDestination.images objectAtIndex:0];
    // If we have already downloaded the image, use the cached image
    if (nil != [self.imageCache objectForKey:firstImage.id]) {
        travelDestinationCell.image.image = [self.imageCache objectForKey:firstImage.id];
        return travelDestinationCell;
    }
    // Otherwise send async request to download the image
    void (^blockLoadImage)() =  ^{
        NSString *urlEncodedId = firstImage.id;
        urlEncodedId = [urlEncodedId stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://usercontent.googleapis.com/freebase/v1/image/%@", urlEncodedId]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(),^{
            NSLog(@"loading image");
            [self.imageCache setObject:image forKey:firstImage.id];
            travelDestinationCell.image.image = image;
        });
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), blockLoadImage);
    return travelDestinationCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setDetailItem:[self.travelDestinations objectAtIndex:indexPath.item]];
    }
}

- (void)scrollViewDidScroll: (UIScrollView *)scroll {
    // UITableView only moves in one direction, y axis
    NSInteger currentOffset = scroll.contentOffset.y;
    NSInteger maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0) {
        if (FALSE == self.isLoadingMoreContent && self.offset + 20 < self.count) {
            self.isLoadingMoreContent = TRUE;
            self.offset += 20;
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSMutableArray *moreTravelDestinations = [appDelegate.databaseService getTravelDestinations:self.limit  skip:self.offset];
                                                      for (TravelDestination *travelDestination in moreTravelDestinations) {
                                                          [self.travelDestinations addObject:travelDestination];
                                                      }
            self.isLoadingMoreContent = FALSE;
            [self.tableView reloadData];
        }
    }
}

@end
