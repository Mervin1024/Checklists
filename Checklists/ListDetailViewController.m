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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setValues];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
//    self.iconImageView.image = [UIImage imageNamed:_iconName];
    self.iconImageView.image = [UIImage imageWithCGImage:[[UIImage imageNamed:_iconName] CGImage] scale:([UIImage imageNamed:_iconName].scale * 2.2) orientation:([UIImage imageNamed:_iconName].imageOrientation)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 跳转界面锁定textField为当前控制焦点
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return indexPath;
    }else{
        return nil;
    }
}

// Done 按钮启用
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"changelist");
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.doneBarButton.enabled = ([newText length]>0);
    
    return YES;
    
}

- (IBAction)cancel:(id)sender{
    [self.delegate listDetailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender{
//    NSLog(@"done");
    if (self.checklistToEdit == nil) {
        NSLog(@"add");
        ChecklistModel *checklist = [[ChecklistModel alloc]init];
        checklist.list_name = self.textField.text;
        checklist.listIconName = _iconName;
        [self.delegate listDetailViewController:self didFinishAddingChecklist:checklist];
    }else{
        NSLog(@"edit");
        self.checklistToEdit.list_name = self.textField.text;
        self.checklistToEdit.listIconName = _iconName;
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self.checklistToEdit];
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"PickIcon"]) {
        IconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}
#pragma mark - delegate
- (void) iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName{
    _iconName = iconName;
//    self.iconImageView.image = [UIImage imageNamed:_iconName];
    self.iconImageView.image = [UIImage imageWithCGImage:[[UIImage imageNamed:_iconName] CGImage] scale:([UIImage imageNamed:_iconName].scale * 2.2) orientation:([UIImage imageNamed:_iconName].imageOrientation)];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
