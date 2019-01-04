//
//  NLCalendarViewController.m
//  NLCalendar
//
//  Created by yj_zhang on 2018/7/13.
//  Copyright © 2018年 yj_zhang. All rights reserved.
//

#import "NLCalendarViewController.h"
#import "NLCalendarView.h"

#define kNaviBarHeight                         ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 88.0f : 64.0f)

@interface NLCalendarViewController ()
@property(nonatomic,strong)NLCalendarView *calendarView;

@end

@implementation NLCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.calendarView];
    self.calendarView.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day) {
        NSLog(@"%ld年 - %ld月 - %ld日",year,month,day);
    };
}
-(NLCalendarView *)calendarView{
    if (_calendarView == nil) {
        if (self.calendarType == windowType) {
            self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
            CGFloat width = (self.view.frame.size.width-40);
            CGFloat height = HEADVIEW_HEIGHT + WEEKYVIEW_HEIGHT + (width/7*.7)*6 + 2*MARGIN;
            _calendarView = [[NLCalendarView alloc]initWithFrame:CGRectMake(20, (self.view.frame.size.height-height)/2, width, 0)];
        }else{
            self.view.backgroundColor = [UIColor whiteColor];
            _calendarView = [[NLCalendarView alloc]initWithFrame:CGRectMake(0, kNaviBarHeight-TITLEVIEW_HEIGHT, self.view.frame.size.width, 0)];
        }
        _calendarView.layer.cornerRadius = 5.f;
        _calendarView.layer.masksToBounds = YES;
        _calendarView.isHaveAnimation = YES;
        _calendarView.isCanScroll = YES;
        _calendarView.isShowLastAndNextBtn = YES;
        _calendarView.isShowLastAndNextDate = NO;
        _calendarView.isFutureCanClick = NO;
        _calendarView.todayTitleColor =[UIColor redColor];
        _calendarView.selectBackColor =[UIColor blueColor];
        _calendarView.backgroundColor =[UIColor whiteColor];
        [_calendarView loadData];
    }
    return _calendarView;
}

//展示
- (void)showInController:(UIViewController *)vc{
    vc.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [vc presentViewController:self animated:YES completion:nil];
}


@end
