//
//  NLCalendarViewController.h
//  NLCalendar
//
//  Created by yj_zhang on 2018/7/13.
//  Copyright © 2018年 yj_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CalendarType){
    windowType = 1,
    controllerType,
    
};

@interface NLCalendarViewController : UIViewController

@property(nonatomic,assign)CalendarType calendarType;

//展示
- (void)showInController:(UIViewController *)vc;

@end
