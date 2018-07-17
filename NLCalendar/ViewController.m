//
//  ViewController.m
//  NLCalendar
//
//  Created by yj_zhang on 2018/7/13.
//  Copyright © 2018年 yj_zhang. All rights reserved.
//

#import "ViewController.h"
#import "NLCalendarViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NLCalendarViewController *page = [[NLCalendarViewController alloc]init];
    page.calendarType = windowType;
    [page showInController:self];
}





@end
