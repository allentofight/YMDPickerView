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
@interface ViewController ()

@end

@implementation ViewController

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
    [self.view addSubview:datePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
