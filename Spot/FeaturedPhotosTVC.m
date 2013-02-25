//
//  FeaturedPhotosTVC.m
//  Spot
//
//  Created by W J Bogers on 23-02-13.
//  Copyright (c) 2013 WboSoftware. All rights reserved.
//

#import "FeaturedPhotosTVC.h"
#import "SpotModel.h"
#import "PhotoListTVC.h"

@interface FeaturedPhotosTVC () <PhotoListDelegate>
@property (strong, nonatomic) SpotModel *spotModel;
@property (strong, nonatomic) NSArray *photos;
@end

@implementation FeaturedPhotosTVC

/*===============================
 // Delegate properties / methods
 ==============================*/

-(void)selectedPhoto:(NSDictionary *)photo
{
    // Add the photo which was viewed to the list of recent photos
    [self.spotModel addToRecentPhotos:photo];
}

/*==============================
 // Private properties / methods
 =============================*/

-(SpotModel *)spotModel
{
    if (!_spotModel) _spotModel = [[SpotModel alloc] init];
    return _spotModel;
}

-(NSArray *)photos
{
    if (!_photos) _photos = [[NSArray alloc] init];
    return _photos;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PhotoListTVC class]]) {
        PhotoListTVC *controller = segue.destinationViewController;
        UITableViewCell *cell = sender;
        // Fill the list with photos from the selected category and make this the title
        controller.listOfPhotos = [self.spotModel photosInCategory:cell.textLabel.text];
        controller.title = cell.textLabel.text;
        // Set the featured photo TVC as the delegate for the photo list TVC
        // In this way we can report back which photos were selected, so we can
        // add these to the recent photo list
        controller.delegate = self;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Get a list of all the distinct photo categories
    self.photos = [self.spotModel photoCategories];
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
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the TableView cell
    static NSString *CellIdentifier = @"Featured Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Set test and detail for the cell 
    cell.textLabel.text = self.photos[indexPath.row];
    NSUInteger numberOfPhotos = [self.spotModel numberOfPhotosInCategory:self.photos[indexPath.row]];
    if (numberOfPhotos == 1) {
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%d photo",[self.spotModel numberOfPhotosInCategory:self.photos[indexPath.row]]];
    } else {
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%d photos",[self.spotModel numberOfPhotosInCategory:self.photos[indexPath.row]]];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
