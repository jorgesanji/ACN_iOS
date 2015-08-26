//
//  NewCell.h
//  ACN
//
//  Created by Flamingo Partners on 6/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewCell;
@class Noticia;
@protocol NewCellDelegate <NSObject>
@optional
- (void)removeNewSelected:(Noticia *)noticia;
@end

@interface NewCell : UITableViewCell{
    IBOutlet UILabel *titleNew;
    IBOutlet UILabel *dateNew;
    IBOutlet UIButton *favourite;
}

@property(nonatomic, assign)id<NewCellDelegate>delegate;

-(void)setCellWithNoticia:(id)noticia enabled:(BOOL)enabled;

@end
