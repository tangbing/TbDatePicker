# TbDatePicker

一个带有"无限制"的可以选择年，月，日，时，分的时间选择器

![image](https://github.com/tangbing/TbPopMenuView/blob/master/Tb.gif)
```ios
_datePicker = [[TbDateTimePickerView alloc] init];
[_datePicker show];
self.datePicker.gotoSrceenOrderBlock =^(NSString *selectedTime){
NSLog(@"%@",selectedTime);
};

```


