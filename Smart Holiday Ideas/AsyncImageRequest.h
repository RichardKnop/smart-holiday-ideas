//
//  AsyncImageRequest.h
//  Smart Holiday Ideas
//
//  Created by Richard Knop on 26/05/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncImageRequest : NSObject

@property (nonatomic, assign) BOOL requestSent;
@property (nonatomic, assign) BOOL requestCompleted;
@property (nonatomic, retain) UIView *indicatorView;
@property (strong, nonatomic) UIImage *image;

@end
