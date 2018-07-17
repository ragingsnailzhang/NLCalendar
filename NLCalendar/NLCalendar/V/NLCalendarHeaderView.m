//
//  NLCalendarHeaderView.m
//  NLCalendar
//
//  Created by yj_zhang on 2018/7/13.
//  Copyright © 2018年 yj_zhang. All rights reserved.
//

#import "NLCalendarHeaderView.h"

@interface NLCalendarHeaderView()

@property(nonatomic,strong)UILabel *dateLab;
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@end

@implementation NLCalendarHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutViews];
    }
    return self;
}
-(void)layoutViews{
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 56.f)];
    titleLab.text = @"选择日期";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    [self addSubview:titleLab];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(self.bounds.size.width-56, 0, 56, 56);
    [closeBtn setImage:[UIImage imageNamed:@"calendar_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 56.f, self.bounds.size.width, 0.6)];
    line.backgroundColor = [UIColor colorWithRed:0.73f green:0.73f blue:0.73f alpha:1.00f];
    [self addSubview:line];
    
    UILabel *dateLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 56.f, self.bounds.size.width-160, 60.f)];
    _dateLab = dateLab;
    dateLab.text = @"2018-06";
    dateLab.textAlignment = NSTextAlignmentCenter;
    dateLab.textColor = [UIColor blackColor];
    dateLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:dateLab];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn = leftBtn;
    leftBtn.frame = CGRectMake(36, dateLab.frame.origin.y, 60, 60);
    [leftBtn setImage:[UIImage imageNamed:@"calendar_left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = rightBtn;
    rightBtn.frame = CGRectMake(self.bounds.size.width-36-60, dateLab.frame.origin.y, 60, 60);
    [rightBtn setImage:[UIImage imageNamed:@"calendar_right"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    
}

-(void)setDateStr:(NSString *)dateStr{
    _dateStr = dateStr;
    self.dateLab.text = dateStr;
}
-(void)setIsShowLeftAndRightBtn:(BOOL)isShowLeftAndRightBtn{
    _isShowLeftAndRightBtn = isShowLeftAndRightBtn;
    self.leftBtn.hidden = self.rightBtn.hidden = !isShowLeftAndRightBtn;
}
-(void)closeAction{
    NSLog(@"close");
    if (self.closeClickBlock) {
        self.closeClickBlock();
    }
}
-(void)leftAction{
    NSLog(@"left");
    if (self.leftClickBlock) {
        self.leftClickBlock();
    }
}
-(void)rightAction{
    NSLog(@"right");
    if (self.rightClickBlock) {
        self.rightClickBlock();
    }
}


@end
