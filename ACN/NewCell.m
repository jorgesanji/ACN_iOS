//
//  NewCell.m
//  ACN
//
//  Created by Flamingo Partners on 6/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "NewCell.h"
#import "Notifications.h"
#import "Noticia.h"
#import "UIColor+CustomColorsApp.h"
#import "UIView+Frame.h"
#import "DatabaseManager.h"
#import "UIView+Frame.h"

#define KMinWidth 200.0f

@interface NewCell()
@end

@implementation NewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setCellWithNoticia:(id)noticia enabled:(BOOL)enabled{
    
    NSString *title = nil;
    NSString *subtitle = nil;
    NSString *description = nil;
    NSDate *creation_date = nil;
    NSString * image = nil;
    BOOL isFavourite = NO;
    BOOL useFav = YES;
    
    if ([noticia isKindOfClass:[Notifications class]]) {
        Notifications *nt = (Notifications *)noticia;
        title = nt.title;
        subtitle = nt.subtitle;
        description = nt.description;
        creation_date = nt.creation_date;
        image = nt.image;
        isFavourite = [nt.isFavourite boolValue];
        useFav = NO;
    }else{
        Noticia *nt = (Noticia *)noticia;
        title = nt.title;
        subtitle = nt.subtitle;
        description = nt.descriptionFeed;
        creation_date = nt.creation_date;
        isFavourite = [nt.isFavourite boolValue];
    }
    
    NSString *strDate = @"";
    
    if (creation_date) {
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormater setDateFormat:@"dd/MM/yyyy HH:mm"];
        strDate = [dateFormater stringFromDate:creation_date];
    }
    
    dateNew.text = strDate;
    dateNew.textColor = [UIColor getgrayColor];
    
    titleNew.textColor = [UIColor getPrimaryColor];
    titleNew.text = title;
    [titleNew sizeToFit];
    titleNew.width  = (titleNew.width < KMinWidth) ? KMinWidth : titleNew.width;
    
    if (useFav) {
        favourite.layer.cornerRadius = [favourite width]/2;
        favourite.layer.borderColor = [UIColor getPrimaryColor].CGColor;
        favourite.layer.borderWidth = 7.0f;
        favourite.layer.masksToBounds = YES;
        favourite.enabled = YES;
        favourite.backgroundColor = (isFavourite) ? [UIColor getPrimaryColor] : [UIColor clearColor];
    }else{
        [favourite setHidden:YES];
    }
}

-(IBAction)makeFavourite:(UIButton *)sender{
        
    if (_clickFavourite) {
        _clickFavourite(sender);
    }
}

@end
