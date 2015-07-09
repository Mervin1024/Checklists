//
//  AddItemViewController.h
//  Checklists
//
//  Created by 马遥 on 15/2/4.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark - Delegate
@class ItemDetailViewController;
@class ChecklistItemModel;
@protocol ItemDetailViewControllerDelegate <NSObject>

-(void)itemDetailViewController:(ItemDetailViewController*)controller didFinishEditingItem:(ChecklistItemModel*)item;
-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController*)controller;
-(void)itemDetailViewController:(ItemDetailViewController*)controller didFinishAddingItem:(ChecklistItemModel*)item;
@end

#pragma mark - interface
@interface ItemDetailViewController : UITableViewController<UITextFieldDelegate>
@property(weak,nonatomic) id <ItemDetailViewControllerDelegate> delegate;
@property(strong,nonatomic) ChecklistItemModel *itemToEdit;
@property (weak, nonatomic) IBOutlet UISwitch *switchController;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;

- (IBAction)Cancel:(id)sender;
- (IBAction)Done:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;

@end
