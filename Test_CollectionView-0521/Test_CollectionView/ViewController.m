//
//  ViewController.m
//  Test_CollectionView
//
//  Created by 崔林豪_mac on 2021/5/18.
//

#import "ViewController.h"
#import "PFShopcollectionViewCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "PFCollectionViewLayout.h"


//https://www.jianshu.com/p/66d8d88f50ff

 /*
  //1.collectionView第一次布局的时候和布局失效的时候会调用该方法, 需要注意的是子类记得要调用super
  - (void)prepareLayout
  
  //2.返回rect范围内所有元素的布局属性的数组
  - (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
  
  //3.返回indexPath位置上的元素的布局属性
  - (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath

  //4.返回collectionView的滚动范围
  - (CGSize)collectionViewContentSize
  
  **/


@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, PFCollectionViewLayoutDelegate>

@property (nonatomic, strong) NSMutableArray * shops;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UICollectionView *collectionView ;

@end


@implementation ViewController

#pragma mark - Lazy Load
-(NSMutableArray *)shops
{
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemPinkColor;
    self.currentPage = 0;
    
    
    [self _initUI];
}


- (void)_initUI
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5.0;
    flowLayout.minimumInteritemSpacing = 5.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    PFCollectionViewLayout *layout = [[PFCollectionViewLayout alloc] init];
    layout.delegate = self;



    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, height) collectionViewLayout:flowLayout];



    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];

    [collectionView registerClass:[PFShopcollectionViewCell class] forCellWithReuseIdentifier:@"PFShopcollectionViewCell"];
    self.collectionView = collectionView;


    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //模拟网络请求

            [self.shops removeAllObjects];
            [self.shops addObjectsFromArray:[self newShops]];


            [self.collectionView reloadData];

            [self.collectionView.mj_header endRefreshing];

        });
    }];

    //第一次进入加载
    [self.collectionView.mj_header beginRefreshing];

    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *NSEC_PER_SEC)), dispatch_get_main_queue() , ^{
            [self.shops addObjectsFromArray:[self moreShopsWithCurrentPage:self.currentPage]];

            [self.collectionView reloadData];

            [self.collectionView.mj_footer endRefreshing];


        });
    }];


}


#pragma mark - private method

- (NSArray *)newShops
{
    NSMutableArray *arr = [PFShopModel mj_objectArrayWithFilename:@"test.plist"];
    return [PFShopModel mj_objectArrayWithFilename:@"test.plist"];
}

- (NSArray *)moreShopsWithCurrentPage:(NSInteger)currentPage
{
    //页码判断
    if (currentPage == 3) {
        self.currentPage = 0;
    } else {
        self.currentPage++;
    }

    NSString *nextPage = [NSString stringWithFormat:@"%lu.plist", self.currentPage];

    return [PFShopModel mj_objectArrayWithFilename:nextPage];

}


#pragma mark - Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}



- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PFShopcollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PFShopcollectionViewCell" forIndexPath:indexPath];

    //PFShopModel * model =  [[PFShopModel alloc] init];
    //model.price = @"3214234";
    //model.img = @"loading";
    cell.shopModel = self.shops[indexPath.item];

    cell.contentView.backgroundColor = UIColor.purpleColor;
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = UIColor.systemGrayColor;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 230);
}

#pragma mark - Delegate
/**返回index位置下的item高度**/
- (CGFloat)waterFallLayout:(PFCollectionViewLayout *)flowLayout heightForItemAtIndex:(NSInteger)index width:(CGFloat)width
{
    PFShopModel *shop = self.shops[index];
    CGFloat shopHeight = [shop.h doubleValue];
    CGFloat shopwidth = [shop.w doubleValue];
    
    return shopHeight * width / shopwidth;

}



@end
