//
//  WhiteListScopeView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WhiteListScopeView.h"
#import "WTScopeCell.h"


@interface WhiteListScopeView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)WhiteListScopeViewModel *mViewModel;
@property(strong, nonatomic)UITableView *tableView;
//列表显示数据池
@property(strong, nonatomic)NSMutableArray *tableDatas;
//数据总池
@property(strong, nonatomic)NSMutableArray *allDatas;

@end

@implementation WhiteListScopeView

-(instancetype)initWithViewModel:(WhiteListScopeViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        _tableDatas = [[NSMutableArray alloc]init];
        _allDatas = [[NSMutableArray alloc]init];
        [self initView];
    }
    return self;
}


-(void)initView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight-STHeight(50))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView useDefaultProperty];
    
    [self addSubview:_tableView];
    
    NSString *btnText = @"确定";
    if(_mViewModel.from == WHITELIST_FROM_EDIT){
        btnText = @"修改";
    }
    UIButton *confirmBtn = [[UIButton alloc]initWithFont:STFont(18) text:btnText textColor:c_btn_txt_highlight backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
    confirmBtn.frame = CGRectMake(0, ContentHeight - STHeight(50), ScreenWidth, STHeight(50));
    [confirmBtn addTarget:self action:@selector(onConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableDatas count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(50);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WTScopeCell *cell = [tableView dequeueReusableCellWithIdentifier:[WTScopeCell identify]];
    NSInteger position = indexPath.row;
    if(!cell){
        cell = [[WTScopeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[WTScopeCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_tableDatas)){
        cell.selectBtn.tag = position;
        [cell updateData:[_tableDatas objectAtIndex:indexPath.row] position:position];
        [cell.selectBtn addTarget:self action:@selector(onSelectImageClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WTScopeModel *model = [_tableDatas objectAtIndex:indexPath.row];
    //如果是商户或者连锁分店,不查询下级
    if(model.mchType == 1){
        return;
    }
    model.isExpand = !model.isExpand;
    if(_mViewModel.from == WHITELIST_FROM_CREATE){
        if(model.isExpand){
            if(model.isQuery){
                //将子级的缓存数据显示出来
                [self showChildDatas:model.mchId];
            }else{
                model.isQuery = YES;
                [_mViewModel queryChildDatas:model.mchId selected:model.selected position:indexPath.row];
            }
        }else{
            NSMutableArray *childDatas = [[NSMutableArray alloc]init];
            for(WTScopeModel *tempModel in _tableDatas){
                if([tempModel.parentAgencyId isEqualToString:model.mchId]){
                    tempModel.isHidden = YES;
                    [childDatas addObject:tempModel];
                }
            }
            [self deleteDatas:childDatas];
        }
        
    }else{
        if(model.isExpand){
            if(model.isQuery){
                //将子级的缓存数据显示出来
                [self showChildDatas:model.mchId];
            }else{
                model.isQuery = YES;
                [_mViewModel requestScopeList:model.mchId selected:model.selected position:indexPath.row];
            }
        }else{
            NSMutableArray *childDatas = [[NSMutableArray alloc]init];
            for(WTScopeModel *tempModel in _tableDatas){
                if([tempModel.parentAgencyId isEqualToString:model.mchId]){
                    tempModel.isHidden = YES;
                    [childDatas addObject:tempModel];
                }
            }
            [self deleteDatas:childDatas];
        }
    }

    [_tableView reloadData];

}


//展开列表，添加元素
-(void)addDatas:(NSMutableArray *)addDatas position:(NSUInteger)position{
    WS(weakSelf)
    [_allDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(position == (weakSelf.allDatas.count - 1)){
            [weakSelf.allDatas addObjectsFromArray:addDatas];
        }else{
            NSRange range = NSMakeRange(position+1, addDatas.count);
            NSIndexSet *indexSet= [NSIndexSet indexSetWithIndexesInRange:range];
            [weakSelf.allDatas insertObjects:addDatas atIndexes:indexSet];
        }

        *stop = YES;
    }];
    [self handleTableDatas];
}


//收起列表，删除元素
-(void)deleteDatas:(NSMutableArray *)deleteDatas{
    WS(weakSelf)
    [_allDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for(WTScopeModel *deleteModel in deleteDatas){
            WTScopeModel *model = [weakSelf.allDatas objectAtIndex:idx];
            if([model.mchId isEqualToString:deleteModel.mchId]){
                model.isExpand = NO;
                model.isHidden = YES;
            }
            //下级如果有展开
            if(deleteModel.isExpand){
                //循环删除多级数据
                NSMutableArray *childDatas = [[NSMutableArray alloc]init];
                for(WTScopeModel *tempModel in weakSelf.allDatas){
                    if([tempModel.parentAgencyId isEqualToString:deleteModel.mchId]){
                        [childDatas addObject:tempModel];
                    }
                }
                [self deleteDatas:childDatas];
            }
        }
    }];
    [self handleTableDatas];
}

//tableDatas上的数据同步allDatas
-(void)handleTableDatas{
    [_tableDatas removeAllObjects];
    WS(weakSelf)
    [_allDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WTScopeModel *model = obj;
        if(!model.isHidden){
            [weakSelf.tableDatas addObject:obj];
        }
    }];
    [_tableView reloadData];
    [STLog print:@"所有数据量" content:[NSString stringWithFormat:@"%lu",(unsigned long)_allDatas.count]];
    [STLog print:@"展示数据量" content:[NSString stringWithFormat:@"%lu",(unsigned long)_tableDatas.count]];
}

//显示已经查过的子级数据
-(void)showChildDatas:(NSString *)mchId{
    for(WTScopeModel *model in _allDatas){
        if([model.parentAgencyId isEqualToString:mchId]){
            model.isHidden = NO;
        }
    }
    [self handleTableDatas];
}

-(void)onSelectImageClicked:(id)sender{
    NSInteger position = ((UIButton *)sender).tag;
    WTScopeModel *model = [_tableDatas objectAtIndex:position];
    if(model.selected == WHITELIST_SELECT_ALL){
        model.selected = WHITELIST_SELECT_NONE;
    }else{
        model.selected = WHITELIST_SELECT_ALL;
    }
    [self handleChildSelect:model];
    [self handleParentSelect:model];
    [self handleTableDatas];
    [_tableView reloadData];
}



//处理子级选中状态
-(void)handleChildSelect:(WTScopeModel *)model{
//    if(model.isExpand){
        //如果子级已经展开，那么子集跟随父级的选中状态
        for(WTScopeModel *tempModel in _allDatas){
            if([tempModel.parentAgencyId isEqualToString:model.mchId]){
                tempModel.selected = model.selected;
                //循环改变子级的子级等等的选中状态
                [self handleChildSelect:tempModel];
            }
        }
//    }
}


//处理父级选中状态
-(void)handleParentSelect:(WTScopeModel *)model{
    //判断子级是否都选中
    Boolean isSelectAll = YES;
    Boolean isSelectOne = NO;
    for(WTScopeModel *tempModel in _allDatas){
        if([tempModel.parentAgencyId isEqualToString:model.parentAgencyId]){
            if(tempModel.selected){
                //同级有一个选中记录，则为半选中
                isSelectOne = YES;
            }else{
                //同级有一个未选中，则不为全选中
                isSelectAll = NO;
            }
        }
    }
    //改变父级选中状态
    for(WTScopeModel *tempModel in _allDatas){
        if([model.parentAgencyId isEqualToString:tempModel.mchId]){
            if(isSelectAll){
                tempModel.selected = WHITELIST_SELECT_ALL;
            }else if(!isSelectAll && isSelectOne){
                tempModel.selected = WHITELIST_SELECT_HALF;
            }else{
                tempModel.selected = WHITELIST_SELECT_NONE;
            }
            //循坏改变父级的父级等等的选中状态
            [self handleParentSelect:tempModel];
        }
    }
}


//处理第一个选中的状态
-(void)handleFirstSelect:(WTScopeModel *)model{
    //判断子级是否都选中
    Boolean isSelectAll = YES;
    Boolean isSelectOne = NO;
    for(WTScopeModel *tempModel in _allDatas){
        if([tempModel.parentAgencyId isEqualToString:model.mchId]){
            if(tempModel.selected){
                //同级有一个选中记录，则为半选中
                isSelectOne = YES;
            }else{
                //同级有一个未选中，则不为全选中
                isSelectAll = NO;
            }
        }
    }
    //改变父级选中状态
    if(isSelectAll){
        model.selected = WHITELIST_SELECT_ALL;
    }else if(!isSelectAll && isSelectOne){
        model.selected = WHITELIST_SELECT_HALF;
    }else{
        model.selected = WHITELIST_SELECT_NONE;
    }
    
}


-(void)updateView:(int)position{
    if(position == -1){
        [_tableDatas addObjectsFromArray:_mViewModel.scopeDatas];
        [_allDatas addObjectsFromArray:_mViewModel.scopeDatas];
    }else{
        WTScopeModel *tableModel = [_tableDatas objectAtIndex:position];
        NSString *mchId = tableModel.mchId;
        WS(weakSelf)
        [_allDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WTScopeModel *model = obj;
            if([mchId isEqualToString:model.mchId]){
                [weakSelf addDatas:weakSelf.mViewModel.scopeDatas position:idx];
                *stop = YES;
            }
        }];
        //如果是修改，并且查询的是第一级，则根据子集的选中状态判断父级的选中状态
        if(position == 0 && (_mViewModel.from == WHITELIST_FROM_EDIT)){
            [self handleFirstSelect:[_tableDatas objectAtIndex:0]];
        }
    }
    [self handleFirstSelect:_tableDatas[0]];
    [self handleTableDatas];
    [_tableView reloadData];
}

-(void)onConfirmBtnClick{
    if(_mViewModel){
        if(_mViewModel.from == WHITELIST_FROM_CREATE){
           [_mViewModel saveSelect:_allDatas];
        }else if(_mViewModel.from == WHITELIST_FROM_EDIT){
            [_mViewModel goEditWhiteListPage:_allDatas];
        }
    }
}

@end

