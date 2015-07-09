//
//  ListDetailViewController.h
//  Checklists
//
//  Created by 马遥 on 15/7/7.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconPickerViewController.h"

#pragma mark - Delegate
@class ChecklistModel;
@class ListDetailViewController;
@protocol ListDetailViewControllerDelegate <NSObject>

- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(ChecklistModel *)checklist;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(ChecklistModel *)checklist;

@end

#pragma mark - interface
@interface ListDetailViewController : UITableViewController<UITextFieldDelegate,IconPickerViewControllerDelegate>

@property (nonatomic,weak)IBOutlet UITextField *textField;
@property (nonatomic,weak)IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic,weak)id <ListDetailViewControllerDelegate> delegate;

@property (nonatomic,strong) ChecklistModel *checklistToEdit;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end
