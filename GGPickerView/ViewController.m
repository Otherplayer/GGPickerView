//
//  ViewController.m
//  GGPickerView
//
//  Created by __无邪_ on 15/4/26.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import "ViewController.h"
#import "GGPickerView.h"

@interface ViewController ()<GGPickerViewDelegate>
@property (nonatomic,strong)GGPickerView *pickerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    
//    self.pickerView = [[GGPickerView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:self.pickerView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action
- (IBAction)showAction:(id)sender {
    GGPickerView *picker = [[GGPickerView alloc] init];
    [picker setDelegate:self];
//    [picker showInView:self.view.window withDateModel:UIDatePickerModeTime withSelectDate:@""];
    [picker showInView:self.view.window withMutableArray:@[@[@"df",@"sdf"],@[@"2",@"3"],@[@"3",@"4"]]];
}
#pragma mark - Delegate
- (void)pickerView:(GGPickerView *)pickerView didSelectedWithResultStr:(NSString *)resultstr;{
    NSLog(@"---%@",resultstr);
}

@end
