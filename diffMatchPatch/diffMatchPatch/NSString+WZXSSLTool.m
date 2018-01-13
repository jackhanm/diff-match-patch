//
//  NSString+WZXSSLTool.m
//  WZXSSLTool
//
//  Created by wordoor－z on 16/3/28.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import "NSString+WZXSSLTool.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>  
#define FileHashDefaultChunkSizeForReadingData 1024*8
@implementation NSString (WZXSSLTool)

- (NSString *)do32MD5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}
- (NSString *)md5_32bit {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

- (NSString *)MD5_32BIT {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02X", digest[i]];
    return result;
}
- (NSString *)do16MD5
{
    NSString *md5_32Bit_String=[self do32MD5];
    return [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];
}

- (NSString *)doSha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes,(unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *)doBase64
{
    NSData * data = [self
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString * base64Encoded = [data base64EncodedStringWithOptions:0];
    
    return base64Encoded;
}

- (NSString *)decodeBase64
{
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:self options:0];
    
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    return base64Decoded;
}
#pragma mark 大文件的md5
-(NSString*)getFileMD5WithPath:(NSString*)path

{
  
  return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
  
}



CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
  
  // Declare needed variables
  
  CFStringRef result = NULL;
  
  CFReadStreamRef readStream = NULL;
  
  // Get the file URL
  
  CFURLRef fileURL =
  
  CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                
                                (CFStringRef)filePath,
                                
                                kCFURLPOSIXPathStyle,
                                
                                (Boolean)false);
  
  if (!fileURL) goto done;
  
  // Create and open the read stream
  
  readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                          
                                          (CFURLRef)fileURL);
  
  if (!readStream) goto done;
  
  bool didSucceed = (bool)CFReadStreamOpen(readStream);
  
  if (!didSucceed) goto done;
  
  // Initialize the hash object
  
  CC_MD5_CTX hashObject;
  
  CC_MD5_Init(&hashObject);
  // Make sure chunkSizeForReadingData is valid
  
  if (!chunkSizeForReadingData) {
    
    chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    
  }
  
  // Feed the data to the hash object
  
  bool hasMoreData = true;
  
  while (hasMoreData) {
    
    uint8_t buffer[chunkSizeForReadingData];
    
    CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
    
    if (readBytesCount == -1) break;
    
    if (readBytesCount == 0) {
      
      hasMoreData = false;
      
      continue;
      
    }
    
    CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    
  }
  
  // Check if the read operation succeeded
  
  didSucceed = !hasMoreData;
  
  // Compute the hash digest
  
  unsigned char digest[CC_MD5_DIGEST_LENGTH];
  
  CC_MD5_Final(digest, &hashObject);
  
  // Abort if the read operation failed
  
  if (!didSucceed) goto done;
  // Compute the string result
  
  char hash[2 * sizeof(digest) + 1];
  
  for (size_t i = 0; i < sizeof(digest); ++i) {
    
    snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    
  }
  
  result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
  
  
  
done:
  
  if (readStream) {
    
    CFReadStreamClose(readStream);
    
    CFRelease(readStream);
    
  }
  
  if (fileURL) {
    
    CFRelease(fileURL);
    
  }
  return result;
  
}
  


@end
