//
//  TravelDestinationCell.m
//  Smart Holiday Ideas
//
//  Created by Richard Knop on 25/05/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "TravelDestinationCell.h"

@implementation TravelDestinationCell

- (IBAction)clickMore:(id)sender {
    self.description.text = self.longDescription;
}

@end
