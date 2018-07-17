//
//  NLCalendarHeaderView.h
//  NLCalendar
//
//  Created by yj_zhang on 2018/7/13.
//  Copyright © 2018年 yj_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLCalendarHeaderView : UIView

@property(nonatomic,copy)void(^closeClickBlock)(void);
@property(nonatomic,copy)void(^leftClickBlock)(void);
@property(nonatomic,copy)void(^rightClickBlock)(void);

@property(nonatomic,strong)NSString *dateStr;
@property(nonatomic,assign)BOOL isShowLeftAndRightBtn; //是否显示左右两侧按钮

@end
