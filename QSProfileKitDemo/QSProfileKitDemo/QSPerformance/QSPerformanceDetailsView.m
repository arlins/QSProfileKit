//
//  QSPerformanceDetailsView
//  QSProfileKit
//
//  Created by arlin on 2017/8/11.
//  Copyright © 2017年 bls. All rights reserved.
//

#import "QSPerformanceDetailsView.h"
#import "QSProfileKit.h"

static QSPerformanceDetailsView *g_detailWindow = nil;

@interface QSDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *textFillLabel;

@end

@implementation QSDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        self.textFillLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        self.textFillLabel.textColor = [UIColor greenColor];
        self.textFillLabel.font = [UIFont systemFontOfSize:10];
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.textFillLabel];
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (void)setSelected:(BOOL)selected
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = CGRectMake(4, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    self.textFillLabel.frame = rect;
}

@end

@interface QSPerformanceDetailsView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *details;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation QSPerformanceDetailsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
        
        [_tableView registerClass:[QSDetailCell class] forCellReuseIdentifier:@"QSDetailCell"];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.layer.cornerRadius = 4.0;
        [self addSubview:_tableView];
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
        [self addGestureRecognizer:self.panGestureRecognizer];
        
        [self fillAllDetails];
        [self startTimer];
    }
    
    return self;
}

- (void)dragAction:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged
        || sender.state == UIGestureRecognizerStateEnded )
    {
        CGPoint offset = [sender translationInView:self];
        CGPoint targetPoint = CGPointMake(self.center.x + offset.x - self.bounds.size.width/2.0, self.center.y + offset.y - self.bounds.size.height/2.0);
        CGRect targetRect = CGRectMake(targetPoint.x, targetPoint.y, self.bounds.size.width, self.bounds.size.height);
        CGRect screenArea = [UIScreen mainScreen].bounds;
        
        if ( CGRectContainsRect(screenArea, targetRect))
        {
            CGPoint targetCenter = CGPointMake(self.center.x + offset.x, self.center.y + offset.y);
            [self setCenter:targetCenter];
        }
        
        [sender setTranslation:CGPointMake(0, 0) inView:self];
    }
}

+ (void)show
{
    if ( g_detailWindow == nil )
    {
        g_detailWindow = [[QSPerformanceDetailsView alloc] initWithFrame:CGRectMake(20, 20, 120, 68)];
    }
    
    if ( g_detailWindow.hidden )
    {
        g_detailWindow.hidden = NO;
    }
}

+ (void)hide
{
    g_detailWindow = nil;
}

- (void)dealloc
{
    [self removeGestureRecognizer:_panGestureRecognizer];
    
    [_timer invalidate];
}

- (void)startTimer
{
    if ( _timer )
    {
        return;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:[QSWeakProxy proxyWithTarget:self]
                                            selector:@selector(onTimerTimeout:)
                                            userInfo:nil
                                             repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)onTimerTimeout:(NSTimer *)timer
{
    [self fillAllDetails];
    [self.tableView reloadData];
}

- (void)fillAllDetails
{
    QSPerformanceMemoryDetail *memoryDetail = [QSPerformanceService sharedService].memoryDetail;
    QSPerformanceNetworkDetail *networkDetail = [QSPerformanceService sharedService].networkDetail;
    NSMutableArray *detailsArray = [NSMutableArray array];
    
    {
        NSMutableString *text = [NSMutableString string];
        [text appendString:[NSString stringWithFormat:@"FPS: %d", [QSPerformanceService sharedService].fps]];
        [text appendString:[NSString stringWithFormat:@" CPU: %.2f%%", [QSPerformanceService sharedService].cpuUsage]];
        [detailsArray addObject:text];
    }
    
    {
        NSMutableString *text = [NSMutableString string];
        [text appendString:[NSString stringWithFormat:@"内存: %.2fMB", memoryDetail.usage/(1024*1024.0)]];
        [text appendString:[NSString stringWithFormat:@" %.2lf%%", memoryDetail.ratio]];
        [detailsArray addObject:text];
    }
    
    {
        NSMutableString *text = [NSMutableString string];
        [text appendString:[NSString stringWithFormat:@"上行: %@", [self translateSpeedToString:networkDetail.upSpeed]]];
        [detailsArray addObject:text];
    }
    
    {
        NSMutableString *text = [NSMutableString string];
        [text appendString:[NSString stringWithFormat:@"下行: %@", [self translateSpeedToString:networkDetail.downSpeed]]];
        [detailsArray addObject:text];
    }
    
    self.details = [NSArray arrayWithArray:detailsArray];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.details.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QSDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QSDetailCell"];
    
    cell.textFillLabel.text = [self.details objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSString *)translateSpeedToString:(double)speed
{
    NSString *speedString = nil;
    
    if ( speed < 0.00001 )
    {
        speedString = @"0 B/s";
    }
    else if ( speed < 1024.0 )
    {
        speedString = [NSString stringWithFormat:@"%.2lf B/s", speed];
    }
    else if ( speed < 1024*1024.0 )
    {
        speedString = [NSString stringWithFormat:@"%.2lf KB/s", speed/1024.0];
    }
    else
    {
        speedString = [NSString stringWithFormat:@"%.2lf MB/s", speed/1024*1024.0];
    }
    
    return speedString;
}

@end
