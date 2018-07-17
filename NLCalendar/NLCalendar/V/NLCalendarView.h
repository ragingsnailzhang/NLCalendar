//
//  NLCalendarView.h
//  NLCalendar
//
//  Created by yj_zhang on 2018/7/13.
//  Copyright © 2018年 yj_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEADVIEW_HEIGHT 116
#define TITLEVIEW_HEIGHT 56
#define WEEKYVIEW_HEIGHT 18
#define MARGIN 10

@interface NLCalendarView : UIView

/**
 * 当前月的title颜色
 */
@property(nonatomic,strong)UIColor *currentMonthTitleColor;

/**
 * 上月的title颜色
 */
@property(nonatomic,strong)UIColor *lastMonthTitleColor;

/**
 * 下月的title颜色
 */
@property(nonatomic,strong)UIColor *nextMonthTitleColor;

/**
 * 选中的背景颜色
 */
@property(nonatomic,strong)UIColor *selectBackColor;

/**
 * 今日的title颜色
 */
@property(nonatomic,strong)UIColor *todayTitleColor;

/**
 * 选中的是否动画效果
 */
@property(nonatomic,assign)BOOL     isHaveAnimation;

/**
 * 是否禁止手势滚动
 */
@property(nonatomic,assign)BOOL     isCanScroll;

/**
 * 是否当天之后可点击
 */
@property(nonatomic,assign)BOOL     isFutureCanClick;

/**
 * 是否显示上月，下月的按钮
 */
@property(nonatomic,assign)BOOL     isShowLastAndNextBtn;

/**
 * 是否显示上月，下月的的数据
 */
@property(nonatomic,assign)BOOL     isShowLastAndNextDate;

//选中的回调
@property(nonatomic,copy)void(^selectBlock)(NSInteger year ,NSInteger month ,NSInteger day);

//加载数据
-(void)loadData;

@end
