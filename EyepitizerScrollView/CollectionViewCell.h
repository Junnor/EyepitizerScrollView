//
//  CollectionViewCell.h
//  EyepitizerScrollView
//
//  Created by Ju on 2017/1/12.
//  Copyright © 2017年 Ju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
