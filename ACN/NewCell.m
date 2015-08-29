//
//  NewCell.m
//  ACN
//
//  Created by Flamingo Partners on 6/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "NewCell.h"
#import "UIColor+CustomColorsApp.h"
#import "UIView+Frame.h"
#import "UIView+Frame.h"
#import "Common.h"

@interface NewCell()
@end

@implementation NewCell

- (void)awakeFromNib {
    // Initialization code
    [self initUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    dateNewLabel.textColor = [UIColor getgrayColor];
    titleNewLabel.textColor = [UIColor getPrimaryColor];
    favouriteButton.layer.cornerRadius = [favouriteButton width]/2;
    favouriteButton.layer.borderColor = [UIColor getPrimaryColor].CGColor;
    favouriteButton.layer.borderWidth = 7.0f;
    favouriteButton.layer.masksToBounds = YES;
}

-(IBAction)makeFavourite:(UIButton *)sender{
    if (_clickFavourite) {
        _clickFavourite(sender);
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
}

#pragma mark - Public methods

- (void)setTitle:(NSString *)title{
    _title = title;
    titleNewLabel.text = title;
    [titleNewLabel sizeToFit];
    titleNewLabel.width  = (titleNewLabel.width < KMinWidth) ? KMinWidth : titleNewLabel.width;
}

- (void)setSubtitle:(NSString *)subtitle{
    _subtitle = subtitle;
}

- (void)setDescriptionDetail:(NSString *)descriptionDetail{
    _descriptionDetail = descriptionDetail;
}

-(void)setCreationDate:(NSDate *)creationDate{
    _creationDate = creationDate;
    if (creationDate) {
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormater setDateFormat:@"dd/MM/yyyy HH:mm"];
        dateNewLabel.text = [dateFormater stringFromDate:creationDate];
    }
}

-(void)setImage:(NSString *)image{
    _image = image;
}

-(void)setIsFavourite:(BOOL)isFavourite{
    favouriteButton.backgroundColor = (isFavourite) ? [UIColor getPrimaryColor] : [UIColor clearColor];
}

- (void) setHideButtonFavourite:(BOOL)hideButtonFavourite{
    _hideButtonFavourite = hideButtonFavourite;
    [favouriteButton setHidden:hideButtonFavourite];
}

@end
