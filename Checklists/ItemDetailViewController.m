//
//  AddItemViewController.m
//  Checklists
//
//  Created by 马遥 on 15/2/4.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ChecklistItemModel.h"

@implementation ItemDetailViewController{
    NSDictionary *items;
    NSDate *_dueDate;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setValues];
    
}

- (void) setValues{
    self.tableView.rowHeight = 44.0f;
    if (self.itemToEdit !=nil) {
        self.title = @"Edit Item";
        self.textField.text = self.itemToEdit.list_text;
        self.doneBarButton.enabled = YES;
        self.switchController.on = self.itemToEdit.shouldRemind;
        _dueDate = self.itemToEdit.dueDate;
    }else{
        self.switchController.on = NO;
        _dueDate = [NSDate date];
    }
    [self updateDueDateLabel];
}

- (void) updateDueDateLabel{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.dueDateLabel.text = [dateFormatter stringFromDate:_dueDate];
}

- (IBAction)Cancel:(id)sender {
    [self.delegate itemDetailViewControllerDidCancel:self];
}

- (IBAction)Done:(id)sender {
    if (self.itemToEdit == nil) {
        NSLog(@"add");
        ChecklistItemModel *item = [[ChecklistItemModel alloc]initWithTableName:nil ListID:nil Text:self.textField.text Checked:NO dueDate:_dueDate shouldRemind:self.switchController.on];
        [self.delegate itemDetailViewController:self didFinishAddingItem:item];
    }else{
        NSLog(@"edit");
        self.itemToEdit.list_text = self.textField.text;
        self.itemToEdit.shouldRemind = self.switchController.on;
        self.itemToEdit.dueDate = _dueDate;
        [self.delegate itemDetailViewController:self didFinishEditingItem:self.itemToEdit];
    }
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

// 跳转界面锁定textField为当前控制焦点
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

// Done 按钮启用
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"changeItem");
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.doneBarButton.enabled = ([newText length]>0);
    
    return YES;
    
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self Done:textField];
//    return YES;
//}

- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

    


@end
