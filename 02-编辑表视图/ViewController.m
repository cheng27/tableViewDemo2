//
//  ViewController.m
//  02-编辑表视图
//
//  Created by qingyun on 15/12/4.
//  Copyright (c) 2015年 阿六. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableDictionary *dict;
@property (nonatomic,strong) NSArray *keys;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController
static NSString *identifier = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDictFromFile];
    //注册通知
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    //创建barBtnItem
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)editAction:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"编辑"]) {
        item.title = @"完成";
        [_tableView setEditing:YES];
    }else
    {
        item.title = @"编辑";
        [_tableView setEditing:NO];
    }
}

- (void)loadDictFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sortednames" ofType:@"plist"];
    _dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    //取出key
    NSArray *array = _dict.allKeys;
    _keys =[array sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - UITableViewDataSource
//组数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _keys.count;
}
//每组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //先取出section对应的key
    NSString *key = _keys[section];
    //取section对应的数组
    NSArray *array = _dict[key];
    return array.count;
}
//每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    //取到当前section对应的索引
    NSString *key = _keys[indexPath.section];
    //取到当前section的行数据
    NSArray *array = _dict[key];
    //当前单元格对应的数据
    cell.textLabel.text = array[indexPath.row];
    
    return cell;
}
//section的头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _keys[section];
}
//索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}
#pragma mark - 编辑--添加删除
//编辑--添加删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//设置当前单元格的编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0 ) {
        return UITableViewCellEditingStyleDelete;
    }else
    {
        return UITableViewCellEditingStyleInsert;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出当前数据
    NSString *key = _keys[indexPath.section];
    NSMutableArray *array = _dict[key];
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        //更改数据源
        [array insertObject:@"青云iOS" atIndex:indexPath.row + 1];
        //更改界面
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationRight];
        
    }else if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //更改数据源
        [array removeObjectAtIndex:indexPath.row];
        //更改界面
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}
#pragma mark -编辑--移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //取出原单元格对应的数据
    //取源section对应的sourceKey
    NSString *sourceKey = _keys[sourceIndexPath.section];
    //用sourceKey取section的所有数据sourceArray
    NSMutableArray *sourceArray = _dict[sourceKey];
    //从sourceArray中取到当前单元格的内容
    NSString *sourcrStr = sourceArray[sourceIndexPath.row];
    //把移动的单元格内容移除
    [sourceArray removeObjectAtIndex:sourceIndexPath.row];
    
    //把取到的原单元格的数据插入到目的indexPath
    //取到插入的数据（目标section的数据）
    NSString *destKey = _keys[destinationIndexPath.section];
    NSMutableArray *destArray = _dict[destKey];
    [destArray insertObject:sourcrStr atIndex:destinationIndexPath.row];
}

#pragma mark - 扩展
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"分享" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信" otherButtonTitles:@"QQ", nil];
        [actionSheet showInView:actionSheet];
        
    }];
    rowAction.backgroundColor = [UIColor cyanColor];
    
    UITableViewRowAction *rowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //取出当前数据
        NSString *key = _keys[indexPath.section];
        NSMutableArray *array = _dict[key];
        //更改数据源
        [array removeObjectAtIndex:indexPath.row];
        //更改界面
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }];
    rowAction2.backgroundColor = [UIColor blueColor];
    return @[rowAction,rowAction2];
}

@end
