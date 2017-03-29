//
//  selectVC.m
//  安邦金融test
//
//  Created by zhimenghzao on 16/10/31.
//  Copyright © 2016年 支梦召. All rights reserved.
//

#import "SelectVC.h"


@interface SelectVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIScrollView *scl;
//食物种类
@property (nonatomic,strong) NSArray  *foods;
//不带肉的种类
@property (nonatomic,strong) NSArray *foodsNotmeat;

@property (nonatomic,strong) NSArray *kind;
@property (nonatomic,strong) NSArray *foodsWithmeat;
@property (nonatomic,strong) UIPickerView *piv;







@end
@implementation SelectVC
@synthesize scl,foods,kind,foodsWithmeat ,foodsNotmeat,piv;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"精选";
    self.view.backgroundColor = [UIColor whiteColor];
    scl = [[UIScrollView alloc]init];
    scl.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*2);
    
    
//    scl.showsVerticalScrollIndicator = NO;
//    scl.showsHorizontalScrollIndicator = NO;
//    [scl setPagingEnabled:YES];
    [self.view addSubview:scl];

    [scl makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height));
    }];
    [self setContentView];
     [self setup];
    
}


-(void)setContentView{
    //添加Button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"你好" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:25]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [scl addSubview:btn];
    [btn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scl).with.offset(80);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(100,30));
        
    }];


}
-(void)setup{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(80, 200, 100, 100);
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn setTitle:@"hahahha" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    

}

















-(void)UIControl{
  
    
    
    //添加TextField
    UITextField *text = [[UITextField alloc]init];
    text.borderStyle = UITextBorderStyleLine;
    text.placeholder = @"请输入密码";
    [text setFont:[UIFont systemFontOfSize:15]];
    [text setBackgroundColor:[UIColor grayColor]];
    [scl addSubview:text];
   
     
//    //添加UISwitch
//    UISwitch *sch = [[UISwitch alloc]init];
//    [<#view#> addSubview:sch];
//    [sch makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(<#view#>).with.offset(<#size#>);
//        make.centerX.equalTo(<#view#>);
//        make.size.equalTo(CGSizeMake(<#width#>,<#hight#>));
//    }];
//    //添加UISlider
//    UISlider *sld = [UISlider new];
//    [<#view#> addSubview:sld];
//    [sld makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(<#view#>).with.offset(<#size#>);
//        make.centerX.equalTo(<#view#>);
//        make.size.equalTo(CGSizeMake(<#width#>,<#height#>));
//    }];
//    
//    //添加UIPageControl
//    UIPageControl *pag = [UIPageControl new];
//    pag.numberOfPages = 3;
//    pag.currentPage = 1;
//    pag.pageIndicatorTintColor = [UIColor greenColor];
//    pag.currentPageIndicatorTintColor = [UIColor redColor];
//    
//    [<#view#> addSubview:pag];
//    [pag makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(<#view#>).with.offset(<#size#>);
//        make.centerX.equalTo(<#view#>);
//        make.size.equalTo(CGSizeMake(<#width#>,<#height#>));
//    }];
//    
//    
//    //添加UISegmentedControl
//    NSArray *arry = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
//    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:arry];
//    seg.selectedSegmentIndex = 0;
//    [<#view#> addSubview:seg];
//    [seg makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(<#view#>).with.offset(<#size#>);
//        make.centerX.equalTo(<#view#>);
//        make.size.equalTo(CGSizeMake(<#width#>,<#height#>));
//    }];
//    
//    //添加UIDatePicker
//    UIDatePicker *dp = [[UIDatePicker alloc]init];
//    [<#view#> addSubview:dp];
//    [dp makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(<#view#>).with.offset(<#size#>);
//        make.centerX.equalTo(<#view#>);
//        make.size.equalTo(CGSizeMake(<#width#>,<#height#>));
//    }];
//    
//    /**添加UITextView
//    dataDetectorTypes
//    delegate
//    editable
//    inputAccessoryView
//    inputView
//    text
//    textAlignment
//    textColor
//     */
//    UITextView *tev = [[UITextView alloc]init];
//    tev.textAlignment = NSTextAlignmentCenter;
//    tev.font = [UIFont systemFontOfSize:20];
//    tev.backgroundColor = [UIColor greenColor];
//    tev.textColor = [UIColor redColor];
//    [<#view#> addSubview:tev];
//    [tev makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(<#view#>).with.offset(<#size#>);
//        make.centerX.equalTo(<#view#>);
//        make.size.equalTo(CGSizeMake(<#width#>,<#height#>));
//    }];
//    //添加UISearchBar
//    UISearchBar *sec = [[UISearchBar alloc]init];
//    sec.barStyle = UISearchBarStyleDefault;
//    sec.placeholder = @"请输入关键词";
//    sec.tintColor = [UIColor redColor];
//    [<#view#> addSubview:sec];
//    [sec makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(<#view#>).with.offset(<#size#>);
//        make.centerX.equalTo(<#view#>);
//        make.size.equalTo(CGSizeMake(<#width#>,<#height#>));
//    }];
//    //添加UILabel
//    UILabel *lab = [[UILabel alloc]init];
//    lab.numberOfLines = 0;
//    lab.textColor = [UIColor redColor];
//    lab.font = [UIFont systemFontOfSize:25];
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.text = @"hahahahhah";
//    [<#view#> addSubview:lab];
//    [lab makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(<#view#>).with.offset(<#size#>);
//        make.centerX.equalTo(<#view#>);
//        make.size.equalTo(CGSizeMake(<#width#>,<#height#>));
//    }];
//    
//    
//    //添加UIPickerView
//    piv =[[UIPickerView alloc]init];
//    piv.dataSource = self;
//    piv.delegate = self;
//    foodsWithmeat = [NSArray arrayWithObjects:@"水煮肉片",@"鱼香肉丝",@"小鸡炒蘑菇",nil];
//    kind = [NSArray arrayWithObjects:@"带肉的",@"不带肉的", nil];
//    foodsNotmeat = [NSArray arrayWithObjects:@"小葱拌豆腐",@"酸辣白菜",@"面条", nil];
//    foods = foodsWithmeat;
////    piv.showsSelectionIndicator=YES;
//    [<#view#> addSubview:piv];
//    [seg makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(<#view#>).with.offset(<#size#>);
//        make.centerX.equalTo(<#view#>);
//        make.size.equalTo(CGSizeMake(<#width#>,<#height#>));
//    }];
//    
//    //添加UIProgressView
//    UIProgressView *prs = [[UIProgressView alloc]init];
//    prs.progressViewStyle = UIProgressViewStyleDefault;
//    prs.progressTintColor = [UIColor redColor];
//    prs.trackTintColor = [UIColor blueColor];
//    value = 0;
//    valueTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        if (value<1) {
//            value += 0.2;
//            prs.progress = value;
//
//        }else{
//            [valueTimer invalidate];
//        }
//
//    }];
//    
//    [<#view#> addSubview:prs];
//    [prs makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(<#view#>).with.offset(<#size#>);
//        make.centerX.equalTo(<#view#>);
//        make.size.equalTo(CGSizeMake(<#width#>,<#height#>));
//    }];
    //截取字符串
    NSString *str = @"20|http://www.smarttemple.com";
    //去掉index == 3以后的
    NSString *str1 = [str substringToIndex:2];
    NSLog(@"%@",str1);
    //去掉index == 4以前的
    NSString *str2 = [str substringFromIndex:3];
    NSLog(@"%@",str2);
 
}

-(void)go{



}

#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return kind.count;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return kind.count;
    }else{
        return foodsWithmeat.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return kind[row];
    }else{
        return foods[row];
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 150;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        if (row == 0) {
            foods = foodsWithmeat;
        }else{
            foods = foodsNotmeat;
        }
    }
    [piv reloadComponent:1];
}

@end;
