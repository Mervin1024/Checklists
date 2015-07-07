//
//  NSDictionary+Assemble.h
//  Checklists
//
//  Created by 马遥 on 15/7/6.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Assemble)

- (NSString *) stringByJoinSimplyWithSpaceCharacter:(NSString *)spaceCharacter andBoundary:(NSString *)boundary;
- (NSString *) stringByJoinEntireWithSpaceCharacter:(NSString *)spaceCharacter andBoundary:(NSString *)boundary;

@end
