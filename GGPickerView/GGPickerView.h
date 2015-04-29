//
//  GGPickerView.h
//  GGPickerView
//
//  Created by __无邪_ on 15/4/26.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGPickerView;
@protocol GGPickerViewDelegate <NSObject>

- (void)pickerView:(GGPickerView *)pickerView didSelectedWithResultStr:(NSString *)resultstr;

@end

@interface GGPickerView : UIView

@property (nonatomic, unsafe_unretained)id<GGPickerViewDelegate>delegate;
-(void)showInView:(UIView *)superView withDateModel:(UIDatePickerMode)dateMode withSelectDate:(NSString *)strSelectDate;//日期模式
-(void)showInView:(UIView *)superView withMutableArray:(NSArray *)dataArray;
@end
