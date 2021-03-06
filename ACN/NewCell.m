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
@property(nonatomic ,strong)NSObject *noticia;
@end

@implementation NewCell
@synthesize noticia = _noticia;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setCellWithNoticia:(id)noticia enabled:(BOOL)enabled{
    
    self.noticia = noticia;
    
    NSString *title = nil;
    NSString *subtitle = nil;
    NSString *description = nil;
    NSDate *creation_date = nil;
    NSString * image = nil;
    BOOL isFavourite = NO;
    BOOL useFav = YES;
    
    if ([_noticia isKindOfClass:[Notifications class]]) {
        Notifications *nt = (Notifications *)_noticia;
        title = nt.title;
        subtitle = nt.subtitle;
        description = nt.description;
        creation_date = nt.creation_date;
        image = nt.image;
        isFavourite = [nt.isFavourite boolValue];
        useFav = NO;
    }else{
        Noticia *nt = (Noticia *)_noticia;
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
    
    titleNew.textColor = [UIColor getPrimaryColor];
    dateNew.textColor = [UIColor getgrayColor];
    
    titleNew.text = title;
    [titleNew sizeToFit];
    if(titleNew.width < KMinWidth){
        titleNew.width  = KMinWidth;
    }
    
    dateNew.text = strDate;
    
    if (useFav) {
        favourite.layer.cornerRadius = [favourite width]/2;
        favourite.layer.borderColor = [UIColor getPrimaryColor].CGColor;
        favourite.layer.borderWidth = 7.0f;
        favourite.layer.masksToBounds = YES;
        favourite.enabled = YES;
        
        favourite.backgroundColor = [UIColor clearColor];
        if (isFavourite) {
            favourite.backgroundColor = [UIColor getPrimaryColor];
        }
    }else{
        [favourite setHidden:YES];
    }
}

-(IBAction)makeFavourite:(UIButton *)sender{
    if ([(NSObject*)self.delegate respondsToSelector:@selector(removeNewSelected:)]){
        Noticia *nt = (Noticia *)_noticia;
        [self.delegate removeNewSelected:nt];
    }else{
        Noticia *nt = (Noticia *)_noticia;
        BOOL isStarred = [[nt isFavourite] boolValue];
        if (isStarred) {
            nt.isFavourite = [NSNumber numberWithBool:!isStarred];
            favourite.backgroundColor = [UIColor clearColor];
        }else{
            nt.isFavourite = [NSNumber numberWithBool:!isStarred];
            sender.backgroundColor = [UIColor getPrimaryColor];
        }
        [[DatabaseManager sharedInstance] saveCoreDataContext];
        [sender scaleViewAnimation];
    }
}

@end
