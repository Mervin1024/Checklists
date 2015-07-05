//
//  ChecklistItem.m
//  Checklists
//
//  Created by 马遥 on 15/1/28.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "ChecklistItem.h"

@implementation ChecklistItem

- (void)toggleChecked{
    self.checked = !self.checked;
}

@end
