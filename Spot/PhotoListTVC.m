//
//  PhotoListTVC.m
//  Spot
//
//  Created by W J Bogers on 24-02-13.
//  Copyright (c) 2013 WboSoftware. All rights reserved.
//

#import "PhotoListTVC.h"
#import "PhotoVC.h"

@interface PhotoListTVC ()
//
@end

@implementation PhotoListTVC

#define SPOT_TITLE @"spot_title"
#define SPOT_DESCRIPTION @"spot_description"
#define SPOT_ID @"spot_id"
#define SPOT_LARGE_PHOTO @"spot_large_photo"
#define SPOT_ORIGINAL_PHOTO @"spot_original_photo"

/*=============================
 // Public properties / methods
 ============================*/

-(NSArray *)listOfPhotos
{
    if (!_listOfPhotos) _listOfPhotos = [[NSArray alloc] init];
    return _listOfPhotos;
}

/*==============================
 // Private properties / methods
 =============================*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PhotoVC class]]) {
        PhotoVC *controller = segue.destinationViewController;
        UITableViewCell *cell = sender;
        // Get the index path for the selected cell
        NSIndexPath *index= [self.tableView indexPathForCell:cell];
        // Convert the NSString url to an NSURL url.
        NSString *pathAsString = [self.listOfPhotos[index.row] valueForKey:SPOT_LARGE_PHOTO];
        NSURL *pathAsUrl = [[NSURL alloc] initWithString:pathAsString];
        // Set photo and title of PhotoVC
        controller.photo = pathAsUrl;
        controller.title = cell.textLabel.text;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listOfPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the TableView cell
    static NSString *CellIdentifier = @"Photo details";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Set text and detail for the cell
    cell.textLabel.text = [self.listOfPhotos[indexPath.row] valueForKey:SPOT_TITLE];
    cell.detailTextLabel.text = [self.listOfPhotos[indexPath.row] valueForKey:SPOT_DESCRIPTION];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // When a photo in the list is selected, we give it back to the featured photo TVC
    // by means of delegation. The featured photo TVC can then call the model to add a
    // recent photo to the list.
    [self.delegate selectedPhoto:self.listOfPhotos[indexPath.row]];
}

@end
