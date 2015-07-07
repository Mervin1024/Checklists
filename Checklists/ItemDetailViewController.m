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
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (self.itemToEdit !=nil) {
        self.title = @"Edit Item";
        self.textField.text = self.itemToEdit.list_text;
        self.doneBarButton.enabled = YES;
    }
}



- (IBAction)Cancel:(id)sender {
    [self.delegate itemDetailViewControllerDidCancel:self];
}

- (IBAction)Done:(id)sender {
    if (self.itemToEdit == nil) {
        NSLog(@"add");
        ChecklistItemModel *item = [[ChecklistItemModel alloc]initWithTableName:nil ListID:nil Text:self.textField.text andChecked:NO];
        [self.delegate itemDetailViewController:self didFinishAddingItem:item];
    }else{
        NSLog(@"edit");
        self.itemToEdit.list_text = self.textField.text;
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
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.doneBarButton.enabled = ([newText length]>0);
    
    return YES;
    
}
- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

    


@end
