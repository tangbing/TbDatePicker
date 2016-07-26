
//
//  TbDateTimePickerView.m
//  时间选择器
//
//  Created by tangbing on 16/4/21.
//  Copyright © 2016年 tangbing. All rights reserved.
//

#define SelectDate @"selectDate"

#import "TbDateTimePickerView.h"

#define mScreenWidth   ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight  ([UIScreen mainScreen].bounds.size.height)


@interface TbDateTimePickerView()
@property (strong,nonatomic) NSDateFormatter *fmt;
@property (strong,nonatomic) NSDate *pickerStartDate;
@property (strong,nonatomic) NSDate *pickEndDate;
@property (strong,nonatomic) NSCalendar *calendar;
@property (strong,nonatomic) NSDate *selectedDate;
@property (strong,nonatomic) NSDateComponents *selectedComponents;
@property NSInteger unitFlags;
@property (nonatomic,strong)NSMutableArray *yearArray;
/**背景遮盖*/
@property (nonatomic, strong) UIView *bgView;
@end
@implementation TbDateTimePickerView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TbDateTimePickerView" owner:nil options:nil] firstObject];
        
        // 初始化设置
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, mScreenHeight, mScreenWidth, 235);
        [window addSubview:self.bgView];
        [window addSubview:self];
    }
    return self;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _bgView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (NSMutableArray *)yearArray
{
    if (!_yearArray) {
        _yearArray = [[NSMutableArray alloc] init];
        for (int i = 2010; i< 2050; i++) {
            NSString *yearString = [NSString stringWithFormat:@"%d",i];
            [_yearArray addObject:yearString];
        }
        NSString *str = [NSString stringWithFormat:@"无限制"];
        [_yearArray insertObject:str atIndex:0];
    }
    return _yearArray;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
  
    [self setupFormatter];
    // 读取数据
    [self readCacheDate];
}

- (void)setupFormatter
{
    self.fmt = [[NSDateFormatter alloc] init];
    [self.fmt setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    self.pickerStartDate = [self.fmt dateFromString:@"2000-1-1 0:0"];
    self.pickEndDate = [self.fmt dateFromString:@"2100-1-1 0:0"];
    self.selectedDate = [NSDate date];
    self.calendar = [NSCalendar currentCalendar];
    self.unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    self.selectedComponents = [self.calendar components:self.unitFlags fromDate:self.selectedDate];
    
}

#pragma mark - UIPickerViewDataSource
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel) {
        dateLabel = [[UILabel alloc] init];
        [dateLabel setFont:[UIFont systemFontOfSize:17]];
    }
    
    switch (component) {
        case 0: {
            NSString *currentYear = nil;
            if (row == 0) {
                currentYear = [self.yearArray firstObject];
            } else {
                currentYear = [NSString stringWithFormat:@"%ld年", [[self.yearArray objectAtIndex:1] integerValue] + row];
            }
            [dateLabel setText:currentYear];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 1: {
            NSString *currentMonth = [NSString stringWithFormat:@"%ld月",(long)row+1];
            [dateLabel setText:currentMonth];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 2: {
            NSRange dateRange = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                    inUnit:NSCalendarUnitMonth
                                                   forDate:self.selectedDate];
            
            NSString *currentDay = [NSString stringWithFormat:@"%lu日", (row + 1) % (dateRange.length + 1)];
            [dateLabel setText:currentDay];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 3:{
            NSString *currentHour = [NSString stringWithFormat:@"%ld时",(long)row];
            [dateLabel setText:currentHour];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 4:{
            NSString *currentMin = [NSString stringWithFormat:@"%02ld分",row];
            [dateLabel setText:currentMin];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        default:
            break;
    }
    
    return dateLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:// 年
        {
            return self.yearArray.count;
        }
        case 1:// 月
        {
            return 12;
        }
            
        case 2:// 日
        {
            return [self getDayCount];
            
        }
            
        case 3:// 时
        {
            return 24;
        }
        case 4:// 分
        {
            return 60;
        }
        default:
            break;
    }
    return  0;
}

//每次修改都要执行的方法
-(void)changeDateLabel{
    [self.datePicker reloadAllComponents];
    self.selectedDate = [self.calendar dateFromComponents:self.selectedComponents];
    self.selectedDateString = [self.fmt stringFromDate:self.selectedDate];
    NSLog(@"selectedDateString:%@",self.selectedDateString);
}

#pragma mark - UIPickerViewDelegate Methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        if (row == 0) {
            self.selectedDateString = @"无限制";
            return;
        } else {
            NSInteger year = [[self.yearArray objectAtIndex:1] integerValue] + row ;
            self.selectedComponents.year = year;
            [self changeDateLabel];
        }
        
    } else if (component == 1){
        [self.selectedComponents setMonth:row+1];
        [self changeDateLabel];
        
    } else if (component == 2){
        [self.selectedComponents setDay:row +1];
        [self changeDateLabel];
        
    }else if (component == 3){
        
        [self.selectedComponents setHour:row];
        [self changeDateLabel];
        
    }else if(component == 4){
        [self.selectedComponents setMinute:row];
        [self changeDateLabel];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    return 35.0;
}
/**
 *  获得某年某月中得天的数量
 */
- (NSInteger)getDayCount
{
    self.selectedDate = [self.calendar dateFromComponents:self.selectedComponents];
    NSRange dayRange = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate: self.selectedDate];
    return dayRange.length;
}

#pragma mark - UIPickerViewDelegate


- (IBAction)sureClick:(id)sender
{
    [self hide];
    if (self.gotoSrceenOrderBlock) {
        self.gotoSrceenOrderBlock(self.selectedDateString);
    }
    [self saveCacheData];
}
- (IBAction)cancelClick:(id)sender
{
    [self hide];
}

#pragma mark - 保存时间数据

- (void)saveCacheData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.selectedDateString forKey:SelectDate];
    // 立刻让数据存储
    [defaults synchronize];
}

#pragma mark - 读取时间数据
- (void)readCacheDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.selectedDateString =[defaults objectForKey:SelectDate];
    self.selectedDate = [self.fmt dateFromString:self.selectedDateString];
    if (self.selectedDate == nil)// 无限制
    {
        [self.datePicker selectRow:0 inComponent:0 animated:YES];
    } else {// 非无限制
        NSInteger year = [self.calendar component:NSCalendarUnitYear fromDate:self.selectedDate];
        NSInteger month = [self.calendar component:NSCalendarUnitMonth fromDate:self.selectedDate];
        NSInteger day = [self.calendar component:NSCalendarUnitDay fromDate:self.selectedDate];
        NSInteger hour = [self.calendar component:NSCalendarUnitHour fromDate:self.selectedDate];
        NSInteger minute = [self.calendar component:NSCalendarUnitMinute fromDate:self.selectedDate];
        
        [self.datePicker selectRow:year -2010 inComponent:0 animated:YES];
        [self.datePicker selectRow:month - 1 inComponent:1 animated:YES];
        [self.datePicker selectRow:day - 1 inComponent:2 animated:YES];
        [self.datePicker selectRow:hour inComponent:3 animated:YES];
        [self.datePicker selectRow:minute inComponent:4 animated:YES];
    }
}


#pragma mark 功能方法

/** 显示 */
- (void)show {
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.hidden = NO;
        
        CGRect newFrame = self.frame;
        newFrame.origin.y = mScreenHeight - self.frame.size.height;
        self.frame = newFrame;
    } completion:nil];
}

/** 隐藏 */
- (void)hide {
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
        self.bgView.hidden = YES;
        
        CGRect newFrame = self.frame;
        newFrame.origin.y = mScreenHeight;
        self.frame = newFrame;
    } completion:nil];
}



@end
