//
//  PFCollectionViewLayout.m
//  Test_CollectionView
//
//  Created by 崔林豪_mac on 2021/5/20.
//

#import "PFCollectionViewLayout.h"

/*默认参数**/

//列数
static const CGFloat PFDefaultColumnCount = 3;
//行间距 10
static const CGFloat PFDefaultRowMargin = 10;
//列间距 10
static const CGFloat PFDefaultColumnMargin = 10;
//edgeInsets {10, 10, 10, 10}
static const UIEdgeInsets PFDefaultedgeInsets = {10, 10, 10, 10};


//记录代理是否响应
struct {
    BOOL didRespondColumnCount : 1; // 列的个数
    BOOL didResponseColumnMargin : 1; //列的间距
    BOOL didResponseRowMargin : 1; // 行间距
    BOOL didRespondEdgeInsets : 1; // 边缘
} _delegateFlages;

@interface PFCollectionViewLayout ()
{
   
}

 /**cell 的布局属性数组**/
@property (nonatomic, strong) NSMutableArray * attrsArray;

 /**每列的高度数组**/
@property (nonatomic, strong) NSMutableArray * columnheights;

 /**最大值**/
@property (nonatomic, assign) CGFloat maxY;

@end

@implementation PFCollectionViewLayout

#pragma mark - Lazy Load

- (NSMutableArray *)columnheights
{
    if (!_columnheights) {
        _columnheights = [NSMutableArray array];
    }
    return _columnheights;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

#pragma mark - layout 方法

 /**
  
  // The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
  
  //集合视图在布局失效后，在请求布局信息之前再次调用-prepareLayout。
  首先会调用prepareLayout方法，在此方法中尽可能将后续布局时需要用到的前置计算处理好，每次重新布局都是从此方法开始
  
  **/
#pragma mark 准备布局
- (void)prepareLayout
{
    [super prepareLayout];
    
    //初始化最大高度数组
    [self _setupColumnHeightsArray];
    [self _setupAttrsArray];
    [self _setupDelegateFlags];
    
    self.maxY = [self _maxYWithColumnHeightsArray:self.columnheights];
    
}

//MARK: 返回rect 范围内的item的布局数组（这个方法会频繁调用）

- (NSArray <UICollectionViewLayoutAttributes *> *)layoutAttributesForElementInRect:(CGRect)rect
{
	return self.attrsArray;
}

//MARK: 返回indexPath位置的item布局属性
/** 注释
 //使用此方法可检索特定项的布局信息。您应该始终使用此方法，而不是直接查询布局对象。
 Use this method to retrieve the layout information for a particular(特定的) item. You should always use this method instead of querying the layout object directly.
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
	
	//开始计算item的x，y width， height
	CGFloat collectionViewWidth = self.collectionView.frame.size.width;
	
	CGFloat contentW = [self edgeInsets].left + [self edgeInsets].right + (([self columnCount] - 1) * [self columnMargin]);
	/** 注释
	 一个cell的宽度
	 */
	CGFloat width = (collectionViewWidth -  contentW) / [self columnCount];
	
	//计算当前item应该放在第几列（就是计算那一列高度最短）
	//默认是第0列
	__block NSInteger minColumn = 0;
	__block CGFloat minHeight = MAXFLOAT;
	[self.columnheights enumerateObjectsUsingBlock:^(NSNumber  *_Nonnull heightNumber, NSUInteger idx, BOOL * _Nonnull stop) {
			//遍历找出最小高度的列
		CGFloat height = [heightNumber doubleValue];
		
		if (minHeight > height) {
			minHeight = height;
			minColumn = idx;
		}
	}];
	
	CGFloat x = [self edgeInsets].left + minColumn *([self columnMargin] + width);
	
	CGFloat y = minHeight + [self rowMargin];
	
	CGFloat height = [self.delegate waterFallLayout:self heightForItemAtIndex:indexPath.item width:width];
	attrs.frame = CGRectMake(x, y, width, height);
	
	//更新数组中的最短列的高度
	self.columnheights[minColumn] = @(y + height);
	
	
	NSLog(@"__aaaaa____%@", NSStringFromCGRect(attrs.frame));
	
	
	return attrs;
}

//MARK: 返回collectionViewView的contentSize

- (CGSize)collectionViewContentSize
{
	return  CGSizeMake(0, self.maxY + [self edgeInsets].bottom);
}

//MARK:


#pragma mark - 处理 prepareLayout

 /**初始化最大高度数组**/

- (void)_setupColumnHeightsArray
{
    [self.columnheights removeAllObjects];
    
    //初始化列高度
    for (int i = 0; i < [self columnCount]; i++) {
        
        [self.columnheights addObject:@([self edgeInsets].top)];
    }
    
}

 /**初始化item布局属性数组**/

- (void)_setupAttrsArray
{
    //清空item布局属性数组
    [self.attrsArray removeAllObjects];
    
    //计算item的attrs
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            // 如果item数目过大容易造成内存峰值提高
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [self.attrsArray addObject:attrs];
        }
    }
}

 /**设置代理方法的标志**/
- (void)_setupDelegateFlags
{
    _delegateFlages.didRespondColumnCount = [self.delegate respondsToSelector:@selector(columnCountOfWaterFallLayout:)];
    
    _delegateFlages.didResponseColumnMargin = [self.delegate respondsToSelector:@selector(columnMarginWaterFallLayout:)];
    
    _delegateFlages.didRespondEdgeInsets = [self.delegate respondsToSelector:@selector(edgeInsetsOfFallLayout:)];
    
    _delegateFlages.didResponseRowMargin = [self.delegate respondsToSelector:@selector(rowMarginOfWaterFallLayout:)];
    
}

 /**计算最大的Y值**/

- (CGFloat)_maxYWithColumnHeightsArray:(NSMutableArray *)array
{
    __block CGFloat maxY = 0;
    [self.columnheights enumerateObjectsUsingBlock:^(NSNumber *heightNumber, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([heightNumber doubleValue] > maxY) {
            maxY = [heightNumber doubleValue];
        }
    }];
    
    return maxY;
}


#pragma mark - 默认参数获取数据

- (NSUInteger)columnCount
{
    return _delegateFlages.didRespondColumnCount ? [self.delegate columnCountOfWaterFallLayout:self] : PFDefaultColumnCount;
}

- (CGFloat)columnMargin
{
    return _delegateFlages.didResponseRowMargin ? [self.delegate columnMarginWaterFallLayout:self] : PFDefaultColumnMargin;
}

- (CGFloat)rowMargin
{
    return _delegateFlages.didResponseRowMargin ? [self.delegate rowMarginOfWaterFallLayout:self] : PFDefaultRowMargin;
}

- (UIEdgeInsets)edgeInsets
{
    return _delegateFlages.didRespondEdgeInsets? [self.delegate edgeInsetsOfFallLayout:self] : PFDefaultedgeInsets;
}

@end
