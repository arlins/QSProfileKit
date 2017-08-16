//
//  TableViewTestViewController.m
//  BLSmartLayoutEngineDemo
//
//  Created by arlin on 2017/8/8.
//  Copyright © 2017年 9game. All rights reserved.
//

#import "TableViewTestViewController.h"
#import "BLSmartLayoutEngine.h"
#import "QSWebImageView+UIImageView.h"

@interface TableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIImageView *tagImageView0;
@property (nonatomic, strong) UIImageView *tagImageView1;
@property (nonatomic, strong) UIImageView *tagImageView2;
@property (nonatomic, strong) UILabel *titleLLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end


@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        UIView *rightContentView = [[UIView alloc] initWithFrame:CGRectZero];
        UIView *topContentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.headImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.tagImageView0 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.tagImageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.tagImageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.titleLLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.followButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:rightContentView];
        
        [topContentView addSubview:self.titleLLabel];
        [topContentView addSubview:self.tagImageView0];
        [topContentView addSubview:self.tagImageView1];
        [topContentView addSubview:self.tagImageView2];
        [topContentView addSubview:[[UIView alloc] init]];
        [topContentView addSubview:self.followButton];
        
        [rightContentView addSubview:topContentView];
        [rightContentView addSubview:self.descLabel];
        
        //self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.contentView.bls_layoutType = BLSmartLayoutTypeHBox;
        self.contentView.bls_margins = UIEdgeInsetsMake(10, 10, -10, -10);
        self.contentView.bls_spacing = 10.0;
        
        rightContentView.bls_layoutType = BLSmartLayoutTypeVBox;
        rightContentView.bls_spacing = 5.0;
        topContentView.bls_layoutType = BLSmartLayoutTypeHBox;
        topContentView.bls_spacing = 5;
        
        self.headImage.bls_fixedWidth = 30;
        self.headImage.layer.cornerRadius = 15;
        self.headImage.layer.masksToBounds = YES;
        self.followButton.bls_fixedWidth = 40;
        self.followButton.layer.cornerRadius = 3.0;
        self.followButton.backgroundColor = [UIColor lightGrayColor];
        
        self.tagImageView0.bls_fixedWidth = 20;
        self.tagImageView1.bls_fixedWidth = 20;
        self.tagImageView2.bls_fixedWidth = 20;
        self.titleLLabel.bls_fixedWidth = 100;
        self.titleLLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.titleLLabel.font = [UIFont systemFontOfSize:13.0];
        self.descLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.descLabel.font = [UIFont systemFontOfSize:11.0];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.headImage qs_cancelDownload];
    self.headImage.image = nil;
}

@end

@interface TableViewTestViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *userInfos;

@end

@implementation TableViewTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor blueColor];
    self.view.bls_layoutType = BLSmartLayoutTypeHBox;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    [self.view addSubview:self.tableView];
    [self markTs];
}

- (void)markTs
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *nameArray = @[@"こ無字情書ζ",
                      @"磨磨叽叽o○",
                      @"人海孤独症",
                      @"相忘于江湖う",
                      @"对着太阳喊声日"];
    NSArray *descArray = @[@"我要走了，地球太危险了",
                      @"带上耳机世界与我无关,心跳多久爱多久",
                      @"你长了一张欠吻的嘴, 带沵装B带沵飞",
                      @"连我家的输入法都认识你了,再平凡咱也是限量版i",
                      @"心跳多久爱你多久,怂人～"];
    NSArray *headArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502872149489&di=039429ee6d8bf62c87cd6e1e74788717&imgtype=0&src=http%3A%2F%2Fs.news.bandao.cn%2Fnews_upload%2F201701%2F20170125092309_17NV8T68.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502872301787&di=1fd35004634c50893e6f840b2fd6d6ed&imgtype=0&src=http%3A%2F%2Fpic24.nipic.com%2F20121008%2F3822951_094451200000_2.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502872301787&di=f620851534ae2c2773d258bc75cb86ba&imgtype=0&src=http%3A%2F%2Fpic3.16pic.com%2F00%2F12%2F61%2F16pic_1261451_b.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502872301787&di=c63059e02d31bf59b7bd3b68ccdaf461&imgtype=0&src=http%3A%2F%2Fimg.juimg.com%2Ftuku%2Fyulantu%2F120926%2F219049-12092612154377.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502872301786&di=e642887e539164e5749478f86fea2a10&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F140326%2F235113-1403260U22059.jpg"];
    
    for (int i = 0; i < 1000; i++)
    {
        int nameRandom = arc4random() % nameArray.count;
        int descRandom = arc4random() % descArray.count;
        //int headRandom = arc4random() % headArray.count;
        NSString *name = [nameArray objectAtIndex:nameRandom];
        NSString *desc = [descArray objectAtIndex:descRandom];
        NSString *head = [headArray objectAtIndex:i%5];
        
        [array addObject:[NSString stringWithFormat:@"%d_%@|%@|%@", i, name, desc, head]];
    }
    
    self.userInfos = array;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    NSArray *userInfo = [[self.userInfos objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"];
    
    if ( userInfo.count == 3 )
    {
        NSString *name = [userInfo objectAtIndex:0];
        NSString *desc = [userInfo objectAtIndex:1];
        NSString *head = [userInfo objectAtIndex:2];
        
        [cell.headImage qs_setImageURL:head];
        cell.tagImageView0.image = [UIImage imageNamed:@"icon_hot"];
        cell.tagImageView1.image = [UIImage imageNamed:@"icon_star"];
        cell.tagImageView2.image = [UIImage imageNamed:@"icon_top"];
        cell.titleLLabel.text = name;
        cell.descLabel.text = desc;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
