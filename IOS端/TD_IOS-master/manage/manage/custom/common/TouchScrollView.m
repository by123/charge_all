//
//  TouchScrollView.m
//  gogo
//
//  Created by by.huang on 2017/10/26.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "TouchScrollView.h"
#import <MJRefresh/MJRefresh.h>

@interface TouchScrollView()<UIScrollViewDelegate>

@end

@implementation TouchScrollView{
    UIView *parentView;
}

-(instancetype)initWithParentView : (UIView *)view delegate:(id<TouchScrollViewDelegate>)delegate{
    if(self == [super init]){
        _touchScollViewDelegate = delegate;
        self.delegate = self;
        parentView = view;
        [self initSetting];
    }
    return self;
}

-(void)initSetting{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;

    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
    }
}

-(void)enableHeader{
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = header;
}


-(void)refreshNew{
    if(_touchScollViewDelegate && [_touchScollViewDelegate respondsToSelector:@selector(refreshNew)]){
        [_touchScollViewDelegate refreshNew];
    }
}

-(void)endRefreshNew{
    if(self.mj_header){
        [self.mj_header endRefreshing];
    }
}

-(void)enableFooter{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    self.mj_footer = footer;
}

-(void)uploadMore{
    if(_touchScollViewDelegate && [_touchScollViewDelegate respondsToSelector:@selector(uploadMore)]){
        [_touchScollViewDelegate uploadMore];
    }
}

-(void)endUploadMore{
    if(self.mj_footer){
        [self.mj_footer endRefreshing];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [parentView touchesBegan:touches withEvent:event];
}

-(void)noMoreData{
    if(self.mj_footer){
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

-(void)hideFooter:(Boolean)hidden{
    if(self.mj_footer){
        self.mj_footer.hidden = hidden;
    }
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_touchScollViewDelegate){
        [_touchScollViewDelegate onScrollViewDidScroll:scrollView];
    }
}


@end
