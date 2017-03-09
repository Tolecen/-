//
//  des.c
//  DES64
//
//  Created by u_r_sb on 12-5-30.
//  Copyright (c) 2012年 u_r_sv. All rights reserved.
//

#include <stdio.h>

// Input: 64-bit plain text
// Output: 2 32-bit half blocks
// Low for left and High for right
static void InitialPermutation(unsigned pDst[2], const unsigned pSrc[2])
{
    unsigned result;
    
    unsigned lowBlock = pSrc[0];
    unsigned highBlock = pSrc[1];
    
    // Row 1
    result = (highBlock & (0x1 << 6)) << 25;    // 0 (31)
    result |= (highBlock & (0x1 << 14)) << 16;  // 1 (30)
    result |= (highBlock & (0x1 << 22)) << 7;   // 2 (29)
    result |= (highBlock & (0x1 << 30)) >> 2;   // 3 (28)
    result |= (lowBlock & (0x1 << 6)) << 21;    // 4 (27)
    result |= (lowBlock & (0x1 << 14)) << 12;   // 5 (26)
    result |= (lowBlock & (0x1 << 22)) << 3;    // 6 (25)
    result |= (lowBlock & (0x1 << 30)) >> 6;    // 7 (24)
    
    // Row 2
    result |= (highBlock & (0x1 << 4)) << 19;   // 8 (23)
    result |= (highBlock & (0x1 << 12)) << 10;  // 9 (22)
    result |= (highBlock & (0x1 << 20)) << 1;   // 10 (21)
    result |= (highBlock & (0x1 << 28)) >> 8;   // 11 (20)
    result |= (lowBlock & (0x1 << 4)) << 15;    // 12 (19)
    result |= (lowBlock & (0x1 << 12)) << 6;    // 13 (18)
    result |= (lowBlock & (0x1 << 20)) >> 3;    // 14 (17)
    result |= (lowBlock & (0x1 << 28)) >> 12;   // 15 (16)
    
    // Row 3
    result |= (highBlock & (0x1 << 2)) << 13;   // 16 (15)
    result |= (highBlock & (0x1 << 10)) << 4;   // 17 (14)
    result |= (highBlock & (0x1 << 18)) >> 5;   // 18 (13)
    result |= (highBlock & (0x1 << 26)) >> 14;  // 19 (12)
    result |= (lowBlock & (0x1 << 2)) << 9;     // 20 (11)
    result |= lowBlock & (0x1 << 10);           // 21 (10)
    result |= (lowBlock & (0x1 << 18)) >> 9;    // 22 (9)
    result |= (lowBlock & (0x1 << 26)) >> 18;   // 23 (8)
    
    // Row 4
    result |= (highBlock & (0x1 << 0)) << 7;    // 24 (7)
    result |= (highBlock & (0x1 << 8)) >> 2;    // 25 (6)
    result |= (highBlock & (0x1 << 16)) >> 11;  // 26 (5)
    result |= (highBlock & (0x1 << 24)) >> 20;  // 27 (4)
    result |= (lowBlock & (0x1 << 0)) << 3;     // 28 (3)
    result |= (lowBlock & (0x1 << 8)) >> 6;     // 29 (2)
    result |= (lowBlock & (0x1 << 16)) >> 15;   // 30 (1)
    result |= (lowBlock & (0x1 << 24)) >> 24;   // 31 (0)
    
    pDst[0] = result;
    
    // Row 5
    result = (highBlock & (0x1 << 7)) << 24;    // 0 (31)
    result |= (highBlock & (0x1 << 15)) << 15;  // 1 (30)
    result |= (highBlock & (0x1 << 23)) << 6;   // 2 (29)
    result |= (highBlock & (0x1 << 31)) >> 3;   // 3 (28)
    result |= (lowBlock & (0x1 << 7)) << 20;    // 4 (27)
    result |= (lowBlock & (0x1 << 15)) << 11;   // 5 (26)
    result |= (lowBlock & (0x1 << 23)) << 2;    // 6 (25)
    result |= (lowBlock & (0x1 << 31)) >> 7;    // 7 (24)
    
    // Row 6
    result |= (highBlock & (0x1 << 5)) << 18;   // 8 (23)
    result |= (highBlock & (0x1 << 13)) << 9;   // 9 (22)
    result |= highBlock & (0x1 << 21);          // 10 (21)
    result |= (highBlock & (0x1 << 29)) >> 9;   // 11 (20)
    result |= (lowBlock & (0x1 << 5)) << 14;    // 12 (19)
    result |= (lowBlock & (0x1 << 13)) << 5;    // 13 (18)
    result |= (lowBlock & (0x1 << 21)) >> 4;    // 14 (17)
    result |= (lowBlock & (0x1 << 29)) >> 13;   // 15 (16)
    
    // Row 7
    result |= (highBlock & (0x1 << 3)) << 12;   // 16 (15)
    result |= (highBlock & (0x1 << 11)) << 3;   // 17 (14)
    result |= (highBlock & (0x1 << 19)) >> 6;   // 18 (13)
    result |= (highBlock & (0x1 << 27)) >> 15;  // 19 (12)
    result |= (lowBlock & (0x1 << 3)) << 8;     // 20 (11)
    result |= (lowBlock & (0x1 << 11)) >> 1;    // 21 (10)
    result |= (lowBlock & (0x1 << 19)) >> 10;   // 22 (9)
    result |= (lowBlock & (0x1 << 27)) >> 19;   // 23 (8)
    
    // Row 8
    result |= (highBlock & (0x1 << 1)) << 6;    // 24 (7)
    result |= (highBlock & (0x1 << 9)) >> 3;    // 25 (6)
    result |= (highBlock & (0x1 << 17)) >> 12;  // 26 (5)
    result |= (highBlock & (0x1 << 25)) >> 21;  // 27 (4)
    result |= (lowBlock & (0x1 << 1)) << 2;     // 28 (3)
    result |= (lowBlock & (0x1 << 9)) >> 7;     // 29 (2)
    result |= (lowBlock & (0x1 << 17)) >> 16;   // 30 (1)
    result |= (lowBlock & (0x1 << 25)) >> 25;   // 31 (0)
    
    pDst[1] = result;
}

static void FinalPermutation(unsigned pDst[2], const unsigned pSrc[2])
{
    unsigned result;
    
    unsigned lowBlock = pSrc[0];
    unsigned highBlock = pSrc[1];
    
    // Row 1
    result =(highBlock & (0x1 << 24)) << 7;                   // 0 (31)
    result |=(lowBlock & (0x1 << 24)) << 6;                   // 1 (30)
    result |=(highBlock &(0x1 << 16)) << 13;                  // 2 (29)
    result |=(lowBlock &(0x1 << 16)) << 12;                   // 3 (28)    
    result |=(highBlock &(0x1 << 8)) << 19;                   // 4 (27)
    result |=(lowBlock &(0x1 << 8)) << 18;                    // 5 (26)    
    result |=(highBlock &(0x1 << 0)) << 25;                   // 6 (25)
    result |=(lowBlock &(0x1 << 0)) << 24;                    // 7 (24)
    
    // Row 2
    result |=(highBlock &(0x1 << 25)) >> 2;              // 8 (23)
    result |=(lowBlock &(0x1 << 25)) >> 3;               // 9 (22)
    result |=(highBlock &(0x1 << 17)) << 4;              // 10 (21)
    result |=(lowBlock &(0x1 << 17)) << 3;               // 11 (20)
    result |=(highBlock &(0x1 << 9)) << 10;              // 12 (19)
    result |=(lowBlock &(0x1 << 9)) << 9;                // 13 (18)
    result |=(highBlock &(0x1 << 1)) << 16;              // 14 (17)
    result |=(lowBlock &(0x1 << 1)) << 15;               // 15 (16)
    
    // Row 3
 
    result |= (highBlock &(0x1 << 26)) >> 11;           // 16 (15)
    result |= (lowBlock &(0x1 << 26)) >> 12;            // 17 (14)
    result |= (highBlock &(0x1 << 18)) >> 5;            // 18 (13)
    result |= (lowBlock &(0x1 << 18)) >> 6;             // 19 (12)
    result |= (highBlock &(0x1 << 10)) << 1;            // 20 (11)
    result |= (lowBlock &(0x1 << 10)) << 0;             // 21 (10)
    result |= (highBlock &(0x1 << 2)) << 7;             // 22 (9)
    result |= (lowBlock &(0x1 << 2)) << 6;              // 23 (8)
    
    // Row 4
 
    result |= (highBlock &(0x1 << 27)) >> 20;           // 24 (7)
    result |= (lowBlock &(0x1 << 27)) >> 21;            // 25 (6)    
    result |= (highBlock &(0x1 << 19)) >> 14;           // 26 (5)
    result |= (lowBlock &(0x1 << 19)) >> 15;            // 27 (4)
    result |= (highBlock &(0x1 << 11)) >> 8;            // 28 (3)
    result |= (lowBlock &(0x1 << 11)) >> 9;             // 29 (2)
    result |= (highBlock &(0x1 << 3)) >> 2;             // 30 (1)
    result |= (lowBlock &(0x1 << 3)) >> 3;              // 31 (0)
    
    pDst[0] = result;
    
    // Row 5
    
    result =(highBlock & (0x1 << 28)) <<3;                  // 0 (31)
    result |=(lowBlock & (0x1 << 28)) <<2;                   // 1 (30)
    result |=(highBlock &(0x1 << 20)) << 9;                  // 2 (29)
    result |=(lowBlock &(0x1 << 20)) << 8;                   // 3 (28)    
    result |=(highBlock &(0x1 << 12)) << 15;                 // 4 (27)
    result |=(lowBlock &(0x1 << 12)) << 14;                  // 5 (26)    
    result |=(highBlock &(0x1 << 4)) << 21;                  // 6 (25)
    result |=(lowBlock &(0x1 << 4)) << 20;                   // 7 (24)
    
    // Row 6
    
    result |=(highBlock &(0x1 << 29)) >> 6;              // 8 (23)
    result |=(lowBlock &(0x1 << 29)) >> 7;               // 9 (22)
    result |=(highBlock &(0x1 << 21)) >> 0;              // 10 (21)
    result |=(lowBlock &(0x1 << 21)) >> 1;               // 11 (20)    
    result |=(highBlock &(0x1 << 13)) << 6;              // 12 (19)
    result |=(lowBlock &(0x1 << 13)) << 5;               // 13 (18)
    result |=(highBlock &(0x1 << 5)) << 12;              // 14 (17)
    result |=(lowBlock &(0x1 << 5)) << 11;               // 15 (16)
    
    // Row 7
    
    result |= (highBlock &(0x1 << 30)) >> 15;           // 16 (15)
    result |= (lowBlock &(0x1 << 30)) >> 16;            // 17 (14)
    result |= (highBlock &(0x1 << 22)) >> 9;            // 18 (13)
    result |= (lowBlock &(0x1 << 22)) >> 10;            // 19 (12)
    result |= (highBlock &(0x1 << 14)) >> 3;            // 20 (11)
    result |= (lowBlock &(0x1 << 14)) >> 4;             // 21 (10)
    result |= (highBlock &(0x1 << 6)) << 3;             // 22 (9)
    result |= (lowBlock &(0x1 << 6)) << 2;              // 23 (8)
  
    // Row 8
    
    result |= (highBlock &(0x1 << 31)) >> 24;           // 24 (7)
    result |= (lowBlock &(0x1 << 31)) >> 25;            // 25 (6)    
    result |= (highBlock &(0x1 << 23)) >> 18;           // 26 (5)
    result |= (lowBlock &(0x1 << 23)) >> 19;            // 27 (4)    
    result |= (highBlock &(0x1 << 15)) >> 12;           // 28 (3)
    result |= (lowBlock &(0x1 << 15)) >> 13;            // 29 (2)
    result |= (highBlock &(0x1 << 7)) >> 6;             // 30 (1)
    result |= (lowBlock &(0x1 << 7)) >> 7;              // 31 (0)
    
    pDst[1] = result;
}


#pragma mark - key schedule
// Left for low, Right for high

// PC-1
// Input: 64-bit key
// Output: 56-bit key (28 bits for left and 28 bits for right)
static void PermutedChoice1(unsigned pDst[2], const unsigned pSrc[2])
{
    unsigned result;
    
    unsigned lowHalf = pSrc[0];
    unsigned highHalf = pSrc[1];
    
    // Left:
    result = (highHalf & (0x1 << 7)) << 24;     // 0 (31)
    result |= (highHalf & (0x1 << 15)) << 15;   // 1 (30)
    result |= (highHalf & (0x1 << 23)) << 6;    // 2 (29)
    result |= (highHalf & (0x1 << 31)) >> 3;    // 3 (28)
    result |= (lowHalf & (0x1 << 7)) << 20;     // 4 (27)
    result |= (lowHalf & (0x1 << 15)) << 11;    // 5 (26)
    result |= (lowHalf & (0x1 << 23)) << 2;     // 6 (25)
    result |= (lowHalf & (0x1 << 31)) >> 7;     // 7 (24)
    
    result |= (highHalf & (0x1 << 6)) << 17;    // 8 (23)
    result |= (highHalf & (0x1 << 14)) << 8;    // 9 (22)
    result |= (highHalf & (0x1 << 22)) >> 1;    // 10 (21)
    result |= (highHalf & (0x1 << 30)) >> 10;   // 11 (20)
    result |= (lowHalf & (0x1 << 6)) << 13;     // 12 (19)
    result |= (lowHalf & (0x1 << 14)) << 4;     // 13 (18)
    result |= (lowHalf & (0x1 << 22)) >> 5;     // 14 (17)
    result |= (lowHalf & (0x1 << 30)) >> 14;    // 15 (16)
    
    result |= (highHalf & (0x1 << 5)) << 10;    // 16 (15)
    result |= (highHalf & (0x1 << 13)) << 1;    // 17 (14)
    result |= (highHalf & (0x1 << 21)) >> 8;    // 18 (13)
    result |= (highHalf & (0x1 << 29)) >> 17;   // 19 (12)
    result |= (lowHalf & (0x1 << 5)) << 6;      // 20 (11)
    result |= (lowHalf & (0x1 << 13)) >> 3;     // 21 (10)
    result |= (lowHalf & (0x1 << 21)) >> 12;    // 22 (9)
    result |= (lowHalf & (0x1 << 29)) >> 21;    // 23 (8)
    
    result |= (highHalf & (0x1 << 4)) << 3;     // 24 (7)
    result |= (highHalf & (0x1 << 12)) >> 6;    // 25 (6)
    result |= (highHalf & (0x1 << 20)) >> 15;   // 26 (5)
    result |= (highHalf & (0x1 << 28)) >> 24;   // 27 (4)
    
    pDst[0] = result;
    
    // Right:
    result = (highHalf & (0x1 << 1)) << 30;     // 0 (31)
    result |= (highHalf & (0x1 << 9)) << 21;    // 1 (30)
    result |= (highHalf & (0x1 << 17)) << 12;   // 2 (29)
    result |= (highHalf & (0x1 << 25)) << 3;    // 3 (28)
    result |= (lowHalf & (0x1 << 1)) << 26;     // 4 (27)
    result |= (lowHalf & (0x1 << 9)) << 17;     // 5 (26)
    result |= (lowHalf & (0x1 << 17)) << 8;     // 6 (25)
    result |= (lowHalf & (0x1 << 25)) >> 1;     // 7 (24)
    
    result |= (highHalf & (0x1 << 2)) << 21;    // 8 (23)
    result |= (highHalf & (0x1 << 10)) << 12;   // 9 (22)
    result |= (highHalf & (0x1 << 18)) << 3;    // 10 (21)
    result |= (highHalf & (0x1 << 26)) >> 6;    // 11 (20)
    result |= (lowHalf & (0x1 << 2)) << 17;     // 12 (19)
    result |= (lowHalf & (0x1 << 10)) << 8;     // 13 (18)
    result |= (lowHalf & (0x1 << 18)) >> 1;     // 14 (17)
    result |= (lowHalf & (0x1 << 26)) >> 10;    // 15 (16)
    
    result |= (highHalf & (0x1 << 3)) << 12;    // 16 (15)
    result |= (highHalf & (0x1 << 11)) << 3;    // 17 (14)
    result |= (highHalf & (0x1 << 19)) >> 6;    // 18 (13)
    result |= (highHalf & (0x1 << 27)) >> 15;   // 19 (12)
    result |= (lowHalf & (0x1 << 3)) << 8;      // 20 (11)
    result |= (lowHalf & (0x1 << 11)) >> 1;     // 21 (10)
    result |= (lowHalf & (0x1 << 19)) >> 10;    // 22 (9)
    result |= (lowHalf & (0x1 << 27)) >> 19;    // 23 (8)
    
    result |= (lowHalf & (0x1 << 4)) << 3;      // 24 (7)
    result |= (lowHalf & (0x1 << 12)) >> 6;     // 25 (6)
    result |= (lowHalf & (0x1 << 20)) >> 15;    // 26 (5)
    result |= (lowHalf & (0x1 << 28)) >> 24;    // 27 (4)
    
    pDst[1] = result;
}

// PC-2
// Input: 56-bit key (28 bits for left and 28 bits for right)
// Output: 48-bit subkey
static void PermutedChoice2(unsigned pDst[2], const unsigned pSrc[2])
{
    unsigned result;
    unsigned lowHalf = pSrc[0];
    unsigned highHalf = pSrc[1];
    
    // Left 24 bits
    result = (lowHalf & (0x1 << 18)) << 13;     // 0 (31)
    result |= (lowHalf & (0x1 << 15)) << 15;    // 1 (30)
    result |= (lowHalf & (0x1 << 21)) << 8;     // 2 (29)
    result |= (lowHalf & (0x1 << 8)) << 20;     // 3 (28)
    result |= (lowHalf & (0x1 << 31)) >> 4;     // 4 (27)
    result |= (lowHalf & (0x1 << 27)) >> 1;     // 5 (26)
    result |= (lowHalf & (0x1 << 29)) >> 4;     // 6 (25)
    result |= (lowHalf & (0x1 << 4)) << 20;     // 7 (24)
    
    result |= (lowHalf & (0x1 << 17)) << 6;     // 8 (23)
    result |= (lowHalf & (0x1 << 26)) >> 4;     // 9 (22)
    result |= (lowHalf & (0x1 << 11)) << 10;    // 10 (21)
    result |= (lowHalf & (0x1 << 22)) >> 2;     // 11 (20)
    result |= (lowHalf & (0x1 << 9)) << 10;     // 12 (19)
    result |= (lowHalf & (0x1 << 13)) << 5;     // 13 (18)
    result |= (lowHalf & (0x1 << 20)) >> 3;     // 14 (17)
    result |= (lowHalf & (0x1 << 28)) >> 12;    // 15 (16)
    
    result |= (lowHalf & (0x1 << 6)) << 9;      // 16 (15)
    result |= (lowHalf & (0x1 << 24)) >> 10;    // 17 (14)
    result |= (lowHalf & (0x1 << 16)) >> 3;     // 18 (13)
    result |= (lowHalf & (0x1 << 25)) >> 13;    // 19 (12)
    result |= (lowHalf & (0x1 << 5)) << 6;      // 20 (11)
    result |= (lowHalf & (0x1 << 12)) >> 2;     // 21 (10)
    result |= (lowHalf & (0x1 << 19)) >> 10;    // 22 (9)
    result |= (lowHalf & (0x1 << 30)) >> 22;    // 23 (8)
    
    pDst[0] = result;
    
    // Right 24 bits
    result = (highHalf & (0x1 << 19)) << 12;    // 0 (31)
    result |= (highHalf & (0x1 << 8)) << 22;    // 1 (30)
    result |= highHalf & (0x1 << 29);           // 2 (29)
    result |= (highHalf & (0x1 << 23)) << 5;    // 3 (28)
    result |= (highHalf & (0x1 << 13)) << 14;   // 4 (27)
    result |= (highHalf & (0x1 << 5)) << 21;    // 5 (26)
    result |= (highHalf & (0x1 << 30)) >> 5;    // 6 (25)
    result |= (highHalf & (0x1 << 20)) << 4;    // 7 (24)
    
    result |= (highHalf & (0x1 << 9)) << 14;    // 8 (23)
    result |= (highHalf & (0x1 << 15)) << 7;    // 9 (22)
    result |= (highHalf & (0x1 << 27)) >> 6;    // 10 (21)
    result |= (highHalf & (0x1 << 12)) << 8;    // 11 (20)
    result |= (highHalf & (0x1 << 16)) << 3;    // 12 (19)
    result |= (highHalf & (0x1 << 11)) << 7;    // 13 (18)
    result |= (highHalf & (0x1 << 21)) >> 4;    // 14 (17)
    result |= (highHalf & (0x1 << 4)) << 12;    // 15 (16)
    
    result |= (highHalf & (0x1 << 26)) >> 11;   // 16 (15)
    result |= (highHalf & (0x1 << 7)) << 7;     // 17 (14)
    result |= (highHalf & (0x1 << 14)) >> 1;    // 18 (13)
    result |= (highHalf & (0x1 << 18)) >> 6;    // 19 (12)
    result |= (highHalf & (0x1 << 10)) << 1;    // 20 (11)
    result |= (highHalf & (0x1 << 24)) >> 14;   // 21 (10)
    result |= (highHalf & (0x1 << 31)) >> 22;   // 22 (9)
    result |= (highHalf & (0x1 << 28)) >> 20;   // 23 (8)
    
    pDst[1] = result;
}

static unsigned RotateLeft(unsigned org, int nBits)
{
    unsigned mask = (1U << nBits) - 1U;
    unsigned highBits = org & (mask << (32 - nBits));
    unsigned result = (org << nBits) | (highBits >> (28 - nBits));
    
    return result & 0xfffffff0;
}

// Input: 64-bit key
// Output: 16 48-bit subkeys
static void KeySchedule(unsigned pSubkeys[2 * 16], const unsigned orgKey[2])
{
    unsigned keys[2];
    unsigned subkey[2];
    
    PermutedChoice1(keys, orgKey);
    
    // Subkey 1
    keys[0] = RotateLeft(keys[0], 1);
    keys[1] = RotateLeft(keys[1], 1);
    PermutedChoice2(subkey, keys);
    pSubkeys[0] = subkey[0];
    pSubkeys[1] = subkey[1];
    
    // Subkey 2
    keys[0] = RotateLeft(keys[0], 1);
    keys[1] = RotateLeft(keys[1], 1);
    PermutedChoice2(subkey, keys);
    pSubkeys[2] = subkey[0];
    pSubkeys[3] = subkey[1];
    
    // Subkey 3
    keys[0] = RotateLeft(keys[0], 2);
    keys[1] = RotateLeft(keys[1], 2);
    PermutedChoice2(subkey, keys);
    pSubkeys[4] = subkey[0];
    pSubkeys[5] = subkey[1];
    
    // Subkey 4
    keys[0] = RotateLeft(keys[0], 2);
    keys[1] = RotateLeft(keys[1], 2);
    PermutedChoice2(subkey, keys);
    pSubkeys[6] = subkey[0];
    pSubkeys[7] = subkey[1];
    
    // Subkey 5
    keys[0] = RotateLeft(keys[0], 2);
    keys[1] = RotateLeft(keys[1], 2);
    PermutedChoice2(subkey, keys);
    pSubkeys[8] = subkey[0];
    pSubkeys[9] = subkey[1];
    
    // Subkey 6
    keys[0] = RotateLeft(keys[0], 2);
    keys[1] = RotateLeft(keys[1], 2);
    PermutedChoice2(subkey, keys);
    pSubkeys[10] = subkey[0];
    pSubkeys[11] = subkey[1];
    
    // Subkey 7
    keys[0] = RotateLeft(keys[0], 2);
    keys[1] = RotateLeft(keys[1], 2);
    PermutedChoice2(subkey, keys);
    pSubkeys[12] = subkey[0];
    pSubkeys[13] = subkey[1];
    
    // Subkey 8
    keys[0] = RotateLeft(keys[0], 2);
    keys[1] = RotateLeft(keys[1], 2);
    PermutedChoice2(subkey, keys);
    pSubkeys[14] = subkey[0];
    pSubkeys[15] = subkey[1];
    
    // Subkey 9
    keys[0] = RotateLeft(keys[0], 1);
    keys[1] = RotateLeft(keys[1], 1);
    PermutedChoice2(subkey, keys);
    pSubkeys[16] = subkey[0];
    pSubkeys[17] = subkey[1];
    
    // Subkey 10
    keys[0] = RotateLeft(keys[0], 2);
    keys[1] = RotateLeft(keys[1], 2);
    PermutedChoice2(subkey, keys);
    pSubkeys[18] = subkey[0];
    pSubkeys[19] = subkey[1];
    
    // Subkey 11
    keys[0] = RotateLeft(keys[0], 2);
    keys[1] = RotateLeft(keys[1], 2);
    PermutedChoice2(subkey, keys);
    pSubkeys[20] = subkey[0];
    pSubkeys[21] = subkey[1];
    
    // Subkey 12
    keys[0] = RotateLeft(keys[0], 2);
    keys[1] = RotateLeft(keys[1], 2);
    PermutedChoice2(subkey, keys);
    pSubkeys[22] = subkey[0];
    pSubkeys[23] = subkey[1];
    
    // Subkey 13
    keys[0] = RotateLeft(keys[0], 2);
    keys[1] = RotateLeft(keys[1], 2);
    PermutedChoice2(subkey, keys);
    pSubkeys[24] = subkey[0];
    pSubkeys[25] = subkey[1];
    
    // Subkey 14
    keys[0] = RotateLeft(keys[0], 2);
    keys[1] = RotateLeft(keys[1], 2);
    PermutedChoice2(subkey, keys);
    pSubkeys[26] = subkey[0];
    pSubkeys[27] = subkey[1];
    
    // Subkey 15
    keys[0] = RotateLeft(keys[0], 2);
    keys[1] = RotateLeft(keys[1], 2);
    PermutedChoice2(subkey, keys);
    pSubkeys[28] = subkey[0];
    pSubkeys[29] = subkey[1];
    
    // Subkey 16
    keys[0] = RotateLeft(keys[0], 1);
    keys[1] = RotateLeft(keys[1], 1);
    PermutedChoice2(subkey, keys);
    pSubkeys[30] = subkey[0];
    pSubkeys[31] = subkey[1];
}


#pragma mark - The Feistel (F) function

static void expandBlock(unsigned pExpansion[2], unsigned halfBlock)
{
    // Phase 1
    unsigned res;

    //row1
    res = (halfBlock & (0x1 << 0)) << 31;               // 0 (31)
    res |= (halfBlock & (0x1 << 31)) >> 1;              // 1 (30)
    res |= (halfBlock & (0x1 << 30)) >> 1;              // 2 (29)
    res |= (halfBlock & (0x1 << 29)) >> 1;              // 3 (28)
    res |= (halfBlock & (0x1 << 28)) >> 1;              // 4 (27)
    res |= (halfBlock & (0x1 << 27)) >> 1;              // 5 (26)
    

    //row2
    res |= (halfBlock & (0x1 << 28)) >> 3;              // 6 (25)
    res |= (halfBlock & (0x1 << 27)) >> 3;              // 7 (24)    
    res |= (halfBlock & (0x1 << 26)) >> 3;              // 8 (23)
    res |= (halfBlock & (0x1 << 25)) >> 3;              // 9 (22)
    res |= (halfBlock & (0x1 << 24)) >> 3;              // 10 (21)
    res |= (halfBlock & (0x1 << 23)) >> 3;              // 11 (20)
    

    //row3
    res |= (halfBlock & (0x1 << 24)) >> 5;              // 12 (19)
    res |= (halfBlock & (0x1 << 23)) >> 5;              // 13 (18)
    res |= (halfBlock & (0x1 << 22)) >> 5;              // 14 (17)
    res |= (halfBlock & (0x1 << 21)) >> 5;              // 15 (16)
    res |= (halfBlock & (0x1 << 20)) >> 5;              // 16 (15)
    res |= (halfBlock & (0x1 << 19)) >> 5;              // 17 (14)
    

    //row4
    res |= (halfBlock & (0x1 << 20)) >> 7;              // 18 (13)
    res |= (halfBlock & (0x1 << 19)) >> 7;              // 19 (12)
    res |= (halfBlock & (0x1 << 18)) >> 7;              // 20 (11) 
    res |= (halfBlock & (0x1 << 17)) >> 7;              // 21 (10)    
    res |= (halfBlock & (0x1 << 16)) >> 7;              // 22 (9)  
    res |= (halfBlock & (0x1 << 15)) >> 7;              // 23 (8)  

    
    pExpansion[0] = res;
    
    // Phase 2
    //row5
    res = (halfBlock & (0x1 << 16)) << 15;               // 0 (31)
    res |= (halfBlock & (0x1 << 15)) << 15;              // 1 (30)
    res |= (halfBlock & (0x1 << 14)) << 15;              // 2 (29)
    res |= (halfBlock & (0x1 << 13)) << 15;              // 3 (28)
    res |= (halfBlock & (0x1 << 12)) << 15;              // 4 (27)
    res |= (halfBlock & (0x1 << 11)) << 15;              // 5 (26)
    //row6
    res |= (halfBlock & (0x1 << 12)) << 13;              // 6 (25)
    res |= (halfBlock & (0x1 << 11)) << 13;              // 7 (24)
    res |= (halfBlock & (0x1 << 10)) << 13;              // 8 (23)
    res |= (halfBlock & (0x1 << 9)) << 13;               // 9 (22)
    res |= (halfBlock & (0x1 << 8)) << 13;               // 10 (21)
    res |= (halfBlock & (0x1 << 7)) << 13;               // 11 (20)
    //row7
    res |= (halfBlock & (0x1 << 8)) << 11;               // 12 (19)
    res |= (halfBlock & (0x1 << 7)) << 11;               // 13 (18)
    res |= (halfBlock & (0x1 << 6)) << 11;               // 14 (17)
    res |= (halfBlock & (0x1 << 5)) << 11;               // 15 (16)
    res |= (halfBlock & (0x1 << 4)) << 11;               // 16 (15)
    res |= (halfBlock & (0x1 << 3)) << 11;               // 17 (14)
    //row8
    res |= (halfBlock & (0x1 << 4)) << 9;                // 18 (13)
    res |= (halfBlock & (0x1 << 3)) << 9;                // 19 (12)
    res |= (halfBlock & (0x1 << 2)) << 9;                // 20 (11)
    res |= (halfBlock & (0x1 << 1)) << 9;                // 21 (10)
    res |= (halfBlock & (0x1 << 0)) << 9;                // 22 (9)
    res |= (halfBlock & (0x1 << 31)) >>23;               // 23 (8)
    pExpansion[1] = res;
}

// Substitution Boxes

static unsigned char S_box1[4][16] = {
    {14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7},
    {0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8},
    {4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0},
    {15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13}
};

static unsigned char S_box2[4][16] = {
    {15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10},
    {3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5},
    {0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15},
    {13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9}
};

static unsigned char S_box3[4][16] = {
    {10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8},
    {13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1},
    {13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7},
    {1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12}
};

static unsigned char S_box4[4][16] = {
    {7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15},
    {13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9},
    {10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4},
    {3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14}
};

static unsigned char S_box5[4][16] = {
    {2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9},
    {14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6},
    {4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14},
    {11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3}
};

static unsigned char S_box6[4][16] = {
    {12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11},
    {10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8},
    {9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6},
    {4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13}
};

static unsigned char S_box7[4][16] = {
    {4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1},
    {13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6},
    {1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2},
    {6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12}
};

static unsigned char S_box8[4][16] = {
    {13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7},
    {1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2},
    {7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8},
    {2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11}
};

static unsigned Substitution(unsigned pBlock[2])
{
    unsigned result, rowIndex, colIndex, tmp;
    
    unsigned lowPart = pBlock[0];
    unsigned highPart = pBlock[1];
    unsigned maskRow = 0x21;
    unsigned maskCol = 0xf;
    
    // S1
    rowIndex = (lowPart >> 26) & maskRow;
    rowIndex = (rowIndex >> 4) | (rowIndex & 1);
    colIndex = maskCol & (lowPart >> 27);
    tmp = S_box1[rowIndex][colIndex];
    result = tmp << 28;
    
    // S2
    rowIndex = (lowPart >> 20) & maskRow;
    rowIndex = (rowIndex >> 4) | (rowIndex & 1);
    colIndex = (lowPart >> 21) & maskCol;
    tmp = S_box2[rowIndex][colIndex];
    result |= tmp << 24;
    
    // S3 
    rowIndex = (lowPart >> 14) & maskRow;
    rowIndex = (rowIndex >> 4) | (rowIndex & 1);
    colIndex = (lowPart >> 15) & maskCol;
    tmp = S_box3[rowIndex][colIndex];
    result |= tmp << 20;
    
    // S4
    rowIndex = (lowPart >> 8) & maskRow;
    rowIndex = (rowIndex >> 4) | (rowIndex & 1);
    colIndex = (lowPart >> 9) & maskCol;
    tmp = S_box4[rowIndex][colIndex];
    result |= tmp << 16;
    
    // S5
    rowIndex = (highPart >> 26) & maskRow;
    rowIndex = (rowIndex >> 4) | (rowIndex & 1);
    colIndex = (highPart >> 27) & maskCol;
    tmp = S_box5[rowIndex][colIndex];
    result |= tmp << 28;
    
    // S6
    rowIndex = (highPart >> 20) & maskRow;
    rowIndex = (rowIndex >> 4) | (rowIndex & 1);
    colIndex = (highPart >> 21) & maskCol;
    tmp = S_box6[rowIndex][colIndex];
    result |= tmp << 24;
    
    // S7
    rowIndex = (highPart >> 14) & maskRow;
    rowIndex = (rowIndex >> 4) | (rowIndex & 1);
    colIndex = (highPart >> 15) & maskCol;
    tmp = S_box7[rowIndex][colIndex];
    result |= tmp << 20;
    
    // S8
    rowIndex = (highPart >> 8) & maskRow;
    rowIndex = (rowIndex >> 4) | (rowIndex & 1);
    colIndex = (highPart >> 9) & maskCol;
    tmp = S_box8[rowIndex][colIndex];
    result |= tmp << 16;
    
    return result;
}

static unsigned Permutation(unsigned block)
{    
    unsigned result = (block & (0x1 << 16)) << 15;      // 0(31)
    result |= (block & (0x1 << 25)) << 5;               // 1(30)
    result |= (block & (0x1 << 12)) << 17;              // 2(29)
    result |= (block & (0x1 << 11)) << 17;              // 3(28)
    result |= (block & (0x1 << 3)) << 24;               // 4(27)
    result |= (block & (0x1 << 20)) << 6;               // 5(26)
    result |= (block & (0x1 << 4)) << 21;               // 6(25)
    result |= (block & (0x1 << 15)) << 9;               // 7(24)
    
    result |= (block & (0x1<< 31)) >>8;                 // 8(23)
    result |= (block & (0x1 << 17)) << 5;               // 9(22)
    result |= (block & (0x1 << 9)) << 12;               // 10(21)
    result |= (block & (0x1 << 6)) << 14;               // 11(20)
    result |= (block & (0x1 << 27)) >> 8;               // 12(19)
    result |= (block & (0x1 << 14)) << 4;               // 13(18)
    result |= (block & (0x1 << 1)) << 16;               // 14(17)
    result |= (block & (0x1 << 22)) >> 6;               // 15(16)
    
    result |= (block & (0x1 << 30)) >> 15;              // 16(15)
    result |= (block & (0x1 << 24)) >> 10;              // 17(14)
    result |= (block & (0x1 << 8)) << 5;                // 18(13)
    result |= (block & (0x1 << 18)) >> 6;               // 19(12)
    result |= (block & (0x1 << 0)) << 11;               // 20(11)
    result |= (block & (0x1 << 5)) << 5;                // 21(10)
    result |= (block & (0x1 << 29)) >> 20;              // 22(9)
    result |= (block & (0x1 << 23)) >> 15;              // 23(8)
    
    result |= (block & (0x1 << 13)) >> 6;               // 24(7)
    result |= (block & (0x1 << 19)) >> 13;              // 25(6)
    result |= (block & (0x1 << 2)) << 3;                // 26(5)
    result |= (block & (0x1 << 26)) >> 22;              // 27(4)
    result |= (block & (0x1 << 10)) >> 7;               // 28(3)
    result |= (block & (0x1 << 21)) >> 19;              // 29(2)
    result |= (block & (0x1 << 28)) >> 27;              // 30(1)
    result |= (block & (0x1 << 7)) >> 7;                // 31(0)   
    
    return result;
}

static unsigned FeistelFunction(unsigned halfBlock, const unsigned pSubkey[2])
{
    unsigned result;
    unsigned eBlock[2];
    
    expandBlock(eBlock, halfBlock);
    
    eBlock[0] ^= pSubkey[0];
    eBlock[1] ^= pSubkey[1];
    
    result = Substitution(eBlock);
    
    return Permutation(result);
}

#pragma mark - External interface

void __attribute__((weak, visibility("internal"))) MoccaDESEncrypt(unsigned pDst[2], const unsigned pPlainText[2], const unsigned pKey[2])
{
    unsigned halfBlocks[2];
    unsigned subkeys[2 * 16];
    unsigned leftHalf, rightHalf;
    unsigned tmp;
    
    KeySchedule(subkeys, pKey);
    
    InitialPermutation(halfBlocks, pPlainText);
    
    leftHalf = halfBlocks[0];
    rightHalf = halfBlocks[1];
    
    // Round 1
    tmp = FeistelFunction(rightHalf, &subkeys[0 * 2]);
    leftHalf ^= tmp;
    
    // Round 2
    tmp = FeistelFunction(leftHalf, &subkeys[1 * 2]);
    rightHalf ^= tmp;
    
    // Round 3
    tmp = FeistelFunction(rightHalf, &subkeys[2 * 2]);
    leftHalf ^= tmp;
    
    // Round 4
    tmp = FeistelFunction(leftHalf, &subkeys[3 * 2]);
    rightHalf ^= tmp;
    
    // Round 5
    tmp = FeistelFunction(rightHalf, &subkeys[4 * 2]);
    leftHalf ^= tmp;
    
    // Round 6
    tmp = FeistelFunction(leftHalf, &subkeys[5 * 2]);
    rightHalf ^= tmp;
    
    // Round 7
    tmp = FeistelFunction(rightHalf, &subkeys[6 * 2]);
    leftHalf ^= tmp;
    
    // Round 8
    tmp = FeistelFunction(leftHalf, &subkeys[7 * 2]);
    rightHalf ^= tmp;
    
    // Round 9
    tmp = FeistelFunction(rightHalf, &subkeys[8 * 2]);
    leftHalf ^= tmp;
    
    // Round 10
    tmp = FeistelFunction(leftHalf, &subkeys[9 * 2]);
    rightHalf ^= tmp;
    
    // Round 11
    tmp = FeistelFunction(rightHalf, &subkeys[10 * 2]);
    leftHalf ^= tmp;
    
    // Round 12
    tmp = FeistelFunction(leftHalf, &subkeys[11 * 2]);
    rightHalf ^= tmp;
    
    // Round 13
    tmp = FeistelFunction(rightHalf, &subkeys[12 * 2]);
    leftHalf ^= tmp;
    
    // Round 14
    tmp = FeistelFunction(leftHalf, &subkeys[13 * 2]);
    rightHalf ^= tmp;
    
    // Round 15
    tmp = FeistelFunction(rightHalf, &subkeys[14 * 2]);
    leftHalf ^= tmp;
    
    // Round 16
    tmp = FeistelFunction(leftHalf, &subkeys[15 * 2]);
    rightHalf ^= tmp;
    
    halfBlocks[0] = rightHalf;
    halfBlocks[1] = leftHalf;
    
    FinalPermutation(pDst, halfBlocks);
}

void __attribute__((weak, visibility("internal"))) MoccaDESDecrypt(unsigned pDst[2], const unsigned pPlainText[2], const unsigned pKey[2])
{
    unsigned halfBlocks[2];
    unsigned subkeys[2 * 16];
    unsigned leftHalf, rightHalf;
    unsigned tmp;
    
    KeySchedule(subkeys, pKey);
    
    InitialPermutation(halfBlocks, pPlainText);
    
    leftHalf = halfBlocks[0];
    rightHalf = halfBlocks[1];
    
    // Round1
    tmp = FeistelFunction(rightHalf, &subkeys[15 * 2]);
    leftHalf ^= tmp;
    
    // Round2
    tmp = FeistelFunction(leftHalf, &subkeys[14 * 2]);
    rightHalf ^= tmp;
    
    // Round3
    tmp = FeistelFunction(rightHalf, &subkeys[13 * 2]);
    leftHalf ^= tmp;
    
    // Round 4
    tmp = FeistelFunction(leftHalf, &subkeys[12 * 2]);
    rightHalf ^= tmp;
    
    // Round 5
    tmp = FeistelFunction(rightHalf, &subkeys[11 * 2]);
    leftHalf ^= tmp;
    
    // Round 6
    tmp = FeistelFunction(leftHalf, &subkeys[10 * 2]);
    rightHalf ^= tmp;
    
    // Round 7
    tmp = FeistelFunction(rightHalf, &subkeys[9 * 2]);
    leftHalf ^= tmp;
    
    // Round 8
    tmp = FeistelFunction(leftHalf, &subkeys[8 * 2]);
    rightHalf ^= tmp;
    
    // Round 9
    tmp = FeistelFunction(rightHalf, &subkeys[7 * 2]);
    leftHalf ^= tmp;
    
    // Round 10
    tmp = FeistelFunction(leftHalf, &subkeys[6 * 2]);
    rightHalf ^= tmp;
    
    // Round 11
    tmp = FeistelFunction(rightHalf, &subkeys[5 * 2]);
    leftHalf ^= tmp;
    
    // Round 12
    tmp = FeistelFunction(leftHalf, &subkeys[4 * 2]);
    rightHalf ^= tmp;
    
    // Round 13
    tmp = FeistelFunction(rightHalf, &subkeys[3 * 2]);
    leftHalf ^= tmp;
    
    // Round 14
    tmp = FeistelFunction(leftHalf, &subkeys[2 * 2]);
    rightHalf ^= tmp;
    
    // Round 15
    tmp = FeistelFunction(rightHalf, &subkeys[1 * 2]);
    leftHalf ^= tmp;
    
    // Round 16
    tmp = FeistelFunction(leftHalf, &subkeys[0 * 2]);
    rightHalf ^= tmp;
    
    halfBlocks[0] = rightHalf;
    halfBlocks[1] = leftHalf;
    
    FinalPermutation(pDst, halfBlocks);
}

