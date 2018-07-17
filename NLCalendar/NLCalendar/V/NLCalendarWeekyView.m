//
//  NLCalendarWeekyView.m
//  NLCalendar
//
//  Created by yj_zhang on 2018/7/13.
//  Copyright © 2018年 yj_zhang. All rights reserved.
//

#import "NLCalendarWeekyView.h"

@implementation NLCalendarWeekyView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutViews];
    }
    return self;
}
-(void)layoutViews{
    NSArray *weekyArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat width = self.bounds.size.width/weekyArr.count;
    for (NSString *weekStr in weekyArr) {
        NSInteger index = [weekyArr indexOfObject:weekStr];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(width * index, 0, width, self.bounds.size.height)];
        lab.text = weekStr;
        lab.font = [UIFont systemFontOfSize:15];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor blackColor];
        [self addSubview:lab];
    }
}

@end
