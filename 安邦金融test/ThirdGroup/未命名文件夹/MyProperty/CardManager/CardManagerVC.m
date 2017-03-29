//
//  CardManagerVC.m
//  LiCaiBang
//
//  Created by 支梦召 on 2017/1/6.
//  Copyright © 2017年 AnBang. All rights reserved.
//

#import "CardManagerVC.h"
#import "CardCell.h"
#import "LCBTakePhotoCell.h"

@interface CardManagerVC ()<UITableViewDelegate ,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSArray *cardName;
@property (nonatomic,strong) NSArray *cardImage;
@property (nonatomic,strong) NSArray *cardNumber;

@end

@implementation CardManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self displayReturnButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:_tableView];
    
    self.cardName = @[@"中国银行",@"农业银行"];
    self.cardImage = @[@"gl",@"zg"];
    self.cardNumber = @[@"1234",@"5678"];
    
}

#pragma  mark - UITableViewDataSourse (数据源方法)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cardName.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    LCBTakePhotoCell *cell = [LCBTakePhotoCell cellWithTableView:tableView];
   
    cell.titleLabelMess.text = @"ddadaaergeage";
//    cell.nameStr = @"中国";
//    cell.numberStr = @"22222";
//    cell.imageStr = @"gl";
    
    return cell;
   
    
}
#pragma  mark - UITableViewDelegate (代理方法)
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}



@end
