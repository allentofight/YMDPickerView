YMDPickerView
=============

custom datePicker view, without showing the past year and future year

Thanks [rolandleth](https://github.com/rolandleth),This Library is inspired by his great library[LTHMonthYearPickerView](https://github.com/rolandleth/LTHMonthYearPickerView)

Apple Provides us the UIDatePickerView to selecte Date,but sometimes we want only to show the years between minimum Date and maximum Date,This Control comes to help!

First See the effect

![Demo](http://i.imgur.com/dIxKZuS.gif)

####How to use
First , you need to set the beginDate and endDate to limit the date to shown, just like the UIDatePickerView's minumum Date and maximum Date

    NSDate *beginDate = [NSDate date];
    
    NSDate *endDate = [[NSDate date] dateByAddingDays:365];
    
    YMDPickerView *datePicker = [[YMDPickerView alloc] initWithBeginDate:beginDate endDate:endDate
                                          shortMonths: NO
                                       numberedMonths: YES
                                           andToolbar: NO];
                                           
	[self.view addSubView:datePicker];
	
after you select Date,you can get the date by `datePicker.date`, or if you want to see the date every time the date picker stop scrolling, you can achieve it by implementing the delegate methods
	
	datePicker.delegate = self;	
	
	delegate Method
	- (void)pickerDidSelectDate:(NSDate *)date{

	}