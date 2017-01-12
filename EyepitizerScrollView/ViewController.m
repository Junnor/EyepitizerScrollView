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

#define width CGRectGetWidth(self.collectionView.bounds)
#define cellHeight width * 45 / 80

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// 在 headerView 里，你可以替换你需要设置的图片。
@property (strong, nonatomic) HeaderView *headerView;

// 如果设置 scrollHeaderViewUp 为 true，则伴随着 scrollView 的向上滚动，headerView 也会一起向上滚动。
@property (assign, nonatomic) Boolean scrollHeaderViewUp;

@end

@implementation ViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCollectionView];

    // For header view
    NSArray *headerNibs = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    self.headerView = headerNibs.firstObject;
    self.headerView.frame = CGRectMake(0, 0, width, cellHeight);
    [self.view insertSubview:self.headerView belowSubview:self.collectionView];
    
//    self.scrollHeaderViewUp = true;
}


#pragma mark - Helper

- (void)configureCollectionView {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:@"ClearCellID"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"CollectionViewCellID"];
}

#pragma mark - Collection View DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 1 为头部的透明Cell
    return 8 + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        UICollectionViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClearCellID"
                                                                                     forIndexPath:indexPath];
        headerCell.backgroundColor = [UIColor clearColor];
        return headerCell;
    } else {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellID"
                                                                             forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", indexPath.item + 19]];
        cell.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
        return cell;
    }
}

#pragma mark - Collection View Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(width, cellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CATransform3D headerTransform = CATransform3DIdentity;
    
    if (offsetY < 0) {  // 向下滚动
        CGFloat headerScaleFactor = -(offsetY) / self.headerView.bounds.size.height;
        CGFloat headerSizevariation = ((self.headerView.bounds.size.height * (1.0 + headerScaleFactor)) - self.headerView.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        self.headerView.layer.transform = headerTransform;
    } else {            // 向上滚动
        if (self.scrollHeaderViewUp) {
            headerTransform = CATransform3DTranslate(headerTransform, 0, -offsetY, 0);
            self.headerView.layer.transform = headerTransform;
        }
    }
}


@end
