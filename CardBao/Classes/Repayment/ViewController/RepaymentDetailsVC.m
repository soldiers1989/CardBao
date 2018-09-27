//
//  RepaymentDetailsVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/20.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//
#import "AdvanceEndAlert.h"
#import "RepaymentPlanVC.h"
#import "RepaymentDetailsVC.h"
#import "RepaymentDetailsCell.h"

@interface RepaymentDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
}
@end

@implementation RepaymentDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUI];
}
#pragma mark GETUI
-(void)getUI {
    self.title = @"我要还款";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提前结清" style:UIBarButtonItemStyleDone target:self action:@selector(advanceEnd:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    // tableView
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [listTableView registerClass:[RepaymentDetailsCell class] forCellReuseIdentifier:@"RepaymentDetailsCell"];
    listTableView.dataSource         = self;
    listTableView.delegate           = self;
    listTableView.estimatedRowHeight = 200;
    listTableView.backgroundColor    = DYGrayColor(243);
    listTableView.scrollEnabled      = NO;
    listTableView.tableFooterView    = [UIView new];
    [self.view addSubview:listTableView];
    
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
}
#pragma mark TableView protocol
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0;
    else return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view         = [UIView new];
    view.backgroundColor = DYGrayColor(243);
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idf = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idf];
    
    if (indexPath.section == 0) {
        cell.separatorInset = UIEdgeInsetsMake(0, screenWidth,0, -screenWidth);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSectionOne:cell];
        
        
    } else if (indexPath.section == 1) {
        RepaymentDetailsCell *cellA = [tableView dequeueReusableCellWithIdentifier:@"RepaymentDetailsCell"];
        cellA.separatorInset = UIEdgeInsetsMake(0, screenWidth,0, -screenWidth);
        
        // 赋值
        cellA.currentTotalLabel.text = @"当前应还：5000.00元";
        cellA.billLabel.text         = @"第1/12期账单";
        cellA.moneyLabel.text        = @"应还本金：4000.00";
        cellA.interestLabel.text     = @"应还利息：200.00";
        cellA.dateLabel.text         = @"应还日期：20-09-09";
        cellA.penaltyLabel.text      = @"应还罚息：33.00";
        
        cellA.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellA;
        
    } else {
        cell.separatorInset = UIEdgeInsetsZero;
        cell.textLabel.text = @"还款计划";
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"查看";
    }
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        RepaymentPlanVC *planVC = [RepaymentPlanVC new];
        [self.navigationController pushViewController:planVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
-(void)initSectionOne:(UITableViewCell*)cell {
    NSArray *titleArray = @[@"借款金额\n50000.00元",@"待还金额\n50000.00元",@"借款期限\n12个月"];
    for (int i = 0; i<titleArray.count; i++) {
        UILabel *label      = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text          = titleArray[i];
        label.numberOfLines = 2;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(15);
            make.bottom.equalTo(cell.contentView).offset(-15);
            make.left.equalTo(cell.contentView).offset(i*screenWidth/3.0);
            make.width.mas_equalTo(screenWidth/3.0);
        }];
        
    }
}
#pragma mark 提前结束
-(void)advanceEnd:(UIBarButtonItem*)sender {
    AdvanceEndAlert *alert = [[AdvanceEndAlert alloc]init];
    alert.totalNum         = @"还款总额：4920.00元";
    alert.moneyNum         = @"剩余本金：800.00元";
    alert.interestNum      = @"剩余利息：34.00元";
    alert.feeNum           = @"手续费：12.00元";
    
    alert.event = ^(NSInteger index) {
        NSLog(@"index:%d",index);
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end