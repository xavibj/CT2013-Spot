//
//  PhotoVC.m
//  Spot
//
//  Created by W J Bogers on 24-02-13.
//  Copyright (c) 2013 WboSoftware. All rights reserved.
//

#import "PhotoVC.h"

@interface PhotoVC () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (nonatomic) BOOL zoomScalesSpecified;
@end

@implementation PhotoVC

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // There is only one subview, the programmaticatly added imageview
    return scrollView.subviews[0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set the PhotoVC as the delegate for the scrollview
    self.photoScrollView.delegate = self;
    // Get the photo and put it in an imageview
    NSData *photo = [NSData dataWithContentsOfURL:self.photo];
    UIImage *image = [UIImage imageWithData:photo];
    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    iv.contentMode = UIViewContentModeScaleToFill;
    [self.photoScrollView addSubview:iv];
    // Set the scrollview's contentsize to the size of the imageview
    self.photoScrollView.contentSize = iv.bounds.size;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    // Get the image view
    UIImageView *iv = self.photoScrollView.subviews[0];
    // Set minimum and maximum zoomscale to show as much of the photo as possible. Only do this if these values
    // have not been set before
    if (!self.zoomScalesSpecified) {
        if (self.photoScrollView.frame.size.width / iv.frame.size.width > self.photoScrollView.frame.size.height / iv.frame.size.height) {
            self.photoScrollView.minimumZoomScale = self.photoScrollView.frame.size.width / iv.frame.size.width;
        } else {
            self.photoScrollView.minimumZoomScale = self.photoScrollView.frame.size.height / iv.frame.size.height;
        }
        self.photoScrollView.maximumZoomScale = 2.0;
        // Set initial zoomscale to minimum zoomscale (to show as much of the photo as possible)
        self.photoScrollView.zoomScale = self.photoScrollView.minimumZoomScale;
        self.zoomScalesSpecified = YES;
    }
}

@end