//
//  AddItemViewController.h
//  Checklists
//
//  Created by 马遥 on 15/2/4.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddItemViewController;
@class ChecklistItem;
@protocol AddItemViewControllerDelegate <NSObject>

-(void)addItemViewController:(AddItemViewController*)controller didFinishEditingItem:(ChecklistItem*)item;
-(void)addItemViewControllerDidCancel:(AddItemViewController*)controller;
-(void)addItemViewController:(AddItemViewController*)controller didFinishAddingItem:(ChecklistItem*)item;
@end
@interface AddItemViewController : UITableViewController<UITextViewDelegate>
@property(weak,nonatomic) id <AddItemViewControllerDelegate> delegate;
@property(strong,nonatomic) ChecklistItem *itemToEdit;

- (IBAction)Cancel:(id)sender;
- (IBAction)Done:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;

@end
