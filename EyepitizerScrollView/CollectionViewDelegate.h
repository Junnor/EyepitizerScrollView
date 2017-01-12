//
//  CollectionViewDelegate.h
//  EyepitizerScrollView
//
//  Created by Ju on 2017/1/12.
//  Copyright © 2017年 Ju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewDelegate : UIViewController
<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

// use weak, avoid cycle reference.
@property (weak, nonatomic) UICollectionView *collectionView;

@end
