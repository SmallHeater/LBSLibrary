//
//  NSString+ChineseCharactersToSpelling.h
//  LBSDemo
//
//  Created by xianjunwang on 17/5/17.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//  汉字转拼音，NSString的分类

#import <Foundation/Foundation.h>

@interface NSString (ChineseCharactersToSpelling)
+(NSString *)lowercaseSpellingWithChineseCharacters:(NSString *)chinese;
@end
