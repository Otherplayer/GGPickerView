//
//  GGPickerView.m
//  GGPickerView
//
//  Created by __无邪_ on 15/4/26.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import "GGPickerView.h"

@interface GGPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong)UIDatePicker *datePickerView;//时间选择器
@property (nonatomic, strong)UIPickerView *pickerView; //选择器


@property (nonatomic, strong)UIView *containerView;
@end

@implementation GGPickerView{
    UIDatePickerMode datePickerMode;
    NSString *strDateFormat;
    NSString *strSelectedDate;
    NSMutableArray *pickerViewDataArr;
    
    BOOL _isDataArray;//是否是多重数组
    BOOL _isDataString;//是否是字符串数组
    NSMutableArray *_subsetComponent;//子类项目
    
    NSString *resultString;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setFrame:[[UIScreen mainScreen] bounds]];
        [self drawSelfSubview];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:[[UIScreen mainScreen] bounds]];
        [self drawSelfSubview];
    }
    return self;
}

#pragma mark - initView
-(void)drawSelfSubview{
    UIView *viewBack = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self addSubview:viewBack];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissView)];
    [viewBack addGestureRecognizer:tap];
    
    
    self.containerView = [[UIView alloc] initWithFrame:[self hiddenViewFrame]];
    [viewBack addSubview:self.containerView];
    
    [self setUpToolBar];
}

-(void)setUpToolBar{
    
    UIColor *titleColor = [UIColor darkGrayColor];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth(), 44)];
    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *okButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitleColor:titleColor forState:UIControlStateNormal];
    [okButton setTitleColor:titleColor forState:UIControlStateNormal];
    okButton.bounds=CGRectMake(0,0,50,40);
    cancelButton.bounds=CGRectMake(0,0,50,40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton addTarget:self action:@selector(dissmissView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelButtonItem=[[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *okButtonItem=[[UIBarButtonItem alloc]initWithCustomView:okButton];
    
    toolBar.items = [NSArray arrayWithObjects:cancelButtonItem,flexibleSpace,okButtonItem, nil];
    [self.containerView addSubview:toolBar];
    
}


////////////////////////
////////////////////////
- (void)setUpDatePickerView{
    self.datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth(), 216)];
    [self.datePickerView setDatePickerMode:datePickerMode];
    [self.datePickerView setTimeZone:[NSTimeZone systemTimeZone]];
    [self.containerView addSubview:self.datePickerView];
    [self.datePickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}
- (void)setUpPickerView{
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth(), 216)];
    [self.containerView addSubview:self.pickerView];
    [self.pickerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.pickerView setDataSource:self];
    [self.pickerView setDelegate:self];
}

///////////////////////////////////
///////////////////////////////////
#pragma mark - Public
-(void)showInView:(UIView *)superView withDateModel:(UIDatePickerMode)dateMode withSelectDate:(NSString *)strSelectDate{
    [superView addSubview:self];
    datePickerMode = dateMode;
    strSelectedDate = strSelectDate;
    [self setUpDatePickerView];
    [self setUpDatePickerFormatString];
    [UIView animateWithDuration:0.25 animations:^{
        [self.containerView setFrame:[self normalViewFrame]];
    }];
    
}

-(void)showInView:(UIView *)superView withMutableArray:(NSArray *)dataArray{
    [superView addSubview:self];
    [self analysisArrayClass:dataArray];
    [self setUpPickerView];
    [UIView animateWithDuration:0.25 animations:^{
        [self.containerView setFrame:[self normalViewFrame]];
    }];
}

///////////////////////////////////
///////////////////////////////////

-(void)setUpDatePickerFormatString{
    
    switch (datePickerMode){
        case UIDatePickerModeTime: {
            strDateFormat = @"HH:mm";
        }
            break;
        case UIDatePickerModeDateAndTime: {
            strDateFormat = @"yyyy-MM-dd HH:mm";
        }
            break;
        case UIDatePickerModeCountDownTimer:{
            strDateFormat = @"HH:mm";
        }
            break;
        default: {
            strDateFormat = @"yyyy-MM-dd";
        }
            break;
    }
    NSDate *selectDate;
    if ([self stringByTrim:strSelectedDate].length<=0){
        selectDate = [NSDate date];
    }
    else{
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:strDateFormat];
        selectDate = [self dateFromString:strSelectedDate dateFormatter:dateFormatter];
    }
    [self.datePickerView setDate:selectDate animated:YES];
}


-(void)analysisArrayClass:(NSArray *)arraySuper{
    
    pickerViewDataArr = [[NSMutableArray alloc] initWithArray:arraySuper];
    for (id arraySubset in arraySuper) {
        if ([arraySubset isKindOfClass:[NSArray class]]) {
            if (_isDataArray) {
                _subsetComponent = [[NSMutableArray alloc] init];
            }
            _isDataArray = YES;
            _isDataString = NO;
        }
        else if ([arraySubset isKindOfClass:[NSString class]]){
            _isDataArray = NO;
            _isDataString = YES;
        }
    }
}

///////////////////////////////////
///////////////////////////////////

- (CGRect)normalViewFrame{
    return CGRectMake(0, ScreenHeight() - 260, ScreenWidth(), 260);
}
- (CGRect)hiddenViewFrame{
    return CGRectMake(0, ScreenHeight(), ScreenWidth(), 260);
}

#pragma mark - Mission

- (void)datePickerValueChanged:(UIDatePicker *)sender{
    NSDate *select = [sender date];//获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = strDateFormat; //设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
    NSLog(@"%@",dateAndTime);
    if ([_delegate respondsToSelector:@selector(pickerView:didSelectedWithResultStr:)]) {
        [_delegate pickerView:self didSelectedWithResultStr:dateAndTime];
    }
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    NSInteger number;
    if (_isDataArray) {
        number=pickerViewDataArr.count;
    } else if (_isDataString){
        number=1;
    }
    return number;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isDataArray) {
        rowArray=pickerViewDataArr[component];
    }
    else if (_isDataString){
        rowArray=pickerViewDataArr;
    }
    return rowArray.count;
}

#pragma
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle = nil;
    if (_isDataArray) {
        rowTitle=pickerViewDataArr[component][row];
    }
    else if (_isDataString){
        rowTitle=pickerViewDataArr[row];
    }
    return rowTitle;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_isDataString) {
        resultString = pickerViewDataArr[row];
    }
    else if (_isDataArray) {
        NSLog(@"%@",pickerViewDataArr[component][row]);
        resultString=@"";
        if (![_subsetComponent containsObject:@(component)]) {
            [_subsetComponent addObject:@(component)];
        }
        for (int i=0; i<pickerViewDataArr.count;i++) {
            if ([_subsetComponent containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                resultString=[NSString stringWithFormat:@"%@%@_",resultString,pickerViewDataArr[i][cIndex]];
            }else{
                resultString=[NSString stringWithFormat:@"%@%@_",resultString,pickerViewDataArr[i][0]];
            }
        }
    }
    NSLog(@"------%@",resultString);
}

#pragma mark - Action

- (void)okButtonAction{
    
}
- (void)dissmissView{
    [UIView animateWithDuration:0.25 animations:^{
        [self.containerView setFrame:[self hiddenViewFrame]];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#ifndef ScreenWidth
static inline CGFloat ScreenWidth(){
    return [UIScreen mainScreen].bounds.size.width;
}
#endif

#ifndef ScreenHeight
static inline CGFloat ScreenHeight(){
    return [UIScreen mainScreen].bounds.size.height;
}
#endif

- (NSString *)stringByTrim:(NSString *)targetStr{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [targetStr stringByTrimmingCharactersInSet:set];
}
- (NSDate *)dateFromString:(NSString *)dateStr dateFormatter:(NSDateFormatter *)dateFormatter{
    NSDate * date = [NSDate date];
    if (!dateStr || !dateStr.length){
        return nil;
    }
    if (!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    date = [dateFormatter dateFromString:dateStr];
    return date;
}

@end
