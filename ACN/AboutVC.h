//
//  AboutVC.h
//  ACN
//
//  Created by Flamingo Partners on 6/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutVC : UIViewController{
    IBOutlet UILabel *titleAbout;
    IBOutlet UILabel *contentAbout;
    IBOutlet UIView *separatorAbout;
    IBOutlet UIScrollView *contentAboutScroll;
}

@end
