//
//  RecentPhotoListTVC.m
//  Spot
//
//  Created by W J Bogers on 24-02-13.
//  Copyright (c) 2013 WboSoftware. All rights reserved.
//

#import "RecentPhotoListTVC.h"
#import "SpotModel.h"

@interface RecentPhotoListTVC ()

@end

@implementation RecentPhotoListTVC

-(void)viewWillAppear:(BOOL)animated
{
    // Get recent photos
    self.listOfPhotos = [SpotModel recentPhotos];
    [self.tableView reloadData];
}

@end
