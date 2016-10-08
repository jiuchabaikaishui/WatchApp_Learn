//
//  ViewController.m
//  WatchApp_Learn
//
//  Created by 綦 on 16/9/29.
//  Copyright © 2016年 PowesunHolding. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataArr;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation ViewController

#pragma mark - 属性方法
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray arrayWithCapacity:1];
    }
    
    return _dataArr;
}

#pragma mark - 控制器周期
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUi];
}

#pragma mark - 自定义方法
- (void)settingUi
{
    self.title = @"今日计划";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    CGFloat H = 21.5;
    [button setFrame:CGRectMake(0, 0, H, H)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
    [button addTarget:self action:@selector(rightBarAction:) forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 触摸点击方法
- (void)rightBarAction:(UIButton *)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"添加计划" message:@"您的计划做什么呢？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCtr addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = [alertCtr.textFields lastObject];
        [self.dataArr addObject:textField.text];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    okAction.enabled = NO;
    [alertCtr addAction:okAction];
    [alertCtr addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入计划今日事宜！";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }];
    [self presentViewController:alertCtr animated:YES completion:nil];
}
- (void)textFieldChange:(NSNotification *)sender
{
    UIAlertController *alertCtr = (UIAlertController *)self.presentedViewController;
    UITextField *textField = [alertCtr.textFields lastObject];
    UIAlertAction *okAction = [alertCtr.actions lastObject];
    okAction.enabled = textField.text.length > 0;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

@end
