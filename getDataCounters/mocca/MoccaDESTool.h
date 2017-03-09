//
//  ZKcmoneDESTool.h
//  DESdEMO
//
//  Created by mmone on 13-12-4.
//  Copyright (c) 2013年 mmone. All rights reserved.
//


/** 声明
 * !!IMPORTANT!!
 * 注意！本Demo以及附属接口文档的属于本公司机密，未经许可不得擅自发布！
 * 本Demo中的mmoneTools文件夹中提供了方便开发者获得接口相关参数的工具类，开发者可以根据自己的需要灵活使用本demo所提供的代码。
 * 由于泡泡糖API在嵌入过程中具有很大的灵活性，本demo没有提供开发者如何管理用户消费和如何具体显示泡泡界面的相关代码，开发者可以根据接口文档和自己应用的实际需求灵活处理。
 * 开发者在嵌入过程中如果遇到任何问题，请联系安沃相关人员及时沟通，以免对开发者造成不必要的损失。
 */

#import <Foundation/Foundation.h>

@interface MoccaDESTool : NSObject

//DES加密方法，开发者只需要传入需要加密的字符串，和经过base64编码转化的密钥(NSData类型)就可以返回加密后的字符串mmoneDESEncrypt

//+(NSData *) mmoneDESEncrypt:(NSString *)encryptText;
//+(NSData *) mmoneDESEncrypt:(NSString *)encryptText Key:(NSString *)key;
+(NSData *)mmoneDESEncrypt:(NSString *)encryptText Key:(NSData *)key;
//DES解密方法，开发者只需要传入需要解密的字符串，和经过base64编码转化的密钥(NSData类型)就可以返回加密后的字符串

+(NSString *)mmoneDESDecrypt:(NSData *)decryptdata Key:(NSData *)key;

@end
