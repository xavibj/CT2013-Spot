//
//  PhotoListTVC.h
//  Spot
//
//  Created by W J Bogers on 24-02-13.
//  Copyright (c) 2013 WboSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoListDelegate <NSObject>
@optional
-(void)selectedPhoto:(NSDictionary *)photo;
@end

@interface PhotoListTVC : UITableViewController
@property (strong, nonatomic) NSArray *listOfPhotos;
@property (weak, nonatomic) id <PhotoListDelegate> delegate;
@end
