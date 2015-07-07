//
//  ViewController.m
//  Checklists
//
//  Created by 马遥 on 15/1/27.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "ChecklistViewController.h"
#import "ChecklistModel.h"
#import "ChecklistItemModel.h"
#import "DBManager.h"
#import "ChecklistsDate.h"
#import "NSString+Format.h"

@interface ChecklistViewController (){
    DBManager *dbManager;
    ChecklistItemModel *listTable;
    NSMutableArray *tableData;
    NSString *tableName;
}

//@property (nonatomic) NSMutableArray *tableData;
//@property (nonatomic) ChecklistsModel *listTable;
//@property (nonatomic) DBManager *dbManager;
@end

@implementation ChecklistViewController{

}
//@synthesize count;
//@synthesize refreshControl;
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = self.checklist.list_name;
    [self initValues];
    [self initDB];
//    [self insertItemsToTableData];
}

- (void)initValues{
//    tableData = [NSMutableArray array];
    tableData = self.checklist.listItems;
    dbManager = [ChecklistsDate shareManager].dbManager;
    tableName = self.checklist.list_name;
//    self.count = [ChecklistItemModel countOfLists];
}

- (void)initDB{
    NSLog(@"initDB");
    listTable = [[ChecklistItemModel alloc] initChecklists];
    [dbManager createTableName:tableName columns:[ChecklistItemModel dictionaryOfPropertiesAndTypes]];
//    if ([dbManager countOfItemsNumberInTable:tableName] < 10) {
//        for (int i = 0; i < 5; i++) {
//            NSDictionary *text1 = [listTable dictionaryOfText:@"雷扬是傻吊"];
//            NSDictionary *text2 = [listTable dictionaryOfText:@"考斌是傻吊"];
//            [dbManager insertItemsToTableName:tableName columns:text1];
//            [dbManager insertItemsToTableName:tableName columns:text2];
//        }
//    }
}

//- (void)insertItemsToTableData{
//    NSLog(@"insertToTableData");
//    [tableData addObjectsFromArray:[dbManager arrayOfAllBySelect:listTable.columns fromTable:tableName where:nil]];
//    NSLog(@"count of tableData:%lu",(unsigned long)tableData.count);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Delegate
-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItemModel *)item{
    [dbManager insertItemsToTableName:tableName columns:[item dictionaryOfdata]];
    item.list_tableName = tableName;
    NSInteger newRowIndex = [tableData count];
    NSArray *list = [dbManager arrayBySelect:listTable.columns fromTable:item.list_tableName where:nil orderBy:nil from:newRowIndex to:newRowIndex+1];
    NSLog(@"adding:%@",list[0]);
    [tableData addObject:list[0]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];// 通知tableview有新的row
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItemModel *)item{
    NSDictionary *items = [item dictionaryOfdata];
    NSString *listID = [items objectForKey:listItemID];
    NSArray *list = [dbManager arrayOfAllBySelect:listTable.columns fromTable:item.list_tableName where:@{listItemID:listID}];
    NSLog(@"editing:%@ to %@",list[0],[item dictionaryOfdata]);
    NSInteger index = [tableData indexOfObject:list[0]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    tableData[index] = [item dictionaryOfdata];
    [dbManager updateItemsTableName:item.list_tableName set:@{listItemText:[items objectForKey:listItemText]} where:@{listItemID:[items objectForKey:listItemID]}];
    [self configureTextForCell:cell withChecklistItem:item];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableData count];
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItemModel *)item{
    
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    
    if (item.checked) {
        label.text = @"√";
    }else{
        label.text = @"";
    }
    
}

- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItemModel *)item{
    
    UILabel *label = (UILabel *)[cell viewWithTag:1024];
    label.text = item.list_text;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Item"];
//    UILabel *label =(UILabel*)[cell viewWithTag:1024];
    NSDictionary *items = tableData[indexPath.row];
    ChecklistItemModel *item = [[ChecklistItemModel alloc]initWithTableName:tableName ListID:[items objectForKey:listItemID] Text:[items objectForKey:listItemText] andChecked:[[items objectForKey:listItemChecked] isYes]];
//    label.text = [item objectForKey:@"list_text"];
    
    
    
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    [self configureTextForCell:cell withChecklistItem:item];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelect");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *items = tableData[indexPath.row];
    NSString *listID = [items objectForKey:listItemID];
    ChecklistItemModel *item = [[ChecklistItemModel alloc]initWithTableName:tableName ListID:listID Text:[items objectForKey:listItemText] andChecked:[[items objectForKey:listItemChecked] isYes]];
    NSLog(@"item_checked1:%@",[item stringWithChecked]);
    [item toggleChecked];
    NSLog(@"item_checked2:%@",[item stringWithChecked]);
    tableData[indexPath.row] = [item dictionaryOfdata];
    [dbManager updateItemsTableName:tableName set:@{listItemChecked:[item stringWithChecked]} where:@{listItemID:listID}];
    
    
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - deleteRows
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *list_id = [tableData[indexPath.row] objectForKey:listItemID];
    ChecklistItemModel *item = [[ChecklistItemModel alloc]initWithTableName:tableName ListID:list_id Text:[tableData[indexPath.row] objectForKey:listItemText] andChecked:[[tableData[indexPath.row] objectForKey:listItemChecked] isYes]];
    [item deleteItemWithID:list_id];
    [tableData removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


#pragma mark - prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"AddItem"]){
        
        UINavigationController *navigationController = segue.destinationViewController;

        ItemDetailViewController *controller = (ItemDetailViewController*) navigationController.topViewController;
        
        controller.delegate = self;
        
    }else if([segue.identifier isEqualToString:@"EditItem"]){
        
        UINavigationController *navigationController = segue.destinationViewController;
        
        ItemDetailViewController *controller = (ItemDetailViewController*) navigationController.topViewController;
        
        controller.delegate = self;
        
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        NSInteger row = indexPath.row;
        controller.itemToEdit =[[ChecklistItemModel alloc]initWithTableName:tableName ListID:[tableData[row] objectForKey:listItemID] Text:[tableData[row] objectForKey:listItemText] andChecked:[[tableData[row] objectForKey:listItemChecked] isYes]];
        
        
    }
    
}

@end
