//
//  ViewController.m
//  YMDPickerVIewDemo
//
//  Created by ronaldo on 7/24/14.
//  Copyright (c) 2014 ronaldo. All rights reserved.
//

#import "ViewController.h"
#import "YMDPickerView.h"
#import "NSDate+YMDExtensions.h"
@interface ViewController () <YMDPickerViewDelegate>

@end

@implementation ViewController {
    __weak IBOutlet UILabel *_dateLbl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSDate *beginDate = [NSDate date];
    NSDate *endDate = [[NSDate date] dateByAddingDays:365];
    YMDPickerView *datePicker = [[YMDPickerView alloc] initWithBeginDate:beginDate endDate:endDate
                                          shortMonths: NO
                                       numberedMonths: YES
                                           andToolbar: NO];
    CGPoint origin = datePicker.frame.origin;
    datePicker.delegate = self;
    datePicker.frame = (CGRect){origin.x, origin.y+20, datePicker.frame.size};
    [self.view addSubview:datePicker];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - YMDPickerView
- (void)pickerDidSelectDate:(NSDate *)date{
    NSInteger year = [date year];
    NSInteger month = [date month];
    NSInteger day = [date day];
    _dateLbl.text = [NSString stringWithFormat:@"%d/%02d/%d", year, month, day];
}

@end
