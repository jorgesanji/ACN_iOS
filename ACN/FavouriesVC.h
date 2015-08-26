//
//  FavouriesVC.h
//  ACN
//
//  Created by Flamingo Partners on 6/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const reloadNewsNotification = @"reload_news";

@interface FavouriesVC : UIViewController{
    IBOutlet UITableView *table;
    IBOutlet UILabel *noFavourites;
    IBOutlet UISearchBar *searchBar;
}

+(instancetype)getInstance;

@end
