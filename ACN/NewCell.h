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
    IBOutlet UILabel *titleNewLabel;
    IBOutlet UILabel *dateNewLabel;
    IBOutlet UIButton *favouriteButton;
}

@property(nonatomic, copy)onClickFavourite clickFavourite;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *subtitle;
@property(nonatomic, strong)NSString *descriptionDetail;
@property(nonatomic, strong)NSDate *creationDate;
@property(nonatomic, strong)NSString *image;
@property(nonatomic)BOOL isFavourite;
@property(nonatomic)BOOL hideButtonFavourite;

@end
