//
//  HPAlarmListFlowLayout.h
//  Alertify
//
//  Created by Hans Pinckaers on 08-10-13.
//  Copyright (c) 2013 Hans Pinckaers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPAlarmListFlowLayout;

@protocol HPAlarmListFlowLayoutDelegate <NSObject>

- (void)alarmListFlowLayout:(HPAlarmListFlowLayout *)layout didStopDraggingWithOffset:(CGPoint)offset;

@end

@interface HPAlarmListFlowLayout : UICollectionViewLayout <UIGestureRecognizerDelegate, UIDynamicAnimatorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat latestDelta;
@property (nonatomic, assign) CGFloat damping;
@property (nonatomic, assign) CGFloat frequence;

@property (nonatomic, assign) BOOL containsAddItem;
@property (nonatomic, assign) id <HPAlarmListFlowLayoutDelegate> delegate;

@end
