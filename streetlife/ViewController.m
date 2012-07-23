//
//  ViewController.m
//  streetlife
//
//  Created by Kawazoe Masatoshi on 12/07/18.
//  Copyright (c) 2012年 Kayac Inc. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCellCell.h"
#import "UIImageView+Cinematic.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray* descriptions;
@property (strong, nonatomic) NSArray* images;

@end

@implementation ViewController

@synthesize tableView = _tableView;
@synthesize descriptions = _descriptions;
@synthesize images = _images;


- (void)loadItems {
    self.descriptions = [NSArray arrayWithObjects:
                         @"船にのりました。",
                         @"もうすぐ着きそう!",
                         @"暑くてうさぎも伸びています",
                         @"島にはビーチもあって涼しげです。",
                         @"日陰にかたまるうさぎ達。",
                         @"思い思いにたれるうさぎのたまり場。",
                         @"うさうさ",
                         @"以上、れもんがお届けしました。",
                         @"Street Life",
                         nil];
    self.images = [NSArray arrayWithObjects:
                   [UIImage imageNamed:@"IMG_1643.JPG"],
                   [UIImage imageNamed:@"IMG_1653.JPG"],
                   [UIImage imageNamed:@"IMG_1669.JPG"],
                   [UIImage imageNamed:@"IMG_1671.JPG"],
                   [UIImage imageNamed:@"IMG_1679.JPG"],
                   [UIImage imageNamed:@"IMG_1680.JPG"],
                   [UIImage imageNamed:@"IMG_1709.JPG"],
                   [UIImage imageNamed:@"IMG_1778.JPG"],
                   [UIImage imageNamed:@"streetlife.png"],
                   nil];
    
    assert([self.images count] == [self.descriptions count]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadItems];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [CustomTableViewCellCell heightForCell:200
                                             text:[self.descriptions objectAtIndex:indexPath.row]
                                            image:[self.images objectAtIndex:indexPath.row]
                                           square:(indexPath.row % 3 == 2)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.images count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* const cellIdentifier = @"Street Life";
    CustomTableViewCellCell* cell = (CustomTableViewCellCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[CustomTableViewCellCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = [self.descriptions objectAtIndex:indexPath.row];
    cell.thumbnailView.image = [self.images objectAtIndex:indexPath.row];
    cell.frame = CGRectMake(0, 0, self.tableView.bounds.size.width,
                            [CustomTableViewCellCell heightForCell:200
                                                              text:[self.descriptions objectAtIndex:indexPath.row]
                                                             image:[self.images objectAtIndex:indexPath.row]
                                                            square:(indexPath.row % 3 == 2)]);
    if (indexPath.row % 2 == 1) {
        cell.alignRight = YES;
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.95 blue:0.95 alpha:1.0];
    } else {
        cell.alignRight = NO;
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    
    if (indexPath.row % 3 == 2) {
        cell.squareFill = YES;
    } else {
        cell.squareFill = NO;
    }
    
    
    return cell;
}

@end
