//
//  TbDateTimePickerView.h
//  时间选择器
//
//  Created by tangbing on 16/4/21.
//  Copyright © 2016年 tangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TbDateTimePickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, copy) void(^gotoSrceenOrderBlock)(NSString *);
@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;
@property (nonatomic,copy)NSString *selectedDateString;

- (IBAction)sureClick:(id)sender;
- (IBAction)cancelClick:(id)sender;

- (void)show;
- (void)hide;

@end
