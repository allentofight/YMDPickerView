//
//  NSDate+Helper.h
//  YMDPickerVIewDemo
//
//  Created by ronaldo on 7/24/14.
//  Copyright (c) 2014 ronaldo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YMDExtensions)
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

- (NSInteger)year;

- (NSInteger)month;

- (NSInteger)day;

- (NSDate *) dateByAddingDays: (NSInteger) dDays;
@end
