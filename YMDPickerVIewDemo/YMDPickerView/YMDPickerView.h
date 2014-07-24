//
//  YMDPickerView.m
//  YMDPickerView Demo
//
//  Created by ronaldo on 7/24/14.
//  Copyright (c) 2014 ronaldo. All rights reserved.
//

@protocol YMDPickerViewDelegate <NSObject>
@optional
- (void)pickerDidSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerDidSelectMonth:(NSString *)month;
- (void)pickerDidSelectDay:(NSString *)day;
- (void)pickerDidSelectYear:(NSString *)year;
- (void)pickerDidSelectMonth:(NSString *)month andYear:(NSString *)year;
- (void)pickerDidSelectDate:(NSDate *)date;


- (void)pickerDidPressCancel;
/**
 @brief				  If you want to change your text field (and/or variables) dynamically by implementing any of the pickerDidSelect__ delegate methods, instead of doing the change when Done was pressed, you should implement this method too, so the Cancel button restores old values.
 @param initialValues @{ "month" : month, @"year" : year }
 */
- (void)pickerDidPressCancelWithInitialValues:(NSDictionary *)initialValues;
@end

@interface YMDPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<YMDPickerViewDelegate> delegate;
@property (nonatomic, strong) UIPickerView *datePicker;

@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSDate *date;


/**
 @brief				   Month / Year picker view, for those pesky Credit Card expiration dates and alike.
 @param date           set if you want the picker to be initialized with a specific month and year, otherwise it will be initialized with the current month and year.
 @param shortMonths    set to YES if you want months to be returned as Jan, Feb, etc, set to NO if you want months to be returned as January, February, etc.
 @param numberedMonths set to YES if you want months to be returned as 01, 02, etc. This takes precedence over shortMonths if set to YES.
 @param showToolbar    set to YES if you want the picker to have a Cancel/Done toolbar.
 @return a container view which contains the UIPicker and toolbar
 */
- (id)initWithBeginDate:(NSDate *)startDate endDate:(NSDate *)endDate shortMonths:(BOOL)shortMonths numberedMonths:(BOOL)numberedMonths andToolbar:(BOOL)showToolbar;

@end
