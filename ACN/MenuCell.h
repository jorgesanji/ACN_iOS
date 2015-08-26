//
//  MenuCell.h
//  ACN
//
//  Created by Flamingo Partners on 6/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Categorias;
@interface MenuCell : UITableViewCell{
    IBOutlet UIImageView *thumb;
    IBOutlet  UILabel *titleNew;
    IBOutlet UILabel *dateUpdated;
}

-(void)setCellWithCategorias:(Categorias *)categoria;

@end
