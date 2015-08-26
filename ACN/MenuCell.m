//
//  MenuCell.m
//  ACN
//
//  Created by Flamingo Partners on 6/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "MenuCell.h"
#import "Categorias.h"
#import "UIView+Frame.h"
#import "UIColor+CustomColorsApp.h"
#import <QuartzCore/QuartzCore.h>
#import "LocalizationHelper.h"

@implementation MenuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor getPrimaryColor];
    [self setSelectedBackgroundView:bgColorView];
    if (self.isSelected) {
        titleNew.textColor = [UIColor whiteColor];
        dateUpdated.textColor = [UIColor whiteColor];
        [thumb setBackgroundColor:[UIColor whiteColor]];
        
    }else{
        titleNew.textColor = [UIColor blackColor];
        dateUpdated.textColor = [UIColor getgrayColor];
        [thumb setBackgroundColor:[UIColor getPrimaryColor]];
    }
}


-(void)setCellWithCategorias:(Categorias *)categoria{
    
    NSLog(@"%@",categoria.name);
    
    titleNew.text = categoria.name;
    titleNew.textColor = [UIColor blackColor];
    dateUpdated.textColor = [UIColor getgrayColor];
    
    if ([categoria.isLocal boolValue] || !categoria.date_updated) {
        dateUpdated.hidden = YES;
        titleNew.top = self.height/2 - titleNew.height/2;
    }else{
        dateUpdated.hidden = NO;
        titleNew.top = 4.0f;
        dateUpdated.top = 18.0f;
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"dd/MM/yyyy HH:mm"];
        NSString *strDate = [dateFormater stringFromDate:categoria.date_updated];
        
        dateUpdated.text = [NSString stringWithFormat:@"%@%@",[LocalizationHelper getUpdate],strDate];
    }
    
    thumb.hidden = YES;
    //is favourite
    if ([categoria.id_categoria intValue] == -1 && [categoria.type intValue] != -1) {
        thumb.hidden = NO;
        [thumb setBackgroundColor:[UIColor getPrimaryColor]];
        thumb.layer.cornerRadius = thumb.height/2;
        thumb.layer.masksToBounds = YES;
    }
}

@end
