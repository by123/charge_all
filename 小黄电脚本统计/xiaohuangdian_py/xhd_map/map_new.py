# encoding:utf-8

# from pyecharts.charts import Geo,Map
# from pyecharts import options as opts
#
#
# def createGeo():
#     geo = Geo().add_schema(maptype="china").add("geo", [list(z) for z in zip(['吉安'], [10])]).set_series_opts(
#         label_opts=opts.LabelOpts(is_show=False)).set_global_opts(
#         visualmap_opts=opts.VisualMapOpts(), title_opts=opts.TitleOpts(title="测试新接口"))
#     geo.render()
#     return
#
#
# def createMap():
#     map = Map().add("商家A", [list(z) for z in zip(['江西','广东','湖南','湖北'], [90,20,45,30])], "china").set_global_opts(title_opts=opts.TitleOpts(title="Map-基本示例"),visualmap_opts=opts.VisualMapOpts())
#     map.render()
#     return
#
# createMap()



#微信下单测试
import requests
import json
import hashlib
import sys
import os.path
import urllib
import requests


url = "http://www-x-sxpth-x-cn.img.abc188.com/"
rootPath = "/Users/by.huang/Desktop/download/"

def down():
    datas = ["陈思瑜", "陈慧", "张娜", "周雪芳", "卜崇慧", "李慧", "白肖雪", "郭学晴", "李国清", "李莉", "李苓", "李玉先", "李玉先", "任小琴", "谭琴", "周波",
             "王宝良", "崔学乾", "王金伟", "胡东伟", "胡东伟", "戴飞铭", "艾亚妮", "解思源", "吴佳乐", "贺绒绒", "张珍珍", "焦斌", "田张鑫", "张咪", "张达", "赵雪",
             "周迪乐", "李荣荣", "刘彩云", "冯蕾", "冯妍", "郭世芳", "王小丽", "杨闹过", "虎来花", "虎来花", "刘霞", "杨江霞", "杨江霞", "杨梅宏", "杨瑞霞", "陈丽",
             "张雯", "苟全花", "周迪乐", "何娸", "何娸", "李菊梅", "韦雅婷", "安占钊", "鲁根社", "同建龙", "汪国兴", "田凯", "周腾飞", "贾欢", "胡兴安", "胡兴安",
             "高沐泉", "刘婷", "陈廷琪", "韩美芳", "孟娜", "段天瑞", "寇彩霞", "候盼盼", "钟慧", "李芹兰", "何岩宏", "王当巴", "焦延琴", "王硕", "冯晓超", "柯昌静",
             "云博霄", "李欣谕", "张锐锐", "王荣", "巩保利", "赵婷婷", "魏田田", "王云云", "栗芳芳", "栗芳芳", "雷伊娜", "赵英", "胡社社", "贺甜甜", "任艳艳",
             "杜亚丽", "贾若楠", "赵亚丽", "慕丽娟", "温丽婷", "刘亚亚", "张亚荣", "朱亚妮", "何小婷", "何桃红", "郑晓翠", "郑帆", "张明艳", "张明艳", "袁巧娟",
             "叶丽丽", "张娅丽", "杨亚琪", "王艳芳", "王倩倩", "孟满香", "马路红", "刘伟伟", "刘静", "李文玲", "李佩佩", "李佩佩", "李方方", "李方方", "陈欣",
             "李垚", "蒲三艳", "张福豹", "王震", "张腾", "冉梦梅", "荔建萌", "荔建萌", "何小红", "门洋", "王倩", "杨京育", "方嘉瑶", "张帆", "曹爽", "程佩",
             "程佩", "高娅娅", "郭芳", "贺薪宇", "贺秀琪", "胡荣荣", "刘宁宁", "汪思敏", "卫金芝", "许慧", "杨琴", "卜璐", "高调", "李海娜", "刘春艳", "刘海亚",
             "刘进霞", "刘静", "徐子宁", "徐子宁", "俞利利", "李瑞", "薛瑞洁", "白春琴", "代绘莉", "胡晓梅", "田路", "冯婉婷", "付晶晶", "李红霞", "高娜", "谢小英",
             "刘志刚", "韩秀丽", "李吉莉", "高锐", "金欣", "李芮娇", "刘敬", "慕亚妮", "张丽", "常荷蕊", "冯燕燕", "高慧贤", "贾敏", "雷丹丹", "刘俊芳", "卢海霞",
             "卢海霞", "孙阳敏", "魏丹丹", "吴娜", "药欢", "淡飞飞", "贺亚美", "王生蓉", "赵萍", "朱春梅", "朱春梅", "高列宁", "张悦", "范世婷", "康娟", "贺翔龙",
             "李小丽", "刘军", "吴娜娜", "薛彩霞", "张仪丹", "张议丹", "李乐", "任志雄", "高淑娟", "李静", "唐雪茹", "徐媛媛", "严婕", "张小溪", "赵焕焕", "李艳丽",
             "刘龙", "任笑笑", "高小玲", "高晓雅", "贺建芬", "贺建芬", "惠凯", "王艳", "郑振娟", "高晓瑜", "闫玉荣", "杨菊", "刘婧", "常翠翠", "陈丽", "宾春利",
             "程珊珊", "冯小梅", "刘小香", "门艳艳", "王敏", "张开惠", "陈文莲", "韩苗", "韩倩", "滕正琴", "张雅迪", "赵海梅", "朱同", "董锋艳", "李瑾", "杨珂",
             "冯琪", "古云", "何爱华", "蒋甜甜", "金彩丽", "李雪", "李雪", "刘艳芳", "彭娟", "舒丹丹", "王小顺", "王雅丽", "余春银", "张菁叶", "张静", "张云舒",
             "王英兰", "刘笑妤", "门渊媛", "王英", "杨红艳", "张未", "范佳乐", "李丹妮", "李丹", "李建慧", "刘继芳", "刘旭霞", "罗珊", "吕贝贝", "南锦", "邵犇",
             "卫军", "杨苗", "张文静", "袁东霞", "刘琴", "黄雯", "苗慧芳", "张洁", "高晋", "高晋", "秦艳红", "朱艳芳", "曹咪咪", "封帆", "封帆", "赵鑫", "宋瑞",
             "李绮", "熊小菊", "胡麟", "刘向东", "米娜瓦尔阿依古丽华蕾", "蔺文燕", "蔺文燕", "王丽君", "辛敏", "刘乐", "王雪", "王雪", "余苗", "张爱婕", "张爱婕",
             "惠富艳", "程柳", "张青", "谢越", "谢越", "刘璐", "刘璐", "胡延妮", "杨丹阳", "李存山", "王逍", "冯兰儒", "武慧", "李焕焕", "李盼丽", "张雅",
             "陈洁", "陈润", "包晋荣", "陈艳", "陈艳", "何采颖", "张伟英", "赵广妮", "张鹏", "李丁丁", "芮守强", "付思远", "胡慧敏", "戎娅晶", "唐蓉", "王珞朝",
             "王世铃", "朱婷", "邹玲", "曹桂桂", "郭艳", "韩丹丹", "胡媛媛", "李鑫", "刘艳", "史海珂", "史海珂", "王进宁", "杨蕊", "袁亮亮", "张贵宁", "马晶",
             "李亚敏", "李亚敏", "张婷", "白帆", "刘欢", "温红梅", "高海霞", "高海霞", "张帆帆", "罗艳丽", "崔蓉蓉", "张苗苗", "党恒昌", "杨晓鹏", "刘新华", "何娟",
             "何娟", "杨珊", "杨丹", "杨婷", "杨鑫", "岳玲", "朱俊蓉", "陈滨涛", "陈建军", "董芝荣", "董芝荣", "贺德珍", "刘红柳", "刘继华", "刘新华", "宋小波",
             "唐虎", "王静", "吴苗", "张欢", "张敏", "张敏", "周勋梅", "陈思瑜", "陈慧", "张娜", "周雪芳", "卜崇慧", "李慧", "白肖雪", "郭学晴", "李国清",
             "李莉", "李苓", "李玉先", "李玉先", "任小琴", "谭琴", "周波", "王宝良", "崔学乾", "王金伟", "胡东伟", "胡东伟", "戴飞铭", "艾亚妮", "解思源", "吴佳乐",
             "贺绒绒", "张珍珍", "焦斌", "田张鑫", "张咪", "张达", "赵雪", "周迪乐", "李荣荣", "刘彩云", "冯蕾", "冯妍", "郭世芳", "王小丽", "杨闹过", "虎来花",
             "虎来花", "刘霞", "杨江霞", "杨江霞", "杨梅宏", "杨瑞霞", "陈丽", "张雯", "苟全花", "周迪乐", "何娸", "何娸", "李菊梅", "韦雅婷", "安占钊", "鲁根社",
             "同建龙", "汪国兴", "田凯", "周腾飞", "贾欢", "胡兴安", "胡兴安", "高沐泉", "刘婷", "陈廷琪", "韩美芳", "孟娜", "段天瑞", "寇彩霞", "候盼盼", "钟慧",
             "李芹兰", "何岩宏", "王当巴", "焦延琴", "王硕", "冯晓超", "柯昌静", "云博霄", "李欣谕", "张锐锐", "王荣", "巩保利", "赵婷婷", "魏田田", "王云云",
             "栗芳芳", "栗芳芳", "雷伊娜", "赵英"]
    tempDatas = []
    try:
        for name in datas:
            # print(name)
            downUrl = url + name + ".jpg"
            path = rootPath + name + ".jpg"
            # print(downUrl)
            # print(path)
            r = requests.get(downUrl, timeout=10)
            # if r.status_code == 200:
            if not os.path.exists(path):
                    # print("文件存在=>" + name + ".jpg")
                # else:
                print("下载成功=>"+name+".jpg")
                with open(path, "wb") as code:
                        code.write(r.content)
                        tempDatas.append(name)
            else:
                print("文件存在")
    except Exception as ex:
        print("出错继续")
        pass
    print(tempDatas)
    return

def md5(str):
    md5Str = hashlib.md5()
    md5Str.update(str.encode("utf-8"))
    return md5Str.hexdigest()


def sha256(key, value):
    sha256Str = hashlib.sha256(key.encode("utf-8"))
    sha256Str.update(value.encode("utf-8"))
    return sha256Str.hexdigest().upper()


def trans_dict_to_xml(data_dict):  # 定义字典转XML的函数
    data_xml = []
    for k in sorted(data_dict.keys()):  # 遍历字典排序后的key
        v = data_dict.get(k)  # 取出字典中key对应的value
        if k == 'detail' and not v.startswith('<![CDATA['):  # 添加XML标记
            v = '<![CDATA[{}]]>'.format(v)
        data_xml.append('<{key}>{value}</{key}>'.format(key=k, value=v))
    return '<xml>{}</xml>'.format(''.join(data_xml)).encode('utf-8')  # 返回XML，并转成utf-8，解决中文的问题


# # mchId = '1517022871'
# # key='DsiBk0iiVIIdA5hE7QcbX8PdjcB0GuSY'
# # appid = 'wx5ec64022b475262d'
# key = '1q2w3e4r5t6y7u8i9o0p1q2w3e4r5t6y'
# mchId = '1493801212'
# appid = 'wxde5fbd426d60cb4e'
# nonceStr = '12345678901234567890123456789023'
# body = 'by666'
# out_trade_no = '12312413123'
# trade_type = 'NATIVE'
# device_info = '1000'
# notifyUrl = 'http://1s7p978583.iok.la/wxpay/notify.action'
# spbill_create_ip = '127.0.0.1'
# total_fee = '10'
#
# str = "appid="+appid+"&body="+body+"&device_info="+device_info+"&mch_id="+mchId+"&nonce_str="+nonceStr+"&notify_url="+notifyUrl+"&out_trade_no="+out_trade_no+"&spbill_create_ip="+spbill_create_ip +"&total_fee="+total_fee+"&trade_type="+trade_type
# str = str + "&key="+key
# print(str)
# sign = md5(str).upper()
# print("md5签名：" + sign)
# # sign = sha256(key,str)
# # print("sha256签名:"+sign)
#
# reqData = {"appid": appid,
#            "body": body,
#            "device_info":device_info,
#            "mch_id": mchId,
#            "nonce_str": nonceStr,
#            "notify_url": notifyUrl,
#            "out_trade_no": out_trade_no,
#            "sign": sign,
#            "spbill_create_ip": spbill_create_ip,
#            "total_fee": total_fee,
#            "trade_type": trade_type
#            }
# xml = trans_dict_to_xml(reqData)
# print(xml)
# respond = requests.post("https://api.mch.weixin.qq.com/pay/unifiedorder", data=xml)
# print(respond.content.decode())

down()
