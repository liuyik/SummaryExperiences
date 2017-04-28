//
//  NSString+Extension.h
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/4/28.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/** 判断字符串是否为空白的*/
- (BOOL)isBlank;

/** 判断字符串是否为空*/
- (BOOL)isEmpty;

/** 判断字符串是否为Null*/
- (BOOL)isNULL;

/** 把手机号第4-7位变成星号*/
+(NSString *)phoneNumToAsterisk:(NSString*)phoneNum;

/** 把身份证号第5-14位变成星号*/
+(NSString *)idCardToAsterisk:(NSString *)idCardNum;

/** 判断是否是身份证号码*/
+(BOOL)validateIdCard:(NSString *)idCard;

/** 邮箱验证*/
+(BOOL)validateEmail:(NSString *)email;

/** 手机号码验证*/
+(BOOL)validateMobile:(NSString *)mobile;

@end
