//
//  WTLThemesViewController.m
//  Weightly
//
//  Created by Yiming Tang on 11/9/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLThemesViewController.h"
#import "WTLThemeCollectionViewCell.h"

@interface WTLThemesViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic) CGSize itemSize;
@property (nonatomic) BOOL needsUpdateItemSize;

@end

@implementation WTLThemesViewController

static NSString *const reuseIdentifier = @"themeCell";

@synthesize itemSize = _itemSize;

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    if ((self = [super initWithCollectionViewLayout:layout])) {
        _itemSize = CGSizeZero;
        _needsUpdateItemSize = YES;
    }
    
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:76.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    [self.collectionView registerClass:[WTLThemeCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    // NOTE: http://stackoverflow.com/questions/22451793/setcollectionviewlayoutanimated-causing-debug-error-snapshotting-a-view-that-h
    // In this method, the bounds of collection view is not updated. However, we can get the new value when it
    // finishes. After that, layout delegate methods are called, thus we assign the recalculated size to layout.
    // There's another solution: assign new item size and re-layout in `willAnimateRotationToInterfaceOrientation:duration`.
    // But a message will show in the console: 'Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.'
    // Therefore, we choose the first one.
    
    // if portrait -> landscape or landscape -> portrait, change item size and trigger layout
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) != UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.needsUpdateItemSize = YES;
        [self.collectionViewLayout invalidateLayout];
    }
}


#pragma mark - Private Methods

- (CGSize)itemSize {
    if (self.needsUpdateItemSize) {
        CGSize collectionViewSize = self.collectionView.bounds.size;
        CGFloat width = 0;
        if (collectionViewSize.width > collectionViewSize.height) {
            width = collectionViewSize.width / 3;
        } else {
            width = collectionViewSize.width / 2;
        }
        _itemSize = CGSizeMake(width, width * 1.25f);
        self.needsUpdateItemSize = NO;
    }
    
    return _itemSize;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WTLThemeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithWhite:(indexPath.item / 10.0f) alpha:1.0f];
    cell.titleLabel.text = @"BELIZE HOLE";
    cell.weightLabel.text = @"65.3";
    cell.bmiLabel.text = @"21.8 - NORMAL";
    
    return cell;
}


#pragma mark - UICollectionViewDelegate


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}

@end
