//
//  ViewController.m
//  diffMatchPatch
//
//  Created by 余浩 on 2018/1/10.
//  Copyright © 2018年 余浩. All rights reserved.
//

#import "ViewController.h"
#import <DiffMatchPatch.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //将要比较的文件拷贝到沙盒中去
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *txtPath = [docPath stringByAppendingPathComponent:@"main.jsbundle"]; // 此时仅存在路径，文件并没有真实存在
    NSString *txtPath2 = [docPath stringByAppendingPathComponent:@"main-2.jsbundle"]; // 此时仅存在路径，文件并没有真实存在
   NSString *jsBundlePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"jsbundle"];
    NSString *jsversionBundlePath2 = [[NSBundle mainBundle] pathForResource:@"main-2" ofType:@"jsbundle"];
    [[NSFileManager defaultManager] copyItemAtPath:jsBundlePath toPath:txtPath error:nil];
      [[NSFileManager defaultManager] copyItemAtPath:jsversionBundlePath2 toPath:txtPath2 error:nil];
    //
    DiffMatchPatch *dmp = [DiffMatchPatch new];
    
    
    // 字符串写入沙盒
    // 在Documents下面创建一个文本路径，假设文本名称为objc.txt
    // 获取Documents目录
    
    // 数组写入文件
    // 创建一个存储数组的文件路径
    NSString *filePath = [docPath stringByAppendingPathComponent:@"patch.txt"];
    NSString *text1 = [NSString stringWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    NSString *text2 = [NSString stringWithContentsOfFile:txtPath2 encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *array =  [dmp diff_mainOfOldString:text1 andNewString:text2];
    //   [dmp patch_apply:<#(NSArray *)#> toString:<#(NSString *)#>]
    
    // 数组写入文件执行的方法
    
    NSLog(@"array%@", array);
    // NSArray *arrdiff = [array arr] [dmp patch_makeFromDiffs:array];
    NSString *patchtxt =  [dmp patch_toText:[dmp patch_makeFromDiffs:array]];
    
    //将差异写到文件
    [patchtxt writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //输出差异文件地址
    
    NSString *resultStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    // 读取差异文件
    NSMutableArray *patchDataArr =[dmp patch_fromText:resultStr error:nil];
    // 差异文件和原始文件合并生成新的文件
    NSArray *ResultData= [dmp patch_apply:patchDataArr toString:text1];
    NSString *txtPath3 = [docPath stringByAppendingPathComponent:@"main3.jsbundle"]; // 此时仅存在路径，文件并没有真实存在
    for (int i =0; i < ResultData.count; i ++) {
        if (i ==0) {
            [ResultData[i] writeToFile:txtPath3 atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        NSLog(@"%@/n", ResultData[i]);
    }
    // 数组写入文件执行的方法
    [array writeToFile:txtPath atomically:YES];
    NSLog(@"filePath is %@", txtPath);
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
