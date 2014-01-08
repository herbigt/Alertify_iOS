//
//  HPAlarmListViewController.m
//  Alertify
//
//  Created by Hans Pinckaers on 08-10-13.
//  Copyright (c) 2013 Hans Pinckaers. All rights reserved.
//

#import "HPAlarmListViewController.h"
#import "ClockView.h"
#import "HPAlarmListFlowLayout.h"
#import "HPNewTimerViewController.h"

static NSString * CellIdentifier = @"CellIdentifier";

@interface HPAlarmListViewController () <HPAlarmListFlowLayoutDelegate>

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
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    [(HPAlarmListFlowLayout *)self.collectionView.collectionViewLayout setDelegate:self];
    
//    UISlider *damping = [[UISlider alloc] initWithFrame:CGRectMake(10, 480, 310, 10)];
//    damping.minimumValue = 0.0f;
//    damping.maximumValue = 10.0f;
//    [damping addTarget:self action:@selector(dampingChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:damping];
//    
//    UISlider *freq = [[UISlider alloc] initWithFrame:CGRectMake(10, 520, 310, 10)];
//    freq.minimumValue = 0.0f;
//    freq.maximumValue = 25.0f;
//    [freq addTarget:self action:@selector(frequencyChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:freq];
}

- (void)dampingChanged:(UISlider *)sender
{
    NSLog(@"damping: %f", sender.value);
    [(HPAlarmListFlowLayout *)self.collectionViewLayout setDamping:sender.value];
}

- (void)frequencyChanged:(UISlider *)sender
{
    NSLog(@"frequency: %f", sender.value);
    [(HPAlarmListFlowLayout *)self.collectionViewLayout setFrequence:sender.value];
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
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell.contentView.subviews.count == 0)
    {
        UIImageView *accept = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accept@2x.png"]];
        accept.frame = CGRectMake(20, 23, 28, 26);
        accept.tag = 1;
        accept.alpha = 0.0f;
        [cell.contentView addSubview:accept];

        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:cell.bounds];
        scrollView.contentSize = CGSizeMake(cell.bounds.size.width, cell.bounds.size.height);
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        [cell.contentView addSubview:scrollView];

        UIView *dragView = [[UIView alloc] initWithFrame:cell.bounds];
        dragView.backgroundColor = [UIColor colorWithRed:0.682 green:0.776 blue:0.714 alpha:1.000];

        UIView *highlight = [[UIView alloc] initWithFrame:(CGRect){{0,0}, {cell.bounds.size.width, 1}}];
        highlight.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
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
        descriptionLabel.textAlignment = NSTextAlignmentCenter;
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
        descriptionLabel.textColor = [UIColor whiteColor];
        descriptionLabel.tag = 2;
        [dragView addSubview:descriptionLabel];

        scrollView.delegate = self;

        [scrollView addSubview:dragView];
    }

    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:2];
    if(indexPath.row == 0) descriptionLabel.text = @"Release to add alarm";
    else descriptionLabel.text = @"Wake up!";

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView != self.collectionView)
    {
        UIImageView *accept = (UIImageView *)[[scrollView superview] viewWithTag:1];
        accept.alpha = MIN(-scrollView.contentOffset.x / 72, 1);
    }
}

- (void)alarmListFlowLayout:(HPAlarmListFlowLayout *)layout didStopDraggingWithOffset:(CGPoint)offset;
{
    if(offset.y > -5) {
        [self addNewTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

- (void)addNewTimer
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(320, 75);
    HPNewTimerViewController *newTimerViewController = [[HPNewTimerViewController alloc] initWithCollectionViewLayout:layout];
    [self.navigationController pushViewController:newTimerViewController animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
