//
//  MainVC.h
//  DimecCuba
//
//  Created by Flamingo Partners on 27/09/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@class Categorias;
@interface MainVC : UIViewController<SlideNavigationControllerDelegate>{
    IBOutlet UITableView *table;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIActivityIndicatorView *activ;
}

-(void)cleanData;
-(void)getNewsByCategory:(Categorias *)categoria cadena:(NSString *)cadena;
@end
