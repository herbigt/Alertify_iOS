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
    UIAttachmentBehavior *attachedToFinger;
    NSArray *items;
    UISnapBehavior *topBehaviour;
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
    items = [super layoutAttributesForElementsInRect:
                      CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height)];
    
    if (self.dynamicAnimator.behaviors.count == 0 && [items count] > 0) {
        
        [self.collectionView.panGestureRecognizer addTarget:self action:@selector(panned:)];
        
        UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:items];
        collision.collisionMode = UICollisionBehaviorModeItems;
        [self.dynamicAnimator addBehavior:collision];
        
        UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:items];
        dynamic.allowsRotation = NO;
        dynamic.friction = 0.0f;
        dynamic.angularResistance = CGFLOAT_MAX;
        [self.dynamicAnimator addBehavior:dynamic];
        
        id<UIDynamicItem> prevObjc = nil;
        for(id<UIDynamicItem> obj in items)
        {
            if(prevObjc)
            {
                UIAttachmentBehavior *behaviour = [[UIAttachmentBehavior alloc] initWithItem:obj attachedToItem:prevObjc];
                behaviour.damping = 3.0f;
                behaviour.frequency = 5.5f;
                [self.dynamicAnimator addBehavior:behaviour];
            }
            prevObjc = obj;
        }
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

- (void)panned:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint tTouchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];

    if(panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self.dynamicAnimator removeBehavior:attachedToFinger];
        [self.dynamicAnimator removeBehavior:topBehaviour];
        topBehaviour = nil;
        attachedToFinger = nil;
        
        UICollectionViewLayoutAttributes *item = [[self.dynamicAnimator itemsInRect:CGRectMake(tTouchLocation.x, tTouchLocation.y, 1, 1)] firstObject];
        if (!item) return;
        
        attachedToFinger = [[UIAttachmentBehavior alloc] initWithItem:item
                                                     offsetFromCenter:UIOffsetMake(-item.center.x, 0)
                                                     attachedToAnchor:CGPointMake(0, item.center.y)];
        attachedToFinger.damping = 1.0f;
        attachedToFinger.frequency = 12.0f;
        [self.dynamicAnimator addBehavior:attachedToFinger];
        
        for(id<UIDynamicItem> obj in items)
            [self.dynamicAnimator updateItemUsingCurrentState:obj];
    }
    else if(panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        tTouchLocation.x = 0;
        attachedToFinger.anchorPoint = tTouchLocation;
        
        for(id<UIDynamicItem> obj in items)
            [self.dynamicAnimator updateItemUsingCurrentState:obj];
    }
    else if(panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled)
    {
        attachedToFinger.anchorPoint = CGPointMake(0, [[(UICollectionViewLayoutAttributes *)[attachedToFinger.items firstObject] indexPath] row] * 75.0f + 37.5f);
        attachedToFinger.damping = 3.0f;
        attachedToFinger.frequency = 5.5f;

        for(id<UIDynamicItem> obj in items)
            [self.dynamicAnimator updateItemUsingCurrentState:obj];
    }
}


-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

@end
