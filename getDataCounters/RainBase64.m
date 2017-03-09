//
//  AdwoBase64.m
//  Base64Demo
//
//  Created by adwo0710 on 14-3-6.
//  Copyright (c) 2014年 adwo. All rights reserved.
//

#import "RainBase64.h"

@implementation RainBase64

static const char encodingTable[] = "012E3456879aBCDFgHIjLNOPQRSUVWXYzAbcKdefMGhiJklmnopqrstTuvwxyZ+/";

//加密
+ (NSString *)adwoBase64Encode:(NSData *)data
    {
        if (data.length == 0)
        return nil;
        
        char *characters = malloc(data.length * 3 / 2);
        
        if (characters == NULL)
        return nil;
        
        int end = data.length - 3;
        int index = 0;
        int charCount = 0;
        int n = 0;
        
        while (index <= end) {
            
            int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
            | (((int)(((char *)[data bytes])[index + 1]) & 0x0ff) << 8)
            | ((int)(((char *)[data bytes])[index + 2]) & 0x0ff);
            
            characters[charCount++] = encodingTable[(d >> 18) & 63];
            characters[charCount++] = encodingTable[(d >> 12) & 63];
            characters[charCount++] = encodingTable[(d >> 6) & 63];
            characters[charCount++] = encodingTable[d & 63];
            
            index += 3;
            
            if(n++ >= 14)
            {
                n = 0;
                characters[charCount++] = ' ';
            }
        }
        
        if(index == data.length - 2)
        {
            int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
            | (((int)(((char *)[data bytes])[index + 1]) & 255) << 8);
            characters[charCount++] = encodingTable[(d >> 18) & 63];
            characters[charCount++] = encodingTable[(d >> 12) & 63];
            characters[charCount++] = encodingTable[(d >> 6) & 63];
            characters[charCount++] = '=';
        }
        else if(index == data.length - 1)
        {
            int d = ((int)(((char *)[data bytes])[index]) & 0x0ff) << 16;
            characters[charCount++] = encodingTable[(d >> 18) & 63];
            characters[charCount++] = encodingTable[(d >> 12) & 63];
            characters[charCount++] = '=';
            characters[charCount++] = '=';
        }
        NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
        return [rtnStr autorelease];
        
    }
    //解密
+(NSData *)dataWithBase64DecodedString:(NSString *)string
{
        if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
        if ([string length] == 0)
        return [NSData data];
        
        static char *decodingTable = NULL;
        if (decodingTable == NULL)
        {
            decodingTable = malloc(256);
            if (decodingTable == NULL)
            return nil;
            memset(decodingTable, CHAR_MAX, 256);
            NSUInteger i;
            for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
        }
        
        const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
        if (characters == NULL)     //  Not an ASCII string!
        return nil;
        char *bytes = malloc((([string length] + 3) / 4) * 3);
        if (bytes == NULL)
        return nil;
        NSUInteger length = 0;
        
        NSUInteger i = 0;
        while (YES)
        {
            char buffer[4];
            short bufferLength;
            for (bufferLength = 0; bufferLength < 4; i++)
            {
                if (characters[i] == '\0')
                break;
                if (isspace(characters[i]) || characters[i] == '=')
                continue;
                buffer[bufferLength] = decodingTable[(short)characters[i]];
                if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
                {
                    free(bytes);
                    return nil;
                }
            }
            
            if (bufferLength == 0)
            break;
            if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
            {
                free(bytes);
                return nil;
            }
            
            //  Decode the characters in the buffer to bytes.
            bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
            if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
            if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
        }
        
        bytes = realloc(bytes, length);
        return [NSData dataWithBytesNoCopy:bytes length:length];
    
    }
    
    

@end
