//
//  AllListsViewController.m
//  Checklists
//
//  Created by 马遥 on 15/7/7.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "AllListsViewController.h"
#import "ChecklistViewController.h"
#import "ChecklistModel.h"
#import "ChecklistItemModel.h"
#import "DBManager.h"
#import "ChecklistsDate.h"

@interface AllListsViewController (){
    NSMutableArray *_lists;
    DBManager *dbManager;
    ChecklistModel *checklistTable;
}

@end

@implementation AllListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValues];
    [self initDB];
    [self insertToLists];
}

- (void) initValues{
    _lists = [NSMutableArray array];
    dbManager = [ChecklistsDate shareManager].dbManager;
}

- (void) initDB{
    NSLog(@"initDB");
    checklistTable = [[ChecklistModel alloc]init];
//    if ([dbManager countOfItemsNumberInTable:listsTableName] < 2) {
//        for (int i = 0; i < 2; i++) {
//            NSDictionary *name = [checklistTable dictionaryOfText:[NSString stringWithFormat:@"list:%d",i]];
//            [dbManager insertItemsToTableName:listsTableName columns:name];
//        }
//    }
}

- (void) insertToLists{
//    NSLog(@"insertToLists");
    [_lists addObjectsFromArray:[dbManager arrayOfAllBySelect:checklistTable.columns fromTable:listsTableName where:nil]];
    NSLog(@"insertToLists:%lu",(unsigned long)_lists.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
- (void) listDetailViewControllerDidCancel:(ListDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(ChecklistModel *)checklist{
    [dbManager insertItemsToTableName:listsTableName columns:[checklist dictionaryOfdata]];
//    [dbManager createTableName:checklist.list_name columns:[ChecklistItemModel dictionaryOfPropertiesAndTypes]];
    NSInteger newRowIndex = [_lists count];
    NSArray *list = [dbManager arrayBySelect:checklist.columns fromTable:listsTableName where:nil orderBy:nil from:newRowIndex to:newRowIndex+1];
    
    NSLog(@"adding:%@",list[0]);
    [_lists addObject:list[0]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];// 通知tableview有新的row
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(ChecklistModel *)checklist{
    NSDictionary *items = [checklist dictionaryOfdata];
    NSString *listID = [items objectForKey:listsID];
    NSArray *list = [dbManager arrayOfAllBySelect:checklist.columns fromTable:listsTableName where:@{listsID:listID}];
    NSLog(@"editing:%@ to %@",list[0],[checklist dictionaryOfdata]);
    [dbManager alterTableName:[list[0] objectForKey:listsName] toNewName:checklist.list_name];
    NSInteger index = [_lists indexOfObject:list[0]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    _lists[index] = [checklist dictionaryOfdata];
    [dbManager updateItemsTableName:listsTableName set:@{listsName:[items objectForKey:listsName]} where:@{listsID:[items objectForKey:listsID]}];
//    [self configureTextForCell:cell withChecklist:checklist];
    cell.textLabel.text = checklist.list_name;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *list_id = [_lists[indexPath.row] objectForKey:listsID];
    NSString *list_name = [_lists[indexPath.row] objectForKey:listsName];
    [dbManager dropTableName:list_name];
    [ChecklistModel deletListWithID:list_id];
    [_lists removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_lists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_lists[indexPath.row] objectForKey:listsName];
//    cell.textLabel.text = [NSString stringWithFormat:@"清单:%ld",(long)indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
    ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
    controller.delegate = self;
    ChecklistModel *checklist = [[ChecklistModel alloc]initWithID:[_lists[indexPath.row] objectForKey:listsID] andName:[_lists[indexPath.row] objectForKey:listsName]];
    controller.checklistToEdit = checklist;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChecklistModel *checllist = [[ChecklistModel alloc]initWithID:[_lists[indexPath.row] objectForKey:listsID] andName:[_lists[indexPath.row] objectForKey:listsName]];
    [self performSegueWithIdentifier:@"ShowChecklist" sender:checllist];
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowChecklist"]) {
        ChecklistViewController *controller = segue.destinationViewController;
        controller.checklist = sender;
        
    }else if ([segue.identifier isEqualToString:@"AddChecklist"]){
        UINavigationController *navigationController = segue.destinationViewController;
        ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
        
        controller.delegate = self;
        controller.checklistToEdit = nil;
    }
    
}

@end
