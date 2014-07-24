//
//  YMDPickerView.m
//
//  Created by ronaldo on 7/24/14.
//  Copyright (c) 2014 ronaldo. All rights reserved.
//

#import "YMDPickerView.h"
#import "NSDate+YMDExtensions.h"

#define kMonthColor [UIColor darkGrayColor]
#define kYearColor [UIColor darkGrayColor]
#define kDayColor [UIColor darkGrayColor]
#define kMonthFont [UIFont systemFontOfSize: 22.0]
#define kYearFont [UIFont systemFontOfSize: 22.0]
#define kWinSize [UIScreen mainScreen].bounds.size

const NSUInteger kYearComponent = 0;
const NSUInteger kMonthComponent = 1;
const NSUInteger kDayComponent = 2;

const NSUInteger kMaxYear = 2015;
const CGFloat kRowHeight = 30.0;

@interface YMDPickerView ()

@property (readwrite) NSInteger yearIndex;
@property (readwrite) NSInteger monthIndex;
@property (readwrite) NSInteger dayIndex;
@property (nonatomic) NSInteger minYear;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSMutableArray *days;
@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSDictionary *initialValues;

@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSNumber *month;
@property (nonatomic, strong) NSNumber *day;

@end


@implementation YMDPickerView

static inline BOOL isYearLeapYear(NSInteger year)  {
    return (( year%100 != 0) && (year%4 == 0)) || year%400 == 0;
}

static inline NSInteger daysForYearMonth(NSInteger year, NSInteger month){
    NSInteger daysForLeapYear[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    NSInteger daysForCommonYear[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    if (isYearLeapYear(year)) {
        return daysForLeapYear[month-1];
    }else{
        return daysForCommonYear[month-1];
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (!_initialValues) _initialValues = @{ @"month" : _months[_monthIndex],
                                             @"year" : _years[_yearIndex] };
    switch (component) {
        case kDayComponent:{
            _dayIndex = [_datePicker selectedRowInComponent: kDayComponent];
            if ([self.delegate respondsToSelector: @selector(pickerDidSelectDay:)])
                [self.delegate pickerDidSelectDay: _days[_dayIndex]];
        }
            break;
        case kMonthComponent: {
            _monthIndex = [_datePicker selectedRowInComponent: kMonthComponent];
            if ([self.delegate respondsToSelector: @selector(pickerDidSelectMonth:)])
                [self.delegate pickerDidSelectMonth: _months[_monthIndex]];
        }
            break;
        case kYearComponent: {
            _yearIndex = [_datePicker selectedRowInComponent: kYearComponent];
            if ([self.delegate respondsToSelector: @selector(pickerDidSelectYear:)])
                [self.delegate pickerDidSelectYear: _years[_yearIndex]];
        }
            break;
        default:
            break;
    }
    
    
	_year = _years[_yearIndex];
    _month = _months[_monthIndex];
    _day = _days[_dayIndex];
    
    NSDate *selectedDate = [NSDate dateWithYear:[_year intValue] month:_monthIndex+1 day:[_day intValue]];
    
    
    if ([_beginDate compare:selectedDate] == NSOrderedDescending) {
        _monthIndex = [_beginDate month]-1;
        _dayIndex = [_beginDate day]-1;
        [pickerView selectRow:_monthIndex inComponent:kMonthComponent animated:YES];
        [pickerView selectRow:_dayIndex inComponent:kDayComponent animated:YES];
    }else if ([_endDate compare:selectedDate] == NSOrderedAscending) {
        _monthIndex = [_endDate month]-1;
        _dayIndex = [_endDate day]-1;
        [pickerView selectRow:_monthIndex inComponent:kMonthComponent animated:YES];
        [pickerView selectRow:_dayIndex inComponent:kDayComponent animated:YES];
    }
    
    
    _days = [NSMutableArray new];
    NSInteger dayLenth = daysForYearMonth([_years[_yearIndex] intValue], _monthIndex+1);
    for (NSInteger day = 1; day < dayLenth+1; day++) {
        [_days addObject:@(day)];
    }
    
    [_datePicker reloadComponent:kDayComponent];
    if (_dayIndex > dayLenth-1) {
        _dayIndex = dayLenth-1;
        [_datePicker selectRow:dayLenth-1 inComponent:kDayComponent animated:YES];
    }
    
    _year = _years[_yearIndex];
    _month = _months[_monthIndex];
    _day = _days[_dayIndex];
    self.date = [NSDate dateWithYear:[_year intValue] month:_monthIndex+1 day:[_day intValue]];
    
    if ([self.delegate respondsToSelector: @selector(pickerDidSelectMonth:andYear:)])
        [self.delegate pickerDidSelectMonth: _months[_monthIndex]
                                    andYear: _years[_yearIndex]];
    
    if ([self.delegate respondsToSelector: @selector(pickerDidSelectRow:inComponent:)])
        [self.delegate pickerDidSelectRow: row inComponent: component];
    
    if ([self.delegate respondsToSelector: @selector(pickerDidSelectDate:)])
        [self.delegate pickerDidSelectDate:self.date];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *label = [[UILabel alloc] initWithFrame: CGRectZero];
	label.textAlignment = NSTextAlignmentCenter;
    
    switch (component) {
        case kYearComponent:{
            label.text = [NSString stringWithFormat: @"%@", _years[row]];
            label.textColor = kYearColor;
            label.font = kYearFont;
            label.frame = CGRectMake(kWinSize.width * 0.5, 0, kWinSize.width * 0.5, kRowHeight);
        }
            break;
        case kMonthComponent:{
            label.text = [NSString stringWithFormat: @"%@", _months[row]];
            label.textColor = kMonthColor;
            label.font = kMonthFont;
            label.frame = CGRectMake(0, 0, kWinSize.width * 0.5, kRowHeight);
        }
            break;
        case kDayComponent:{
            label.text = [NSString stringWithFormat: @"%@", _days[row]];
            label.textColor = kMonthColor;
            label.font = kMonthFont;
            label.frame = CGRectMake(0, 0, kWinSize.width * 0.5, kRowHeight);
        }
        default:
            break;
    }
    
	return label;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.bounds.size.width / 3;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return kRowHeight;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0: {
         return _years.count;
        }
            break;
        case 1: {
         return _months.count;
        }
            break;
        case 2: {
         return _days.count;
        }
            break;
        default:
            break;
    }
    
    return 0;
    
}


#pragma mark - Actions
- (void)_done {
    if ([self.delegate respondsToSelector: @selector(pickerDidSelectDate:)])
        [self.delegate pickerDidSelectDate:self.date];
//	[[NSNotificationCenter defaultCenter]
//     postNotificationName: @"pickerDidPressDone"
//     object: self
//     userInfo: @{ @"month" : _months[_currentMonth], @"year" : _years[_currentYear] }];
    _initialValues = nil;
	_year = _years[_yearIndex];
    _month = _months[_monthIndex];
}


- (void)_cancel {
    if (!_initialValues) _initialValues  = @{ @"month" : _months[_monthIndex],
											  @"year" : _years[_yearIndex] };
    if ([self.delegate respondsToSelector: @selector(pickerDidPressCancelWithInitialValues:)]) {
        [self.delegate pickerDidPressCancelWithInitialValues: _initialValues];
        [self.datePicker selectRow: [_months indexOfObject: _initialValues[@"month"]]
                       inComponent: 0
                          animated: NO];
        [self.datePicker selectRow: [_years indexOfObject: _initialValues[@"year"]]
                       inComponent: 1
                          animated: NO];
    }
    else if ([self.delegate respondsToSelector: @selector(pickerDidPressCancel)])
        [self.delegate pickerDidPressCancel];
//	[[NSNotificationCenter defaultCenter]
//     postNotificationName: @"pickerDidPressDone"
//     object: self
//     userInfo: _initialValues];
	_monthIndex = [_months indexOfObject: _initialValues[@"month"]];
	_yearIndex = [_years indexOfObject: _initialValues[@"year"]];
	_year = _years[_yearIndex];
    _month = _months[_monthIndex];
	_initialValues = nil;
}

- (NSInteger)minYear{
    if (!_minYear) {
        _minYear = [[NSDate date] year];
    }
    return _minYear;
}

#pragma mark - Init
- (void)_setupComponentsFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
	NSInteger currentYear = [calendar components: NSCalendarUnitYear
										fromDate: [NSDate date]].year;

	if (currentYear < self.minYear) _yearIndex = [_years indexOfObject: [NSString stringWithFormat: @"%lu", (unsigned long)self.minYear]];
	else
        _yearIndex = [_years indexOfObject: @(currentYear)];
    _monthIndex = [calendar components: NSCalendarUnitMonth
                                fromDate: [NSDate date]].month - 1;
    
    _dayIndex = [calendar components: NSCalendarUnitDay
                              fromDate: [NSDate date]].day;

	NSDateComponents *dateComponents =
	[calendar components: NSCalendarUnitMonth | NSCalendarUnitYear
				fromDate: date];
	// Set your min year to current year for credit card checks.
    if (self.minYear < [_years[_yearIndex] integerValue]) {
        if (dateComponents.year == _yearIndex) {
            if (dateComponents.month >= _monthIndex) {
				_monthIndex = dateComponents.month - 1;
            }
			_yearIndex = [_years indexOfObject: [NSString stringWithFormat: @"%lu", (unsigned long)dateComponents.year]];
        }
        else {
			_yearIndex = [_years indexOfObject: [NSString stringWithFormat: @"%lu", (unsigned long)dateComponents.year]];
			_monthIndex = dateComponents.month - 1;
        }
    }
    
    _days = [NSMutableArray new];
    NSInteger dayLenth = daysForYearMonth([_years[_yearIndex] intValue], _monthIndex+1);
    for (NSInteger day = 1; day < dayLenth+1; day++) {
        [_days addObject:@(day)];
    }
    
	[_datePicker selectRow: _yearIndex
			   inComponent: 0
				  animated: YES];
	[_datePicker selectRow: _monthIndex
			   inComponent: 1
				  animated: YES];
	[_datePicker selectRow: _dayIndex
			   inComponent: 2
				  animated: YES];
    

    [self performSelector: @selector(_sendFirstPickerValues) withObject: nil afterDelay: 0.1];
}

- (void)_sendFirstPickerValues {
	if ([self.delegate respondsToSelector: @selector(pickerDidSelectRow:inComponent:)]) {
		[self.delegate pickerDidSelectRow: [self.datePicker selectedRowInComponent:0]
							  inComponent: 0];
		[self.delegate pickerDidSelectRow: [self.datePicker selectedRowInComponent:1]
							  inComponent: 1];
	}
    if ([self.delegate respondsToSelector: @selector(pickerDidSelectMonth:andYear:)])
        [self.delegate pickerDidSelectMonth: _months[_monthIndex]
                                    andYear: _years[_yearIndex]];
	_year = _years[_yearIndex];
    _month = _months[_monthIndex];
}


#pragma mark - Init
- (id)initWithBeginDate:(NSDate *)startDate endDate:(NSDate *)endDate shortMonths:(BOOL)shortMonths numberedMonths:(BOOL)numberedMonths andToolbar:(BOOL)showToolbar {
    self = [super init];
    if (self) {
        if (!startDate) startDate = [NSDate date];
        if (!endDate) endDate = [[NSDate date] dateByAddingDays:365];
        self.beginDate = startDate;
        self.endDate = endDate;
        self.date = startDate;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [NSDateComponents new];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        NSMutableArray *months = [NSMutableArray new];
        dateComponents.month = 1;

        if (numberedMonths) [dateFormatter setDateFormat: @"MM"]; // MARK: Change to @"M" if you don't want double digits
        else if (shortMonths) [dateFormatter setDateFormat: @"MMM"];
        else [dateFormatter setDateFormat: @"MMMM"];

        for (NSInteger i = 1; i <= 12; i++) {
            [months addObject: [dateFormatter stringFromDate: [calendar dateFromComponents: dateComponents]]];
            dateComponents.month++;
        }

        _months = [months copy];
        _years = [NSMutableArray new];

        self.minYear = [startDate year];
        NSInteger endYear = [endDate year];
        for (NSInteger year = self.minYear; year <= endYear; year++) {
            [_years addObject: @(year)];
        }

		CGRect datePickerFrame;
        if (showToolbar) {
            self.frame = CGRectMake(0.0, 0.0, kWinSize.width, 260.0);
			datePickerFrame = CGRectMake(0.0, 44.5, self.frame.size.width, 216.0);

            UIToolbar *toolbar = [[UIToolbar alloc]
                                  initWithFrame: CGRectMake(0.0, 0.0, self.frame.size.width, datePickerFrame.origin.y - 0.5)];

            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                             target: self
                                             action: @selector(_cancel)];
            UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                          target: self
                                          action: nil];
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                        target: self
                                        action: @selector(_done)];

            [toolbar setItems: @[cancelButton, flexSpace, doneBtn]
                     animated: YES];
            [self addSubview: toolbar];
        }
        else {
			self.frame = CGRectMake(0.0, 0.0, kWinSize.width, 216.0);
			datePickerFrame = self.frame;
		}
        _datePicker = [[UIPickerView alloc] initWithFrame: datePickerFrame];
        _datePicker.dataSource = self;
        _datePicker.delegate = self;
        [self addSubview: _datePicker];
        [self _setupComponentsFromDate: startDate];
    }
    return self;
}


@end
