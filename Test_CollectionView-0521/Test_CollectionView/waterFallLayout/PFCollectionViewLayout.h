//
//  PFCollectionViewLayout.h
//  Test_CollectionView
//
//  Created by 崔林豪_mac on 2021/5/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PFCollectionViewLayout;

@protocol PFCollectionViewLayoutDelegate <NSObject>

@required

 /**返回index位置下的item高度**/
- (CGFloat)waterFallLayout:(PFCollectionViewLayout *)flowLayout heightForItemAtIndex:(NSInteger)index width:(CGFloat)width;

@optional

/**瀑布流显示的列数*/
- (NSInteger)columnCountOfWaterFallLayout:(PFCollectionViewLayout *)flowLayout;
 
/**行间距**/
- (CGFloat)rowMarginOfWaterFallLayout:(PFCollectionViewLayout *)flowLayout;

/**列间距**/
- (CGFloat)columnMarginWaterFallLayout:(PFCollectionViewLayout *)flowLayout;

/**边缘间距**/
- (UIEdgeInsets)edgeInsetsOfFallLayout:(PFCollectionViewLayout *)flowLayout;



@end

@interface PFCollectionViewLayout : UICollectionViewLayout


@property (nonatomic, weak) id <PFCollectionViewLayoutDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END
