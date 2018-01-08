//
//  ATContactViewController.m
//  MiLin
//
//  Created by AdminTest on 2017/10/27.
//  Copyright © 2017年 AdminTest. All rights reserved.
//

#import "ATContactViewController.h"
#import "ATContactModel.h"

/*! 索引 */
#define kBALocalizedIndexArrayKey @"kBALocalizedIndexArrayKey"
/*! 排序后的分组，可以为 model */
#define kBALocalizedGroupArrayKey @"kBALocalizedGroupArrayKey"

static NSString *const kIdentifier = @"ATContactViewControllerID";

@interface ATContactViewController () <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *searchResultsKeywordsArray;
@property (nonatomic, strong) NSMutableArray <NSString *> *searchResultIndexArray;

/*! 索引 */
@property (nonatomic, strong) NSMutableArray <NSString *> *indexArray;
@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ATContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"通讯录";
    
    [self getSectionData];
}

- (void)getSectionData
{
    NSDictionary *dict = [ATContactViewController sortedDataArray:self.dataArray bySelector:@selector(user_Name)];
    self.indexArray   = dict[kBALocalizedIndexArrayKey];
    self.sectionArray = dict[kBALocalizedGroupArrayKey];
    
    NSMutableArray *tempModel = [[NSMutableArray alloc] init];
    NSArray *temp = @[@{@"user_Name" : @"新的朋友",
                         @"user_Image_url" : @"icon.bundle/plugins_FriendNotify"},
                       @{@"user_Name" : @"群聊",
                         @"user_Image_url" : @"icon.bundle/add_friend_icon_addgroup"},
                       @{@"user_Name" : @"标签",
                         @"user_Image_url" : @"icon.bundle/Contact_icon_ContactTag"},
                       @{@"user_Name" : @"公众号",
                         @"user_Image_url" : @"icon.bundle/add_friend_icon_offical"}];
    for (NSDictionary *dict in temp)
    {
        ATContactModel *model = [ATContactModel new];
        model.user_Name = dict[@"user_Name"];
        model.user_Image_url = dict[@"user_Image_url"];
        [tempModel addObject:model];
    }
    
    [self.sectionArray insertObject:tempModel atIndex:0];
    [self.indexArray insertObject:@"🔍" atIndex:0];
    
    [self.tableView reloadData];
}


#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.searchController.active) {
        return self.indexArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.searchController.active) {
        return [self.sectionArray[section] count];
    }
    return self.searchResultsKeywordsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier ];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kIdentifier];
    }
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;

    ATContactModel *model = nil;
    
    if (!self.searchController.active)
    {
        model = self.sectionArray[section][row];
        cell.textLabel.text = model.user_Name;
    }
    else
    {
        model = self.searchResultsKeywordsArray[row];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.user_Name attributes:@{NSForegroundColorAttributeName:UIColorBlack}];
        
        NSRange range = [model.user_Name rangeOfString:self.searchController.searchBar.text];
        if (range.location != NSNotFound)
        {
            [attributedString addAttributes:@{NSForegroundColorAttributeName:UIColorRed} range:range];
        }
        cell.textLabel.attributedText = attributedString;
    }
    
    if (model.user_Image_url)
    {
        cell.imageView.image = [UIImage changeCellRoundImageViewSizeWithCell:cell image:UIImageMake(model.user_Image_url) imageSize:CGSizeMake(40, 40)];
    }

    if (model.user_PhoneNumber)
    {
        cell.detailTextLabel.text = model.user_PhoneNumber;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        //        cell.detailTextLabelEdgeInsets = UIEdgeInsetsMake(2, -3, 0, 0);
    }
    else
    {
        cell.detailTextLabel.text = nil;
    }
    
    //    cell.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    //    cell.textLabelEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    cell.backgroundColor = UIColorClear;
    //    [cell updateCellAppearanceWithIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    ATContactModel *model = nil;
    if (!self.searchController.active)
    {
        model = self.sectionArray[section][row];
    }
    else
    {
        model = self.searchResultsKeywordsArray[row];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!self.searchController.active)
    {
        return self.indexArray[section];
    }
    else
    {
        if (self.searchResultsKeywordsArray.count > 0)
        {
            return @"最佳匹配";
            //            return self.searchResultIndexArray[section];
        }
    }
    return nil;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.searchController.active)
    {
        return self.indexArray;
    }
    return nil;
}

#pragma mark - UISearchControllerDelegate
// 谓词搜索过滤
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];
    [self.searchResultsKeywordsArray removeAllObjects];
    
    for (ATContactModel *model in self.dataArray)
    {
        if ([model.user_Name isContainsString:searchString])
        {
            [self.searchResultsKeywordsArray addObject:model];
        }
        if (self.searchResultsKeywordsArray.count)
        {
            NSDictionary *dict = [ATContactViewController sortedDataArray:self.searchResultsKeywordsArray bySelector:@selector(user_Name)];
            self.searchResultIndexArray = dict[kBALocalizedIndexArrayKey];
        }
    }
    
    if (self.searchResultsKeywordsArray.count == 0 && [self.searchController.searchBar isFirstResponder])
    {
        self.emptyView.hidden = NO;
    }
    else
    {
        self.emptyView.hidden = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - UISearchControllerDelegate代理,可以省略,主要是为了验证打印的顺序
- (void)willPresentSearchController:(UISearchController *)searchController
{
    [QMUIHelper renderStatusBarStyleDark];
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    // 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
    //    [self.view addSubview:self.searchController.searchBar];
    //    if (![searchController.searchBar.text ba_stringIsBlank])
    //    {
    //        self.searchController.dimsBackgroundDuringPresentation = NO;
    //    }
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    [QMUIHelper renderStatusBarStyleLight];
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    //    [self ba_removeEmptyView];
}

- (void)presentSearchController:(UISearchController *)searchController
{
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.emptyView.hidden = YES;
    //    [self ba_removeEmptyView];
}


- (UISearchController *)searchController
{
    if (!_searchController)
    {
        _searchController = ({
            // 创建UISearchController
            UISearchController *vc = [[UISearchController alloc] initWithSearchResultsController:nil];
            //设置代理
            vc.delegate = self;
            vc.searchResultsUpdater = self;
            vc.searchBar.delegate = self;
            
            //包着搜索框外层的颜色
            vc.searchBar.barTintColor = UIColorMakeWithHex(@"f0f0f0");
            
            // placeholder
            vc.searchBar.placeholder = @"搜索";
            vc.searchBar.searchBarStyle = UISearchBarStyleDefault;
            // 顶部提示文本,相当于控件的Title
            //        vc.searchBar.prompt = @"Prompt";
            // 搜索框样式
            vc.searchBar.barStyle = UIBarMetricsDefault;
            // 位置
//            vc.searchBar.frame = CGRectMake(vc.searchBar.frame.origin.x, vc.searchBar.frame.origin.y, SCREEN_WIDTH, 44.0);
            //         [vc.searchBar setSearchTextPositionAdjustment:UIOffsetMake(30, 0)];
            // 改变系统自带的“cancel”为“取消”
            [vc.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
            vc.searchBar.tintColor = UIColorRed;
            //        vc.searchBar.backgroundColor = UIColorGreen;
            
            // 是否提供自动修正功能（这个方法一般都不用的）
            // 设置自动检查的类型
            [vc.searchBar setSpellCheckingType:UITextSpellCheckingTypeYes];
            [vc.searchBar setAutocorrectionType:UITextAutocorrectionTypeDefault];// 是否提供自动修正功能，一般设置为UITextAutocorrectionTypeDefault
            [vc.searchBar sizeToFit];
            
            
            //  是否显示灰色透明的蒙版，默认 YES，点击事件无效
            vc.dimsBackgroundDuringPresentation = NO;
            // 是否隐藏导航条，这个一般不需要管，都是隐藏的
            //        vc.hidesNavigationBarDuringPresentation = YES;
            // 搜索时，背景变模糊
            //        vc.obscuresBackgroundDuringPresentation = NO;
            
            //点击搜索的时候,是否隐藏导航栏
            //    vc.hidesNavigationBarDuringPresentation = NO;
            
            // 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
            self.definesPresentationContext = YES;
            // 添加 searchbar 到 headerview
            self.tableView.tableHeaderView = vc.searchBar;
            
            vc;
        });
    }
    return _searchController;
}

- (NSMutableArray *)searchResultsKeywordsArray
{
    if(_searchResultsKeywordsArray == nil)
    {
        _searchResultsKeywordsArray = [[NSMutableArray <ATContactModel *> alloc] init];
    }
    return _searchResultsKeywordsArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray <ATContactModel *> alloc] init];
        
        NSArray *iconImageNamesArray = @[@"headers.bundle/0.jpg",
                                         @"headers.bundle/1.jpg",
                                         @"headers.bundle/2.jpg",
                                         @"headers.bundle/3.jpg",
                                         @"headers.bundle/8.jpg",
                                         @"headers.bundle/9.jpg",
                                         @"headers.bundle/5.jpg",
                                         @"headers.bundle/6.jpg",
                                         @"headers.bundle/7.jpg",
                                         ];
        NSArray *namesArray = @[@"jj",
                                @"AA",
                                @"小明",
                                @"陆晓峰",
                                @"石少庸是小明的老师",
                                @"石少庸",
                                @"Alix",
                                @"Tom",
                                @"Tomb",
                                @"Lucy",
                                @"123",
                                @"cydn",
                                @"mami",
                                @"888",
                                @"zhangSan",
                                @"王二",
                                @"微信",
                                @"张小龙"];
        
        NSMutableArray *iconArray = [NSMutableArray array];
        for (NSInteger i = 0; i < namesArray.count; i ++)
        {
            if (iconImageNamesArray.count < namesArray.count)
            {
                for (NSInteger j = 0; j < iconImageNamesArray.count; j ++)
                {
                    [iconArray addObject:iconImageNamesArray[j]];
                }
            }
            ATContactModel *model = [[ATContactModel alloc] init];
            model.user_Image_url = iconArray[i];
            model.user_Name = namesArray[i];

            [self.dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (NSMutableArray <NSString *> *)indexArray
{
    if(_indexArray == nil)
    {
        _indexArray = [[NSMutableArray <NSString *> alloc] init];
    }
    return _indexArray;
}

- (NSMutableArray *)sectionArray
{
    if(_sectionArray == nil)
    {
        _sectionArray = [[NSMutableArray alloc] init];
    }
    return _sectionArray;
}


/*!
 按首字母或者汉字拼音首字母分组排序索引
 
 @param dataArray        需要排序的数组，可以为 model
 @param selector 数组中对象需要排序的属性，可以为 model.userName
 
 @return 排序后的索引及 groupArray 字典形式 kBALocalizedIndexArrayKey kBALocalizedGroupArrayKey
 */
+ (NSDictionary *)sortedDataArray:(NSMutableArray *)dataArray bySelector:(SEL)selector
{
    /*! 对数组重建索引，按照abcd字母顺序进行分组 */
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSInteger index, sectionTitlesCount = [[indexCollation sectionTitles] count];
    NSMutableArray *indexArray = [[NSMutableArray alloc] initWithArray:[indexCollation sectionTitles]];
    
    /*! 临时数据，存放 section 对应的 userObjc 数组数据 */
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    /*! 设置sections数组初始化：元素包含userObjs数据的空数据 */
    for (index = 0; index < sectionTitlesCount; index++)
    {
        [newSectionsArray addObject:[NSMutableArray array]];
    }
    
    /*! 分组 */
    for (id object in dataArray)
    {
        /*! 根据timezone的localename，获得对应的的section number */
        NSInteger sectionNumber = [indexCollation sectionForObject:object collationStringSelector:selector];
        /*! 根据sectionNumber获取数组 */
        NSMutableArray *sectionUserObjs = [newSectionsArray objectAtIndex:sectionNumber];
        /*! 添加对象到对应的数组中 */
        [sectionUserObjs addObject:object];
    }
    
    /*! 获取空的数组的index */
    NSMutableArray *willDeleteAry = [NSMutableArray new];
    for (int i = 0; i < newSectionsArray.count; i ++)
    {
        NSArray *tempAry = newSectionsArray[i];
        if (tempAry.count == 0) {
            [willDeleteAry addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    /*! 删除空的数组 */
    for (NSInteger i = willDeleteAry.count; i > 0; i -- )
    {
        NSInteger index = [willDeleteAry[i - 1] integerValue];
        [newSectionsArray removeObjectAtIndex:index];
        [indexArray removeObjectAtIndex:index];
    }
    
    /*! 该字典中存放分组排序呢后的索引及数据 */
    NSDictionary *dict = @{kBALocalizedGroupArrayKey : newSectionsArray,
                           kBALocalizedIndexArrayKey : indexArray};
    
    return dict;
}


@end
