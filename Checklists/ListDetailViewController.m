//
//  ListDetailViewController.m
//  Checklists
//
//  Created by 马遥 on 15/7/7.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "ListDetailViewController.h"
#import "ChecklistModel.h"
#import "ChecklistsDate.h"

@interface ListDetailViewController (){
    NSString *_iconName;
}

@end

@implementation ListDetailViewController
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setValues];
}

- (void) setValues{
    self.tableView.rowHeight = 44.0f;
    self.iconImageView.image = [UIImage imageNamed:@"download"];
    if (self.checklistToEdit != nil) {
        self.title = @"Edit Checklist";
        self.textField.text = self.checklistToEdit.list_name;
        self.doneBarButton.enabled = YES;
        _iconName = self.checklistToEdit.listIconName;
    }else{
        _iconName = @"folder";
    }
    self.iconImageView.image = [UIImage imageWithCGImage:[[UIImage imageNamed:_iconName] CGImage] scale:([UIImage imageNamed:_iconName].scale * 2.2) orientation:([UIImage imageNamed:_iconName].imageOrientation)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - textField
// 跳转界面锁定textField为当前控制焦点
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

// Done 按钮启用
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.doneBarButton.enabled = ([newText length]>0);
    
    return YES;
    
}
#pragma mark - tableView
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return indexPath;
    }else{
        return nil;
    }
}

#pragma mark - Button
- (IBAction)cancel:(id)sender{
    [self.delegate listDetailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender{
    if (self.checklistToEdit == nil) {
        ChecklistModel *checklist = [[ChecklistModel alloc]init];
        checklist.list_name = self.textField.text;
        checklist.listIconName = _iconName;
        [self.delegate listDetailViewController:self didFinishAddingChecklist:checklist];
    }else{
        self.checklistToEdit.list_name = self.textField.text;
        self.checklistToEdit.listIconName = _iconName;
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self.checklistToEdit];
    }
    
}
#pragma mark - prepareForSegue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"PickIcon"]) {
        IconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}
#pragma mark - Delegate
- (void) iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName{
    _iconName = iconName;
    self.iconImageView.image = [UIImage imageWithCGImage:[[UIImage imageNamed:_iconName] CGImage] scale:([UIImage imageNamed:_iconName].scale * 2.2) orientation:([UIImage imageNamed:_iconName].imageOrientation)];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
