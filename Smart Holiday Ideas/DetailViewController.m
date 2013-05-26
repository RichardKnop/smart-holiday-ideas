//
//  DetailViewController.m
//  Smart Holiday Ideas
//
//  Created by Richard Knop on 25/05/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "DetailViewController.h"

#import "TravelDestination.h"
#import <MapKit/MapKit.h>

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(TravelDestination *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configure];
    }
}

- (void)configure
{
    // Update the user interface for the detail item.
    
    if (_detailItem) {
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        MKCoordinateRegion region;
        region.center.latitude = [_detailItem.latitude doubleValue];
        region.center.longitude = [_detailItem.longitude doubleValue];
        region.span.longitudeDelta = 8.0;
        region.span.latitudeDelta = 8.0;
        mapView.showsUserLocation = NO;
        [mapView setScrollEnabled:YES];
        [mapView setRegion:region];
        [self.view addSubview:mapView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self configureDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing the map view


@end
