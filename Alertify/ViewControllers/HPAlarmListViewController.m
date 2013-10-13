//
//  HPAlarmListViewController.m
//  Alertify
//
//  Created by Hans Pinckaers on 08-10-13.
//  Copyright (c) 2013 Hans Pinckaers. All rights reserved.
//

#import "HPAlarmListViewController.h"

static NSString * CellIdentifier = @"CellIdentifier";

@interface HPAlarmListViewController ()

@end

@implementation HPAlarmListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:CellIdentifier];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionViewLayout invalidateLayout];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UICollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                  forIndexPath:indexPath];
    

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:cell.bounds];
    scrollView.contentSize = CGSizeMake(cell.bounds.size.width, cell.bounds.size.height);
    scrollView.alwaysBounceHorizontal = YES;
    [cell addSubview:scrollView];

    UIView *dragView = [[UIView alloc] initWithFrame:cell.bounds];
    dragView.backgroundColor = [UIColor colorWithRed:0.686 green:0.784 blue:0.718 alpha:1.000];

    UIView *highlight = [[UIView alloc] initWithFrame:(CGRect){{0,0}, {cell.bounds.size.width, 1}}];
    highlight.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.25f];
    [dragView addSubview:highlight];

    UIView *shadow = [[UIView alloc] initWithFrame:(CGRect){{0, cell.bounds.size.height - 1}, {cell.bounds.size.width, 1}}];
    shadow.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    [dragView addSubview:shadow];

    [scrollView addSubview:dragView];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
