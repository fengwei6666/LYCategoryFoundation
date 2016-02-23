//
//  MDGridLayout.m
//  Mediapad
//
//  Created by wei feng on 15/8/23.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import "MDGridLayout.h"

@interface MDGridLayout()

@property (retain, nonatomic) NSMutableArray *constraints;            ///< 保存已布局的constraintstring
@property (retain, nonatomic) NSMutableArray *framesIndexPath;        ///< 保存frame和indexpath的一一对应
@property (retain, nonatomic) NSIndexPath *firstLayoutIndexPath;
@property (retain, nonatomic) NSMutableArray *whiteSpacesIndexPath;

/**
 *  @brief  计算cell的frame并存储在framesIndexPath中
 */
- (void)caculateCellFramesforBounds:(CGRect)bounds;

/**
 *  @brief  查找到分割线之下的第一个frameindexpath
 *
 *  @param spliteling 分割线
 *
 *  @return frame／indexpath in framesIndexPath
 */
- (NSDictionary *)quitFetchFirstUnderlineSplite:(CGFloat)spliteling;

@end

@implementation MDGridLayout

- (void)dealloc
{
    self.framesIndexPath = nil;
    self.whiteSpacesIndexPath = nil;
    self.constraints = nil;
    self.firstLayoutIndexPath = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.itemSpace = 0;
    }
    return self;
}

- (NSMutableArray *)framesIndexPath
{
    if (_framesIndexPath == nil)
    {
        _framesIndexPath = [[NSMutableArray alloc] init];
    }
    return _framesIndexPath;
}

- (NSMutableArray *)whiteSpacesIndexPath
{
    if (_whiteSpacesIndexPath == nil)
    {
        _whiteSpacesIndexPath = [[NSMutableArray alloc] init];
    }
    return _whiteSpacesIndexPath;
}

- (NSMutableArray *)constraints
{
    if (_constraints == nil)
    {
        _constraints = [[NSMutableArray alloc] init];
    }
    return _constraints;
}

- (CGSize)collectionViewContentSize
{
    CGSize size = CGSizeMake(CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame) + 66);
    NSInteger end = [self.framesIndexPath count] - 1;
    
    //maybe have a bug some time.(acture should loop all frames)
    while ((end >= 0) && (end >= (NSInteger)[self.framesIndexPath count] - 5))
    {
        CGRect rect = CGRectFromString([[self.framesIndexPath[end] allKeys] lastObject]);
        if (CGRectGetMaxY(rect) > size.height)
        {
            size.height = CGRectGetMaxY(rect);
        }
        end--;
    }

//    CGRect rect = [[[[[self.whiteSpacesIndexPath lastObject] allValues] lastObject] lastObject] CGRectValue];
//    size.height = (CGRectGetMinX(rect) > size.height) ? CGRectGetMinX(rect) : size.height;

    return size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    [self caculateCellFramesforBounds:rect];
    NSDictionary *top = [self quitFetchFirstUnderlineSplite:CGRectGetMinY(rect)];
    NSDictionary *bottom = [self quitFetchFirstUnderlineSplite:CGRectGetMaxY(rect)];
    if (!top && !bottom) return nil;
    
    NSInteger start = [self.framesIndexPath indexOfObject:top];
    NSInteger end = bottom ? [self.framesIndexPath indexOfObject:bottom] : ([self.framesIndexPath count] - 1);
    
    NSInteger min = start - 10;
    //some low
    while ((start > 0) && (start > min))
    {
        start --;
    }
    
    NSMutableArray *layoutAttributes = [NSMutableArray arrayWithCapacity:(end - start + 1)];
    for (NSInteger i = start; i <= end; i++)
    {
        NSDictionary *frameInfo = self.framesIndexPath[i];
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:[[frameInfo allValues] lastObject]];
        att.frame = CGRectFromString([[frameInfo allKeys] lastObject]);
        [layoutAttributes addObject:att];
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    return attributes;
}

- (void)prepareLayout
{
    [super prepareLayout];
}

- (void)invalidateLayout
{
    [super invalidateLayout];
    
    self.firstLayoutIndexPath = nil;
    [self enumCollectionView:self.collectionView
                       start:nil
                        stop:nil
                      excute:^BOOL(NSIndexPath *indexPath)
    {
        NSString *constraintString = [self.layoutDelegate collectionView:self.collectionView
                                                                  layout:self
                                             constraintStringAtIndexPath:indexPath];
        NSString *origin = [self source:self.constraints fetchValueAtIndexPath:indexPath];;
        BOOL same = (([origin length] > 0) && [origin isEqualToString:constraintString]);
        if (!same) self.firstLayoutIndexPath = indexPath;
        return !same;
    }];
    
    //(row + 1) or (section + 1) is a question
    if (self.firstLayoutIndexPath == nil)
    {
        NSInteger sectionCount = [self.collectionView numberOfSections];
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:(sectionCount - 1)];
        self.firstLayoutIndexPath = [NSIndexPath indexPathForItem:rowCount inSection:(sectionCount-1)];
    }

    if (self.firstLayoutIndexPath)
    {
        [self source:self.constraints deleteObjsAfterIndexPath:self.firstLayoutIndexPath];
        for (NSInteger i = 0; i < [self.framesIndexPath count]; i++)
        {
            NSIndexPath *frameIndex = [[self.framesIndexPath[i] allValues] lastObject];
            if ([frameIndex compare:self.firstLayoutIndexPath] != NSOrderedAscending)
            {
                [self.framesIndexPath removeObjectAtIndex:i];
                i--;
            }
        }
        
        [self source:self.whiteSpacesIndexPath deleteObjsAfterIndexPath:self.firstLayoutIndexPath];
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return CGRectGetWidth(newBounds) != CGRectGetWidth(self.collectionView.bounds);
//    return !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
}

#pragma mark - privite

- (NSString *)stringFromIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row];
}

- (id)source:(NSMutableArray *)source fetchValueAtIndexPath:(NSIndexPath *)indexPath
{
    if (source && indexPath)
    {
        for (NSDictionary *dict in source)
        {
            if ([[[dict allKeys] lastObject] isEqualToString:[self stringFromIndexPath:indexPath]])
            {
                return [[dict allValues] lastObject];
            }
        }
    }
    return nil;
}

- (void)source:(NSMutableArray *)array deleteObjsAfterIndexPath:(NSIndexPath *)indexPath
{
    if (array && [array count] > 0 && indexPath)
    {
        NSInteger index = [array count];
        for (NSInteger i = 0; i < [array count]; i++)
        {
            if ([[[array[i] allKeys] lastObject] isEqualToString:[self stringFromIndexPath:indexPath]])
            {
                index = i;
                break;
            }
        }
        
        if (index < [array count])
        {
            [array removeObjectsInRange:NSMakeRange(index, [array count] - index)];
        }
    }
}

- (void)enumCollectionView:(UICollectionView *)collectionView
                     start:(NSIndexPath *)startIndexPath
                      stop:(NSIndexPath *)stopIndexPath
                    excute:(BOOL(^)(NSIndexPath *indexPath))excuteBlock
{
    if (collectionView && excuteBlock)
    {
        NSInteger section_count = [collectionView numberOfSections];
        NSInteger section_start = startIndexPath ? startIndexPath.section : 0;
        NSInteger row_start = startIndexPath ? startIndexPath.row : 0;
        NSInteger section_stop = stopIndexPath ? stopIndexPath.section : section_count - 1;
        
        for (NSInteger section = section_start; section <= section_stop; section++)
        {
            NSInteger row_count = [collectionView numberOfItemsInSection:section];
            NSInteger row_stop = (stopIndexPath && (section == section_stop)) ? stopIndexPath.row : row_count -1;
            
            for (NSInteger row = row_start; row <= row_stop; row++)
            {
                NSIndexPath *sIndexPath = [NSIndexPath indexPathForItem:row inSection:section];
                BOOL stop = excuteBlock(sIndexPath);
                if (stop) return;
            }
            row_start = 0;
        }
    }
}

- (CGSize)sizeForConstraintString:(NSString *)constraintString
{
    if ([constraintString length] > 0)
    {
        NSArray *array = [constraintString componentsSeparatedByString:@"-"];
        if (array && [array count] == 3)
        {
            CGFloat totalWidth = CGRectGetWidth(self.collectionView.frame) + self.itemSpace;
            NSInteger total = [array[0] integerValue];
            NSInteger width = [array[1] integerValue];
            NSInteger heigth = [array[2] integerValue];
            total = (total <= 0) ? 1 : total;
            width = (width > total) ? total : width;
            return CGSizeMake((int)(totalWidth/total*width) - self.itemSpace, (int)(totalWidth/total*heigth) - self.itemSpace);
        }
    }
    return CGSizeZero;
}

NSInteger sortFrameByOrigin(id obj1, id obj2, void *context)
{
    CGRect rect1 = CGRectZero;
    CGRect rect2 = CGRectZero;
    if ([obj1 isKindOfClass:[NSDictionary class]])
    {
        rect1 = CGRectFromString([[obj1 allKeys] lastObject]);
        rect2 = CGRectFromString([[obj2 allKeys] lastObject]);
    }
    else if ([obj1 isKindOfClass:[NSValue class]])
    {
        rect1 = [obj1 CGRectValue];
        rect2 = [obj2 CGRectValue];
    }
    
    if (CGRectGetMinY(rect1) == CGRectGetMinY(rect2))
    {
        return (CGRectGetMinX(rect1) < CGRectGetMinX(rect2)) ? NSOrderedAscending : NSOrderedDescending;
    }
    return (CGRectGetMinY(rect1) < CGRectGetMinY(rect2)) ? NSOrderedAscending : NSOrderedDescending;
}

- (void)originRect:(CGRect)rect clipRect:(CGRect)clipRect
               top:(CGRect *)top left:(CGRect *)left bottom:(CGRect *)bottom right:(CGRect *)right
{
    *top = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetMinY(clipRect) - CGRectGetMinY(rect));
    *left = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMinX(clipRect) - CGRectGetMinX(rect), CGRectGetHeight(rect));
    *bottom = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(clipRect), CGRectGetWidth(rect), CGRectGetMaxY(rect) - CGRectGetMaxY(clipRect));
    *right = CGRectMake(CGRectGetMaxX(clipRect), CGRectGetMinY(clipRect), CGRectGetMaxX(rect) - CGRectGetMaxX(clipRect), CGRectGetHeight(rect));
}

- (void)frameArray:(NSMutableArray *)array handleNewFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame)) return;
    
    BOOL didHave = NO;
    for (NSValue *value in array)
    {
        CGRect rect = [value CGRectValue];
        if (CGRectContainsRect(rect, frame))
        {
            didHave = YES;
            break;
        }
    }
    
    if (!didHave)
    {
        [array addObject:[NSValue valueWithCGRect:frame]];
    }
}

- (NSIndexPath *)preIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if ((row == 0) && (section == 0))
    {
        return nil;
    }
    else if (row == 0)
    {
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:(section - 1)];
        return [NSIndexPath indexPathForItem:(rowCount - 1) inSection:(section - 1)];
    }
    else
    {
        return [NSIndexPath indexPathForItem:(indexPath.row - 1) inSection:indexPath.section];
    }
}

- (NSIndexPath *)nextIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath)
    {
        NSInteger secCount = [self.collectionView numberOfSections];
        if (indexPath.section < secCount)
        {
            NSInteger rowCount = [self.collectionView numberOfItemsInSection:indexPath.section];
            if (indexPath.row < rowCount - 1)
            {
                return [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
            }
            else if (indexPath.row == rowCount - 1)
            {
                if (indexPath.section < secCount - 1)
                {
                    return [NSIndexPath indexPathForItem:0 inSection:(indexPath.section + 1)];
                }
            }
        }
    }
    return nil;
}

- (void)whiteSpaceHandleCellRect:(CGSize)size atIndexPath:(NSIndexPath *)indexPath
{
    if (CGSizeEqualToSize(size, CGSizeZero) || !indexPath) return;
    
    CGRect cellRect = CGRectZero;
    NSArray *whiteSpace = [self source:self.whiteSpacesIndexPath fetchValueAtIndexPath:[self preIndexPath:indexPath]];
    whiteSpace = whiteSpace ? : @[[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.collectionView.frame), CGFLOAT_MAX)]];
    
    for (NSValue *value in whiteSpace)
    {
        CGRect rect = [value CGRectValue];
        if ((rect.size.width >= size.width) && (rect.size.height >= size.height))
        {
            cellRect = CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
            [self.framesIndexPath addObject:@{NSStringFromCGRect(cellRect) : indexPath}];
            break;
        }
    }
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:whiteSpace];
    CGRect clipRect = CGRectMake(CGRectGetMinX(cellRect), CGRectGetMinY(cellRect), CGRectGetWidth(cellRect) + self.itemSpace, CGRectGetHeight(cellRect) + self.itemSpace);
    for (NSValue *value in whiteSpace)
    {
        CGRect rect = [value CGRectValue];
        CGRect interRect = CGRectIntersection(rect, clipRect);
        if (!CGRectIsEmpty(interRect))
        {
            [temp removeObject:value];
            CGRect top, left, bottom, right;
            [self originRect:rect clipRect:interRect top:&top left:&left bottom:&bottom right:&right];
            [self frameArray:temp handleNewFrame:top];
            [self frameArray:temp handleNewFrame:left];
            [self frameArray:temp handleNewFrame:bottom];
            [self frameArray:temp handleNewFrame:right];
        }
        
        if (CGRectGetMinY(rect) >= CGRectGetMaxY(clipRect)) break;
    }
    
    [temp sortUsingFunction:sortFrameByOrigin context:nil];
    [self.whiteSpacesIndexPath addObject:@{[self stringFromIndexPath:indexPath] : temp}];
}

- (void)caculateCellFramesforBounds:(CGRect)bounds
{
    if (self.firstLayoutIndexPath)
    {
        static NSInteger loop = 20;
        loop -= 10;
        [self enumCollectionView:self.collectionView
                           start:self.firstLayoutIndexPath
                            stop:nil
                          excute:^BOOL(NSIndexPath *indexPath)
         {
             loop++;
             NSString *constraintString = [self.layoutDelegate collectionView:self.collectionView
                                                                       layout:self
                                                  constraintStringAtIndexPath:indexPath];
             [self.constraints addObject:@{[self stringFromIndexPath:indexPath] : constraintString}];
             CGSize size = [self sizeForConstraintString:constraintString];
             [self whiteSpaceHandleCellRect:size atIndexPath:indexPath];
             CGRect firstWhiteSpace = [[[[[self.whiteSpacesIndexPath lastObject] allValues] lastObject] firstObject] CGRectValue];
             BOOL stop = (CGRectGetMinY(firstWhiteSpace) > CGRectGetMaxY(bounds));
             stop = (loop > 50) ? YES : stop;
             if (stop) self.firstLayoutIndexPath = [self nextIndexPath:indexPath];
             return stop;
         }];
        
        [self.framesIndexPath sortUsingFunction:sortFrameByOrigin context:nil];
    }
}

- (CGFloat)getFrameInfoTopline:(NSDictionary *)frameInfo
{
    return CGRectGetMinY(CGRectFromString([[frameInfo allKeys] lastObject]));
}

- (NSDictionary *)quitFetchFirstUnderlineSplite:(CGFloat)spliteling
{
    if ([self.framesIndexPath count] == 0) return nil;
    
    NSInteger start = 0;
    NSInteger end = [self.framesIndexPath count] - 1;
    NSInteger i = (start + end)/2;

    while (i != start)
    {
        NSDictionary *frameInfo = self.framesIndexPath[i];
        CGFloat line = [self getFrameInfoTopline:frameInfo];;
        if (line < spliteling)
        {
            start = i;
            i = (start + end)/2;
        }
        else if (line == spliteling)
        {
            return self.framesIndexPath[i];
        }
        else
        {
            if (i > 0)
            {
                NSDictionary *preInfo = self.framesIndexPath[i-1];
                CGFloat preline = [self getFrameInfoTopline:preInfo];
                if (preline <= spliteling)
                {
                    return self.framesIndexPath[i];
                }
                else
                {
                    end = i;
                    i = (start + end)/2;
                }
            }
            else
            {
                return self.framesIndexPath[i];
            }
        }
    }
    
    CGFloat endline = [self getFrameInfoTopline:self.framesIndexPath[end]];
    return (endline >= spliteling) ? self.framesIndexPath[end] : nil;
}

#pragma mark - public

- (void)setItemSpace:(CGFloat)itemSpace
{
    if (_itemSpace != itemSpace)
    {
        _itemSpace = itemSpace;
        
        [self invalidateLayout];
    }
}

@end
