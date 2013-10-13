//
//  HPAlarmListFlowLayout.h
//  Alertify
//
//  Created by Hans Pinckaers on 08-10-13.
//  Copyright (c) 2013 Hans Pinckaers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPAlarmListFlowLayout : UICollectionViewFlowLayout <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat latestDelta;

@end