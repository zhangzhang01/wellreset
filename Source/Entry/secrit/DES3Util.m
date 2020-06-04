//
//  DES3Util.m
//  DES
//
//  Created by Toni on 12-12-27.
//  Copyright (c) 2012年 sinofreely. All rights reserved.
//

#import "DES3Util.h"
#define gkey            @"app_key_ioved1cm!@#$5678"
//#define gkey            @"liuyunqiang@lx100$#365#$"
#define gIv             @"01234567"


@implementation DES3Util


 const Byte iv[] = {1,2,3,4,5,6,7,8};

//Des加密
 +(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
 {
    
     NSString *ciphertext = nil;
//     NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//     NSUInteger dataLength = [textData length];
//     unsigned char buffer[1024];
//     memset(buffer, 0, sizeof(char));
//     size_t numBytesEncrypted = 0;
//     CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
//                                                kCCOptionPKCS7Padding,
//                                              [key UTF8String], kCCKeySizeDES,
//                                                            iv,
//                                                [textData bytes], dataLength,
//                                                        buffer, 1024,
//                                                    &numBytesEncrypted);
//         if (cryptStatus == kCCSuccess) {
//                 NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//             ciphertext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//             }
//         return ciphertext;
     
     
     char keyPtr[kCCKeySizeAES256+1];
     bzero(keyPtr, sizeof(keyPtr));
     plainText = [GTMBase64 encodeBase64String:plainText];
     NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
     [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
     
     NSUInteger dataLength = [data length];
     
     size_t bufferSize = dataLength + kCCBlockSizeAES128;
     void *buffer = malloc(bufferSize);
     
     size_t numBytesEncrypted = 0;
     NSString *byteStr = @"12345678";
     const void *iiv = (const void *)[byteStr UTF8String];
     CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                           kCCOptionPKCS7Padding,
                                           [key UTF8String], kCCBlockSizeDES,
                                           iiv,
                                           [data bytes], dataLength,
                                           buffer, bufferSize,
                                           &numBytesEncrypted);
     NSString* md5 = nil;
     if (cryptStatus == kCCSuccess) {
     data =  [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
         ciphertext = [GTMBase64 stringWithHexBytes2:data];
         md5 = [ciphertext md5String];
     }
     
     
     return ciphertext;
     
     }



//Des解密
 +(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key
 {
//         NSString *plaintext = nil;
//         NSData *cipherdata = [GTMBase64 convertHexStrToData:cipherText];
//         unsigned char buffer[1024];
//         memset(buffer, 0, sizeof(char));
//         size_t numBytesDecrypted = 0;
//         CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
//                                                           kCCOptionPKCS7Padding,
//                                                           [key UTF8String], kCCKeySizeDES,
//                                                           iv,
//                                                           [cipherdata bytes], [cipherdata length],
//                                                           buffer, 1024,
//                                                           &numBytesDecrypted);
//         if(cryptStatus == kCCSuccess)
//         {
//                NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
//                 plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
//         }
//     return plaintext;
//     }

NSData* cipherData = [GTMBase64 convertHexStrToData:cipherText ];
unsigned char buffer[1024];
memset(buffer, 0, sizeof(char));
size_t numBytesDecrypted = 0;

NSString *byteStr = @"12345678";
const void *iiv = (const void *)[byteStr UTF8String];

CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                      kCCAlgorithmDES,
                                      kCCOptionPKCS7Padding,
                                      [key UTF8String],
                                      kCCKeySizeDES,
                                      iiv,
                                      [cipherData bytes],
                                      [cipherData length],
                                      buffer,
                                      1024,
                                      &numBytesDecrypted);
NSString* plainText = nil;
if (cryptStatus == kCCSuccess) {
    NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
    plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
return plainText;

 }


@end
