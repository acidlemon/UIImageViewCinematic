//
//  ViewController.h
//  streetlife
//
//  Created by Kawazoe Masatoshi on 12/07/18.
//  Copyright (c) 2012年 Kayac Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView* tableView;


@end
