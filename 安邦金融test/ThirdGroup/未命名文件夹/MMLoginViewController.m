//
//  MMLoginViewController.m
//  ZhuanLe
//
//  Created by frank on 14-10-14.
//  Copyright (c) 2014年 AnBang. All rights reserved.
//

#import "MMLoginViewController.h"
#import "UIColor-RGB.h"
#import "MMRegisterViewController.h"
#import "MMForgetPasswordViewController.h"
#import "LCBAssetsViewController.h"
#import "LCBProductListViewController.h"
#import "LCBMoreViewController.h"
#import "HostViewController.h"
#import "RongCloudService.h"
#import "ProductInfoService.h"
#import "WXApi.h"
#import "View+MASAdditions.h"
#import "UMSocial.h"
#import "UMSocialSnsData.h"
#import "UMSocialBar.h"
#import "UMSocialData.h"
#import "UMSocialConfig.h"
#import "UMSocialSnsService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialAccountManager.h"
#import "AFNetworking.h"

@implementation MMLoginViewController
@synthesize userField,passField,weChatButton,thirdLable,Account,model;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    self.navigationController.navigationBarHidden = NO;
//    self.returnButton.hidden = NO;
    self.returnButton.hidden = _isHideBackButton;

    if (userField || passField)
    {
        [self EmptyTextValue];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //导航栏
    self.title = @"登录";
    [self displayReturnButton];

    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, KScreenW, KRowHeight * 2)];
    bgView.layer.borderColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    bgView.layer.borderWidth = 1.0;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIView *lineOneView = [[UIView alloc]initWithFrame:CGRectMake(0, KRowHeight, KScreenW, 0.8)];
    lineOneView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [bgView addSubview:lineOneView];
    
    UIImage *userIconImg = [UIImage imageNamed:@"l_userIcon.png"];
    UIImageView *useIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(30, (KRowHeight-userIconImg.size.height)/2, userIconImg.size.width, userIconImg.size.height)];
    useIconImgView.image = userIconImg;
    [bgView addSubview:useIconImgView];
    
    UIImage *passIconImg = [UIImage imageNamed:@"l_passIcon.png"];
    UIImageView *passIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(useIconImgView.frame.origin.x, (KRowHeight-userIconImg.size.height)/2+KRowHeight, passIconImg.size.width, passIconImg.size.height)];
    passIconImgView.image = passIconImg;
    [bgView addSubview:passIconImgView];
    
    //用户名输入框
    userField = [[MMInputField alloc]initWithFrame:CGRectMake(useIconImgView.bounds.origin.x+useIconImgView.bounds.size.width, 1,(KScreenW-userIconImg.size.width-20), KRowHeight) andPlaceholder:@"请输入手机号"];
    userField.returnKeyType = UIReturnKeyDone;
    userField.text = @"";
    userField.font = KLabelFont;
    userField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:userField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#c3cbd8"]}];
    userField.delegate = self;
    [bgView addSubview:userField];
    
    //密码输入框
    passField = [[MMInputField alloc]initWithFrame:CGRectMake(userField.frame.origin.x, userField.frame.origin.y+userField.frame.size.height, userField.frame.size.width, userField.frame.size.height) andPlaceholder:@"请输入密码"];
    passField.returnKeyType = UIReturnKeyDone;
    passField.text = @"";
    passField.font = KLabelFont;
    passField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:passField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#c3cbd8"]}];
    passField.delegate = self;
    passField.secureTextEntry = YES;
    [bgView addSubview:passField];
    
    //登录按钮背景
//    UIView *btnBgView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.origin.y+bgView.frame.size.height, KScreenW, 75)];
//    btnBgView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
//    [self.view addSubview:btnBgView];
//    
//    UIView *lineTwoView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, KScreenW, 0.8)];
//    lineTwoView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
//    [btnBgView addSubview:lineTwoView];
    
    //登录按钮
    UIImage *loginImg = [UIImage imageNamed:@"l_loginBtn.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 5, 0, 5);
    // 指定为拉伸模式，伸缩后重新赋值
    loginImg = [loginImg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, bgView.frame.origin.y+bgView.frame.size.height+15, KScreenW-30, 35/*loginImg.size.height*/)];
    [loginBtn setBackgroundImage:loginImg forState:UIControlStateNormal];
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [loginBtn addTarget:self action:@selector(loginBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //忘记密码
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenW-80-15, loginBtn.frame.origin.y+loginBtn.frame.size.height+16, 80, 18)];
    passwordLabel.backgroundColor = [UIColor clearColor];
    passwordLabel.text = @"忘记密码";
    passwordLabel.textColor = [UIColor colorWithHexString:@"#617583"];
    passwordLabel.font = KLabelFont;
    passwordLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:passwordLabel];
    UIButton *passwordBtn = [[UIButton alloc]initWithFrame:passwordLabel.frame];
    passwordBtn.backgroundColor = [UIColor clearColor];
    [passwordBtn addTarget:self action:@selector(passwordBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passwordBtn];
    
    //注册按钮
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, loginBtn.frame.origin.y+loginBtn.frame.size.height+15, 80, 18)];
    registerLabel.backgroundColor = [UIColor clearColor];
    registerLabel.text = @"我要注册";
    registerLabel.textColor = [UIColor colorWithHexString:@"#617583"];
    registerLabel.font = KLabelFont;
    registerLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:registerLabel];
    UIButton *registerBtn = [[UIButton alloc]initWithFrame:registerLabel.frame];
    registerBtn.backgroundColor = [UIColor clearColor];
    [registerBtn addTarget:self action:@selector(registerBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];

    
     [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (HidesBackButton) name:@"HidesBackButton" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (EmptyTextValue) name:@"EmptyTextValue" object:nil];

    loadingView=[[LCBLoadingView alloc] initWithFrame:self.view.bounds];
    
        //第三方微信登录
        // 如果当前手机安装过微信了，才会有下面的的微信登录的view 出现
        if ([WXApi isWXAppInstalled]) {
    
            //创建文字三方登录thirdLable
            thirdLable = [[UILabel alloc]init];
            thirdLable.text = @"使用第三方账号登录";
            thirdLable.tintColor = [UIColor blackColor];
            thirdLable.font = [UIFont systemFontOfSize:15];
            [self.view addSubview:thirdLable];
            //根据文字长度设置lable长度
            CGSize thirdLabelSize = [thirdLable textSizeWithFont:15 withMessage:thirdLable.text];
            [thirdLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(registerLabel.mas_bottom).offset(100*KScreenH/667);
                make.centerX.equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(thirdLabelSize.width, thirdLabelSize.height));
            }];
    
            //创建第一条线
            UIView *thirdLine1 = [[UIView alloc]init];
            thirdLine1.backgroundColor = [UIColor grayColor];
    
            [self.view addSubview:thirdLine1];
            [thirdLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(thirdLable);
                make.left.equalTo(self.view.mas_left).offset(20);
                make.right.equalTo(thirdLable.mas_left).offset(-20);
                make.height.mas_equalTo(1);
            }];
    
            //创建第二条线
            UIView *thirdLine2 = [[UIView alloc]init];
            thirdLine2.backgroundColor = [UIColor grayColor];
            [self.view addSubview:thirdLine2];
    
            [thirdLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(thirdLable);
                make.left.equalTo(thirdLable.mas_right).offset(20);
                make.right.equalTo(self.view.mas_right).offset(-20);
                make.height.mas_equalTo(1);
    
            }];
    
            // 创建可点击登陆的weChatButton
            weChatButton = [[UIButton alloc] init];
            weChatButton.layer.cornerRadius = 5;
            weChatButton.layer.masksToBounds = YES;
            [weChatButton setImage:[UIImage imageNamed:@"weChat_button"] forState:UIControlStateNormal];
            [self.view addSubview:weChatButton];
            [weChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(thirdLable.mas_bottom).offset(70*KScreenH/667);
                make.centerX.equalTo(thirdLable);
                make.size.mas_equalTo(CGSizeMake(80, 80));
            }];
            [weChatButton addTarget:self action:@selector(weChatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    
}
// 微信登录的点击事件
- (void)weChatButtonAction:(UIButton *)sender {
    // 添加获取用户信息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeChatUserInfo) name:abWX_GetWeChatUserInfo object:nil];
    [self weChatLogin];
}
- (void)weChatLogin {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"app";
    [WXApi sendReq:req]; // 开始拉微信的客户端
}
//获取微信用户信息
- (void) getWeChatUserInfo {
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:abWX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:abWX_OPEN_ID];
    LoginService *loginService = [[LoginService alloc]init];
    loginService.delegate = self;
    [loginService getWeChatInfoWithAccessToken:accessToken withOpenId:openID];

}

// 删除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)doReturn:(id)sender
{
    [self rightInfoTips];
}

- (void)HidesBackButton
{
    self.returnButton.hidden = YES;
}

//退出登录成功后清空用户名和密码
- (void)EmptyTextValue
{
    userField.text = @"";
    passField.text = @"";
}

//登录方法
- (void)loginBtnPressed
{
    [userField resignFirstResponder];
    [passField resignFirstResponder];

    //    //用户名和密码判断
    if((userField.text==nil)||[userField.text isEqualToString:@""])
    {
        toolTipView = [[LCBToolTipView alloc]initWithFrame:bgView.bounds andMessage:@"请输入正确的手机号"];
        [bgView addSubview:toolTipView];
        return;
    }
    if ([passField.text isEqualToString:@""] || passField.text == nil)
    {
        toolTipView = [[LCBToolTipView alloc]initWithFrame:bgView.bounds andMessage:@"用户名或密码错误，请重新输入"];
        [bgView addSubview:toolTipView];

        return;
    }
    
    [self.view addSubview:loadingView];
    

    LoginService *loginService = [[LoginService alloc]init];
    loginService.delegate = self;
    [loginService loginWithLoginName:userField.text loginPWD:passField.text sourcecode:kAppSrcType];
}

//忘记密码
- (void)passwordBtnPressed
{
    MMForgetPasswordViewController *forgetCon = [[MMForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetCon animated:NO];
}

//注册新会员
- (void)registerBtnPressed
{
    MMRegisterViewController *registerCon = [[MMRegisterViewController alloc]initWithTitle:@"注册" withModel:nil];
    [self.navigationController pushViewController:registerCon animated:NO];
}


#pragma mark - bindTelephoneNumberDelegate
- (void)bindTelephoneNumber
{
    toolTipView = [[LCBToolTipView alloc]initWithFrame:bgView.bounds andMessage:@"用户手机号绑定"];
    [bgView addSubview:toolTipView];
}

#pragma mark - LoginServiceDelegate
-(void)getDicDataForLoginService:(NSMutableDictionary *)data functionKey:(NSString *)functionKey
{
    [loadingView removeFromSuperview];
    
    //登录
    if ([functionKey isEqualToString:@"1"])
    {
        NSTimeInterval timeInterval = 1.0;
        if ([[data objectForKey:@"errorCode"] isEqualToString:@"200"] || [[data objectForKey:@"errorCode"] isEqualToString:@"202"] )
        {
            
            if (![[data objectForKey:@"errorMessage"] isEqualToString:@""] || [data objectForKey:@"errorMessage"] != nil)
            {
                toolTipView = [[LCBToolTipView alloc]initWithFrame:bgView.bounds andMessage:[data objectForKey:@"errorMessage"]];
                [bgView addSubview:toolTipView];
                timeInterval = 0.0;
            }
            else
            {
                timeInterval = 0.0;
            }
          
            
            //登录成功发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_ABJinRong_Login_Success" object:@"islogin" userInfo:nil];

            //调"判断是否实名认证"接口
            UserDefaultsVariableModel *udvm = [CommonService getUserDefaultsVariableModelFromNSUserDefaults];
            if (!udvm.isUserVerified || udvm.idcardno.length==0) {
                [self.view addSubview:loadingView];
                ProductInfoService *infoService = [[ProductInfoService alloc]init];
                infoService.delegate = self;
                [infoService getProductUserVerified];
            }

//            timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(rightInfoTips) userInfo:nil repeats:NO];
        
            
            TouchIDModel *touchId = [[TouchIDModel alloc] init];
            touchId.userName = userField.text;
            touchId.passWord = passField.text;
            [CommonService updateTouchIDModelToNSUserDefaults:touchId];
            
        }
        else if ([[data objectForKey:@"errorCode"] isEqualToString:@"201"])
        {
            toolTipView = [[LCBToolTipView alloc]initWithFrame:bgView.bounds andMessage:[data objectForKey:@"errorMessage"]];
            [bgView addSubview:toolTipView];
            timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(errorInfoTips) userInfo:nil repeats:NO];
        }
    }
    //微信判断是否绑定
    if ([functionKey isEqualToString:@"11"]) {
        [loadingView removeFromSuperview];
        NSTimeInterval timeInterval = 1.0;
        if ([[data objectForKey:@"errorCode"] isEqualToString:@"200"] || [[data objectForKey:@"errorCode"] isEqualToString:@"202"] )
        {
            
            //已绑定
            if ([[data objectForKey:@"isbindCode"] isEqualToString:@"0"])
            {
                toolTipView = [[LCBToolTipView alloc]initWithFrame:bgView.bounds andMessage:[data objectForKey:@"errorMessage"]];
                [bgView addSubview:toolTipView];
                timeInterval = 0.0;


                //登陆成功发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_ABJinRong_Login_Success" object:@"islogin" userInfo:nil];
                
                
                //调"判断是否实名认证"接口
                UserDefaultsVariableModel *udvm = [CommonService getUserDefaultsVariableModelFromNSUserDefaults];
                if (!udvm.isUserVerified || udvm.idcardno.length==0) {
                    ProductInfoService *infoService = [[ProductInfoService alloc]init];
                    infoService.delegate = self;
                    [infoService getProductUserVerified];
                }

                
            }else{
                //未绑定跳转到注册绑定页面
                timeInterval = 0.0;
                MMRegisterViewController *weChatRegister = [[MMRegisterViewController alloc]initWithTitle:@"注册/绑定" withModel:model]; ;
                [self jumpToNextViewController:weChatRegister];
            }
            
           
            /*
             返回参数中没有用户密码
            TouchIDModel *touchId = [[TouchIDModel alloc] init];
            touchId.userName = userField.text;
            touchId.passWord = passField.text;
            [CommonService updateTouchIDModelToNSUserDefaults:touchId];
             */
            
        }
        else if([[data objectForKey:@"errorCode"] isEqualToString:@"201"]){
    
            toolTipView = [[LCBToolTipView alloc]initWithFrame:bgView.bounds andMessage:[data objectForKey:@"errorMessage"]];
            [bgView addSubview:toolTipView];
            timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(errorInfoTips) userInfo:nil repeats:NO];
    }

}
    //获取用户信息
    if ([functionKey isEqualToString:@"15"]) {
        
        if ([[data objectForKey:@"responseMessage"] objectForKey:@"unionid"] && ![[[data objectForKey:@"responseMessage"] objectForKey:@"unionid"] isEqualToString:@""]) {
            model = [[WeChatModel alloc]initWithDic:[data objectForKey:@"responseMessage"]];
            //将用户头像地址存入本地
            [[NSUserDefaults standardUserDefaults] setObject:[[data objectForKey:@"responseMessage"] objectForKey:@"headimgurl"] forKey:abWeChatIconUrl];
            //判断是否绑定
            LoginService *loginService = [[LoginService alloc]init];
            loginService.delegate = self;
            [loginService isBindWithUnionid:model.unionid];
        }else{
            toolTipView = [[LCBToolTipView alloc]initWithFrame:bgView.bounds andMessage:@"微信授权失败"];
            [bgView addSubview:toolTipView];
        
        }
        
    }

}

- (void)rightInfoTips
{
    [timer invalidate];
    if (loadingView)
    {
        [loadingView removeFromSuperview];
    }
    
    UserDefaultsVariableModel *udvm = [CommonService getUserDefaultsVariableModelFromNSUserDefaults];
    if ((udvm.AccountName!=nil)&&(![udvm.AccountName isEqualToString:@""])&&((udvm.MobilePhoneNumber==nil)||[udvm.MobilePhoneNumber isEqualToString:@""])) {
        LCBAlertView *errorAlert = [[LCBAlertView alloc] initWithTitle:@"您还没有绑定手机号" contentText:nil leftButtonTitle:@"立即绑定" rightButtonTitle:@"取消" ImageView:nil];
        errorAlert.delegate = self;
        [errorAlert show];
    }
    else{
        [self.navigationController popViewControllerAnimated:NO];
        NSNotification * addMessage = [NSNotification notificationWithName:@"addMessagePoint" object:nil userInfo:nil];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:addMessage];
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,  NSUserDomainMask, YES);
    NSString *cachesDirectoryPath = [paths objectAtIndex:0];
    NSString *productListFile = [cachesDirectoryPath stringByAppendingPathComponent:@"productList.plist"];
    [[NSFileManager defaultManager] removeItemAtPath:productListFile error:nil];

    //连接融云
    RongCloudService *rcs = [[RongCloudService alloc]init];
    [rcs connectRongCloud];

}

- (void)errorInfoTips
{
    [timer invalidate];

    if (loadingView)
        [loadingView removeFromSuperview];

}

#pragma mark - ProductInfoServiceDelegate
-(void)getDicDataForProductInfoService:(NSMutableDictionary *)data functionKey:(NSString *)functionKey
{
    [loadingView removeFromSuperview];
    
    //是否实名认证
    if ([functionKey isEqualToString:@"10"])
    {
        NSTimeInterval timeInterval = 1.0;
        if ([[data objectForKey:@"errorCode"] isEqualToString:@"200"] || [[data objectForKey:@"errorCode"] isEqualToString:@"202"] )
        {
            
            if (![[data objectForKey:@"errorMessage"] isEqualToString:@""] || [data objectForKey:@"errorMessage"] != nil)
            {
                toolTipView = [[LCBToolTipView alloc]initWithFrame:bgView.bounds andMessage:[data objectForKey:@"errorMessage"]];
                timeInterval = 1.0;
            }
            else
            {
                timeInterval = 0.0;
            }
            
            timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(rightInfoTips) userInfo:nil repeats:NO];
        }
        else if ([[data objectForKey:@"errorCode"] isEqualToString:@"201"])
        {
            toolTipView = [[LCBToolTipView alloc]initWithFrame:bgView.bounds andMessage:[data objectForKey:@"errorMessage"]];
            [self.view addSubview:toolTipView];
            timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(rightInfoTips) userInfo:nil repeats:NO];
        }
    }
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //用户名转换为小写
    if (textField == userField)
    {
        userField.text = [userField.text lowercaseString];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - LCBAlertViewDelegate
-(void)getRightButtonClick{
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)getLeftButtonClick{
    toolTipView = [[LCBToolTipView alloc]initWithFrame:bgView.bounds andMessage:@"这里进入手机号绑定页"];
    [self.view addSubview:toolTipView];
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
