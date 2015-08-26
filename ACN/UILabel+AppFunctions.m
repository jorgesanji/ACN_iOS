//
//  UILabel+AppFunctions.m
//  ACN
//
//  Created by Flamingo Partners on 11/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "UILabel+AppFunctions.h"

@implementation UILabel (AppFunctions)

-(void)setTapWithTarget:(id)target selector:(SEL)selector{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector
                                   ];
    [tap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tap];
    
}


- (void)boldSubstring: (NSString*)substring withFontName:(NSString *)fontname withUnderline:(BOOL)underLine{
    
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range withFontName:fontname withUnderline:underLine];
    
}

- (void) boldRange: (NSRange) range withFontName:(NSString *)fontname withUnderline:(BOOL)underLine{
    
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    }
    
    if (fontname) {
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontname size:self.font.pointSize]} range:range];
    }else{
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font.pointSize]} range:range];
    }
    
    if (underLine) {
        [attributedText addAttribute:NSUnderlineStyleAttributeName
                               value:[NSNumber numberWithInt:1]
                               range:range];
    }
    
    self.attributedText = attributedText;
    
}

@end
