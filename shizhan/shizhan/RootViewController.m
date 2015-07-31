//
//  RootViewController.m
//  UITableView2
//
//  Created by qianfeng on 15-1-30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "RootViewController.h"
#import "Frind.h"
@interface RootViewController ()

@end

@implementation RootViewController
{
    NSMutableArray *_friends;//好友。
    UITableView *_tableView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [_friends release];
    [_tableView release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareData];
    [self customUI];
    [self customNavigationBar];
}
-(void)prepareData
{
    _friends=[[NSMutableArray alloc]init];
    NSMutableArray *classMates=[[NSMutableArray alloc]init];//同学；
    NSMutableArray *colleague=[[NSMutableArray alloc]init];//同事。
    [_friends addObject:classMates];
    [_friends addObject:colleague];
    for (NSInteger i=0; i<=20; i++) {
         Frind *frind=[[Frind alloc]init];
         frind.age=arc4random()%20+20;
        if (i%2==0) {
            frind.imageName=[NSString stringWithFormat:@"p_%d",i];
            frind.name=[NSString stringWithFormat:@"同学%d",i/2];
            [classMates addObject:frind];
        }else//同事
        {
            frind.imageName=[NSString stringWithFormat:@"p_%d",i];
            frind.name=[NSString stringWithFormat:@"同事%d",i/2];
            [colleague addObject:frind];
        }
        [frind release];
    }
    [classMates release];
    [colleague release];
    
}
-(void)customUI
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, 416) style:UITableViewStylePlain ];
    _tableView=[tableView retain];
    tableView.dataSource=self;
    tableView.delegate=self;
    [self.view addSubview:tableView];
    [tableView release];
}
-(void)customNavigationBar
{
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onButtonClick:)];
    self.navigationItem.leftBarButtonItem=barButton;
    [barButton release];
    UIBarButtonItem *Button=[[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(onButtonRefreshClick)];
    self.navigationItem.rightBarButtonItem=Button;
    [Button release];
}
-(void)onButtonClick:(UIBarButtonItem*)sender
{
    if ([sender.title isEqualToString:@"编辑"]) {
        sender.title=@"完成";
        [_tableView setEditing:YES animated:YES];//进入编辑状态
    }else
    {
        sender.title=@"编辑";
        [_tableView setEditing:NO animated:NO];//退出编辑状态。
    }
}
-(void)onButtonRefreshClick
{
    [_tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _friends.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *frinds=_friends[section];
    return frinds.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row:%d",indexPath.row);
    static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId]autorelease];
    }
    NSArray *frinds=_friends[indexPath.section];//当前分区对应的数组。
    Frind *friend=frinds[indexPath.row];
    cell.textLabel.text=friend.name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",friend.age];
    cell.imageView.image=[UIImage imageNamed:friend.imageName];
    return cell;
}
//用于返回分区的标题。
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"同学";
    }else
    {
        return @"同事";
    }
}
//UITableViewDelegate
//返回分区的头标题的高度。
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
//返回行高。
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 40;
    }else
    {
        return 60;
    }
}
//选中某行时被调用。
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中第%d行",indexPath.row);
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"取消第%d行",indexPath.row);
}
//UITableViewDelegate
//返回指定分区指定行的编辑状态，删除还是插入。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return UITableViewCellEditingStyleDelete;
    }else
    {
        return UITableViewCellEditingStyleInsert;
    }
}
//当插入或删除单元格时被调用，完成真正的删除或插入操作。
//参数二：操作的类型，插入或删除？
//参数三：哪个分区哪行需要插入或删除。
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //第一步删除数据源。
        NSMutableArray *deleteSectionData=_friends[indexPath.section];
        [deleteSectionData removeObjectAtIndex:indexPath.row];
        //第二步：
        //[_tableView reloadData];//第一种做法。
        //dier中做法。
        NSArray *rowToDelete=[NSArray arrayWithObject:indexPath];//一个元素的数组。
        [tableView deleteRowsAtIndexPaths:rowToDelete withRowAnimation:UITableViewRowAnimationAutomatic];//删除指定行。
    }else
    {
        NSMutableArray *insertSectionData=_friends[indexPath.section];//得到要插的分区。
        //插入一个固定的信息。
        Frind *newFriend=[[Frind alloc]init];
        newFriend.name=@"新朋友";
        newFriend.imageName=@"p_0";
        newFriend.age=18;
        [insertSectionData insertObject:newFriend atIndex:indexPath.row];
        //[tableView reloadData];//第一种做法。
        NSArray *rowToInsert=[NSArray arrayWithObject:indexPath];
        [tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
        [newFriend release];
        
    }
    
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//用于完成数据源的移动
//
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableArray *sourceArray=_friends[sourceIndexPath.section];
    NSMutableArray *destinationArray=_friends[destinationIndexPath.section];
    Frind *selectFriend=[sourceArray[sourceIndexPath.row] retain];
    [sourceArray removeObjectAtIndex:sourceIndexPath.row];
    [destinationArray insertObject:selectFriend atIndex:destinationIndexPath.row];
    [selectFriend release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
