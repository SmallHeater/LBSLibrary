//
//  CityListViewController.m
//  LBSDemo
//
//  Created by xianjunwang on 17/5/13.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "CityListViewController.h"
#import "NSString+ChineseCharactersToSpelling.h"

#define MAINSCREENSIZE [UIScreen mainScreen].bounds.size


@interface CityListViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
//自定义导航
@property (nonatomic,strong) UIView * navView;
//搜索
@property (nonatomic,strong) UISearchBar * citySearchBar;
//表格
@property (nonatomic,strong) UITableView * cityTableView;
//数据数组
@property(nonatomic,strong) NSMutableArray * dataArray;
//城市首字母数组
@property (nonatomic,strong)NSMutableArray *initialsArray;

//表格使用的数据数组
@property (nonatomic,strong) NSMutableArray * showDataArray;
@end

@implementation CityListViewController

#pragma mark  ----  生命周期函数
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    [self addView];
    NSLog(@"3");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  自定义函数

#pragma mark  ----  返回响应
-(void)backBtnClicked{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)addView{
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.citySearchBar];
    [self.view addSubview:self.cityTableView];
}

#pragma mark    获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)initials:(NSString *)aString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

#pragma mark  ----  数组排序
- (void)quickSortArray:(NSMutableArray *)array withLeftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex
{
    if (leftIndex >= rightIndex) {//如果数组长度为0或1时返回
        return ;
    }
    
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    //记录比较基准数
    NSString *keyCity = array[i];
    NSString *keyCityLetter = [NSString lowercaseSpellingWithChineseCharacters:keyCity];
    while (i < j) {
        
        NSString *pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:array[j]];
        /**** 首先从右边j开始查找比基准数小的值 ***/
        while (i < j && [pinyinSecond compare:keyCityLetter] == NSOrderedAscending) {//如果比基准数大，继续查找
            j--;
        }
        //如果比基准数小，则将查找到的小值调换到i的位置
        array[i] = array[j];
        
        /**** 当在右边查找到一个比基准数小的值时，就从i开始往后找比基准数大的值 ***/
        while (i < j && [pinyinSecond compare:keyCityLetter] == NSOrderedDescending) {//如果比基准数小，继续查找
            i++;
        }
        //如果比基准数大，则将查找到的大值调换到j的位置
        array[j] = array[i];
        
    }
    
    //将基准数放到正确位置
    array[i] = keyCity;
    /**** 递归排序 ***/
    //排序基准数左边的
    [self quickSortArray:array withLeftIndex:leftIndex andRightIndex:i - 1];
    //排序基准数右边的
    [self quickSortArray:array withLeftIndex:i + 1 andRightIndex:rightIndex];
}

#pragma mark  ----  代理
#pragma mark  ----  UITableViewDataSource

#pragma mark  ----  显示每组标题索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.initialsArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.showDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary * dic = self.showDataArray[section];
    NSArray * rowsArray = dic.allValues[0];
    return rowsArray.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary * dic = self.showDataArray[section];
    NSString * title = dic.allKeys[0];
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cityCell = [tableView dequeueReusableCellWithIdentifier:@"city"];
    if (!cityCell) {
        cityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"city"];
        cityCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary * cityDic = self.showDataArray[indexPath.section];
    NSArray * cityArray = cityDic.allValues;
    cityCell.textLabel.text = cityArray[0][indexPath.row];
    NSLog(@"4");
    return cityCell;
}
#pragma mark  ----  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * selectedDic = self.showDataArray[indexPath.section];
    NSArray * valueArray = selectedDic.allValues;
    NSString * selectedCity = valueArray[0][indexPath.row];
    UIAlertController * selectedCityAlert = [UIAlertController alertControllerWithTitle:@"选中城市" message:selectedCity preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [selectedCityAlert addAction:cancleAction];
    [selectedCityAlert addAction:sureAction];
    [self presentViewController:selectedCityAlert animated:YES completion:^{
        
    }];
}

#pragma mark  ----  懒加载
#pragma mark  ----  导航
-(UIView *)navView{
    
    if (!_navView){
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENSIZE.width, 64)];
        _navView.backgroundColor = [UIColor whiteColor];
        
        
        UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        backBtn.frame = CGRectMake(20, 20, 40, 40);
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:backBtn];
    }
    return _navView;
}
#pragma mark  ----  搜索框
-(UISearchBar *)citySearchBar{
    
    if (!_citySearchBar){
        _citySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, MAINSCREENSIZE.width, 60)];
    }
    return _citySearchBar;
}

#pragma mark  ----  列表
-(UITableView *)cityTableView{
    
    if (!_cityTableView){
        _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 124, MAINSCREENSIZE.width, MAINSCREENSIZE.height - 124) style:UITableViewStylePlain];
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;
    }
    return _cityTableView;
}

#pragma mark  ----  数据源
-(NSMutableArray *)dataArray{
    if (!_dataArray)
    {
        NSMutableArray * cityArray = [[NSMutableArray alloc] initWithObjects:@"北京",@"深圳",@"天津",@"上海",@"芜湖",@"日照",@"邢台",@"广州",@"阿拉善盟",@"拉萨",@"济南",@"青岛",@"枣庄",@"烟台",@"济宁",@"莱芜",@"菏泽",@"临沂",@"泰安",@"潍坊",@"淄博",@"石家庄",@"张家口",@"唐山",@"秦皇岛",@"廊坊",@"保定",@"沧州",@"衡水",@"邢台",@"邯郸市",@"郑州",@"安阳",@"鹤壁",@"濮阳",@"新乡",@"焦作",@"三门峡",@"开封",@"洛阳",@"商丘",@"许昌",@"平顶山",@"周口",@"漯河",@"南阳",@"驻马店",@"信阳", nil];
        [self quickSortArray:cityArray withLeftIndex:0 andRightIndex:cityArray.count - 1];
       _dataArray = [NSMutableArray arrayWithArray:cityArray];
    }
    return _dataArray;
}




#pragma mark  ----  城市首字母数组
-(NSMutableArray *)initialsArray{
    if (!_initialsArray)
    {
        NSMutableArray * tempInitialsArray = [NSMutableArray array];
        for (NSString * city in self.dataArray) {
            NSString * initials = [self initials:city];
            [tempInitialsArray addObject:initials];
        }
        //    对首字母数组去重，排序
        NSSet * initials = [NSSet setWithArray:tempInitialsArray];
        [tempInitialsArray removeAllObjects];
        tempInitialsArray = nil;
        NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:YES]];
        _initialsArray = [NSMutableArray arrayWithArray:[initials sortedArrayUsingDescriptors:sortDesc]];
    }
    return _initialsArray;
}

#pragma mark  ----  表格使用的数据数组
-(NSMutableArray *)showDataArray{
    if (!_showDataArray)
    {
        _showDataArray = [[NSMutableArray alloc] init];
        
        for (int i =0; i < self.initialsArray.count; i++) {
            NSString * key = self.initialsArray[i];
            NSMutableArray * dataArrayCopy = [self.dataArray copy];
            NSMutableArray * keyValueArray = [NSMutableArray array];
            for (NSString * city in dataArrayCopy) {
                NSString * initials = [self initials:city];
                if ([initials isEqualToString:key])
                {
                    [keyValueArray addObject:city];
                    [self.dataArray removeObject:city];
                }
            }
            
            NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:keyValueArray,key, nil];
            [_showDataArray addObject:dic];
        }
    }
    return _showDataArray;
}



@end
