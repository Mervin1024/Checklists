//
//  ChecklistItem.h
//  Checklists
//
//  Created by 马遥 on 15/1/28.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChecklistItem : NSObject

@property(nonatomic,copy)NSString *text;
@property(nonatomic,assign)BOOL checked;
- (void)toggleChecked;

@end
