//
//  NLCalendarView.m
//  NLCalendar
//
//  Created by yj_zhang on 2018/7/13.
//  Copyright © 2018年 yj_zhang. All rights reserved.
//

#import "NLCalendarView.h"
#import "NLCalendarHeaderView.h"
#import "NLCalendarWeekyView.h"
#import "NLCalendarCell.h"
#import "NSDate+NLCalendar.h"
#import "NLCalendarDayModel.h"
#import "NLCalendarMonthModel.h"

#define WeakSelf(weakSelf)  __weak __typeof(self) weakSelf = self;

@interface NLCalendarView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)NLCalendarHeaderView *headView;
@property(nonatomic,strong)NLCalendarWeekyView *weekyView;
@property(nonatomic,strong)UICollectionView *collectionView;//日历
@property(nonatomic,strong)NSDate *currentMonthDate;//当月的日期
@property(nonatomic,strong)NSMutableArray *monthDataArr;//当月的模型集合

@property(nonatomic,strong)UISwipeGestureRecognizer *leftSwipe;//左滑手势
@property(nonatomic,strong)UISwipeGestureRecognizer *rightSwipe;//右滑手势

@end

@implementation NLCalendarView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initData];
        [self layoutViews];
    }
    return self;
}
-(void)initData{
    self.currentMonthDate = [NSDate date];
    self.monthDataArr = [NSMutableArray array];
}
-(void)layoutViews{
    self.headView = [[NLCalendarHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, HEADVIEW_HEIGHT)];
    self.headView.isShowLeftAndRightBtn = self.isShowLastAndNextBtn;
    [self addSubview:self.headView];
    WeakSelf(weakSelf);
    self.headView.closeClickBlock = ^{
        [[weakSelf getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
    };
    self.headView.leftClickBlock = ^{
        [weakSelf rightSlide];
    };
    
    self.headView.rightClickBlock = ^{
        [weakSelf leftSlide];
    };
    
    self.weekyView = [[NLCalendarWeekyView alloc]initWithFrame:CGRectMake(0, self.headView.frame.size.height, self.bounds.size.width, WEEKYVIEW_HEIGHT)];
    [self addSubview:self.weekyView];
    
    [self addSubview:self.collectionView];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.collectionView.frame.origin.y+self.collectionView.frame.size.height);
    
    //添加左滑右滑手势
    self.leftSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.collectionView addGestureRecognizer:self.leftSwipe];
    
    self.rightSwipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.collectionView addGestureRecognizer:self.rightSwipe];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.headView.frame = CGRectMake(0, 0, self.bounds.size.width, HEADVIEW_HEIGHT);
}
#pragma mark - 数据以及更新处理
-(void)loadData{
    [self.monthDataArr removeAllObjects];
    
    NSDate *previousMonthDate = [self.currentMonthDate previousMonthDate];
    
    //    NSDate *nextMonthDate = [self.currentMonthDate  nextMonthDate];
    
    NLCalendarMonthModel *monthModel = [[NLCalendarMonthModel alloc]initWithDate:self.currentMonthDate];
    
    NLCalendarMonthModel *lastMonthModel = [[NLCalendarMonthModel alloc]initWithDate:previousMonthDate];
    
    //    NLCalendarMonthModel *nextMonthModel = [[NLCalendarMonthModel alloc]initWithDate:nextMonthDate];
    
    self.headView.dateStr = [NSString stringWithFormat:@"%ld-%02ld",monthModel.year,monthModel.month];
    
    NSInteger firstWeekday = monthModel.firstWeekday;
    
    NSInteger totalDays = monthModel.totalDays;
    
    for (int i = 0; i <42; i++) {
        
        NLCalendarDayModel *model =[[NLCalendarDayModel alloc]init];
        
        //配置颜色属性等
        [self configDayModel:model];
        
        model.firstWeekday = firstWeekday;
        model.totalDays = totalDays;
        
        model.month = monthModel.month;
        model.year = monthModel.year;
        
        //上个月的日期
        if (i < firstWeekday) {
            model.day = lastMonthModel.totalDays - (firstWeekday - i) + 1;
            model.isLastMonth = YES;
        }
        
        //当月的日期
        if (i >= firstWeekday && i < (firstWeekday + totalDays)) {
            model.day = i -firstWeekday +1;
            model.isCurrentMonth = YES;
            
            //标识是今天
            if ((monthModel.month == [[NSDate date] dateMonth]) && (monthModel.year == [[NSDate date] dateYear])) {
                if (i == [[NSDate date] dateDay] + firstWeekday - 1) {
                    model.isToday = YES;
                }
            }
        }
        //下月的日期
        if (i >= (firstWeekday + monthModel.totalDays)) {
            model.day = i -firstWeekday - monthModel.totalDays +1;
            model.isNextMonth = YES;
        }
        [self.monthDataArr addObject:model];
        
    }
    
    NSInteger nextMonthDays = 0;
    for (NLCalendarDayModel *model in self.monthDataArr) {
        if (model.isNextMonth) {
            nextMonthDays++;
        }
    }
    if (nextMonthDays >= 7) {
        [self.monthDataArr removeObjectsInRange:NSMakeRange(self.monthDataArr.count-7, 7)];
    }
    [self reloadView];
    [self.collectionView reloadData];
    
}
-(void)reloadView{
    NSInteger row = ceilf(self.monthDataArr.count/7.0f);
    CGFloat height = 34;
    _collectionView.frame = CGRectMake(0, self.weekyView.frame.size.height+self.weekyView.frame.origin.y+MARGIN, self.bounds.size.width, row * height+MARGIN);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.collectionView.frame.origin.y+self.collectionView.frame.size.height);
}
//配置颜色属性等
-(void)configDayModel:(NLCalendarDayModel *)model{
    
    model.isFutureCanClick = self.isFutureCanClick;
    
    model.isHaveAnimation = self.isHaveAnimation;
    
    model.currentMonthTitleColor = self.currentMonthTitleColor;
    
    model.lastMonthTitleColor = self.lastMonthTitleColor;
    
    model.nextMonthTitleColor = self.nextMonthTitleColor;
    
    model.selectBackColor = self.selectBackColor;
    
    model.isHaveAnimation = self.isHaveAnimation;
    
    model.todayTitleColor = self.todayTitleColor;
    
    model.isShowLastAndNextDate = self.isShowLastAndNextDate;
    
}

#pragma mark - 懒加载
-(UICollectionView *)collectionView{
    CGFloat width = (self.bounds.size.width)/7;
    CGFloat height = 34;
    NSInteger row = 6;
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow =[[UICollectionViewFlowLayout alloc]init];
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 0;
        flow.itemSize = CGSizeMake(width, height);
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, self.weekyView.frame.size.height+self.weekyView.frame.origin.y+MARGIN, self.bounds.size.width, row * height+MARGIN) collectionViewLayout:flow];
    }
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollsToTop = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[NLCalendarCell class] forCellWithReuseIdentifier:@"cell"];
    return _collectionView;
}
//当前月的title颜色
-(void)setCurrentMonthTitleColor:(UIColor *)currentMonthTitleColor{
    _currentMonthTitleColor = currentMonthTitleColor;
}
//上月的title颜色
-(void)setLastMonthTitleColor:(UIColor *)lastMonthTitleColor{
    _lastMonthTitleColor = lastMonthTitleColor;
}
//下月的title颜色
-(void)setNextMonthTitleColor:(UIColor *)nextMonthTitleColor{
    _nextMonthTitleColor = nextMonthTitleColor;
}
//选中的背景颜色
-(void)setSelectBackColor:(UIColor *)selectBackColor{
    _selectBackColor = selectBackColor;
}
//选中的是否动画效果
-(void)setIsHaveAnimation:(BOOL)isHaveAnimation{
    
    _isHaveAnimation  = isHaveAnimation;
}
//是否禁止手势滚动
-(void)setIsCanScroll:(BOOL)isCanScroll{
    _isCanScroll = isCanScroll;
    self.leftSwipe.enabled = self.rightSwipe.enabled = isCanScroll;
}
//是否显示上月，下月的按钮
-(void)setIsShowLastAndNextBtn:(BOOL)isShowLastAndNextBtn{
    _isShowLastAndNextBtn  = isShowLastAndNextBtn;
    self.headView.isShowLeftAndRightBtn = isShowLastAndNextBtn;
}
//是否显示上月，下月的的数据
-(void)setIsShowLastAndNextDate:(BOOL)isShowLastAndNextDate{
    _isShowLastAndNextDate =  isShowLastAndNextDate;
}
//今日的title颜色
-(void)setTodayTitleColor:(UIColor *)todayTitleColor{
    _todayTitleColor = todayTitleColor;
}
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.monthDataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifier = @"cell";
    NLCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.model = self.monthDataArr[indexPath.item];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NLCalendarDayModel *model = self.monthDataArr[indexPath.item];
    model.isSelected = YES;
    
    [self.monthDataArr enumerateObjectsUsingBlock:^(NLCalendarDayModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != model) {
            obj.isSelected = NO;
        }
    }];
    
    if (self.selectBlock) {
        self.selectBlock(model.year, model.month, model.day);
    }
    [collectionView reloadData];
}
#pragma mark -左滑处理
-(void)leftSlide{
    self.currentMonthDate = [self.currentMonthDate nextMonthDate];
    
    [self performAnimations:kCATransitionFromRight];
    [self loadData];
}
-(void)leftSwipe:(UISwipeGestureRecognizer *)swipe{
    [self leftSlide];
}
#pragma mark -右滑处理
-(void)rightSlide{
    self.currentMonthDate = [self.currentMonthDate previousMonthDate];
    [self performAnimations:kCATransitionFromLeft];
    
    [self loadData];
}
-(void)rightSwipe:(UISwipeGestureRecognizer *)swipe{
    [self rightSlide];
}
#pragma mark -动画处理
- (void)performAnimations:(NSString *)transition{
    CATransition *catransition = [CATransition animation];
    catransition.duration = 0.2;
    [catransition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    catransition.type = kCATransitionFade; //choose your animation
    catransition.subtype = transition;
    [self.collectionView.layer addAnimation:catransition forKey:nil];
}

- (UIViewController *)getCurrentVC{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}
- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {// 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {// 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){// 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {// 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}


@end
