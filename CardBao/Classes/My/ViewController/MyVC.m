//
//  MyVC.m
//  CardBao
//
//  Created by zhangmingheng on 2018/7/18.
//  Copyright © 2018年 andy_zhang. All rights reserved.
//

#import "MyVC.h"
#import "SettingVC.h"
#import "RepaymentVC.h"
#import "MyBankCardVC.h"
#import "ApplyRecordVC.h"
#import "HelperCenterVC.h"

@interface MyVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listTableView;
    NSArray *localArray; // title
    NSArray *ViewCArray; // 视图控制器
    NSArray *iconArray; // 图标
}
@end

@implementation MyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getLocalData];
    [self getUI];
}
-(void)getLocalData {
    localArray = @[@[@""],@[@"申请记录"],@[@"我要还款",@"我的银行卡",@"帮助中心"],@[@"设置"]];
    ViewCArray = @[@[@""],@[[ApplyRecordVC new]],@[[RepaymentVC new],[MyBankCardVC new],[HelperCenterVC new]],@[[SettingVC new]],];
    iconArray  = @[@[@"My_head"],@[@"My_record",],@[@"My_repayment",@"My_bankCard",@"My_help"],@[@"My_setting",]];
}
#pragma mark GetUI
-(void)getUI {
    [self.navigationItem setTitle:@"卡宝"];
    
    // 去掉下划线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    
    //  viewcontroller 不会被tabbar遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    listTableView.dataSource      = self;
    listTableView.delegate        = self;
    listTableView.tableFooterView = [UIView new];
    listTableView.backgroundColor = DYGrayColor(239);
    [self.view addSubview:listTableView];
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    
}
#pragma mark TableView protocol
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [iconArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArray = iconArray[section];
    return rowArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 210;
    else  return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idF = @"CELL";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idF];
    
    if (indexPath.section == 0){
        // 背景图
        UIImageView *backGroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"My_background"]];
        [cell.contentView addSubview:backGroundImg];
        
        // 头像
        UIImageView *headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconArray[indexPath.section][indexPath.row]]];
        headImg.contentMode  = UIViewContentModeScaleAspectFill;
        [backGroundImg addSubview:headImg];
        // 手机
        UILabel *phoneLabel      = [UILabel new];
        phoneLabel.textColor     = [UIColor whiteColor];
        phoneLabel.text          = [NSString stringWithFormat:@"您好\n%@",[self reviewPhone:kUserPHONE]];
        phoneLabel.textAlignment = NSTextAlignmentCenter;
        phoneLabel.numberOfLines = 2;
        [backGroundImg addSubview:phoneLabel];
        
        [backGroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(cell.contentView);
            make.height.mas_equalTo(140.0);
        }];
        [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backGroundImg);
            make.width.height.mas_equalTo(60);
            make.top.equalTo(backGroundImg).offset(20);
        }];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headImg.mas_bottom).offset(10);
            make.centerX.equalTo(backGroundImg);
        }];
        for (int i=0; i<2; i++) {
            UILabel *textLabel       = [UILabel new];
            textLabel.numberOfLines  = 2;
            textLabel.textAlignment  = NSTextAlignmentCenter;
            textLabel.attributedText = i==0?[self getPriceAttribute:@"本月待还\n¥ 0.00"]:[self getPriceAttribute:@"待还总额\n¥ 0.00"];
            [cell.contentView addSubview:textLabel];
            //布局
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(backGroundImg.mas_bottom).offset(15);
                make.left.equalTo(cell.contentView).offset(15+i*screenWidth/2.0);
                make.right.equalTo(cell.contentView).offset(-15-screenWidth/2.0+i*screenWidth/2.0);
            }];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    } else {
        // 图标
        cell.imageView.image = [UIImage imageNamed:iconArray[indexPath.section][indexPath.row]];
        // 文字
        cell.textLabel.text  = localArray[indexPath.section][indexPath.row];
        // 样式
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section > 0) {
        //2 申请记录//3 我要还款//4 我的银行卡//5 帮助中心//6 设置
        [self.navigationController pushViewController:ViewCArray[indexPath.section][indexPath.row] animated:YES];
    }
}
-(NSString*)reviewPhone:(NSString *)text {
    if (![Helper justMobile:text]) {
        return text;
    }
    return [text stringByReplacingOccurrencesOfString:[text substringWithRange:NSMakeRange(3, 4)] withString:@"****"];
}
-(NSMutableAttributedString *)getPriceAttribute:(NSString *)string{
    
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange pointRange = NSMakeRange(0, 4);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = HomeColor;
    //赋值
    [attribut addAttributes:dic range:pointRange];
    
    return attribut;
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
