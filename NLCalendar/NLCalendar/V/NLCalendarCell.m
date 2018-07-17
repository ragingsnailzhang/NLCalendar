//
//  NLCalendarCell.m
//  NLCalendar
//
//  Created by yj_zhang on 2018/7/13.
//  Copyright © 2018年 yj_zhang. All rights reserved.
//

#import "NLCalendarCell.h"
#import "NSDate+NLCalendar.h"
@interface NLCalendarCell()

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIView *selectView;

@end

@implementation NLCalendarCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self layoutViews];
    }
    return self;
}
-(void)layoutViews{
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake((self.contentView.bounds.size.width-self.contentView.bounds.size.height)/2, 0, self.contentView.bounds.size.height, self.contentView.bounds.size.height)];
    _selectView = selectView;
    selectView.hidden = YES;
    selectView.clipsToBounds = YES;
    selectView.layer.cornerRadius = self.contentView.bounds.size.height/2;
    [self.contentView addSubview:selectView];
    
    self.titleLab = [[UILabel alloc]initWithFrame:self.contentView.bounds];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.text = @"25";
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titleLab];
}
-(void)setModel:(NLCalendarDayModel *)model{
    _model = model;
    self.titleLab.text = [NSString stringWithFormat:@"%ld",model.day];
    self.selectView.hidden = YES;

    NSInteger todayYear = [[NSDate date] dateYear];
    NSInteger todayMonth = [[NSDate date] dateMonth];
    NSInteger today = [[NSDate date] dateDay];
    
    
    if (!model.isFutureCanClick) {
        if (model.isNextMonth || model.isLastMonth) {
            if (model.isShowLastAndNextDate) {
                self.titleLab.hidden = NO;
            }else{
                self.titleLab.hidden = YES;
            }
        }else{
            self.titleLab.hidden = NO;
        }
        
        if (model.year < todayYear) {
            self.userInteractionEnabled = YES;
        }else if (model.year > todayYear){
            self.userInteractionEnabled = NO;
        }else{
            if (model.month < todayMonth && model.year == todayYear) {
                self.userInteractionEnabled = YES;
            }else{
                if (model.isLastMonth && model.month == todayMonth) {
                    self.userInteractionEnabled = YES;
                }else{
                    if (model.isNextMonth) {
                        self.userInteractionEnabled = NO;
                    }else{
                        if (model.day <= today && model.month == todayMonth) {
                            self.userInteractionEnabled = YES;
                        }else{
                            self.userInteractionEnabled = NO;
                        }
                    }
                }
            }
        }
        
        if (self.isUserInteractionEnabled) {
            self.titleLab.textColor = [UIColor blackColor];
        }else{
            self.titleLab.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        }
        
        if (model.isSelected) {
            self.selectView.hidden = NO;
            self.selectView.backgroundColor = model.selectBackColor?model.selectBackColor:[UIColor blueColor];
            if (model.isHaveAnimation) {
                [self addAnimaiton];
            }
        }
    }else{
        if (model.isNextMonth || model.isLastMonth) {
            self.userInteractionEnabled = NO;
            if (model.isShowLastAndNextDate) {
                self.titleLab.hidden = NO;
                if (model.isNextMonth) {
                    self.titleLab.textColor = model.nextMonthTitleColor? model.nextMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
                }
                if (model.isLastMonth) {
                    self.titleLab.textColor = model.lastMonthTitleColor? model.lastMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
                }
            }else{
                self.titleLab.hidden = YES;
            }
        }else{
            self.titleLab.hidden = NO;
            self.userInteractionEnabled = YES;
            if (model.isSelected) {
                self.selectView.hidden = NO;
                self.selectView.backgroundColor = model.selectBackColor?model.selectBackColor:[UIColor blueColor];
                if (model.isHaveAnimation) {
                    [self addAnimaiton];
                }
            }
            self.titleLab.textColor = model.currentMonthTitleColor?model.currentMonthTitleColor:[UIColor blackColor];
            if (model.isToday) {
                self.titleLab.textColor = model.todayTitleColor?model.todayTitleColor:[UIColor redColor];
            }
        }
    }
    
    /*
    if (model.isNextMonth || model.isLastMonth) {
        
        if (model.isCanclick == YES) {
            self.userInteractionEnabled = NO;
            if (model.isShowLastAndNextDate) {
                self.titleLab.hidden = NO;
                if (model.isNextMonth) {
                    self.titleLab.textColor = model.nextMonthTitleColor? model.nextMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
                }
                if (model.isLastMonth) {
                    self.titleLab.textColor = model.lastMonthTitleColor? model.lastMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
                }
            }else{
                self.titleLab.hidden = YES;
            }
        }else{
            if (model.isShowLastAndNextDate) {
                self.titleLab.hidden = NO;
                if (model.isLastMonth) {
                    if (model.month > [[NSDate date] dateMonth]) {
                        self.userInteractionEnabled = NO;
                        self.titleLab.textColor = model.nextMonthTitleColor? model.nextMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
                    }else{
                        self.userInteractionEnabled = YES;
                        self.titleLab.textColor = [UIColor blackColor];
                    }
                }
                if (model.isNextMonth) {
                    self.userInteractionEnabled = NO;
                    self.titleLab.textColor = model.nextMonthTitleColor? model.nextMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
                }
            }else{
                self.titleLab.hidden = YES;
            }
        }
    }else{
        self.titleLab.hidden = NO;
        if (model.isToday) {
            self.titleLab.textColor = model.todayTitleColor?model.todayTitleColor:[UIColor redColor];
        }
        if (model.isSelected) {
            self.selectView.hidden = NO;
            self.selectView.backgroundColor = model.selectBackColor?model.selectBackColor:[UIColor blueColor];
            if (model.isHaveAnimation) {
                [self addAnimaiton];
            }
        }
        if (model.isCanclick == YES) {
            self.userInteractionEnabled = YES;
            self.titleLab.textColor = model.currentMonthTitleColor?model.currentMonthTitleColor:[UIColor blackColor];
            
        }else{
            if (model.year > [[NSDate date] dateYear]) {
                self.userInteractionEnabled = NO;
                self.titleLab.textColor = model.nextMonthTitleColor? model.nextMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
            }else{
                if (model.month > [[NSDate date] dateMonth]) {
                    self.userInteractionEnabled = NO;
                    self.titleLab.textColor = model.nextMonthTitleColor? model.nextMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
                }else{
                    if (model.day > [[NSDate date] dateDay]) {
                        self.userInteractionEnabled = NO;
                        self.titleLab.textColor = model.nextMonthTitleColor? model.nextMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
                    }else{
                        self.userInteractionEnabled = YES;
                        self.titleLab.textColor = model.currentMonthTitleColor?model.currentMonthTitleColor:[UIColor blackColor];
                    }
                }
            }
        }
     }
     */
}
-(void)addAnimaiton{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.values = @[@0.6,@1.2,@1.0];
    anim.keyPath = @"transform.scale";  // transform.scale 表示长和宽都缩放
    anim.calculationMode = kCAAnimationPaced;
    anim.duration = 0.2;                // 设置动画执行时间
    //    anim.repeatCount = MAXFLOAT;        // MAXFLOAT 表示动画执行次数为无限次
    //    anim.autoreverses = YES;            // 控制动画反转 默认情况下动画从尺寸1到0的过程中是有动画的，但是从0到1的过程中是没有动画的，设置autoreverses属性可以让尺寸0到1也是有过程的
    [self.selectView.layer addAnimation:anim forKey:nil];
}

@end
