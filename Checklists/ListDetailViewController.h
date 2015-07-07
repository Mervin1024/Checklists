//
//  ListDetailViewController.h
//  Checklists
//
//  Created by 马遥 on 15/7/7.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChecklistModel;
@class ListDetailViewController;
@protocol ListDetailViewControllerDelegate <NSObject>

- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(ChecklistModel *)checklist;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(ChecklistModel *)checklist;

@end

@interface ListDetailViewController : UITableViewController

@property (nonatomic,weak)IBOutlet UITextField *textField;
@property (nonatomic,weak)IBOutlet UIBarButtonItem *doneBarButton;
@property (nonatomic,weak)id <ListDetailViewControllerDelegate> delegate;

@property (nonatomic) ChecklistModel *checklistToEdit;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end
