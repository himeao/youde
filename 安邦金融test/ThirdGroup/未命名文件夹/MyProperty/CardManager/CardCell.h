//
//  CardCell.h
//  LiCaiBang
//
//  Created by 支梦召 on 2017/1/6.
//  Copyright © 2017年 AnBang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCell : UITableViewCell
@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *numberLab;


+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
