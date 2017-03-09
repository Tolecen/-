//
//  MoccaMD5.c
//  ZKcmone SDK3.0
//
//  Created by zenny_chen on 12-9-28.
//  Copyright (c) 2012年 zenny_chen. All rights reserved.
//

#include <string.h>

// 左环移表
static const unsigned r[64] = {
    7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
    5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20,
    4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
    6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21
};

// 使用弧度制的整型的正弦的整数部分来做表
// floor(fabs(sin(i + 1)) * (2 ^ 32))
static const unsigned k[64] = {
    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
    0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
    0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
    0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
    0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
    0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
    0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
    0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
    0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
};

static inline unsigned leftrotate(unsigned x, int c)
{
    return (x << c) | (x >> (32 - c));
}

// Be sure that output has 16 bytes
void __attribute__((weak, visibility("internal"))) MoccaMD5Encode(void *output, const void *pSrc, size_t srcLength)
{
    unsigned char __attribute__((aligned(4))) contentBuffer[64];
    
    memset(contentBuffer, 0, sizeof(contentBuffer));
    memcpy(contentBuffer, pSrc, srcLength);
    
    // Padding
    
    /** Notice: the input bytes are considered as bits strings,
     where the first bit is the most significant bit of the byte. */
    contentBuffer[srcLength] = 0x80;
    unsigned lengthOnBit = srcLength * 8;
    *(unsigned*)&contentBuffer[56] = lengthOnBit;
    
    // Initialize variables
    unsigned h0 = 0x67452301;
    unsigned h1 = 0xefcdab89;
    unsigned h2 = 0x98badcfe;
    unsigned h3 = 0x10325476;
    
    // Process the message in successive 512-bit chunks:
    // Here assume the message only contains one chunk
    unsigned a = h0;
    unsigned b = h1;
    unsigned c = h2;
    unsigned d = h3;
    
    int i;
    for(i = 0; i < 16; i++)
    {
        unsigned f = (b & c) | (~b & d);
        unsigned g = i;
        
        unsigned temp = d;
        d = c;
        c = b;
        unsigned w = ((unsigned*)contentBuffer)[g];
        b += leftrotate(a + f + k[i] + w, r[i]);
        a = temp;
    }
    while(i < 32)
    {
        unsigned f = (d & b) | (~d & c);
        unsigned g = (5 * i + 1) & 0x0f;
        
        unsigned temp = d;
        d = c;
        c = b;
        unsigned w = ((unsigned*)contentBuffer)[g];
        b += leftrotate(a + f + k[i] + w, r[i]);
        a = temp;
        
        i++;
    }
    while(i < 48)
    {
        unsigned f = (b ^ c) ^ d;
        unsigned g = (3 * i + 5) & 0x0f;
        
        unsigned temp = d;
        d = c;
        c = b;
        unsigned w = ((unsigned*)contentBuffer)[g];
        b += leftrotate(a + f + k[i] + w, r[i]);
        a = temp;
        
        i++;
    }
    while(i < 64)
    {
        unsigned f = c ^ (b | ~d);
        unsigned g = (7 * i) & 0x0f;
        
        unsigned temp = d;
        d = c;
        c = b;
        unsigned w = ((unsigned*)contentBuffer)[g];
        b += leftrotate(a + f + k[i] + w, r[i]);
        a = temp;
        
        i++;
    }
    
    h0 += a;
    h1 += b;
    h2 += c;
    h3 += d;
    
    unsigned *pOut = (unsigned*)output;
    pOut[0] = h0;
    pOut[1] = h1;
    pOut[2] = h2;
    pOut[3] = h3;
}

void __attribute__((weak, visibility("internal"))) MoccaReverseBitOnBytes(char *buffer, size_t length)
{
    for(size_t i = 0; i < length; i++)
    {
        unsigned char token = buffer[i];
        unsigned char result = 0;
        for(int i = 0; i < 8; i++)
            result |= (1 & (token >> (7 - i))) << i;
        buffer[i] = result;
    }
}

