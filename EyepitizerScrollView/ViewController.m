//
//  ViewController.m
//  EyepitizerScrollView
//
//  Created by Ju on 2017/1/12.
//  Copyright © 2017年 Ju. All rights reserved.
//
// 文章参考 http://www.thinkandbuild.it/implementing-the-twitter-ios-app-ui/
// 部分图片来自 https://github.com/ole/CollectionViewParallaxScrolling

#import "ViewController.h"

#import "HeaderView.h"
#import "CollectionViewCell.h"

#define cellWidth CGRectGetWidth(self.collectionView.bounds)
#define cellHeight cellWidth * 45 / 80


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// 在 headerView 里，你可以替换你需要设置的图片。
@property (strong, nonatomic) HeaderView *headerView;

// 如果设置 scrollHeaderViewUp 为 true，则伴随着 scrollView 的向上滚动，headerView 也会一起向上滚动。
@property (assign, nonatomic) Boolean scrollHeaderViewUp;

@end


@implementation ViewController

static NSString* const clearCellId = @"ClearCellIdentifier";
static NSString* const contentCellId = @"CollectionViewCellID";
static CGFloat const maxShadowAlpha = 0.5;

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // For collection view
    [self configureCollectionView];
    
    // For header view
    [self configureHeaderView];

    // For header view scroll effect
    self.scrollHeaderViewUp = true;
}


#pragma mark - Helper

- (void)configureHeaderView {
    NSArray *headerNibs = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    self.headerView = headerNibs.firstObject;
    self.headerView.frame = CGRectMake(0, 0, cellWidth, cellHeight);
    [self.view insertSubview:self.headerView belowSubview:self.collectionView];
}

- (void)configureCollectionView {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // For clear cell
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:clearCellId];
    // For content cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:contentCellId];
    
    // Set layout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
}

#pragma mark - Collection View DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 1 为头部的透明Cell
    return 8 + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        UICollectionViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:clearCellId
                                                                                     forIndexPath:indexPath];
        headerCell.backgroundColor = [UIColor clearColor];
        return headerCell;
    } else {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:contentCellId
                                                                             forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", indexPath.item + 19]];
        cell.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
        return cell;
    }
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {  // clear cell
        NSLog(@"... It's clear cell, and the item = %ld", (long)indexPath.item);
    } else {   // content cell
        NSLog(@"### It's content cell, and the item = %ld", (long)indexPath.item);
    }
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CATransform3D headerTransform = CATransform3DIdentity;
    
    if (offsetY < 0) {  // 向下滚动
        // header view 的缩放
        CGFloat headerScaleFactor = -(offsetY) / self.headerView.bounds.size.height;
        CGFloat headerSizevariation = ((self.headerView.bounds.size.height * (1.0 + headerScaleFactor)) - self.headerView.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        self.headerView.layer.transform = headerTransform;
        
        // !self.scrollHeaderViewUp 条件下 header view 的阴影效果
        if (!self.scrollHeaderViewUp && self.headerView.shadowView.alpha > 0.0) {
            headerScaleFactor = -headerScaleFactor * maxShadowAlpha;
            CGFloat currentAlpha = self.headerView.shadowView.alpha;
            self.headerView.shadowView.alpha = currentAlpha + headerScaleFactor;
        }
    } else {   // 向上滚动
        if (self.scrollHeaderViewUp) {   // header view 一起滚动
            headerTransform = CATransform3DTranslate(headerTransform, 0, -offsetY, 0);
            self.headerView.layer.transform = headerTransform;
        } else {   // 设置滚动阴影
            CGFloat headerScaleFactor = (offsetY) / self.headerView.bounds.size.height * maxShadowAlpha;
            if (headerScaleFactor <= maxShadowAlpha) {
                self.headerView.shadowView.alpha = headerScaleFactor;
            }
        }
    }
}


@end
