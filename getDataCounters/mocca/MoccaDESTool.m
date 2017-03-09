//
//  ZKcmoneDESTool.m
//  DESdEMO
//
//  Created by mmone on 13-12-4.
//  Copyright (c) 2013年 mmone. All rights reserved.
//

#import "MoccaDESTool.h"
#import <CommonCrypto/CommonCryptor.h>

#import "MoccaDeviceInfo.h"
#import "MoccaBase64.h"

@implementation MoccaDESTool

const Byte vector[] = {1,2,3,4,5,6,7,8};
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

//加密DES
+(NSData *)mmoneDESEncrypt:(NSString *)encryptText Key:(NSData *)desKey{
    
    NSData *data =nil;

    NSData *encryptData = [encryptText dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [desKey bytes], kCCKeySizeDES,
                                          vector,
                                          [encryptData bytes], [encryptData length],
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        
        data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
    }
    
    return data;
    
}

////加密DES
//+(NSData *)mmoneDESEncrypt:(NSString *)encryptText Key:(NSString *)key{
//
////    const struct MoccaDeviceInfo *device = MoccaGetDeviceInfo();
////    NSLog(@"deviceInfo ==%@",device->idfa);
////    
////    NSData *desKey =  [MoccaDESTool mmoneBase64Decode:key];
//
////    NSData *desKey =MoccaDecodeString(key);
//   
//    NSData *desKey = [key dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *encryptResust = nil;
//    
//    NSData *data =nil;
//    
//    NSData *encryptData = [encryptText dataUsingEncoding:NSUTF8StringEncoding];
//    unsigned char buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesEncrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding,
//                                          [desKey bytes], kCCKeySizeDES,
//                                          vector,
//                                          [encryptData bytes], [encryptData length],
//                                          buffer, 1024,
//                                          &numBytesEncrypted);
//    if (cryptStatus == kCCSuccess) {
//        
//        data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//    }
//    return data;
//}


//解密DES
//+(NSString *)mmoneDESDecrypt:(NSData *)decryptdata
+(NSString *)mmoneDESDecrypt:(NSData *)decryptdata Key:(NSData *)desKey
{
    
    NSString *decryptResult = nil;
    NSData *plaindata = nil;
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [desKey bytes], kCCKeySizeDES,
                                          vector,
                                          [decryptdata bytes], [decryptdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        decryptResult = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return [decryptResult autorelease];
}



//+(NSString *)mmoneBase64Encode:(NSData *)data
//{
//    if (data.length == 0)
//        return nil;
//    
//    char *characters = malloc(data.length * 3 / 2);
//    
//    if (characters == NULL)
//        return nil;
//    
//    int end = data.length - 3;
//    int index = 0;
//    int charCount = 0;
//    int n = 0;
//    
//    while (index <= end) {
//        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
//        | (((int)(((char *)[data bytes])[index + 1]) & 0x0ff) << 8)
//        | ((int)(((char *)[data bytes])[index + 2]) & 0x0ff);
//        
//        characters[charCount++] = encodingTable[(d >> 18) & 63];
//        characters[charCount++] = encodingTable[(d >> 12) & 63];
//        characters[charCount++] = encodingTable[(d >> 6) & 63];
//        characters[charCount++] = encodingTable[d & 63];
//        
//        index += 3;
//        
//        if(n++ >= 14)
//        {
//            n = 0;
//            characters[charCount++] = ' ';
//        }
//    }
//    
//    if(index == data.length - 2)
//    {
//        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
//        | (((int)(((char *)[data bytes])[index + 1]) & 255) << 8);
//        characters[charCount++] = encodingTable[(d >> 18) & 63];
//        characters[charCount++] = encodingTable[(d >> 12) & 63];
//        characters[charCount++] = encodingTable[(d >> 6) & 63];
//        characters[charCount++] = '=';
//    }
//    else if(index == data.length - 1)
//    {
//        int d = ((int)(((char *)[data bytes])[index]) & 0x0ff) << 16;
//        characters[charCount++] = encodingTable[(d >> 18) & 63];
//        characters[charCount++] = encodingTable[(d >> 12) & 63];
//        characters[charCount++] = '=';
//        characters[charCount++] = '=';
//    }
//    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
//    return rtnStr;
//    
//}
//
//+(NSData *)mmoneBase64Decode:(NSString *)str
//{
//    if(str == nil || str.length <= 0) {
//        return nil;
//    }
//    NSMutableData *rtnData = [[NSMutableData alloc]init];
//    int slen = str.length;
//    int index = 0;
//    while (true) {
//        while (index < slen && [str characterAtIndex:index] <= ' ') {
//            index++;
//        }
//        if (index >= slen || index  + 3 >= slen) {
//            break;
//        }
//        
//        int byte = ([self char2Int:[str characterAtIndex:index]] << 18) + ([self char2Int:[str characterAtIndex:index + 1]] << 12) + ([self char2Int:[str characterAtIndex:index + 2]] << 6) + [self char2Int:[str characterAtIndex:index + 3]];
//        Byte temp1 = (byte >> 16) & 255;
//        [rtnData appendBytes:&temp1 length:1];
//        if([str characterAtIndex:index + 2] == '=') {
//            break;
//        }
//        Byte temp2 = (byte >> 8) & 255;
//        [rtnData appendBytes:&temp2 length:1];
//        if([str characterAtIndex:index + 3] == '=') {
//            break;
//        }
//        Byte temp3 = byte & 255;
//        [rtnData appendBytes:&temp3 length:1];
//        index += 4;
//        
//    }
//    return rtnData;
//}


+(int)char2Int:(char)c
{
    if (c >= 'A' && c <= 'Z') {
        return c - 65;
    } else if (c >= 'a' && c <= 'z') {
        return c - 97 + 26;
    } else if (c >= '0' && c <= '9') {
        return c - 48 + 26 + 26;
    } else {
        switch(c) {
            case '+':
                return 62;
            case '/':
                return 63;
            case '=':
                return 0;
            default:
                return -1;
        }
    }
}
@end
