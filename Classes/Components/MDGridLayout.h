//
//  MDGridLayout.h
//  Mediapad
//
//  Created by wei feng on 15/8/23.
//  Copyright (c) 2015年 wei feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDGridLayoutDelegate <NSObject>

/**
 *  @brief  返回的layoutstring 形如“x-x-x”，用“-”分割的3个数分表表示:collectionView的宽度被平均分割的总的块数，当前cell
 *          宽度所占的块数，当前cell高度所占的块数。(3-1-2, 表示当前cell的宽度是 colectionView宽度的 1/3, 高度是
 *          collectionView 宽度的 2/3),like this : [@"2-1-1", @"2-1-1",@"3-3-2", @"2-1-2", @"2-1-2"];
 */

- (NSString *)collectionView:(UICollectionView *)collectionView
                      layout:(UICollectionViewLayout *)layout constraintStringAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MDGridLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) id<MDGridLayoutDelegate> layoutDelegate;
@property (assign, nonatomic) CGFloat itemSpace;        ///< 网格间距

@end
