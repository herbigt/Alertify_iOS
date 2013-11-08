//
//  HPAlarmListFlowLayout.m
//  Alertify
//
//  Created by Hans Pinckaers on 08-10-13.
//  Copyright (c) 2013 Hans Pinckaers. All rights reserved.
//

#import "HPAlarmListFlowLayout.h"

@implementation HPAlarmListFlowLayout
{
    CGPoint touchLocation;
}
- (id)init
{
    if ((self = [super init]))
    {
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 0;
        self.itemSize = CGSizeMake(320, 75);
        self.sectionInset = UIEdgeInsetsMake(0, 0, 64, 0);
        
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.visibleIndexPathsSet = [NSMutableSet set];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    CGSize contentSize = self.collectionView.contentSize;
    NSArray *items = [super layoutAttributesForElementsInRect:
                      CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height)];
    
    if (self.dynamicAnimator.behaviors.count == 0) {
        [items enumerateObjectsUsingBlock:^(id<UIDynamicItem> obj, NSUInteger idx, BOOL *stop) {
            UIAttachmentBehavior *behaviour = [[UIAttachmentBehavior alloc] initWithItem:obj
                                                                        attachedToAnchor:[obj center]];
            
            behaviour.length = 0.0f;
            behaviour.damping = 0.9f;
            behaviour.frequency = 1.0f;
            
            [self.dynamicAnimator addBehavior:behaviour];
        }];
    }

}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.dynamicAnimator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    self.latestDelta = delta;
    
    CGPoint tTouchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    if(tTouchLocation.y != 0) touchLocation = tTouchLocation;
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes *item = springBehaviour.items.firstObject;

        if([springBehaviour isKindOfClass:[UIAttachmentBehavior class]])
        {
            CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
            CGFloat xDistanceFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
            CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 750.0f;
            
            CGPoint center = item.center;
            if (delta < 0) {
                center.y += self.latestDelta*scrollResistance;
            }
            else {
                center.y += self.latestDelta*scrollResistance;
            }

            item.center = center;
        }

        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];
    
    
    return NO;
}

@end
