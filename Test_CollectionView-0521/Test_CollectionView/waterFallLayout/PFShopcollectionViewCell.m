//
//  PFShopcollectionViewCell.m
//  Test_CollectionView
//
//  Created by 崔林豪_mac on 2021/5/18.
//

#import "PFShopcollectionViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"


@interface PFShopcollectionViewCell ()

@property (nonatomic, strong) UIImageView * img;

@property (nonatomic, strong) UILabel * lab;


@end

@implementation PFShopcollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews
{
    UIImageView *img = [[UIImageView alloc] init];
    [self.contentView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        //make.height.mas_equalTo(120);
        make.bottom.mas_equalTo(-23);
    }];
    _img = img;
    
    _img.backgroundColor = UIColor.systemBlueColor;
    
    UILabel *lab = [[UILabel alloc] init];
    [self.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(img.mas_bottom).mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    lab.backgroundColor = UIColor.systemYellowColor;
    lab.textColor = [UIColor greenColor];
    lab.text = @"12323";
}

#pragma mark - 赋值数据

- (void)setShopModel:(PFShopModel *)shopModel
{
    [self.img sd_setImageWithURL:[NSURL URLWithString:shopModel.img] placeholderImage:[UIImage imageNamed:@"123"]];
    
    self.lab.text = shopModel.price;
    
    
}


@end
