# waterFullDemo
# 瀑布流实现Demo

本文仅供自己学习总结，参考！
* 对于瀑布流，主要就是对UICollectionView的flowLayout的熟练应用，关于UIcollectionView的布局详细讲解，可以查阅[这篇文章](https://objccn.io/issue-3-3/)


* 当UICollectionView需要刷新时，(放到屏幕上或需要reloadData）或者被标记为需要重新计算布局（调用了layout对象的invalidateLayout方法）时，UICollectionView就会向布局对象请求一系列的方法：


1. 首先会调用prepareLayout方法，在此方法中尽可能将后续布局时需要用到的前置计算处理好，每次重新布局都是从此方法开始。

```
 /**
  
  // The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
  
  //集合视图在布局失效后，在请求布局信息之前再次调用-prepareLayout。
  首先会调用prepareLayout方法，在此方法中尽可能将后续布局时需要用到的前置计算处理好，每次重新布局都是从此方法开始
  
  **/
#pragma mark 准备布局
- (void)prepareLayout
{
    //初始化最大高度数组
    //初始化item布局属性数组
    //获取最大的y值
}

```



2. 调用layoutAttributesForElementsInRect:方法，计算rect内相应的布局，并返回一个装有UICollectionViewLayoutAttributes的数组，Attributes 跟所有Item一一对应，UICollectionView就是根据这个Attributes来对Item进行布局，并当新的Rect区域滚动进入屏幕时再次请求此方法。
   
   
```
//MARK: 返回rect 范围内的item的布局数组（这个方法会频繁调用）

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return  self.attrsArray;
}

```


2.1 通过layoutAttributesForItemAtIndexPath方法获取item的布局属性，在改方法中就要计算出cell的 x, y, width, height

```

//MARK: 返回indexPath位置的item布局属性
/** 注释
 //使用此方法可检索特定项的布局信息。您应该始终使用此方法，而不是直接查询布局对象。
 Use this method to retrieve the layout information for a particular(特定的) item. You should always use this method instead of querying the layout object directly.
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	//计算一个cell的宽度
	//计算当前item应该放在第几列（就是计算那一列高度最短）
	/**
	默认是第0列
	计算的方式就是，遍历装有所有高度的数组，让所有的元素和temp去比较，当temp大于元素时，将这个元素赋值给这个temp，找到高度最小的列
	*/
	
	//计算得到 x,y,width, height
	
	return attrs;
}

```


3. 调用collectionViewContentSize方法，根据第一点中的计算来返回所有内容的滚动区域大小。

ps：CGSize中为啥x的值为0 ？

```
//MARK: 返回collectionViewView的contentSize

- (CGSize)collectionViewContentSize
{
    CGSize size =  CGSizeMake(0, self.maxY + [self edgeInsets].bottom);
    NSLog(@"__ssss__%@", NSStringFromCGSize(size));
    return size;
    
}

```
[附上Demo]()



