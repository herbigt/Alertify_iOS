//
// Created by Hans Pinckaers on 08-01-14.
// Copyright (c) 2014 Hans Pinckaers. All rights reserved.
//

#import "HPNewTimerViewController.h"

@implementation HPNewTimerViewController
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark - UICollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                           forIndexPath:indexPath];

    if(cell.contentView.subviews.count == 0)
    {
        UIView *background = [[UIView alloc] initWithFrame:cell.bounds];
        background.backgroundColor = [UIColor colorWithRed:0.682 green:0.776 blue:0.714 alpha:1.000];
        [cell addSubview:background];

        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 320, 18)];
        timeLabel.text = @"Cancel";
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.backgroundColor= [UIColor clearColor];
        timeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19.0f];
        timeLabel.textColor = [UIColor whiteColor];
        [cell addSubview:timeLabel];
    }

    return cell;
}


@end