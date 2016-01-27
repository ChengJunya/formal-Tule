//
//  CCitySelectView.m
//  TL
//
//  Created by Rainbow on 3/7/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "CCitySelectView.h"

#define FirstComponent 0
#define SubComponent 1
#define ThirdComponent 2

@interface CCitySelectView()

@property(nonatomic,retain)NSArray* pickerArray;
@property(nonatomic,retain)NSArray* subPickerArray;
@property(nonatomic,retain)NSArray* thirdPickerArray;
@property(nonatomic,retain)NSArray* selectArray;
@end

@implementation CCitySelectView


@synthesize pickerArray=_pickerArray;
@synthesize subPickerArray=_subPickerArray;
@synthesize thirdPickerArray=_thirdPickerArray;
@synthesize selectArray=_selectArray;


-(void)setPickerArray:(NSArray *)pickerArray{
    _pickerArray = pickerArray;
    if (_pickerArray.count==0) {
        return;
    }
    [self.pickerView reloadComponent:FirstComponent];
    [self.pickerView selectRow:0 inComponent:FirstComponent animated:YES];
    if (self.PickerSelectBlock) {
        self.PickerSelectBlock(self.pickerArray[0],self);
        self.firstCoponentSelectedItem = self.pickerArray[0];
    }
}

-(void)setSubPickerArray:(NSArray *)subPickerArray{
    _subPickerArray = subPickerArray;
    if (_subPickerArray.count==0) {
        return;
    }
    [self.pickerView reloadComponent:SubComponent];
    [self.pickerView selectRow:0 inComponent:SubComponent animated:YES];
    self.subCoponentSelectedItem = self.subPickerArray[0];
//    if (self.PickerSubSelectBlock) {
//        self.PickerSubSelectBlock(self.subPickerArray[0],self);
//
//    }
}
-(void)setThirdPickerArray:(NSArray *)thirdPickerArray{
    _thirdPickerArray = thirdPickerArray;
    if (_thirdPickerArray.count==0) {
        return;
    }
    [self.pickerView reloadComponent:ThirdComponent];
    [self.pickerView selectRow:0 inComponent:ThirdComponent animated:YES];
    self.thirdCoponentSelectedItem = self.thirdPickerArray[0];

}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Do any additional setup after loading the view, typically from a nib.
//        NSString* plistPath=[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
//        _dict=[[NSDictionary alloc] initWithContentsOfFile:plistPath];
//        _dict = @{};
        
        
        _pickerArray=@[];
        _subPickerArray= @[];
        _thirdPickerArray = @[];
        _selectArray=@[];
        
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:self.pickerView];
        
    }
    return self;
}






#pragma mark --
#pragma mark--UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==FirstComponent) {
        return [self.pickerArray count];
    }
    if (component==SubComponent) {
        return [self.subPickerArray count];
    }
    if (component==ThirdComponent) {
        return [self.thirdPickerArray count];
    }
    return 0;
}


#pragma mark--
#pragma mark--UIPickerViewDelegate
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (component==FirstComponent) {
//        return [[self.pickerArray objectAtIndex:row] valueForKey:self.firstCoponentNameKey];
//    }
//    if (component==SubComponent) {
//        return [[self.subPickerArray objectAtIndex:row] valueForKey:self.subCoponentNameKey];
//    }
//    if (component==ThirdComponent) {
//        return [[self.thirdPickerArray objectAtIndex:row] valueForKey:@"name"];
//    }
//    return nil;
//}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (component==FirstComponent) {
        id selectItem = self.pickerArray[row];
        self.firstCoponentSelectedItem = selectItem;
        if (self.PickerSelectBlock) {
            self.PickerSelectBlock(selectItem,self);
        }
    }else if(component == SubComponent){
        id selectItem = self.subPickerArray[row];
        self.subCoponentSelectedItem = selectItem;
        if (self.PickerSubSelectBlock) {
            self.PickerSubSelectBlock(selectItem,self);
        }
    }else if(component == ThirdComponent){
        id selectItem = self.thirdPickerArray[row];
        self.thirdCoponentSelectedItem = selectItem;
    }
    
//    if (component==0) {
//        self.selectArray=[_dict objectForKey:[self.pickerArray objectAtIndex:row]];
//        if ([self.selectArray count]>0) {
//            self.subPickerArray= [[self.selectArray objectAtIndex:0] allKeys];
//        }else{
//            self.subPickerArray=nil;
//        }
//        if ([self.subPickerArray count]>0) {
//            self.thirdPickerArray=[[self.selectArray objectAtIndex:0] objectForKey:[self.subPickerArray objectAtIndex:0]];
//        }else{
//            self.thirdPickerArray=nil;
//        }
//        [pickerView selectedRowInComponent:1];
//        [pickerView reloadComponent:1];
//        [pickerView selectedRowInComponent:2];
//        
//        
//    }
//    if (component==1) {
//        if ([_selectArray count]>0&&[_subPickerArray count]>0) {
//            self.thirdPickerArray=[[self.selectArray objectAtIndex:0] objectForKey:[self.subPickerArray objectAtIndex:row]];
//        }else{
//            self.thirdPickerArray=nil;
//        }
//        [pickerView selectRow:0 inComponent:2 animated:YES];
//        
//    }
//    
//    
//    [pickerView reloadComponent:2];
    
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component==FirstComponent) {
        return 80.0;
    }
    if (component==SubComponent) {
        return 100.0;
    }
    if (component==ThirdComponent) {
        return 100.0;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *myView = nil;
    
    if (component == FirstComponent) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 80, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [[self.pickerArray objectAtIndex:row] valueForKey:self.firstCoponentNameKey];
        
        myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        
    }else if (component == SubComponent){
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.text = [[self.subPickerArray objectAtIndex:row] valueForKey:self.subCoponentNameKey];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.font = [UIFont systemFontOfSize:14];
        
        myView.backgroundColor = [UIColor clearColor];
        
    }else if (component == ThirdComponent){
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.text = [[self.thirdPickerArray objectAtIndex:row] valueForKey:self.thirdCoponentNameKey];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.font = [UIFont systemFontOfSize:14];
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    
    return myView;
    
}

@end
