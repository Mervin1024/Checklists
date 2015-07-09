//
//  ViewController.h
//  Checklists
//
//  Created by 马遥 on 15/1/27.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"

@class ChecklistModel;

@interface ChecklistViewController : UITableViewController<ItemDetailViewControllerDelegate> 

@property (nonatomic,strong) ChecklistModel *checklist;
@end
