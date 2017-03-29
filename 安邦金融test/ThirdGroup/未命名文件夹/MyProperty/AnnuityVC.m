//
//  AnnuityVC.m
//  LiCaiBang
//
//  Created by 支梦召 on 2016/12/30.
//  Copyright © 2016年 AnBang. All rights reserved.
//

#import "AnnuityVC.h"
#import "baseSet.h"
#import "AnnuityService.h"
#import "AnnuityModel.h"
#import "myDetailsVC.h"
#import "cardManager.h"
#import "forgetPassVC.h"
#import "myDetailsOfMixVC.h"
#import "myDetailsVC.h"
#import "aplayMenuVC.h"
#import "detailsVC.h"
#import "MenuVC.h"
#import "LoginVC.h"
#import "redeemVC.h"
#import "LCBProductMixViewController.h"
#import "MMDetailViewController.h"
#import "AnnuityProductDetailViewController.h"
#import "myCuston.h"
//基金详情页面
#import "MMDetailFundAplayViewController.h"
#import "AppDelegate.h"
#import "ResetPassWordViewController.h"
#import "LCBOpenAnAccountViewController.h"

#define W   [UIScreen mainScreen].bounds.size.width
#define H   [UIScreen mainScreen].bounds.size.height
@interface AnnuityVC ()<AnnuityServiceDelegate>

//识别银行卡、我的客户号、风险测评、重置的tag值
@property(nonatomic,assign)CGFloat buttonTag;

//接口服务
@property(nonatomic,strong) AnnuityService *annuityService;
//获取到的信息
@property(nonatomic,strong)AnnuityPersonalRichesModel *PersonalRichesModel;

//银行卡数的Label
@property(nonatomic,strong)UILabel *numLabel;
//风险等级
@property(nonatomic,strong)UILabel *typeLaebl;
//总资产
@property(nonatomic,strong)UILabel *moneySumLabel;
//昨日收益
@property(nonatomic,strong)UILabel *yesterMoneyLabel;
//创建底部滚动的scrollView
@property(nonatomic,strong)UIScrollView *botScrollView;
//等待提示
@property(nonatomic,strong)LCBLoadingView *loadingView;

//"银行卡"与"风险测评"提示信息
@property(nonatomic,strong)NSMutableArray <UIView *>*cardAndResk;
@end

@implementation  AnnuityVC

//获取接口数据
-(AnnuityService *)fundService{
    if (_annuityService == nil) {
        _annuityService = [[AnnuityService alloc] init];
        _annuityService.delegate = self;
    }
    return _annuityService;
}

-(NSMutableArray *)cardAndResk{
    if (_cardAndResk == nil) {
        _cardAndResk = [NSMutableArray array];
    }
    return _cardAndResk;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    //获取养老保险资产信息  functionKey = 3
//    [self.annuityService getPersonalRichesWithCustno:self.custon];
//    if (self.loadingView == nil) {
//        self.loadingView = [[LCBLoadingView alloc] initWithFrame:self.view.frame];
//    }
    
    [self.view addSubview:_loadingView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:fundOfBackGroundColor];
    
    
    self.title = @"我的养老保险";
    
    //初始化银行卡、风险测评等按钮的tag
    self.buttonTag = 0;
    
    
    //创建并添加基金总资产等信息
    UIView *topView = [self createTopMsgView:CGRectMake(0, 0, W, 130)];
    
    [self.view addSubview:topView];
    
    //创建银行卡、风险测评、客户号、重置密码的View
    UIView * midView = [self createMidView:CGPointMake(0, CGRectGetMaxY(topView.frame)+3)];
    midView.backgroundColor = [UIColor whiteColor];
    //通过自定义抽取的方法添加垂直分割线
    [midView viewNeedVerLine:midView andLineNum:1];
    
    [self.view addSubview:midView];
    
    //创建并添加底部的scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(midView.frame)+10, W, H-104-5-CGRectGetMaxY(midView.frame)-10)];
    
    scrollView.backgroundColor = [UIColor colorWithHexString:fundOfBackGroundColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    self.botScrollView = scrollView;
    [self.view addSubview:self.botScrollView];
    
    //创建交易记录与申购记录按钮
    UIView *botView = [self createTradeButtonAndApplyButton];
    //适配iOS4时需要调整scrollView的高度
    
    
    //创建垂直分割线
    [botView viewNeedVerLine:botView andLineNum:1];
    [self.view addSubview:botView];
    
    //添加返回按钮
    [self displayReturnButton];
    
}

#pragma mark - 获取客户资产信息
- (void)getDicDataForAnnuityService:(NSMutableDictionary *)data functionKey:(NSString *)functionKey
{
    if ([functionKey isEqualToString:@"7"]) {
        if ([[data objectForKey:@"errorCode"] isEqualToString:@"200"] || [[data objectForKey:@"errorCode"] isEqualToString:@"202"] )
        {
            AnnuityPersonalRichesModel *prmodel = [data objectForKey:@"model"];
            
            //保存信息
            self.PersonalRichesModel = prmodel;
            
            //设置信息
            //银行卡数
            NSString *cardNum = [NSString stringWithFormat:@"%@张",prmodel.cardNum];
            self.numLabel.text = cardNum;
            
            // 客户风险等级
            self.typeLaebl.text = prmodel.custrisk;
            //02保守 03稳健 05激进
            //          NSArray *custrisk = @[@"安全性",@"保守型",@"稳健型",@"积极型",@"激进型"];
            if ([prmodel.custrisk isEqualToString:@"02"]) {
                self.typeLaebl.text = @"保守型";
            }else if ([prmodel.custrisk isEqualToString:@"03"]){
                self.typeLaebl.text = @"稳健型";
            }else if ([prmodel.custrisk isEqualToString:@"05"]){
                self.typeLaebl.text = @"激进型";
            }
            
            
            //客户总资产
            self.moneySumLabel.text = [NSString stringWithFormat:@"%.2f",[prmodel.countAssets doubleValue]];
            //最宽为屏幕宽度
            self.moneySumLabel.frame = CGRectMake(0, self.moneySumLabel.frame.origin.y, W, self.moneySumLabel.frame.size.height);
            self.moneySumLabel.textAlignment = NSTextAlignmentCenter;
            
            //设置昨日收益
            NSString *yesterMoney = [NSString stringWithFormat:@"%@",prmodel.yesterdayGains];
            //小数点后保留两位
            self.yesterMoneyLabel.text =[NSString stringWithFormat:@"%.2f",[yesterMoney doubleValue]];
            //累计收益
            //prmodel.countGains;
            
            self.botScrollView = [self createBotAndRect:self.botScrollView.frame andArr:prmodel.richesList];
            [self.view addSubview:self.botScrollView];
            if (self.loadingView) {
                [self.loadingView removeFromSuperview];
            }
            
            //            for (FundRichesListModel *rlmodel in prmodel.richesList) {
            //
            //                self.botScrollView = [self createBotAndRect:self.botScrollView.frame andArr:rlmodel];
            //                [self.view addSubview:self.botScrollView];
            //
            //            }
            
        } else if ([[data objectForKey:@"errorCode"] isEqualToString:@"201"])
        {
            
            if (self.loadingView) {
                [self.loadingView removeFromSuperview];
            }
            
            toolTipView = [[LCBToolTipView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-20-44-49) andMessage:[data objectForKey:@"errorMessage"]];
            [self.view addSubview:toolTipView];
        }
    }
    
}

#pragma mark - 银行卡、风险测评、我的客户号、重置交易密码
-(UIView *)createMidView:(CGPoint)point{
    
    //装载信息的View
    UIView *baskView = [[UIView alloc]init];
    
    //创建并添加银行卡这一行的View
    NSArray *arr = @[@"银行卡 ",@"风险测评 "];
    UIImage *imageCard = [UIImage imageNamed:@"14我的资产-银行卡65x65"];
    UIImage *imageRisk = [UIImage imageNamed:@"14我的资产-风险评测65x65"];
    NSArray *imageArrOne  = @[imageCard,imageRisk];
    
    //添加银行卡的数量
    UIView *midViewOne = [self createImgAndRect:CGRectMake(0, 0, W, 55) andMsgArr:arr andImage:imageArrOne];
    
    UILabel *NumLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.cardAndResk[0].frame)-3, 16, 30, 14)];
    NumLabel.textColor = [UIColor colorWithHexString:fundOfBABABA];
    //银行卡数
    NumLabel.text = @" ";
    NumLabel.font = [UIFont systemFontOfSize:13];
    self.numLabel = NumLabel;
    [midViewOne addSubview:NumLabel];
    
    //风险测评
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.cardAndResk[1].frame)-5, 16, 70, 14)];
    typeLabel.textColor = [UIColor colorWithHexString:fundOfBABABA];
    //风险等级
    self.typeLaebl = typeLabel;
    typeLabel.font = [UIFont systemFontOfSize:13];
    typeLabel.text = @" ";
    [midViewOne addSubview:typeLabel];
    
    //底部分割线
    [midViewOne createBotLine:midViewOne];
    [baskView addSubview:midViewOne];
    
    
    
    //创建并添加我的客户号这一行的View
    NSArray *arr2 = @[@"开户",@"重置交易密码"];
    UIImage *imageNum = [UIImage imageNamed:@"14我的资产-我的客户号65x65"];
    UIImage *imagePass = [UIImage imageNamed:@"14我的资产-重置交易密码65x65"];
    NSArray *imageArrTwo = @[imageNum,imagePass];
    UIView *midViewTwo = [self createImgAndRect:CGRectMake(0, CGRectGetMaxY(midViewOne.frame)+4, W, 55) andMsgArr:arr2 andImage:imageArrTwo];
    
    [baskView addSubview:midViewTwo];
    
    baskView.frame = CGRectMake(point.x, point.y, W, CGRectGetMaxY(midViewTwo.frame));
    
    //底部分割线
    [midViewTwo createBotLine:midViewTwo];
    return baskView;
    
}

#pragma mark - 创建基金总资产等信息
-(UIView *)createTopMsgView:(CGRect)rect{
    
    //创建一个装载的View
    UIView *backView = [[UIView alloc]initWithFrame:rect];
    
    //背景色
    backView.backgroundColor = [UIColor redColor];
    
    //设置信息基金总资产
    UILabel *moneyMsgLabel = [self sizeWithMessage:@"基金总资产(元)" andFont:15 andPoint:CGPointMake(15, 5) andSelectedCenter:NO];
    
    moneyMsgLabel.textColor = [UIColor colorWithHexString:fundOfFFFFFF];
    moneyMsgLabel.font = [UIFont systemFontOfSize:15];
    
    [backView addSubview:moneyMsgLabel];
    
    
    
    
    //设置信息基金总资产(元)
    UILabel *moneyLabel = [self sizeWithMessage:@"     - -     " andFont:30 andPoint:CGPointMake(0, CGRectGetMaxY(moneyMsgLabel.frame)+10) andSelectedCenter:YES];
    self.moneySumLabel = moneyLabel;
    moneyLabel.textColor = [UIColor colorWithHexString:fundOfFFFFFF];
    moneyLabel.font = [UIFont systemFontOfSize:30];
    
    [backView addSubview:moneyLabel];
    
    //设置信息昨日总收益
    UILabel *moneyPro = [self sizeWithMessage:@"昨日总收益(元)" andFont:12 andPoint:CGPointMake(15, rect.size.height - 44) andSelectedCenter:NO];
    
    moneyPro.font = [UIFont systemFontOfSize:12];
    moneyPro.textColor = [UIColor colorWithHexString:fundOfFFFFFF];
    
    [backView addSubview:moneyPro];
    
    //昨日收益的钱数
    UILabel *moneryNum = [self sizeWithMessage:@"                - -             " andFont:12 andPoint:CGPointMake(CGRectGetMaxX(moneyPro.frame)+5, moneyPro.frame.origin.y) andSelectedCenter:NO];
    //最宽距离屏幕右侧5
    moneryNum.frame = CGRectMake(moneryNum.frame.origin.x, moneryNum.frame.origin.y, W - moneryNum.frame.origin.x - 5, moneryNum.frame.size.height);
    
    self.yesterMoneyLabel = moneryNum;
    
    moneryNum.font = [UIFont systemFontOfSize:12];
    moneryNum.textColor = [UIColor colorWithHexString:fundOfFFFFFF];
    
    [backView addSubview:moneryNum];
    //返回装载信息的View
    return backView;
}

#pragma mark - 通过传入的字符串与字体大小计算所需的Label宽高
-(UILabel *)sizeWithMessage:(NSString *)msgStr andFont:(NSInteger)font andPoint:(CGPoint)point andSelectedCenter:(BOOL)selected{
    
    //通过传入的字符串与字体大小计算所需的Label宽高
    //最大宽度为屏幕的宽
    CGRect Bounds = [msgStr boundingRectWithSize:CGSizeMake(W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil];
    
    //用来动态保存创建的Label
    UILabel *label;
    //若要求居中，则让Label的位置为整个屏幕的中间
    if (selected) {
        //只能设置为整个屏幕的中间位置
        label  = [[UILabel alloc]initWithFrame:CGRectMake(W/2 - Bounds.size.width/2, point.y, Bounds.size.width, Bounds.size.height)];
        
    }else{
        //不居中时则通过传入的点与计算出的size创建Label
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(point.x, point.y, Bounds.size.width, Bounds.size.height)];
    }
    //设置Label内容与字体大小
    label.text = msgStr;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:font];
    
    return label;
}


#pragma mark - 根据信息数组的count创建View中的提示信息数与内容
-(UIView *)createImgAndRect:(CGRect)rect andMsgArr:(NSArray *)array andImage:(NSArray *)imageArr{
    
    //设置装载的View
    UIView *backView = [[UIView alloc]initWithFrame:rect];
    
    //创建临时保存信息的View，通过for循环创建所需的View
    UIView *msgView;
    for (int i = 0 ; i<array.count; i++) {
        
        //设置信息的View并添加到装载View
        msgView = [self createViewAndLogoAndButtonMsg:CGPointMake(10+rect.size.width/array.count*i, 0) AndMsg:array[i] AndLogo:imageArr[i] andFont:15];
        [backView addSubview:msgView];
        
        [self.cardAndResk addObject:msgView];
        
        //给信息添加一个可点击的按钮接收点击事件并处理
        UIButton *btn = [[UIButton alloc]initWithFrame:msgView.frame];
        btn.backgroundColor = [UIColor clearColor];
        //按钮通过tag值区分
        //tag值设为全局变量CGFloat类型，防止每次调用导致按钮的tag值相同
        btn.tag = ++self.buttonTag;
        //给按钮添加点击事件
        [btn addTarget:self action:@selector(clickMsgBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
    }
    
    return backView;
    
}




#pragma mark - 左边一个Logo右边提示信息根据point、font与信息创建
-(UIView *)createViewAndLogoAndButtonMsg:(CGPoint)point AndMsg:(NSString *)str AndLogo:(UIImage *)img andFont:(CGFloat)font{
    
    //设置一个装载信息的View
    UIView *backView = [[UIView alloc]init];
    
    //设置左侧Logo，用按钮设置防止Logo要求点击
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(5, 8, 30, 30)];
    [btn setImage:img forState:UIControlStateNormal];
    
    //添加设置好的按钮
    [backView addSubview:btn];
    
    //根据字符串的内容获取一个size
    CGRect bounds = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil];
    //设置Label
    UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+10, 13, bounds.size.width, bounds.size.height)];
    msgLabel.text = str;
    msgLabel.textColor = [UIColor colorWithHexString:fundOf808080];
    msgLabel.font = [UIFont systemFontOfSize:font];
    //添加Label
    [backView addSubview:msgLabel];
    
    //设置装载信息的View的frame
    backView.frame = CGRectMake(point.x, point.y, CGRectGetMaxX(msgLabel.frame)+5, CGRectGetMaxY(msgLabel.frame));
    //返回装载View
    return backView;
    
    
}

#pragma mark - 银行卡、风险测评等信息的点击事件
-(void)clickMsgBtn:(UIButton *)sender{
    
    
    if (self.botScrollView) {
        [self.botScrollView removeFromSuperview];
        
    }
    //通过按钮的tag值区分点的是哪条信息
    
    AnnuityLoginModel *loginModel = [AnnuityService  getUserAnnuityLoginModelFromNSUserDefaults];
    if (sender.tag == 1) {
        
        //        NSLog(@"银行卡");
        
        cardManager *cardMana = [[cardManager alloc]init];
        cardMana.certificateno = loginModel.certificateno;
        cardMana.custname = loginModel.custname;
        
        [self.navigationController pushViewController:cardMana animated:NO];
        
    }
    else if (sender.tag == 2){
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@?custno=%@",kHttpUrlG3,KFundRiskTest,loginModel.custno];
        
        MMDetailFundAplayViewController *fundCon = [[MMDetailFundAplayViewController alloc] initWithTitle:@"风险测评" andUrl:urlStr hasShareBtn:NO];
        
        [self jumpToNextViewController:fundCon];
        
    }
    else if (sender.tag == 3){
        
//        //         NSLog(@"我的客户号");
//        myCuston *custon = [[myCuston alloc] init];
//        custon.custon = loginModel.custno;
//        [self.navigationController pushViewController:custon animated:NO];
        LCBOpenAnAccountViewController * vc = [[LCBOpenAnAccountViewController alloc] init];
        [self jumpToNextViewController:vc];

        
        
    }
    else if (sender.tag == 4){
        
        //        NSLog(@"重置交易密码");
//        AnnuityLoginModel *loginModel = [AnnuityService  getUserAnnuityLoginModelFromNSUserDefaults];
//        
//        forgetPassVC *forget = [[forgetPassVC alloc] init];
//        forget.custname = loginModel.custname;     //姓名
//        forget.certificateno = loginModel.certificateno;      //身份证号
//        [self.navigationController pushViewController:forget animated:NO];
        
        ResetPassWordViewController * vc = [ResetPassWordViewController new];
        [self jumpToNextViewController:vc];
        
    }
    
    
}

//CGRect topFrame = topView.frame;
//topView.frame = CGRectMake(topFrame.origin.x, topFrame.origin.y, topFrame.size.width, topFrame.size.height);
#pragma mark - 创建底部建信货币等信息的View模板
-(UIView *)setViewWithMsgArray:(NSArray *)array andPoint:(CGPoint)point{
    
    CGFloat leftSpacing = 15;
    
    //一个信息载体View
    UIView *baskView = [[UIView alloc]init];
    
    //如建信货币信息
    UIView *topView = [self setViewWithLogo:array[0] andMessage:array[1] andRect:CGRectMake(leftSpacing, 0, W, 45)];
    [baskView addSubview:topView];
    
    //载体横向View中的分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(leftSpacing, topView.frame.size.height-1, W - 2 * leftSpacing, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:fundOfLineColor];
    [baskView addSubview:lineView];
    
    
    //资产具体金额的信息
    UILabel *moneyLabel = [self sizeWithMessage:array[2] andFont:18 andPoint:CGPointMake(leftSpacing, CGRectGetMaxY(lineView.frame)+5) andSelectedCenter:NO];
    //最大宽度距屏幕中央5
    moneyLabel.frame = CGRectMake(moneyLabel.frame.origin.x, moneyLabel.frame.origin.y, W/2-moneyLabel.frame.origin.x-5, moneyLabel.frame.size.height);
    
    moneyLabel.textColor = [UIColor colorWithHexString:fundOf808080];
    [baskView addSubview:moneyLabel];
    
    //“资产”信息
    UILabel *asstsLabel = [self sizeWithMessage:@"资产(元)" andFont:13 andPoint:CGPointMake(leftSpacing, CGRectGetMaxY(moneyLabel.frame)+3) andSelectedCenter:NO];
    
    asstsLabel.textColor = [UIColor colorWithHexString:fundOfBABABA];
    [baskView addSubview:asstsLabel];
    
    
    //垂直分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(W/2-1, moneyLabel.frame.origin.y, 1, 40)];
    line.backgroundColor = [UIColor colorWithHexString:fundOfLineColor];
    [baskView addSubview:line];
    
    
    
    //"+"
    //    UILabel *add = [self sizeWithMessage:@"+" andFont:13 andPoint:CGPointMake(CGRectGetMaxX(line.frame)+10, moneyLabel.frame.origin.y) andSelectedCenter:NO];
    //    add.textColor = [UIColor colorWithHexString:fundOf808080];
    //    [baskView addSubview:add];
    
    //昨日收益具体金额的信息
    UILabel *yesterAddView = [self sizeWithMessage:array[3] andFont:18 andPoint:CGPointMake(CGRectGetMaxX(line.frame)+10, moneyLabel.frame.origin.y) andSelectedCenter:NO];
    
    //最大宽度距离屏幕右侧5
    yesterAddView.frame = CGRectMake(yesterAddView.frame.origin.x, yesterAddView.frame.origin.y, W-yesterAddView.frame.origin.x-5, yesterAddView.frame.size.height);
    
    //负数为绿色显示
    if ([[yesterAddView.text substringToIndex:1] isEqualToString:@"-"]) {
        yesterAddView.textColor = [UIColor colorWithHexString:fundOfGreen];
    }else {
        yesterAddView.textColor = [UIColor colorWithHexString:fundOfF02215];
    }
    
    [baskView addSubview:yesterAddView];
    
    
    //创建“昨日收益”信息
    UILabel *yesterView = [self sizeWithMessage:@"昨日收益" andFont:13 andPoint:CGPointMake(CGRectGetMaxX(line.frame)+10, asstsLabel.frame.origin.y) andSelectedCenter:NO];
    yesterView.textColor = [UIColor colorWithHexString:fundOfBABABA];
    [baskView addSubview:yesterView];
    
    
    //设置载体View的frame为昨日收益金额下+5距离
    baskView.frame = CGRectMake(point.x, point.y, W, CGRectGetMaxY(yesterView.frame)+5);
    
    //返回载有信息的View
    return baskView;
}


#pragma mark - 创建左边是Logo 中间为Label 右边为按钮的View
-(UIView *)setViewWithLogo:(NSString *)logo andMessage:(NSString *)message andRect:(CGRect)rect {
    
    //创建主界面View
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    
    //创建左侧Logo标志，使用按钮设置以免被要求除法点击事件
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 15, 30, 20)];
    
    
    UIButton *btn = [[UIButton alloc]init];
    btn.layer.cornerRadius = 3;
    btn.layer.borderWidth = 1;
    [btn setTitle:logo forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [btn setTitleColor:[UIColor colorWithHexString:fundOfBABABA] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor colorWithHexString:fundOfBABABA].CGColor;
    btn.frame = leftBtn.frame;
    leftBtn = btn;

    
    [view addSubview:leftBtn];
    
    
    //自动计算中间信息的长度与高度
    CGSize size = [message sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGSize adjustSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    //定义中间信息的rect
    CGRect midRect = CGRectMake(CGRectGetMaxX(leftBtn.frame)+10, 15, adjustSize.width, adjustSize.height);
    
    
    //设置中间信息的Label
    UILabel *midLabel = [[UILabel alloc]initWithFrame:midRect];
    midLabel.text = message;
    midLabel.textColor = [UIColor colorWithHexString:fundOf5F5F5F];
    [midLabel setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:midLabel];
    
    
    //设置右侧按钮并添加
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width-20-36, 15, 11, 20)];
    //如果中间字体过长盖住箭头，让其右移.
    //并限制中间字体最长宽度
    if (midLabel.frame.size.width + midLabel.frame.origin.x > rightBtn.frame.origin.x) {
        //箭头右移15
        rightBtn.frame = CGRectMake(rect.size.width-20-20, 15, 11, 15);
        //固定字体最宽为箭头左侧10
        midLabel.frame = CGRectMake(midLabel.frame.origin.x, midLabel.frame.origin.y, rect.size.width-20-20-10, midLabel.frame.size.height);
    }
    
    [rightBtn setImage:[UIImage imageNamed:@"下拉选项-右箭头16x31"] forState:UIControlStateNormal];
    
    [view addSubview:rightBtn];
    
    //返回载有按钮的View
    return view;
    
}

//#pragma mark - 无论从哪跳入都返回到基金查询
//-(void)doReturn:(id)sender{
//
//    NSUInteger count = self.navigationController.viewControllers.count;
//    if ([self.navigationController.viewControllers[count-2] isKindOfClass:[MyAssetsFundSearchVC class]]) {
//
//        [self.navigationController popViewControllerAnimated:NO];
//    }else {
//
//        MyAssetsFundSearchVC *asstesFundSearch = [MyAssetsFundSearchVC alloc];
//        //获取登录信息
//        FundLoginModel *loginModel = [FundService  getUserFundLoginModelFromNSUserDefaults];
//        asstesFundSearch.custon = loginModel.custno;//客户号
//        asstesFundSearch.accountStatus = @"1";//已开户并无需登录
//        [self.navigationController pushViewController:asstesFundSearch animated:NO];
//    }
//
//}

#pragma mark - 创建底部滚动的ScrollView的相关信息
-(UIScrollView *)createBotAndRect:(CGRect)rect andArr:(NSArray *)richesList{
    
    
    //创建底部的scrollView
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    
    
    //创建scrollView信息
    
    UIView *botView;//底部分割线
    //通过for循环与自定义的模板创建scrollView中的信息
    for (int i=0; i<self.PersonalRichesModel.richesList.count; i++) {
        
        //NSString *addincome = rlmodel.addincome;//	单只基金累计收益
        FundRichesListModel *rlmodel = self.PersonalRichesModel.richesList[i];
        //基金类型
        //0股票  1债券  2货币 3混合 4专户 5指数 6QD
        NSString *type;
        if ([rlmodel.fundtype isEqualToString:@"0"]) {
            type = @"股票";
        }else if ([rlmodel.fundtype isEqualToString:@"1"]){
            type = @"债券";
        }else if ([rlmodel.fundtype isEqualToString:@"2"]){
            type = @"货币";
        }else if ([rlmodel.fundtype isEqualToString:@"3"]){
            type = @"混合";
        }else if ([rlmodel.fundtype isEqualToString:@"4"]){
            //            type = @"专户";     //不显示
        }else if ([rlmodel.fundtype isEqualToString:@"5"]){
            type = @"指数";
        }else if ([rlmodel.fundtype isEqualToString:@"6"]){
            type = @"QDII";
        }
        
        //rlmodel.fundname;基金名称     rlmodel.fundcode;基金代码
        NSString *fundname = [NSString stringWithFormat:@"%@(%@)",rlmodel.fundname,rlmodel.fundcode];
        //单只基金总额
        NSString *sumLump = [NSString stringWithFormat:@"%.2f",[rlmodel.sumLump doubleValue]];
        //	单只基金昨日收益
        NSString *yestincome = [NSString stringWithFormat:@"%.2f",[rlmodel.yestincome doubleValue]];
        
        
        //装载信息的数组
        NSArray *arr3 = @[type,fundname,sumLump,yestincome];
        
        
        botView = [self setViewWithMsgArray:arr3 andPoint:CGPointMake(0, CGRectGetMaxY(botView.frame)+5)];
        botView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:botView];
        
        
        UIButton *scrollButton = [[UIButton alloc]initWithFrame:botView.frame];
        scrollButton.tag = i;
        [scrollButton addTarget:self action:@selector(clickScrollViewButton:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:scrollButton];
        
    }
    
    //改变scrollView的偏移量
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(botView.frame));
    
    return scrollView;
}

#pragma mark - scrollView中的按钮点击事件
-(void)clickScrollViewButton:(UIButton *)sender{
    //    NSLog(@"可通过tag值1、2、3、4...来区分按钮是scrollView的哪一个");
    
    if (self.botScrollView) {
        [self.botScrollView removeFromSuperview];
        
    }
    
    FundRichesListModel *rlmodel = self.PersonalRichesModel.richesList[sender.tag];
    
    //fundtype是2代表货币,其余非货币
    if ([rlmodel.fundtype  isEqualToString:@"2"]) {
        //货币
        myDetailsVC *detail = [[myDetailsVC alloc] init];
        detail.fundRiches = rlmodel;
        detail.custon = self.custon;
        [self.navigationController pushViewController:detail animated:NO];
    }else{
        //   混合
        myDetailsOfMixVC *mixVC = [[myDetailsOfMixVC alloc] init];
        mixVC.fundRiches = rlmodel;
        mixVC.custon = self.custon;
        [self.navigationController pushViewController:mixVC animated:NO];
    }
    
}



#pragma mark - 创建底部交易纪录与申购基金按钮
-(UIView *)createTradeButtonAndApplyButton{
    
    UIView *baskView = [[UIView alloc]initWithFrame:CGRectMake(0, H-104, W, 40)];
    //交易纪录按钮的创建与添加
    UIButton *tradeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, W/2, 40)];
    [tradeButton setTitle:@"交易记录" forState:UIControlStateNormal];
    [tradeButton setTitleColor:[UIColor colorWithHexString:fundOfFFFFFF] forState:UIControlStateNormal];
    tradeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    tradeButton.layer.cornerRadius = 2;
    tradeButton.layer.masksToBounds = YES;
    [tradeButton addTarget:self action:@selector(clickTradeBtn:) forControlEvents:UIControlEventTouchUpInside];
    tradeButton.backgroundColor = [UIColor colorWithHexString:fundOfF02215];
    
    [baskView addSubview:tradeButton];
    
    
    
    //申购基金按钮的创建与添加
    UIButton *apalyButton = [[UIButton alloc]initWithFrame:CGRectMake(W/2+1, 0, W/2-1, 40)];
    [apalyButton setTitle:@"申购基金" forState:UIControlStateNormal];
    [apalyButton setTitleColor:[UIColor colorWithHexString:fundOfFFFFFF] forState:UIControlStateNormal];
    apalyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    apalyButton.layer.cornerRadius = 2;
    apalyButton.layer.masksToBounds = YES;
    [apalyButton addTarget:self action:@selector(clickApalyBtn:) forControlEvents:UIControlEventTouchUpInside];
    apalyButton.backgroundColor = [UIColor colorWithHexString:fundOfF02215];
    
    [baskView addSubview:apalyButton];
    
    
    return baskView;
}

#pragma mark - 申购基金按钮点击
-(void)clickApalyBtn:(UIButton *)sender{
    
    if (self.botScrollView) {
        [self.botScrollView removeFromSuperview];
        
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    AppDelegate *tempDelegate = [AppDelegate sharedDelegate];
    for(UIViewController *v in tempDelegate.navController.viewControllers )
    {
        if ([v isKindOfClass:NSClassFromString(@"LeveyTabBarController")])
        {
            ((LeveyTabBarController *)v).selectedIndex = 3;
        }
    }
}


#pragma mark - 底部交易纪录按钮的点击事件
-(void)clickTradeBtn:(UIButton *)sender{
    
    if (self.botScrollView) {
        [self.botScrollView removeFromSuperview];
        
    }
    //交易详情
    AnnuityProductDetailViewController * vc = [[AnnuityProductDetailViewController alloc] init];
    [self jumpToNextViewController:vc];
    
    
}



@end
