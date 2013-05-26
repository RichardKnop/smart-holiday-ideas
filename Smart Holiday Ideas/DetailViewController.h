//
//  DetailViewController.h
//  Smart Holiday Ideas
//
//  Created by Richard Knop on 25/05/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TravelDestination.h"
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) TravelDestination *detailItem;
@property (strong, nonatomic) UIImage *cachedImage;

- (void)configure;

@end
