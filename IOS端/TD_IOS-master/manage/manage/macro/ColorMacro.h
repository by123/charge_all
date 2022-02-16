//
//  ColorMacro.h
//  framework
//
//  Created by 黄成实 on 2018/4/17.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STColorUtil.h"



//用于button 、tab滑块、 提示性icon的配色

#define c01 ColorSet(@"#FFCE00",@"#FD5750")
#define c02 ColorSet(@"#FCE447",@"#FF7777")
//用于表单类页面的输入提示、列表的分割线配色
#define c03 [STColorUtil colorWithHexString:@"#DEDEDE"]
#define c04 [STColorUtil colorWithHexString:@"#F1F4F4"]
//用于次要提示文案的配色
#define c05 [STColorUtil colorWithHexString:@"#BDBDBD"]
#define c06 [STColorUtil colorWithHexString:@"#76ADF0"]

#define c07 [STColorUtil colorWithHexString:@"#FF4040"]
#define c08 [STColorUtil colorWithHexString:@"#FFCE00"]
#define c09 [STColorUtil colorWithHexString:@"#25262e" alpha:0.8f]
//用于主要文案、正文标题、模块标题、主要icon（例如列表页的下拉收起）配色
#define c10 [STColorUtil colorWithHexString:@"#353648"]
//用于次要文案、说明性文案、tab未选中状态、表单页面标题、操作button（例如添加、删除）、表单、列表跳转icon等配色
#define c11 [STColorUtil colorWithHexString:@"#757685"]
//用于链接跳转文案配色
#define c12 [STColorUtil colorWithHexString:@"#76ADF0"]
//用于警示、错误提示内容的配色
#define c13  [STColorUtil colorWithHexString:@"#F85429"]
//详情卡片颜色
#define c14  [STColorUtil colorWithHexString:@"#FFF29D"]

//邀请按钮
#define c15 [STColorUtil colorWithHexString:@"#DEC188"]

#define c16 [STColorUtil colorWithHexString:@"#DA8374"]
#define c17 [STColorUtil colorWithHexString:@"#F9B2A4"]

#define c18 [STColorUtil colorWithHexString:@"#E5C1B1"]
#define c19 [STColorUtil colorWithHexString:@"#C38A7B"]

#define c20 [STColorUtil colorWithHexString:@"#E69687"]
#define c21 ColorSet(@"#353648",@"#FFFFFF")
#define c22 ColorSet(@"#FFCE00",@"#353648")
#define c23 ColorSet(@"#FCE447",@"#E5C1B1")
#define c24 ColorSet(@"#DEC188",@"#FD5750")



//用于APP底色配色
#define cbg    [STColorUtil colorWithHexString:@"#F4F4F6"]
#define cwhite [STColorUtil colorWithHexString:@"#ffffff"]
#define cblack [STColorUtil colorWithHexString:@"#000000"]
#define cclear [STColorUtil colorWithHexString:@"#00000000"]
#define cline  [STColorUtil colorWithHexString:@"#DEDEDE"]

#define c_btn_txt_normal (IS_YELLOW_SKIN ? cwhite : c10)
#define c_btn_txt_highlight (IS_YELLOW_SKIN ? c10 : cwhite)

#define cwarn [UIColor colorWithRed:0xFF/255.0 green:0x54/255.0 blue:0x54/255.0 alpha:1.0]

#define ColorSet(yellow,red) (IS_YELLOW_SKIN ? [STColorUtil colorWithHexString:yellow] : [STColorUtil colorWithHexString:red])

