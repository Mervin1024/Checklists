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
@end

@implementation ChecklistViewController{

}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.checklist.list_name;
    [self initValues];
    [self initDB];
}

- (void)initValues{
    tableData = self.checklist.listItems;
    dbManager = [ChecklistsDate shareManager].dbManager;
    tableName = self.checklist.list_name;
    self.tableView.rowHeight = 44.0f;
}

- (void)initDB{
    listTable = [[ChecklistItemModel alloc] initChecklists];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Delegate
-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItemModel *)item{
    [dbManager insertItemsToTableName:tableName columns:[item dictionaryOfdata]];
    item.list_tableName = tableName;
    NSInteger newRowIndex = [tableData count];
    NSArray *list = [item arrayBySelectWhere:nil orderBy:nil from:newRowIndex to:newRowIndex+1];
    [tableData addObject:list[0]];
    [tableData sortUsingSelector:@selector(compareItem:)];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItemModel *)item{
    NSString *listID = [[item dictionaryOfdata] objectForKey:listItemID];
    NSArray *list = [item arrayBySelectWhere:@{listItemID:listID} orderBy:nil from:0 to:0];
    NSInteger index = [tableData indexOfObject:list[0]];
    tableData[index] = [item dictionaryOfdata];
    [item updateStateToTable];
    [tableData sortUsingSelector:@selector(compareItem:)];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RowAtIndexPath
- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItemModel *)item{
    
    if (item.checked) {
        UIImage *checked = [UIImage imageNamed:@"Checked"];
        cell.imageView.image = [UIImage imageWithCGImage:[checked CGImage] scale:(checked.scale * 3.5) orientation:(checked.imageOrientation)];
    }else{
        UIImage *unChecked = [UIImage imageNamed:@"unChecked"];
        cell.imageView.image = [UIImage imageWithCGImage:[unChecked CGImage] scale:(unChecked.scale * 3.5) orientation:(unChecked.imageOrientation)];
    }
}

- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItemModel *)item{
    cell.textLabel.text = item.list_text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:item.dueDate];
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Item"];
    NSDictionary *items = tableData[indexPath.row];
    ChecklistItemModel *item = [[ChecklistItemModel alloc]initWithTableName:tableName ListID:[items objectForKey:listItemID] Text:[items objectForKey:listItemText] Checked:[[items objectForKey:listItemChecked] isYes] dueDate:[[items objectForKey:listItemDueDate] dateFromString] shouldRemind:[[items objectForKey:listItemShouldRemind] isYes]];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    [self configureTextForCell:cell withChecklistItem:item];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *items = tableData[indexPath.row];
    ChecklistItemModel *item = [[ChecklistItemModel alloc]initWithTableName:tableName ListID:[items objectForKey:listItemID] Text:[items objectForKey:listItemText] Checked:[[items objectForKey:listItemChecked] isYes] dueDate:[[items objectForKey:listItemDueDate] dateFromString] shouldRemind:[[items objectForKey:listItemShouldRemind] isYes]];
    [item toggleChecked];
    tableData[indexPath.row] = [item dictionaryOfdata];
    [item updateCheckedToTable];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - deleteRows
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *list_id = [tableData[indexPath.row] objectForKey:listItemID];
    ChecklistItemModel *item = [[ChecklistItemModel alloc]initWithTableName:tableName ListID:list_id Text:[tableData[indexPath.row] objectForKey:listItemText] Checked:[[tableData[indexPath.row] objectForKey:listItemChecked] isYes] dueDate:[[tableData[indexPath.row] objectForKey:listItemDueDate] dateFromString] shouldRemind:[[tableData[indexPath.row] objectForKey:listItemShouldRemind] isYes]];
    [item deleteItemWithID:list_id];
    [tableData removeObjectAtIndex:indexPath.row];
        UILocalNotification *existingNotification = [item notificationForThisItem];
        if (existingNotification != nil) {
            NSLog(@"删除消息通知");
            [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
        }else{
            NSLog(@"未成功删除或没有消息通知");
        }
    
    
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
        controller.itemToEdit =[[ChecklistItemModel alloc]initWithTableName:tableName ListID:[tableData[row] objectForKey:listItemID] Text:[tableData[row] objectForKey:listItemText] Checked:[[tableData[row] objectForKey:listItemChecked] isYes] dueDate:[[tableData[row] objectForKey:listItemDueDate] dateFromString] shouldRemind:[[tableData[row] objectForKey:listItemShouldRemind] isYes]];
        
        
    }
    
}

@end
