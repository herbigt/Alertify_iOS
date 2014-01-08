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
    NSMutableArray *items;
    UISnapBehavior *topBehaviour;
    UICollectionViewLayoutAttributes *firstObj;
    UICollisionBehavior *mainCollisionBehavior;
    UIGravityBehavior *gravity;
}

- (id)init
{
    if ((self = [super init]))
    {
//        self.minimumInteritemSpacing = 10;
//        self.minimumLineSpacing = 0;
//        self.itemSize = CGSizeMake(320, 75);
//        self.sectionInset = UIEdgeInsetsMake(0, 0, 64, 0);
        
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.dynamicAnimator.delegate = self;
        self.visibleIndexPathsSet = [NSMutableSet set];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];

    items = [NSMutableArray array];
    NSInteger rows = [self.collectionView numberOfItemsInSection:0];
    for(int i = 0; i<rows; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemAttributes.frame = CGRectMake(0, 73.0f*(i-1)-30, 320, 75);
        if (itemAttributes) [items addObject:itemAttributes];
    }
    
    if (self.dynamicAnimator.behaviors.count == 0 && [items count] > 0)
    {
        self.collectionView.panGestureRecognizer.enabled = NO;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        pan.delegate = self;
        [self.collectionView addGestureRecognizer:pan];

        mainCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:items];
        mainCollisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
        [mainCollisionBehavior addBoundaryWithIdentifier:@"left" fromPoint:CGPointMake(0,0) toPoint:CGPointMake(0, self.collectionView.frame.size.height)];
        [mainCollisionBehavior addBoundaryWithIdentifier:@"right" fromPoint:CGPointMake(self.collectionView.frame.size.width,0) toPoint:CGPointMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height)];
        [self.dynamicAnimator addBehavior:mainCollisionBehavior];
        
        UICollisionBehavior *collisionFirst = [[UICollisionBehavior alloc] initWithItems:@[[items firstObject]]];
        [collisionFirst addBoundaryWithIdentifier:@"top" fromPoint:CGPointMake(0,-500) toPoint:CGPointMake(self.collectionView.frame.size.width, -500)];

        [collisionFirst addBoundaryWithIdentifier:@"bottom" fromPoint:CGPointMake(0,73) toPoint:CGPointMake(self.collectionView.frame.size.width, 73)];
        [self.dynamicAnimator addBehavior:collisionFirst];
        
        UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:items];
        dynamic.allowsRotation = NO;
        dynamic.friction = 0.0f;
        dynamic.angularResistance = CGFLOAT_MAX;
        [self.dynamicAnimator addBehavior:dynamic];

        UIDynamicItemBehavior *density = [[UIDynamicItemBehavior alloc] initWithItems:@[[items firstObject]]];
        density.density = 0.0f;
        [self.dynamicAnimator addBehavior:density];

        id<UIDynamicItem> prevObjc = nil;
        firstObj = [items firstObject];
        for(id<UIDynamicItem> obj in items)
        {
            if(prevObjc && prevObjc != firstObj)
            {
                UIAttachmentBehavior *behaviour = [[UIAttachmentBehavior alloc] initWithItem:obj attachedToItem:prevObjc];
                behaviour.damping = 3.0f;
                behaviour.frequency = 5.0f;
                behaviour.length = 73.0f;
                [self.dynamicAnimator addBehavior:behaviour];
            }
            prevObjc = obj;
        }

        gravity = [[UIGravityBehavior alloc] initWithItems:@[[items firstObject]]];
    }
}

//- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator
//{
//    firstObj.hidden = YES;
//    [mainCollisionBehavior removeItem:firstObj];
//}
//
//- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
//{
//    firstObj.hidden = NO;
//    firstObj.frame = CGRectMake(0, -75, 320, 75);
//    if(firstObj) [mainCollisionBehavior addItem:firstObj];
//    [self.dynamicAnimator updateItemUsingCurrentState:firstObj];
//}

- (CGSize)collectionViewContentSize
{
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(320, rowCount * 73 * 2);
}


- (void)setDamping:(CGFloat)damping
{
    for (UIAttachmentBehavior *behavior in self.dynamicAnimator.behaviors)
        if ([behavior isKindOfClass:[UIAttachmentBehavior class]])
            behavior.damping = damping;
}

- (void)setFrequence:(CGFloat)frequence
{
    for (UIAttachmentBehavior *behavior in self.dynamicAnimator.behaviors)
        if ([behavior isKindOfClass:[UIAttachmentBehavior class]])
            behavior.frequency = frequence;
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
    CGPoint tTouchLocation = [panGestureRecognizer locationInView:self.collectionView];
    CGPoint translation = [panGestureRecognizer translationInView:self.collectionView];
    if(panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (!gravity.dynamicAnimator)
            [self.dynamicAnimator addBehavior:gravity];
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
        attachedToFinger.anchorPoint = CGPointMake(0, ([[(UICollectionViewLayoutAttributes *)[attachedToFinger.items firstObject] indexPath] row] - 1) * 75.0f + 37.5f-30);
        attachedToFinger.damping = 3.0f;
        attachedToFinger.frequency = 5.0f;

        for(id<UIDynamicItem> obj in items)
            [self.dynamicAnimator updateItemUsingCurrentState:obj];

        [self.delegate alarmListFlowLayout:self didStopDraggingWithOffset:CGPointMake(0, firstObj.frame.origin.y)];
    }
}


-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    NSLog(@"%i", self.collectionView.contentOffset.y);
    return NO;
}

@end
