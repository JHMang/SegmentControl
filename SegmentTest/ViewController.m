//
//  ViewController.m
//  SegmentTest
//
//  Created by 马锦航 on 16/8/18.
//  Copyright © 2016年 JHMang. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewCell.h"


#define ColorI(c) [UIColor colorWithRed:((c>>16)&0xff)/255.0 green:((c>>8)&0xff)/255.0 blue:(c&0xff)/255.0 alpha:1.0] // ColorI(0xbfbfbf)

#define ColorI_A(c,a) [UIColor colorWithRed:((c>>16)&0xff)/255.0 green:((c>>8)&0xff)/255.0 blue:(c&0xff)/255.0 alpha:a] // ColorI(0xbfbfbf)

@interface ViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UISegmentedControl * segmentedControl;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UICollectionView * collectionView;
@end

@implementation ViewController

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"全部",@"被查看",@"待沟通",@"面试",@"不合适"]];
        _segmentedControl.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 30);
        _segmentedControl.tintColor = [UIColor clearColor];//去掉颜色,现在整个segment都看不见
        
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                   NSForegroundColorAttributeName: ColorI(0x989898)};
        [_segmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        
        NSDictionary* unselectedTextAttributes2 = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                                   NSForegroundColorAttributeName: ColorI(0x1BB28B)};
        [_segmentedControl setTitleTextAttributes:unselectedTextAttributes2 forState:UIControlStateSelected];
        _segmentedControl.backgroundColor = ColorI(0xF7F7FA);
        [_segmentedControl addTarget:self action:@selector(segmentSelectedAction:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 94, [UIScreen mainScreen].bounds.size.width, 3);
        _scrollView.backgroundColor = ColorI(0xF7F7FA);
        [_scrollView addSubview:[self borderLine]];
    }
    return _scrollView;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 97);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 97, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 97) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
        _collectionView.bounces = NO;
        
    }
    return _collectionView;
}


#pragma mark - application

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
    self.navigationItem.title = @"简历状态";
}

#pragma mark - view
- (void) loadSubviews {
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.collectionView];
}

- (UIView *) borderLine {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/self.segmentedControl.numberOfSegments, 3)];
    view.backgroundColor = ColorI(0x1BB28B);
    return view;
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.segmentedControl.numberOfSegments;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = [UIColor orangeColor].CGColor;
    cell.layer.borderWidth = 2;
    return cell;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        self.scrollView.contentOffset = CGPointMake(-self.collectionView.contentOffset.x/self.segmentedControl.numberOfSegments, 0);
    }
}

// 已经滑动完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.segmentedControl.selectedSegmentIndex = -self.scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width*self.segmentedControl.numberOfSegments;
}

#pragma mark - action
- (void) segmentSelectedAction:(UISegmentedControl *) segmentedController {
    [self.scrollView setContentOffset:CGPointMake(-([UIScreen mainScreen].bounds.size.width/self.segmentedControl.numberOfSegments)*self.segmentedControl.selectedSegmentIndex, 0) animated:YES];
}

@end
