//
//  MenuVC.h
//  DimecCuba
//
//  Created by Flamingo Partners on 27/09/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuVC : UIViewController{
    IBOutlet UITableView *table;
}

+(instancetype)getInstance;
-(void)reloadMenu;
-(void)LaunchAlerts;

@end
