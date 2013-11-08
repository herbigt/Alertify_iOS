//
//  HPAlarmListViewController.m
//  Alertify
//
//  Created by Hans Pinckaers on 08-10-13.
//  Copyright (c) 2013 Hans Pinckaers. All rights reserved.
//

#import "HPAlarmListViewController.h"
#import "ClockView.h"

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
    
    if(cell.contentView.subviews.count == 0)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:cell.bounds];
        scrollView.contentSize = CGSizeMake(cell.bounds.size.width, cell.bounds.size.height);
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        [cell.contentView addSubview:scrollView];

        UIView *dragView = [[UIView alloc] initWithFrame:cell.bounds];
        dragView.backgroundColor = [UIColor colorWithRed:0.682 green:0.776 blue:0.714 alpha:1.000];

        UIView *highlight = [[UIView alloc] initWithFrame:(CGRect){{0,0}, {cell.bounds.size.width, 1}}];
        highlight.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.25f];
        [dragView addSubview:highlight];

        UIView *shadow = [[UIView alloc] initWithFrame:(CGRect){{0, cell.bounds.size.height - 1}, {cell.bounds.size.width, 1}}];
        shadow.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
        [dragView addSubview:shadow];

        ClockView *clockView = [[ClockView alloc] initWithFrame:CGRectMake(10, 17, 40, 40)];
        [clockView updateToDate:[NSDate date]];
        [dragView addSubview:clockView];

        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 320, 18)];
        timeLabel.text = @"08:30";
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.backgroundColor= [UIColor clearColor];
        timeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19.0f];
        timeLabel.textColor = [UIColor whiteColor];
        [dragView addSubview:timeLabel];

        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, 320, 25)];
        descriptionLabel.text = @"Hey Wake up!";
        descriptionLabel.textAlignment = NSTextAlignmentCenter;
        descriptionLabel.backgroundColor= [UIColor clearColor];
        descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
        descriptionLabel.textColor = [UIColor whiteColor];
        [dragView addSubview:descriptionLabel];

        [scrollView addSubview:dragView];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
