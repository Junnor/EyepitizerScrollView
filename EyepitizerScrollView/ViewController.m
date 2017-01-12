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
#import "ScrollContentView.h"

#define width CGRectGetWidth(self.scrollView.bounds)

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// 在 headerView 里，你可以替换你需要设置的图片。
@property (strong, nonatomic) HeaderView *headerView;

// 你可以添加想要的视图到 scrollContentView， 比如 UICollectionView 或 UITableView 等。
@property (strong, nonatomic) ScrollContentView *scrollContentView;

// 如果设置 scrollHeaderViewUp 为 true，则伴随着 scrollView 的向上滚动，headerView 也会一起向上滚动。
@property (assign, nonatomic) Boolean scrollHeaderViewUp;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // For header view
    CGFloat headerViewHeight = width * 45/80;
    NSArray *headerNibs = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    self.headerView = headerNibs.firstObject;
    self.headerView.frame = CGRectMake(0, 0, width, headerViewHeight);
    [self.view insertSubview:self.headerView belowSubview:self.scrollView];
    
    // For content view
    NSArray *contentNibs = [[NSBundle mainBundle] loadNibNamed:@"ScrollContentView" owner:self options:nil];
    self.scrollContentView = contentNibs.firstObject;
    self.scrollContentView.frame = CGRectMake(0, headerViewHeight, width, 1000 - headerViewHeight);
    [self.scrollView addSubview:self.scrollContentView];
    
    // For scroll view stuff
    self.scrollView.contentSize = CGSizeMake(width, 1000);
    self.scrollView.delegate = self;
    
    
//    self.scrollHeaderViewUp = true;
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
