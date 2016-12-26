//
//  WTLThemesViewController.m
//  Weightly
//
//  Created by Yiming Tang on 11/9/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "WTLThemesViewController.h"
#import "WTLThemeCollectionViewCell.h"
#import "WeightlyKit.h"
#import <SAMCategories/UIColor+SAMAdditions.h>

@interface WTLThemesViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic) CGSize itemSize;
@property (nonatomic) BOOL needsUpdateItemSize;
@property (nonatomic) NSArray *themes;
@property (nonatomic) NSArray *themeNames;
@property (nonatomic) NSString *selectedThemeName;
@end

@implementation WTLThemesViewController

static NSString *const reuseIdentifier = @"themeCell";

@synthesize themes = _themes;
@synthesize themeNames = _themeNames;
@synthesize selectedThemeName = _selectedThemeName;
@synthesize itemSize = _itemSize;
@synthesize needsUpdateItemSize = _needsUpdateItemSize;

#pragma mark - Accessors

- (NSArray *)themeNames {
    if (!_themeNames) {
         _themeNames = [WTLTheme availableThemeNames];
    }
    return _themeNames;
}


- (NSArray *)themes {
    if (!_themes) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:self.themeNames.count];
        for (NSString *name in self.themeNames) {
            [mutableArray addObject:[WTLTheme themeNamed:name]];
        }
        _themes = mutableArray;
    }
    return _themes;
}


#pragma mark - Initialization

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
    
    self.collectionView.backgroundColor = [UIColor wtl_themeColor];
    [self.collectionView registerClass:[WTLThemeCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.selectedThemeName = [[WTLPreferences sharedPreferences] objectForKey:kWTLThemeKey];
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
    return self.themes.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WTLThemeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *themeName = [self.themeNames objectAtIndex:indexPath.item];
    WTLTheme *theme = [self.themes objectAtIndex:indexPath.item];
    
    cell.titleLabel.text = [theme.title uppercaseString];
    cell.backgroundColor = theme.color;
    cell.weightLabel.text = @"65.3";
    cell.bmiLabel.text = @"21.8 - NORMAL";
    
    
    if ([themeName isEqualToString:self.selectedThemeName]) {
        cell.selected = YES;
        // http://stackoverflow.com/questions/15330844/uicollectionview-select-and-deselect-issue
        // should also call this method so that the collection view will deselect this cell after
        // we select another one.
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedThemeName = [self.themeNames objectAtIndex:indexPath.row];
    
    WTLPreferences *preferences = [WTLPreferences sharedPreferences];
    [preferences setObject:self.selectedThemeName forKey:kWTLThemeKey];
    [preferences synchronize];
    
    self.navigationController.navigationBar.barTintColor = [UIColor wtl_themeColor];
    self.collectionView.backgroundColor = [UIColor wtl_themeColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWTLThemeDidChangeNotificationName object:nil];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}

@end
