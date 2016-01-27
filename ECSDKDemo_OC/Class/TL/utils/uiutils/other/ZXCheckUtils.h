//
//  ZXCheckUtils.h
//  alijk
//
//  Created by easy on 14-8-8.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXCheckUtils : NSObject

/*
 * 检测输入的手机号是否符合条件
 * 手机格式：1开头的11位数字 
 * 座机格式：123-12345678或1234-1234567
 * 手机号为空，提示“请输入手机号码”。
 * 手机格式不正确，提示“请输入本人正确的手机号码”。
 */
+ (BOOL)checkPhoneNumber:(NSString*)phone showInfo:(UILabel*)showInfoLabel;

/**
 * 检测注册输入的手机号是否符合条件
 */
+ (BOOL)checkRegPhoneNumber:(NSString*)phone showInfo:(UILabel*)showInfoLabel;
/*
 * 检测输入的邮箱是否符合条件
 * 邮箱格式：4-20位字符，字符包括a-z、A-Z、0-9、_
 * 邮箱为空：提示“请输入邮箱地址”。
 * 邮箱格式不正确，提示“请输入正确的邮箱地址”。
 */
+ (BOOL)checkEmailAddress:(NSString*)email showInfo:(UILabel*)showInfoLabel;

/*
 * 检测输入的密码是否符合条件
 * 密码的输入格式：6-20位字符，字符包括a-z、A-Z、0-9、_
 * 密码为空：提示“请输入密码”。
 * 密码格式输入字符范围不正确，提示“密码只能输入字母、数字或_的组合。请输入正确的旧密码”。
 * 密码输入长度不正确，提示“密码只能输入6-20位字符。字符只能是字母、数字或_的组合。请输入正确的密码”。
 */
+ (BOOL)checkPassword:(NSString*)password showInfo:(UILabel*)showInfoLabel;

/*
 * 检测输入的验证码是否符合条件
 * 验证码的输入格式：4位字母或4位数字
 * 验证码为空，提示“请输入验证码”。
 * 验证码格式不正确或输入错误，提示“请根据短信中的信息，输入正确的验证码“。
 * 验证码验证过期时，提示“您的验证码已过期，请重新获取验证码”。
 */
+ (BOOL)checkCertifyCode:(NSString*)code showInfo:(UILabel*)showInfoLabel;

/*
 * 检测输入的密码是否一致
 * 不一致：提示“两次输入的密码不一致”。
 */
+ (BOOL)checkPassword:(NSString*)password pwdAgain:(NSString*)pwdAgain showInfo:(UILabel*)showInfoLabel;


/*
 * 检测输入的邀请码是否符合条件
 * 验证码的输入格式：6位数字
 * 验证码为空，提示“请输入验证码”。
 * 验证码格式不正确或输入错误，提示“请根据输入正确的验证码“。
 *
 */
+ (BOOL)checkRecommendCode:(NSString*)code showInfo:(UILabel*)showInfoLabel;
/*
 * 检测用户名是否符合条件
 * 联系人为空时，提示“请填写联系人”
 * 联系人最多填写10个汉字，如果超出，提示“请填写正确的联系人姓名”
 */
+ (BOOL)checkUserName:(NSString*)userName showInfo:(UILabel*)showInfoLabel;

/*
 * 检测用户名是否符合条件
 * 身份证为空：提示“请输入身份证号码”。
 * 身份证格式不正确：提示“请输入正确的身份证号码”。
 */
+ (BOOL)checkIDCard:(NSString*)idCard showInfo:(UILabel*)showInfoLabel;

/*
 * 检测用户地址是否符合条件
 * 详细地址为空时，提示“请填写详细地址”
 * 详细地址最多填写200个字符，如果超出，提示“请填写正确的详细地址”
 */
+ (BOOL)checkUserAddress:(NSString*)userAddress showInfo:(UILabel*)showInfoLabel;
/*
 * 检测用户邮编是否符合条件
 * 如果填写了邮编，邮编格式不是6位数字，提示“请填写正确的邮编，或者不确定具体邮编可不用填写”
 */
+ (BOOL)checkUserPost:(NSString*)userPost showInfo:(UILabel*)showInfoLabel;

/*
 * 检测用户就诊医院
 * 省、市、县三个下拉框只是方便患者选择医院的辅助工具，省市县变化时，医院的下拉框内容也要做相应的变化。只要选择了医院即可，可以不用选择具体的省市县。
 * 医院下拉框：默认选中“请选择医院”。此时点击下一步按钮时，提示“请选择曾经的就诊医院”。
 */
+ (BOOL)checkdpHospital:(NSString*)hospital showInfo:(UILabel*)showInfoLabel;

/*
 * 检测用户医保卡或就诊卡号码就诊医院
 * 医保卡/就诊卡的下拉框默认选择“医保卡”。
 * 医保卡/就诊卡的输入框为空，如果下拉框选择“医保卡”，提示“请输入您在就诊医院登记的医保卡号码”。
 * 医保卡/就诊卡的输入框为空，如果下拉框选择“就诊卡”，提示“请输入您在就诊医院登记的就诊卡号码”。
 */
+ (BOOL)checkdpMedicalCard:(NSString*)cardType cardNum:(NSString*)cardNum showInfo:(UILabel*)showInfoLabel;
/*
 *自提的有效时间为2天。显示规则：自提剩余时间等于48小时，显示“2天”；自提剩余时间大于或等于24小时，显示“1天N小时”；自提剩余时间小于24小时且大于等于1小时，显示“N小时”；自提剩余时间小于1小时且大于等于1分钟，显示“M分钟”；自提剩余时间小于1分钟，显示“S秒”
 */
+ (NSString*)showStringWithTime:(NSString*)time;

+ (UILabel*)addShowInfoByTextField:(UITextField*)textField spuerView:(UIView*)superView;

+ (UILabel*)addShowInfoByTextView:(UITextView*)textView spuerView:(UIView*)superView;
+ (UILabel*)addShowInfoByView:(UIView*)view spuerView:(UIView*)superView;
/**
 *  检查字符串长度
 *
 *  @param string 传入字符串;
 *
 *  @return
 */
+ (int)checkLength:(NSString *)string;

+ (void)adjustAndAddAnimationToLabel:(UILabel*)label;

+ (BOOL)checkEmpty:(NSString*)input showInfo:(NSString *)tip onLabel:(UILabel*)showInfoLabel;

+ (BOOL)isNullString:(NSString*)string;

@end