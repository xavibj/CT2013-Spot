//
//  SpotModel.m
//  Spot
//
//  Created by W J Bogers on 23-02-13.
//  Copyright (c) 2013 WboSoftware. All rights reserved.
//

#import "SpotModel.h"
#import "FlickrFetcher.h"

@interface SpotModel()
@property (strong,nonatomic) NSMutableArray *stanfordPhotos;
@end

@implementation SpotModel

#define SPOT_CATEGORY @"category"
#define USER_DEFAULTS_KEY @"Spot.RecentPhotos"

/*==============================
 // Private properties / methods
 =============================*/

-(NSMutableArray *)stanfordPhotos
{
    // Lazy instantiation of our array with Stanford photos
    if (!_stanfordPhotos) {
        _stanfordPhotos = [[FlickrFetcher stanfordPhotos] mutableCopy];
        // Add the key "category" to the dictionary object (i.e. the photos)
        if (_stanfordPhotos) [self addCategoryToPhoto];
    }
    return _stanfordPhotos;
}

-(void)addCategoryToPhoto
{
    // Add the key "category" to each photo dictionary in the array with Stanford
    // photos: this makes it easier to find photos for a specific category and count
    // them.
    for (NSMutableDictionary *photo in self.stanfordPhotos) {
        NSArray *tags = [[photo valueForKey:FLICKR_TAGS] componentsSeparatedByString:@" "];
        NSString *subject = @"";
        for (NSString *tag in tags) {            
            if (![tag isEqualToString:@"cs193pspot"] &&
                ![tag isEqualToString:@"portrait"] &&
                ![tag isEqualToString:@"landscape"]) {
                subject = [tag capitalizedString];
                [photo setObject:subject forKey:SPOT_CATEGORY];
            }
        }
    }
}

-(NSString *)descriptionOfPhoto:(NSDictionary *)photo
{
    // Returns the description of a photo. If no desciption is specified,
    // then a string is return informing the user of this fact.
    NSString *description = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([description isEqualToString:@""]) {
        description = @"No description specified";
    }
    return [description capitalizedString];;
}

/*=============================
 // Public properties / methods
 ============================*/

-(NSArray *)photoCategories
{
    // Determine the unique categories in our collection of Stanford photos
    NSMutableOrderedSet *subjects = [[NSMutableOrderedSet alloc] init];
    for (NSDictionary *photo in self.stanfordPhotos) {
        [subjects addObject:[photo valueForKey:SPOT_CATEGORY]];
    }
    // Return sorted array: nicer presentation
    return [[subjects array] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

-(NSArray *)photosInCategory:(NSString *)category
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSDictionary *photo in self.stanfordPhotos) {
        if ([[photo valueForKey:SPOT_CATEGORY] isEqualToString:category]) {
            // Get url's for large and original formats of the photo
            NSURL *photoLarge = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
            NSURL *photoOriginal = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatOriginal];
            // Add a dictionary object to our array. Note that we have to convert the NSURL
            // to string (to store in NSUserDefaults later on, property list!)
            [photos addObject:
             @{SPOT_TITLE:[photo valueForKey:FLICKR_PHOTO_TITLE],
             SPOT_DESCRIPTION:[self descriptionOfPhoto:photo],
             SPOT_ID:[photo valueForKey:FLICKR_PHOTO_ID],
             SPOT_LARGE_PHOTO:[photoLarge absoluteString],
             SPOT_ORIGINAL_PHOTO:[photoOriginal absoluteString]}];
        }
    }
    return [photos copy];
}

-(NSUInteger)numberOfPhotosInCategory:(NSString *)category;
{
    // Determine the number of photos with the specified category
    NSUInteger numberOfPhotos = 0;
    for (NSDictionary *photo in self.stanfordPhotos) {
        if ([[photo valueForKey:SPOT_CATEGORY] isEqualToString:category]) {
            numberOfPhotos++;
        }
    }
    return numberOfPhotos;
}

-(void)addToRecentPhotos:(NSDictionary *)photo
{
    // Add a photo to the list of recent photos (NSUserDefaults)
    NSUserDefaults *settings = [[NSUserDefaults alloc] init];
    NSMutableArray *recentPhotos = [settings mutableArrayValueForKey:USER_DEFAULTS_KEY];
    if (recentPhotos.count == 0) {
        // No recents yet? => add
        [recentPhotos addObject:photo];
    } else {
        // Recents present? => insert at the top (position 0)
        [recentPhotos insertObject:photo atIndex:0];
    }
    if (recentPhotos.count > 15) {
        // Only allow 15 recent photos => remove oldest if there are more
        [recentPhotos removeLastObject];
    }
    // Update user defaults
    [settings setObject:[recentPhotos copy] forKey:USER_DEFAULTS_KEY];
    [settings synchronize];
}

+(NSArray *)recentPhotos
{
    // Fill the array with recently viewed photos: these photos are stored
    // in NSUserDefaults.
    NSUserDefaults *settings = [[NSUserDefaults alloc] init];
    return [settings arrayForKey:USER_DEFAULTS_KEY];
}

@end
