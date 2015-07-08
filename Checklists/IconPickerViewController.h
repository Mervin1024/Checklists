//
//  IconPickerViewController.h
//  Checklists
//
//  Created by 马遥 on 15/7/8.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IconPickerViewController;
@protocol  IconPickerViewControllerDelegate<NSObject>

- (void) iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName;

@end

@interface IconPickerViewController : UITableViewController

@property (nonatomic,weak) id<IconPickerViewControllerDelegate> delegate;

@end
