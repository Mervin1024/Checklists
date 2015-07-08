//
//  IconPickerViewController.m
//  Checklists
//
//  Created by 马遥 on 15/7/8.
//  Copyright (c) 2015年 马遥. All rights reserved.
//

#import "IconPickerViewController.h"

@implementation IconPickerViewController{
    NSArray *_icons;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    _icons = @[@"No icon",@"folder",@"cake",@"download",@"clock",@"shopping",@"trips"];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_icons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IconCell"];
    NSString *icon = _icons[indexPath.row];
    cell.textLabel.text = icon;
    cell.imageView.image = [UIImage imageNamed:icon];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *iconName = _icons[indexPath.row];
    [self.delegate iconPicker:self didPickIcon:iconName];
}

@end
