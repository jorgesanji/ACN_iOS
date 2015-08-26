//
//  UILabel+AppFunctions.h
//  ACN
//
//  Created by Flamingo Partners on 11/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (AppFunctions)

-(void)setTapWithTarget:(id)target selector:(SEL)selector;

- (void) boldSubstring: (NSString*) substring withFontName:(NSString *)fontname withUnderline:(BOOL)underLine;

- (void) boldRange: (NSRange) range withFontName:(NSString *)fontname withUnderline:(BOOL)underLine;

@end
