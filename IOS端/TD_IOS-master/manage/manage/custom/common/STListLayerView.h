//
//  STListLayerView.h
//  manage
//
//  Created by by.huang on 2019/1/7.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol STListLayerViewDelegate <NSObject>

-(void)onListLayerItemSelected:(NSString *)item position:(NSInteger)position;

@end


@interface STListLayerView : UIView
@property(weak, nonatomic)id<STListLayerViewDelegate> delegate;

-(instancetype)initWithDatas:(NSMutableArray *)datas left:(CGFloat)left top:(CGFloat)top;


@end

NS_ASSUME_NONNULL_END
