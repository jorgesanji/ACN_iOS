//
//  NewCell.h
//  ACN
//
//  Created by Flamingo Partners on 6/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onClickFavourite)(UIButton *sender);

@interface NewCell : UITableViewCell{
    IBOutlet UILabel *titleNew;
    IBOutlet UILabel *dateNew;
    IBOutlet UIButton *favourite;
}

@property(nonatomic, copy)onClickFavourite clickFavourite;

-(void)setCellWithNoticia:(id)noticia enabled:(BOOL)enabled;

@end
