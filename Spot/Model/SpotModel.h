//
//  SpotModel.h
//  Spot
//
//  Created by W J Bogers on 23-02-13.
//  Copyright (c) 2013 WboSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotModel : NSObject

#define SPOT_TITLE @"spot_title"
#define SPOT_DESCRIPTION @"spot_description"
#define SPOT_ID @"spot_id"
#define SPOT_LARGE_PHOTO @"spot_large_photo"
#define SPOT_ORIGINAL_PHOTO @"spot_original_photo"

-(NSArray *)photoCategories;
-(NSUInteger)numberOfPhotosInCategory:(NSString *)category;
-(NSArray *)photosInCategory:(NSString *)category;
-(void)addToRecentPhotos:(NSDictionary *)photo;
+(NSArray *)recentPhotos;

@end
