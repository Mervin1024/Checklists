//
//  AddItemViewController.m
//  Checklists
//
//  Created by 马遥 on 15/2/4.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "AddItemViewController.h"
#import "ChecklistItem.h"

@implementation AddItemViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (self.itemToEdit !=nil) {
        self.title = @"Edit Item";
        self.textField.text = self.itemToEdit.text;
        self.doneBarButton.enabled = YES;
    }
}



- (IBAction)Cancel:(id)sender {
    [self.delegate addItemViewControllerDidCancel:self];
}

- (IBAction)Done:(id)sender {
    if (self.itemToEdit == nil) {
        
        ChecklistItem *item = [[ChecklistItem alloc]init];
        item.text = self.textField.text;
        item.checked = NO;
        [self.delegate addItemViewController:self didFinishAddingItem:item];
    }else{
        self.itemToEdit.text = self.textField.text;
        [self.delegate addItemViewController:self didFinishAddingItem:self.itemToEdit];
    }
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([newText length]>0) {
        self.doneBarButton.enabled = YES;
    }else{
        self.doneBarButton.enabled = NO;
    }
    
    return YES;
    
}
- (void)addItemViewControllerDidCancel:(AddItemViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

    


@end
