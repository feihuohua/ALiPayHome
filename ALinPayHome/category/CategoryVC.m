//
//  CategoryVC.m
//  ALinPayHome
//
//  Created by Qing Chang on 2017/6/13.
//  Copyright © 2017年 Qing Chang. All rights reserved.
//

#import "CategoryVC.h"
#import "Macro.h"
#import "CategoryHomeAppView.h"
#import "CategoryShowHomeAppView.h"
#import "GategroyNavView.h"
#import "GategroyShowNavView.h"
#import "CategoryCollectionCell.h"
#import "CollectionReusableHeaderView.h"
#import "CollectionReusableFooterView.h"

@interface CategoryVC ()<CategoryHomeAppViewDelegate,GategroyShowNavViewDelegate,GategroyNavViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat showHomeAppViewH;
    CGFloat appCollectionViewH;
}
@property (nonatomic, strong) NSMutableArray *homeDataArray;
@property (nonatomic, strong) UIScrollView *categoryScrollView;
@property (nonatomic, strong) CategoryShowHomeAppView *showHomeAppView;
@property (nonatomic, strong) CategoryHomeAppView *homeAppView;
@property (nonatomic, strong) GategroyNavView *navView;
@property (nonatomic, strong) GategroyShowNavView *showNavView;
@property (nonatomic, strong) UICollectionView *appCollectionView;

@end

const CGFloat navViewH = 64;
const CGFloat homeAppViewH = 44;
const CGFloat homeAppBackViewH = 280;
const CGFloat spacing = 8;
const CGFloat collectionReusableViewH = 40;

static NSString *const cellId = @"CategoryCollectionCell";
static NSString *const headerId = @"CollectionReusableHeaderView";
static NSString *const footerId = @"CollectionReusableFooterView";

@implementation CategoryVC


- (NSMutableArray *)homeDataArray{
    if (_homeDataArray == nil) {
        _homeDataArray = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 6; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%d",i];
            [_homeDataArray addObject:imageName];
        }
    }
    return _homeDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self subView];
    
}

- (void)subView{
    self.navView = [GategroyNavView createWithXib];
    self.navView.frame = CGRectMake(0, 0, kFBaseWidth, navViewH);
    [self.view addSubview:self.navView];
    self.navView.delegate = self;
    
    self.showNavView = [GategroyShowNavView createWithXib];
    self.showNavView.frame = CGRectMake(0, 0, kFBaseWidth, navViewH);
    self.showNavView.alpha = 0;
    [self.view addSubview:self.showNavView];
    self.showNavView.delegate = self;
    
    self.categoryScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navViewH, kFBaseWidth, kFBaseHeight-navViewH)];
    self.categoryScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.categoryScrollView];
    self.categoryScrollView.backgroundColor = [UIColor whiteColor];
    
    self.homeAppView = [CategoryHomeAppView createWithXib];
    self.homeAppView.frame= CGRectMake(0, 0, kFBaseWidth, homeAppViewH);
    [self.categoryScrollView addSubview:self.homeAppView];
    self.homeAppView.delegate = self;
    
    self.showHomeAppView = [CategoryShowHomeAppView createWithXib];
    [self setUphomeFunctionArrayCount:self.showHomeAppView.homeAppArray.count];
    [self.categoryScrollView addSubview:self.showHomeAppView ];
    self.showHomeAppView .alpha = 0;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake(kFBaseWidth/5, KFAppHeight/3);
    
    self.appCollectionView.backgroundColor = [UIColor whiteColor];
    // 行数 * 单个app的高度 * 组数
    CGFloat number;
    if ((self.homeDataArray.count % 4) > 0) {
        number = self.homeDataArray.count / 4 + 1;
    }else{
        number = self.homeDataArray.count / 4;
    }
    CGFloat appH = (number * (homeAppBackViewH / 3 - 10.3) + collectionReusableViewH)  * self.homeDataArray.count;
    
    appCollectionViewH = appH + (homeAppViewH+spacing);
    self.appCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, homeAppViewH+spacing, kFBaseWidth, appCollectionViewH) collectionViewLayout:layout];
    
    self.categoryScrollView.contentSize = CGSizeMake(0, appCollectionViewH);
    [self.categoryScrollView addSubview:self.appCollectionView];
    self.appCollectionView.backgroundColor = [UIColor whiteColor];
    self.appCollectionView.delegate = self;
    self.appCollectionView.dataSource = self;
    [self.appCollectionView  registerNib:[UINib nibWithNibName:NSStringFromClass([CategoryCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:cellId];
    
    UINib *cellHeaderNib = [UINib nibWithNibName:NSStringFromClass([CollectionReusableHeaderView class]) bundle:nil];
    UINib *cellFooterNib = [UINib nibWithNibName:NSStringFromClass([CollectionReusableFooterView class]) bundle:nil];
    [self.appCollectionView registerNib:cellHeaderNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    
   [self.appCollectionView registerNib:cellFooterNib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
}

#pragma mark CategoryHomeAppViewDelegate
// 编辑
- (void)categoryHomeAppViewWithEdit:(CategoryHomeAppView *)edit{
    [self showSubView:NO];
}

#pragma mark GategroyShowNavViewDelegate
// 取消
- (void)setUpGategroyShowNavViewWithCancel{
    [self showSubView:YES];
}

// 完成
- (void)setUpGategroyShowNavViewWithComplete{
    [self showSubView:YES];
}

#pragma mark GategroyNavViewDelegate
// 返回
- (void)setUpGategroyNavViewPopHomeVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showSubView:(BOOL)show{
    if (show) {
        [self setUpInteractivePopGestureRecognizerEnabled:YES scrollEnabled:NO];
//                [self.appCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.navView.alpha = 1;
            self.showNavView.alpha = 0;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.homeAppView.alpha = 1;
                self.showHomeAppView.alpha = 0;
                
                CGRect newFrame = self.homeAppView.editApplication.frame;
                newFrame.origin.y = 0;
                self.homeAppView.editApplication.frame = newFrame;
            }];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                CGRect newFrame = self.appCollectionView.frame;
                newFrame.origin.y = homeAppViewH+spacing+spacing;
                newFrame.size.height = appCollectionViewH;
                self.appCollectionView.frame = newFrame;
            }];
        });
    }else{
        [self setUpInteractivePopGestureRecognizerEnabled:NO scrollEnabled:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.navView.alpha = 0;
            self.showNavView.alpha = 1;
            self.homeAppView.alpha = 0;
            self.showHomeAppView.alpha = 1;
            
            CGRect newFrame = self.homeAppView.editApplication.frame;
            newFrame.origin.y = homeAppViewH/2;
            self.homeAppView.editApplication.frame = newFrame;
            
            newFrame = self.appCollectionView.frame;
            newFrame.origin.y = showHomeAppViewH+spacing;
            newFrame.size.height = kFBaseHeight -(navViewH+spacing)-homeAppBackViewH;
            self.appCollectionView.frame = newFrame;
        }];
    }
}

- (void)setUpInteractivePopGestureRecognizerEnabled:(BOOL)enabled scrollEnabled:(BOOL)scrollEnabled{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = enabled;
    }
    if (scrollEnabled) {
        self.categoryScrollView.scrollEnabled = NO;
        self.appCollectionView.scrollEnabled = YES;
    }else{
        self.categoryScrollView.scrollEnabled = YES;
        self.appCollectionView.scrollEnabled = NO;
    }
}

- (void)setUphomeFunctionArrayCount:(NSInteger)count{
    if ( count > 8) {
        showHomeAppViewH = homeAppBackViewH;
    }else if (count > 4 & count <= 8){
        showHomeAppViewH = homeAppBackViewH * 2 / 3;
    }else{
        showHomeAppViewH = homeAppBackViewH/3;
    }
    self.showHomeAppView.frame = CGRectMake(0, 0, kFBaseWidth, showHomeAppViewH);
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.homeDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.homeDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70, 70);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    return [UIColor redColor];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CollectionReusableHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        return headerView;
    }else{
        CollectionReusableFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        return footerView;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kFBaseWidth, collectionReusableViewH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kFBaseWidth, 0.5);
}

@end
