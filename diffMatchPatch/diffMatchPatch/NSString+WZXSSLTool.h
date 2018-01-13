//
//  NSString+WZXSSLTool.h
//  WZXSSLTool
//
//  Created by wordoor－z on 16/3/28.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WZXSSLTool)

/** 
 * 32位MD5加密
 * 32 bit MD5 encryption
 */
- (NSString *)do32MD5;

/**
 * 16位MD5加密
 * 16 bit MD5 encryption
 */
- (NSString *)do16MD5;

/**
 * Sha1加密
 * Sha1 encryption
 */
- (NSString *)doSha1;

/**
 * base64加密
 * base64 encryption
 */
- (NSString *)doBase64;

/**
 * base64解密
 * Base64 decryption
 */
- (NSString *)decodeBase64;
- (NSString *)md5_32bit;
- (NSString *)MD5_32BIT;
/**
 * #pragma mark 大文件的md5
 *
 */

-(NSString*)getFileMD5WithPath:(NSString*)path;

@end
