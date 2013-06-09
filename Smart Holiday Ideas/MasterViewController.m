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
#import "AsyncImageRequest.h"
#import <QuartzCore/QuartzCore.h>

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
    
    // Database Service
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.databaseService = appDelegate.databaseService;
    
    // content
    self.isLoadingMoreContent = NO;
    self.limit = 10;
    self.offset = 0;
    self.count = [self.databaseService countTravelDestinations];
    self.imageCache = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.count; i++) {
        AsyncImageRequest *asyncImageRequest = [[AsyncImageRequest alloc] init];
        asyncImageRequest.requestSent = NO;
        asyncImageRequest.requestCompleted = NO;
        [self.imageCache addObject:asyncImageRequest];
    }
    self.travelDestinations = [self.databaseService getRandomTravelDestinations:self.limit];
    
    // toolbar
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *shuffleButton = [[UIBarButtonItem alloc] initWithTitle:@"Shuffle" style:UIBarButtonItemStyleBordered target:self action:@selector(shuffle)];
    self.toolbarItems = [NSArray arrayWithObjects:flexibleSpace, shuffleButton, flexibleSpace, nil];
}

- (void)shuffle
{
    self.travelDestinations = [self.databaseService getRandomTravelDestinations:self.limit];
    for (int i = 0; i < self.count; i++) {
        AsyncImageRequest *asyncImageRequest = [self.imageCache objectAtIndex:i];
        asyncImageRequest.requestSent = NO;
        asyncImageRequest.requestCompleted = NO;
    }
    [self.tableView reloadData];
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
    
    travelDestinationCell.longDescription = travelDestination.longDescription;
    
    // Description
    [travelDestinationCell.description setEditable:NO];
    travelDestinationCell.description.text = travelDestination.shortDescrption;
    
//    // rounded corners
//    travelDestinationCell.image.layer.cornerRadius = 5.0;
//    travelDestinationCell.image.layer.masksToBounds = YES;
//    travelDestinationCell.image.layer.borderWidth = 1.0;
//    travelDestinationCell.image.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    AsyncImageRequest *asyncImageRequest = (AsyncImageRequest *)[self.imageCache objectAtIndex:indexPath.item];
    // Use cached image if possible
    if (YES == asyncImageRequest.requestCompleted) {
        travelDestinationCell.image.image = asyncImageRequest.image;
        return travelDestinationCell;
    } else {
        asyncImageRequest.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(11.0f, 20.0f, 75.0f, 75.0f)];
        [travelDestinationCell.contentView addSubview:asyncImageRequest.indicatorView];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator startAnimating];
        indicator.center = CGPointMake(37.5, 37.5);
        [asyncImageRequest.indicatorView addSubview:indicator];
    }
    // Otherwise send async request to download the image
    void (^blockLoadImage)() =  ^{
        asyncImageRequest.requestSent = YES;
        Image *firstImage = (Image *)[travelDestination.images objectAtIndex:0];
        NSString *urlEncodedId = firstImage.id;
        urlEncodedId = [urlEncodedId stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://usercontent.googleapis.com/freebase/v1/image/%@", urlEncodedId]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(),^{
            asyncImageRequest.image = [UIImage imageWithData:imageData];
            asyncImageRequest.requestCompleted = YES;
            travelDestinationCell.image.image = asyncImageRequest.image;
            [asyncImageRequest.indicatorView removeFromSuperview];
        });
    };
    // If the request has already been sent, don't send it again
    if (NO == asyncImageRequest.requestSent) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), blockLoadImage);
    }
    return travelDestinationCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TravelDestination *travelDestination = (TravelDestination *)[self.travelDestinations objectAtIndex:indexPath.item];
        [[segue destinationViewController] setDetailItem:travelDestination];
    }
}

- (void)scrollViewDidScroll: (UIScrollView *)scroll {
//    // UITableView only moves in one direction, y axis
//    NSInteger currentOffset = scroll.contentOffset.y;
//    NSInteger maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
//    
//    // Change 10.0 to adjust the distance from bottom
//    if (maximumOffset - currentOffset <= 50.0) {
//        if (FALSE == self.isLoadingMoreContent && self.offset + 10 < self.count) {
//            self.isLoadingMoreContent = YES;
//            self.offset += 10;
//            
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            NSMutableArray *moreTravelDestinations = [appDelegate.databaseService getTravelDestinations:self.limit  skip:self.offset];
//                                                      for (TravelDestination *travelDestination in moreTravelDestinations) {
//                                                          [self.travelDestinations addObject:travelDestination];
//                                                      }
//            self.isLoadingMoreContent = NO;
//            [self.tableView reloadData];
//        }
//    }
}

@end
