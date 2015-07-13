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
#import "UserDefaults.h"
#import "NSDictionary+Assemble.h"

@interface AllListsViewController (){
    NSMutableArray *_lists;
    DBManager *dbManager;
    ChecklistModel *checklistTable;

}

@end

@implementation AllListsViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValues];
    [self initDB];
    [self insertToLists];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

//跳转至上次退出前页面
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    NSInteger index = [UserDefaults indexOfSelectedChecklist];
    if (index != -1) {
        ChecklistModel *checklist = [[ChecklistModel alloc]initWithID:[_lists[index] objectForKey:listsID] andName:[_lists[index] objectForKey:listsName]iconName:[_lists[index] objectForKey:iconName]];
        [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
    }
}
#pragma mark - init
- (void) initValues{
    _lists = [NSMutableArray array];
    dbManager = [ChecklistsDate shareManager].dbManager;
    self.tableView.rowHeight = 44.0f;
}

- (void) initDB{
    checklistTable = [[ChecklistModel alloc]init];
    BOOL firstTime = [UserDefaults boolOfFirstTime];
    if (firstTime) {
        checklistTable.list_name = @"List";
        [dbManager createTableName:checklistTable.list_name columns:[ChecklistItemModel dictionaryOfPropertiesAndTypes]];
        [dbManager insertItemsToTableName:listsTableName columns:[checklistTable dictionaryOfdata]];
        [UserDefaults setIndexOfSelectedChecklist:0];
        [UserDefaults setBoolOfFirstTime:NO];
    }
}

- (void) insertToLists{
    [_lists addObjectsFromArray:[ChecklistModel arrayBySelectedWhere:nil orderBy:nil from:0 to:0]];
    if (_lists.count > 0) {
        [_lists sortUsingSelector:@selector(comparelist:)];//数组排序
    }
}
#pragma mark - delegate
- (void) listDetailViewControllerDidCancel:(ListDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(ChecklistModel *)checklist{
    // Adding协议方法实现
    [checklist insertItemToTable];
    [dbManager createTableName:checklist.list_name columns:[ChecklistItemModel dictionaryOfPropertiesAndTypes]];
    NSInteger newRowIndex = [_lists count];
    NSArray *list = [ChecklistModel arrayBySelectedWhere:nil orderBy:nil from:newRowIndex to:newRowIndex+1];
    [_lists addObject:list[0]];
    [_lists sortUsingSelector:@selector(comparelist:)];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(ChecklistModel *)checklist{
    // Editing协议方法实现
    NSString *listID = [[checklist dictionaryOfdata] objectForKey:listsID];
    NSArray *list = [ChecklistModel arrayBySelectedWhere:@{listsID:listID} orderBy:nil from:0 to:0];
    if (![[list[0] objectForKey:listsName] isEqualToString:checklist.list_name]) {
        // 更改ChecklistItem数据库表名
        [dbManager alterTableName:[list[0] objectForKey:listsName] toNewName:checklist.list_name];
    }
    NSInteger index = [_lists indexOfObject:list[0]];
    _lists[index] = [checklist dictionaryOfdata];
    [checklist updateNameAndIconNameToTable];
    [_lists sortUsingSelector:@selector(comparelist:)];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 若为首页UserDefaults置-1
    if (viewController == self) {
        
        [UserDefaults setIndexOfSelectedChecklist:-1];
    }
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_lists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    ChecklistModel *checklist = [[ChecklistModel alloc]initWithID:[_lists[indexPath.row] objectForKey:listsID] andName:[_lists[indexPath.row] objectForKey:listsName] iconName:[_lists[indexPath.row] objectForKey:iconName]];
    cell.textLabel.text = checklist.list_name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    [self configureDetailTextForCell:cell withChecklist:checklist];
    [self configureImageViewForCell:cell withChecklist:checklist];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // Accessory按钮点击方法实现
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
    ListDetailViewController *listDetailViewController = (ListDetailViewController *)navigationController.topViewController;
    listDetailViewController.delegate = self;
    
    ChecklistModel *checklist = [[ChecklistModel alloc]initWithID:[_lists[indexPath.row] objectForKey:listsID] andName:[_lists[indexPath.row] objectForKey:listsName] iconName:[_lists[indexPath.row] objectForKey:iconName]];
    listDetailViewController.checklistToEdit = checklist;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UserDefaults setIndexOfSelectedChecklist:indexPath.row];
    ChecklistModel *checllist = [[ChecklistModel alloc]initWithID:[_lists[indexPath.row] objectForKey:listsID] andName:[_lists[indexPath.row] objectForKey:listsName] iconName:[_lists[indexPath.row] objectForKey:iconName]];
    [self performSegueWithIdentifier:@"ShowChecklist" sender:checllist];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    ChecklistModel *items = [[ChecklistModel alloc]initWithID:[_lists[indexPath.row] objectForKey:listsID] andName:[_lists[indexPath.row] objectForKey:listsName] iconName:[_lists[indexPath.row] objectForKey:iconName]];
    // 判断items是否有消息通知
    for (NSDictionary *item in items.listItems) {
        ChecklistItemModel *checklist = [[ChecklistItemModel alloc]initWithTableName:items.list_name ListID:[item objectForKey:listItemID] Text:[item objectForKey:listItemText] Checked:[item objectForKey:listItemChecked] dueDate:[item objectForKey:listItemDueDate] shouldRemind:[item objectForKey:listItemShouldRemind]];
        UILocalNotification *existingNotification = [checklist notificationForThisItem];
        if (existingNotification != nil) {
            NSLog(@"删除消息通知");
            [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
        }else{
            NSLog(@"未成功删除或没有消息通知");
        }
        
    }
    [items deletListFromTable];
    [_lists removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
#pragma mark - RowAtIndexPath
- (void)configureDetailTextForCell:(UITableViewCell *)cell withChecklist:(ChecklistModel *)checklist{
    if ([checklist.listItems count] == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(No Items)"];
    }else if ([checklist countUncheckedItems] == 0){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"All Done!"];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Remaining",[checklist countUncheckedItems]];
    }
}

- (void)configureImageViewForCell:(UITableViewCell *)cell withChecklist:(ChecklistModel *)checklist{
    cell.imageView.image = [UIImage imageWithCGImage:[[UIImage imageNamed:checklist.listIconName] CGImage] scale:([UIImage imageNamed:checklist.listIconName].scale * 2.2) orientation:([UIImage imageNamed:checklist.listIconName].imageOrientation)];
}



#pragma mark - prepareForSegue


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowChecklist"]) {
        ChecklistViewController *controller = segue.destinationViewController;
        controller.checklist = sender;
        
    }else if ([segue.identifier isEqualToString:@"AddChecklist"]){
        UINavigationController *navigationController = segue.destinationViewController;
        ListDetailViewController *listDetailViewController = (ListDetailViewController *)navigationController.topViewController;
        
        listDetailViewController.delegate = self;
        listDetailViewController.checklistToEdit = nil;
    }
    
}



@end
