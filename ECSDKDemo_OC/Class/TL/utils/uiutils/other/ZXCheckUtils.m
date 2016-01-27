//
//  ZXCheckUtils.m
//  alijk
//
//  Created by easy on 14-8-8.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "ZXCheckUtils.h"

@implementation ZXCheckUtils

/*
 * 检测输入的手机号是否符合条件
 * 手机格式：1开头的11位数字
 * 座机格式：123-12345678或1234-1234567
 * 手机号为空，提示“请输入手机号码”。
 * 手机格式不正确，提示“请输入本人正确的手机号码”。
 */
+ (BOOL)checkPhoneNumber:(NSString*)phone showInfo:(UILabel*)showInfoLabel
{
    NSString *showInfo;
    NSString *phoneTest = @"\\d{3}-\\d{8}|\\d{4}-\\d{7}|\\d{11}";  //@"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";//@"^(\\d{3,4}-)?\\d{7,8})$";//
   /* NSString *phoneTest = @"^[0-9]{3,4}-[0-9]{3,8}";*/
    NSString *mobilePhoneTest = @"^1[0-9]{10}";
    if ([ZXCheckUtils isNullString:phone]) {
        showInfo = @"请填写联系电话";
    }
    else if (![ZXCheckUtils evaluateString:phone evaluate:phoneTest] &&
             ![ZXCheckUtils evaluateString:phone evaluate:mobilePhoneTest]) {
        showInfo = @"请填写正确的联系电话";
    }
    
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}

/*
 * 检测注册输入的手机号是否符合条件
 * 手机格式：1开头的11位数字
 * 手机号为空，提示“请输入手机号码”。
 * 手机格式不正确，提示“请输入本人正确的手机号码”。
 */
+ (BOOL)checkRegPhoneNumber:(NSString*)phone showInfo:(UILabel*)showInfoLabel
{
    NSString *showInfo;
    NSString *mobilePhoneTest = @"^1[0-9]{10}";
    if ([ZXCheckUtils isNullString:phone]) {
        showInfo = @"请填写联系电话";
    }
    else if (![ZXCheckUtils evaluateString:phone evaluate:mobilePhoneTest]) {
        showInfo = @"请输入本人正确的手机号码";

    }
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}
/*
 * 检测输入的邮箱是否符合条件
 * 邮箱格式：4-20位字符，字符包括a-z、A-Z、0-9、_
 * 邮箱为空：提示“请输入邮箱地址”。
 * 邮箱格式不正确，提示“请输入正确的邮箱地址”。
 */
+ (BOOL)checkEmailAddress:(NSString*)email showInfo:(UILabel*)showInfoLabel
{
    NSString *showInfo;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    if ([ZXCheckUtils isNullString:email]) {
        showInfo = @"请输入邮箱地址";
    }
    else if (![ZXCheckUtils evaluateString:email evaluate:emailRegex]) {
        showInfo = @"请输入正确的邮箱地址";
    }
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}

+ (BOOL)checkEmpty:(NSString*)input showInfo:(NSString *)tip onLabel:(UILabel*)showInfoLabel
{
    NSString *showInfo;
    if ([ZXCheckUtils isNullString:input]) {
        showInfo = tip;
    }
    
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}

/*
 * 检测输入的密码是否符合条件
 * 密码的输入格式：6-20位字符，字符包括a-z、A-Z、0-9、_
 * 密码为空：提示“请输入密码”。
 * 密码格式输入字符范围不正确，提示“密码只能输入字母、数字或_的组合。请输入正确的旧密码”。
 * 密码输入长度不正确，提示“密码只能输入6-20位字符。字符只能是字母、数字或_的组合。请输入正确的密码”。
 */
+ (BOOL)checkPassword:(NSString*)password showInfo:(UILabel*)showInfoLabel
{
    NSString *showInfo;
    NSString *pwdTest = @"^[A-Za-z0-9]+$";
    if ([ZXCheckUtils isNullString:password]) {
        showInfo = @"请输入密码";
    }
    else if (![ZXCheckUtils evaluateString:password evaluate:pwdTest]) {
        showInfo = @"密码只能输入字母、数字或_的组合。请输入正确的密码";
    }
    else if (password.length < 6 || password.length > 20) {
        showInfo = @"密码只能输入6-20位字符。字符只能是字母、数字或_的组合。请输入正确的密码";
    }
    
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}

/*
 * 检测输入的密码是否一致
 * 不一致：提示“两次输入的密码不一致”。
 */
+ (BOOL)checkPassword:(NSString*)password pwdAgain:(NSString*)pwdAgain showInfo:(UILabel*)showInfoLabel
{
    NSString *showInfo;
    if (![password isEqualToString:pwdAgain]) {
        showInfo = @"两次输入的密码不一致";
    }
    
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}

/*
 * 检测输入的验证码是否符合条件
 * 验证码的输入格式：4位字母或4位数字
 * 验证码为空，提示“请输入验证码”。
 * 验证码格式不正确或输入错误，提示“请根据短信中的信息，输入正确的验证码“。
 * 验证码验证过期时，提示“您的验证码已过期，请重新获取验证码”。
 */
+ (BOOL)checkCertifyCode:(NSString*)code showInfo:(UILabel*)showInfoLabel
{
    NSString *showInfo;
    NSString *codeTest = @"^[A-Za-z0-9]{4,6}";
    if ([ZXCheckUtils isNullString:code]) {
        showInfo = @"请输入验证码";
    }
    else if (![ZXCheckUtils evaluateString:code evaluate:codeTest]) {
        showInfo = @"请根据短信中的信息，输入正确的验证码";
    }
    
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}

/*
 * 检测输入的邀请码是否符合条件
 * 验证码的输入格式：6位数字
 *
 */
+ (BOOL)checkRecommendCode:(NSString *)code showInfo:(UILabel *)showInfoLabel
{
    NSString *showInfo;
    if (code.length != 6 && ![code isEqualToString:@""]) {
        showInfo = @"";
        /**
         *  
         *
         *  showInfo = @"邀请码格式错误，请正确填写";
         *
         *
         */
    }

    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}
/*
 * 检测用户名是否符合条件
 * 联系人为空时，提示“请填写联系人”
 * 联系人最多填写10个汉字，如果超出，提示“请填写正确的联系人姓名”
 */
+ (BOOL)checkUserName:(NSString*)userName showInfo:(UILabel*)showInfoLabel
{
    NSString *showInfo;
    if ([ZXCheckUtils isNullString:userName]) {
        showInfo = @"请填写联系人";
    }
    else if([ZXCheckUtils checkLength:userName] >20)
    {
        showInfo = @"联系人姓名不能超过10个汉字";
    }
    int len= userName.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[userName characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='_'))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ))
        showInfo = @"联系人不能输入特殊字符";
    }
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}

/*
 * 检测用户名是否符合条件
 * 身份证为空：提示“请输入身份证号码”。
 * 身份证格式不正确：提示“请输入正确的身份证号码”。
 */
+ (BOOL)checkIDCard:(NSString*)idCard showInfo:(UILabel*)showInfoLabel
{
    NSString *showInfo;
    NSString *idCardTest = @"(^[0-9]{15})|(^[0-9]{17}([0-9]|X))";
    if ([ZXCheckUtils isNullString:idCard]) {
        showInfo = @"请输入身份证号码";
    }
    else if (![ZXCheckUtils evaluateString:idCard evaluate:idCardTest]) {
        showInfo = @"请输入正确的身份证号码";
    }
    
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}

/*
 * 检测用户地址是否符合条件
 * 详细地址为空时，提示“请填写详细地址”
 * 详细地址最多填写200个字符，如果超出，提示“请填写正确的详细地址”
 */
+ (BOOL)checkUserAddress:(NSString*)userAddress showInfo:(UILabel*)showInfoLabel
{
    NSString *showInfo;
    if ([ZXCheckUtils isNullString:userAddress]) {
        showInfo = @"请填写详细地址";
    }
    else if ([ZXCheckUtils checkLength:userAddress] > 200) {
        showInfo = @"详细地址不能超过100个汉字";
    }
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}
/*
 * 检测用户邮编是否符合条件
 * 如果填写了邮编，邮编格式不是6位数字，提示“请填写正确的邮编，或者不确定具体邮编可不用填写”
 */
+ (BOOL)checkUserPost:(NSString*)userPost showInfo:(UILabel*)showInfoLabel
{
    NSString *showInfo;
    NSString *postTest = @"^[0-9]{6}";
    if (![ZXCheckUtils isNullString:userPost] &&
        ![ZXCheckUtils evaluateString:userPost evaluate:postTest]) {
        showInfo = @"请填写正确的邮编，或者不确定具体邮编可不用填写";
    }
    
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}

/*
 * 检测用户就诊医院
 * 省、市、县三个下拉框只是方便患者选择医院的辅助工具，省市县变化时，医院的下拉框内容也要做相应的变化。只要选择了医院即可，可以不用选择具体的省市县。
 * 医院下拉框：默认选中“请选择医院”。此时点击下一步按钮时，提示“请选择曾经的就诊医院”。
 */
+ (BOOL)checkdpHospital:(NSString*)hospital showInfo:(UILabel*)showInfoLabel
{
    NSString *showInfo;
    if ([hospital isEqualToString:@"医院名称"]) {
        showInfo = @"请选择曾经的就诊医院";
    }
    
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}

/*
 * 检测用户医保卡或就诊卡号码就诊医院
 * 医保卡/就诊卡的下拉框默认选择“医保卡”。
 * 医保卡/就诊卡的输入框为空，如果下拉框选择“医保卡”，提示“请输入您在就诊医院登记的医保卡号码”。
 * 医保卡/就诊卡的输入框为空，如果下拉框选择“就诊卡”，提示“请输入您在就诊医院登记的就诊卡号码”。
 */
+ (BOOL)checkdpMedicalCard:(NSString*)cardType cardNum:(NSString*)cardNum showInfo:(UILabel*)showInfoLabel
{
    /* TODO: 目前不知卡号的格式，先不做正则匹配
     */
    
    NSString *showInfo;
    if ([ZXCheckUtils isNullString:cardNum]) {
        if ([cardType isEqualToString:@"医保卡"]) {
            showInfo = @"请输入您在就诊医院登记的医保卡号码";
        }
        else if ([cardType isEqualToString:@"就诊卡"]) {
            showInfo = @"请输入您在就诊医院登记的就诊卡号码";
        }
    }
    
    return ([ZXCheckUtils checkAddRunAnim:showInfo label:showInfoLabel]);
}

+ (BOOL)checkAddRunAnim:(NSString*)showInfo label:(UILabel*)showInfoLabel
{
    if (![ZXCheckUtils isNullString:showInfo]) {
        showInfoLabel.text = showInfo;
        [ZXCheckUtils adjustAndAddAnimationToLabel:showInfoLabel];
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)isNullString:(NSString*)string
{
    return (nil == string || [string isEqualToString:@""]);
}

+ (BOOL)evaluateString:(NSString*)string evaluate:(NSString*)evaluate
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", evaluate];
//      return ([predicate evaluateWithObject:string]);
    return ([predicate evaluateWithObject:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]);
}

/*
 *自提的有效时间为2天。显示规则：自提剩余时间等于48小时，显示“2天”；自提剩余时间大于或等于24小时，显示“1天N小时”；自提剩余时间小于24小时且大于等于1小时，显示“N小时”；自提剩余时间小于1小时且大于等于1分钟，显示“M分钟”；自提剩余时间小于1分钟，显示“S秒”
 */
+ (NSString*)showStringWithTime:(NSString*)time
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *lastTime = [fmt dateFromString:time];
    
    NSString *retValue;
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:lastTime];
    NSInteger remainTime = delta / 3600;
    if (remainTime >= 48) { // 2天外
        retValue = @"2天";
    }
    else if (remainTime >= 24 && remainTime < 48) { // 大于1天 小于两天
        retValue = [NSString stringWithFormat:@"1天%d小时", remainTime - 24];
    }
    else if (remainTime >=1 && remainTime < 24) { //1天内
        retValue = [NSString stringWithFormat:@"%d小时", remainTime];
    }
    else if (delta >60 && delta < 3600) { //1小时内
        retValue = [NSString stringWithFormat:@"%d分钟", (NSInteger)delta/60];
    }
    else { //1分钟内
        retValue = [NSString stringWithFormat:@"%d秒", (NSInteger)delta];
    }
    
    return retValue;
}

+ (UILabel*)addShowInfoByTextField:(UITextField*)textField spuerView:(UIView*)superView
{
    CGRect frame = textField.frame;
    UILabel *label = [[UILabel alloc] init];
    label.font = FONT_12;
    label.textColor = COLOR_BTN_SOLID_ORANGE_SUFACE;
    label.adjustsFontSizeToFitWidth = YES;
    label.frame = CGRectMake(CGRectOriginX(frame), CGRectGetMaxY(frame), CGRectWidth(frame), 16);
    [superView addSubview:label];
    
    return label;
}
+ (UILabel *)addShowInfoByTextView:(UITextView *)textView spuerView:(UIView *)superView
{
    CGRect frame = textView.frame;
    UILabel *label = [[UILabel alloc] init];
    label.font = FONT_12;
    label.textColor = COLOR_BTN_SOLID_ORANGE_SUFACE;
    label.adjustsFontSizeToFitWidth = YES;
    label.frame = CGRectMake(CGRectOriginX(frame), CGRectGetMaxY(frame), CGRectWidth(frame), 16);
    [superView addSubview:label];
    
    return label;
}

+ (UILabel*)addShowInfoByView:(UIView*)view spuerView:(UIView*)superView{
    CGRect frame = view.frame;
    UILabel *label = [[UILabel alloc] init];
    label.font = FONT_12;
    label.textColor = COLOR_BTN_SOLID_ORANGE_SUFACE;
    label.adjustsFontSizeToFitWidth = YES;
    label.frame = CGRectMake(CGRectOriginX(frame), CGRectGetMaxY(frame), CGRectWidth(frame), 16);
    [superView addSubview:label];
    
    return label;
}

+ (void)adjustAndAddAnimationToLabel:(UILabel*)label
{
    // addjust show frame
    /*
    CGRect frame = label.frame;
    CGSize labelSize = [label boundingRectWithSize:CGSizeMake(CGRectWidth(frame), 10000)];
    label.frame = (CGRect){.origin = CGRectOrigin(frame), .size = CGSizeMake(CGRectWidth(frame), labelSize.height)};
     */
    
    // add animation
    if (label.alpha < 1.f) {
        return;
    }
    
    label.hidden = NO;
    label.alpha = 1.f;
    [UIView animateWithDuration:3.f animations:^{
        label.alpha = 0.f;
    } completion:^(BOOL finished) {
        label.text = @"";
        label.alpha = 1.f;
        label.hidden = YES;
    }];
}
+ (int)checkLength:(NSString *)string
{
    int len= string.length;int sum=0;
    for (int i = 0; i<len; i++) {
        unichar a=[string characterAtIndex:i];
        int m;
        if (((a >= 0x4e00 && a <= 0x9fa6))) {
            m =2;
        }
        else{
            m =1;
        }
        sum +=m;
    }
    return sum;
}
@end
