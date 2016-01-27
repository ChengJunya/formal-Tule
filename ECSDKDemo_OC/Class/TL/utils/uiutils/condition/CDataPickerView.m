//
//  CDataPickerView.m
//  ContractManager
//
//  Created by Rainbow on 12/19/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "CDataPickerView.h"
#import "CPickerRowView.h"
@implementation CDataPickerView

-(instancetype)initWithFrameData:(CGRect)frame itemData:(NSDictionary *)itemData{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemData = itemData;
        
        self.pickerDataArray = [self.itemData valueForKey:@"data"];
        
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:self.pickerView];
        
    }
    return self;
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.pickerDataArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *itemData = [self.pickerDataArray objectAtIndex:row];
    return [itemData valueForKey:@"name"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSDictionary *selectedItem = [self.pickerDataArray objectAtIndex:row];


    self.currentSelectedItem = [NSDictionary dictionaryWithObjectsAndKeys:[selectedItem valueForKey:@"id"],@"id",[selectedItem valueForKey:@"name"],@"name",[self.itemData valueForKey:@"paremKey"],@"paramKey", nil];
    
    [self.selectBtn setTitle:[selectedItem valueForKey:@"name"] forState:UIControlStateNormal];
    [self.selectBtn setNeedsDisplay];
    NSLog(@"%@",selectedItem);
}

//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//        NSDictionary *itemData = [self.pickerDataArray objectAtIndex:row];
//    CPickerRowView *rowView = [[CPickerRowView alloc] initWithFrame:CGRectMake(0.f, 0.f, pickerView.width, 30.f) itemData:itemData];
//    [rowView addViews];
//    
//    return rowView;
//}


-(NSDictionary *)getConditionData{
    return self.selectedItem;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
