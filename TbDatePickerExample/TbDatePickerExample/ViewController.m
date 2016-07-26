//
//  ViewController.m
//  TbDatePickerExample
//
//  Created by Tb on 16/7/26.
//  Copyright © 2016年 Tb. All rights reserved.
//

#import "ViewController.h"
#import "TbDateTimePickerView.h"
@interface ViewController ()
@property (nonatomic,strong)TbDateTimePickerView *datePicker;

@end



@implementation ViewController





- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _datePicker = [[TbDateTimePickerView alloc] init];
    [_datePicker show];
    self.datePicker.gotoSrceenOrderBlock =^(NSString *selectedTime){
        NSLog(@"%@",selectedTime);
    };
}

@end
