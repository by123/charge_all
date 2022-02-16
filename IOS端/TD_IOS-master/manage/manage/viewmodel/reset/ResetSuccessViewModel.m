//
//  ResetSuccessViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "ResetSuccessViewModel.h"

@implementation ResetSuccessViewModel

-(void)doCall{
    NSString *callPhone = IS_YELLOW_SKIN ? [NSString stringWithFormat:@"telprompt://%@",@"4008818319"] : [NSString stringWithFormat:@"telprompt://%@",@"4008915518"];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

@end
