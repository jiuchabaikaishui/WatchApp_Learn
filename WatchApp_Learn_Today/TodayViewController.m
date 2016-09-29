//
//  TodayViewController.m
//  WatchApp_Learn_Today
//
//  Created by 綦 on 16/9/29.
//  Copyright © 2016年 PowesunHolding. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) UIView *contentView;
@property (weak, nonatomic) UILabel *priceLabel;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(0, 200);
}
- (void)makeView
{
    __weak __typeof(&*self)ws = self;
    //内容视图
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    self.contentView.userInteractionEnabled = YES;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
        make.height.mas_equalTo(@44).priorityHigh();
    }];
    //Label1
    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = [UIColor colorWithRed:66.0/255 green:145.0/255 blue:211.0/255 alpha:1];
    self.priceLabel.text = @"$592.12";
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView.mas_left).with.offset(20);
        make.top.equalTo(ws.contentView.mas_top).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(62, 21));
    }];
    //切换按钮
    self.toggleLineChartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.toggleLineChartButton];
    [self.toggleLineChartButton addTarget:self action:@selector(toggleLineChartViewVisible:) forControlEvents:UIControlEventTouchUpInside];
    [self.toggleLineChartButton setImage:[UIImage imageNamed:@"caret-notification-center"] forState:UIControlStateNormal];
    [self.toggleLineChartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.contentView.mas_right).with.offset(0);
        make.top.equalTo(ws.contentView.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    //Label2
    self.priceChangeLabel = [UILabel new];
    self.priceChangeLabel.textColor = [UIColor colorWithRed:133.0/255 green:191.0/255 blue:37.0/255 alpha:1];
    self.priceChangeLabel.text = @"+1.23";
    [self.contentView addSubview:self.priceChangeLabel];
    [self.priceChangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.toggleLineChartButton.mas_left).with.offset(-20);
        make.top.equalTo(ws.contentView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(44, 21));
    }];
    //Label3
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.backgroundColor = [UIColor clearColor];
    self.detailLabel.numberOfLines = 0;
    [self.contentView addSubview:self.detailLabel];
    self.detailLabel.text = @"\n\n详细信息";
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.priceLabel.mas_bottom).with.offset(0);
        make.left.equalTo(ws.contentView);
        make.width.equalTo(ws.contentView);
        if(self.lineChartIsVisible)
        {
            self.detailLabel.textColor = [UIColor whiteColor];
            make.height.mas_equalTo(@98);
        }
        else
        {
            self.detailLabel.textColor = [UIColor clearColor];
            make.height.mas_equalTo(@0);
        }
    }];
}
- (void)toggleLineChartViewVisible:(id)sender
{
    __weak __typeof(&*self)ws = self;
    //重新布局
    if(self.lineChartIsVisible)
    {
        self.preferredContentSize = CGSizeMake(0, 44);
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0);
            ws.detailLabel.textColor = [UIColor clearColor];
            ws.detailLabel.textAlignment = NSTextAlignmentCenter;
        }];
        //改变按钮的方向
        self.toggleLineChartButton.transform = CGAffineTransformMakeRotation(0);
        self.lineChartIsVisible = NO;
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@44).priorityHigh();
        }];
    }
    else
    {
        self.preferredContentSize = CGSizeMake(0, 142);
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@98);
            ws.detailLabel.textColor = [UIColor whiteColor];
            ws.detailLabel.textAlignment = NSTextAlignmentCenter;
        }];
        //改变按钮的方向
        self.toggleLineChartButton.transform = CGAffineTransformMakeRotation(180.0 * M_PI/180.0);
        self.lineChartIsVisible = YES;
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@142).priorityHigh();
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

@end
