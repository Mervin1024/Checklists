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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initValues];
    [self initDB];
    [self insertToLists];
}

- (void) initValues{
    _lists = [NSMutableArray array];
    dbManager = [ChecklistsDate shareManager].dbManager;
    self.tableView.rowHeight = 44.0f;
}

- (void) initDB{
    NSLog(@"initDB");
    checklistTable = [[ChecklistModel alloc]init];
    BOOL firstTime = [UserDefaults boolOfFirstTime];
    if (firstTime) {
        NSLog(@"firstTime");
        checklistTable.list_name = @"List";
        [dbManager createTableName:checklistTable.list_name columns:[ChecklistItemModel dictionaryOfPropertiesAndTypes]];
        [dbManager insertItemsToTableName:listsTableName columns:[checklistTable dictionaryOfdata]];
        [UserDefaults setIndexOfSelectedChecklist:0];
        [UserDefaults setBoolOfFirstTime:NO];
    }
}

- (void) insertToLists{
//    NSLog(@"insertToLists");
    [_lists addObjectsFromArray:[ChecklistModel arrayBySelectWhere:nil orderBy:nil from:0 to:0]];
//    [ChecklistModel arrayBySelectWhere:nil orderBy:nil from:nil to:nil];
    if (_lists.count > 0) {
        [_lists sortUsingSelector:@selector(comparelist:)];
    }
    NSLog(@"insertToLists:%lu",(unsigned long)_lists.count);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    NSInteger index = [UserDefaults indexOfSelectedChecklist];
    if (index != -1) {
        ChecklistModel *checklist = [[ChecklistModel alloc]initWithID:[_lists[index] objectForKey:listsID] andName:[_lists[index] objectForKey:listsName]iconName:[_lists[index] objectForKey:iconName]];
        [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
    }
}

#pragma mark - delegate
- (void) listDetailViewControllerDidCancel:(ListDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(ChecklistModel *)checklist{
//    [dbManager insertItemsToTableName:listsTableName columns:[checklist dictionaryOfdata]];
    [checklist insertItemToTable];
    
    [dbManager createTableName:checklist.list_name columns:[ChecklistItemModel dictionaryOfPropertiesAndTypes]];
    NSInteger newRowIndex = [_lists count];
    NSLog(@"newRowIndex:%ld",(long)newRowIndex);
    NSArray *list = [ChecklistModel arrayBySelectWhere:nil orderBy:nil from:newRowIndex to:newRowIndex+1];
//    NSArray *list = [dbManager arrayBySelect:checklist.columns fromTable:listsTableName where:nil orderBy:nil from:newRowIndex+1 to:newRowIndex+2];
    
//    NSLog(@"adding:%@",list[0]);
    [_lists addObject:list[0]];
//    NSLog(@"lists count:%lu",(unsigned long)[_lists count]);
    [_lists sortUsingSelector:@selector(comparelist:)];
    [self.tableView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
//    NSArray *indexPaths = @[indexPath];
//    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];// 通知tableview有新的row
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(ChecklistModel *)checklist{
    NSString *listID = [[checklist dictionaryOfdata] objectForKey:listsID];
//    NSArray *list = [dbManager arrayOfAllBySelect:checklist.columns fromTable:listsTableName where:@{listsID:listID}];
    NSArray *list = [ChecklistModel arrayBySelectWhere:@{listsID:listID} orderBy:nil from:0 to:0];
//    NSLog(@"editing:%@ to %@",list[0],[checklist dictionaryOfdata]);
    if (![[list[0] objectForKey:listsName] isEqualToString:checklist.list_name]) {
        [dbManager alterTableName:[list[0] objectForKey:listsName] toNewName:checklist.list_name];
    }
    NSInteger index = [_lists indexOfObject:list[0]];
    _lists[index] = [checklist dictionaryOfdata];
    [checklist updateNameAndIconNameToTable];
//    NSLog(@"%@",[dbManager arrayOfAllBySelect:checklist.columns fromTable:listsTableName where:@{listsID:listID}][0]);
    [_lists sortUsingSelector:@selector(comparelist:)];
    [self.tableView reloadData];
//    [self configureTextForCell:cell withChecklist:checklist];
//    cell.textLabel.text = checklist.list_name;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"deleteRowsAtIndexPaths");
    NSString *list_id = [_lists[indexPath.row] objectForKey:listsID];
    NSString *list_name = [_lists[indexPath.row] objectForKey:listsName];
    [dbManager dropTableName:list_name];
    [ChecklistModel deletListWithID:list_id];
    [_lists removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self) {
        [UserDefaults setIndexOfSelectedChecklist:-1];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_lists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"cell");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    ChecklistModel *checklist = [[ChecklistModel alloc]initWithID:[_lists[indexPath.row] objectForKey:listsID] andName:[_lists[indexPath.row] objectForKey:listsName] iconName:[_lists[indexPath.row] objectForKey:iconName]];
    cell.textLabel.text = checklist.list_name;
//    cell.textLabel.text = [NSString stringWithFormat:@"清单:%ld",(long)indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    int count = [checklist countUncheckedItems];
    if ([checklist.listItems count] == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(No Items)"];
    }else if (count == 0){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"All Done!"];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Remaining",[checklist countUncheckedItems]];
    }
    cell.imageView.image = [UIImage imageWithCGImage:[[UIImage imageNamed:checklist.listIconName] CGImage] scale:([UIImage imageNamed:checklist.listIconName].scale * 2.2) orientation:([UIImage imageNamed:checklist.listIconName].imageOrientation)];
//    [UIImage imageNamed:checklist.listIconName];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
    ListDetailViewController *listDetailViewController = (ListDetailViewController *)navigationController.topViewController;
    listDetailViewController.delegate = self;
//    NSLog(@"0");
//    NSLog(@"checklist.name:%@",[_lists[indexPath.row] objectForKey:listsName]);
    
    ChecklistModel *checklist = [[ChecklistModel alloc]initWithID:[_lists[indexPath.row] objectForKey:listsID] andName:[_lists[indexPath.row] objectForKey:listsName] iconName:[_lists[indexPath.row] objectForKey:iconName]];
    listDetailViewController.checklistToEdit = checklist;
//    NSLog(@"0000:%@",[checklist dictionaryOfdata]);
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath");
    [UserDefaults setIndexOfSelectedChecklist:indexPath.row];
    ChecklistModel *checllist = [[ChecklistModel alloc]initWithID:[_lists[indexPath.row] objectForKey:listsID] andName:[_lists[indexPath.row] objectForKey:listsName] iconName:[_lists[indexPath.row] objectForKey:iconName]];
    [self performSegueWithIdentifier:@"ShowChecklist" sender:checllist];
}



#pragma mark - Navigation


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
