# -*- coding: utf-8 -*-
from pyecharts import Geo
from pyecharts import Bar
from pyecharts import Map
import requests
import json
import time
import pymysql.cursors

ROOT_URL = "https://www.xhdian.com/appserver"
ORDER_LIST_URL = ROOT_URL + '/manageWeb/order/querylistPost'

headers = {
    "authorization": "Bearer;eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJtMTIzNDU2IiwibWNoSWQiOiJtMTIzNDU2IiwibWNoVHlwZSI6MiwibG9jYXRvciI6IjAiLCJyb2xlVHlwZSI6MCwiaXNzIjoicmVzdGFwaXVzZXIiLCJhdWQiOiIwOThmNmJjZDQ2MjFkMzczY2FkZTRlODMyNjI3YjRmNiIsImV4cCI6MTU1ODAwNDAxOX0.OQza_w9juJ3mXjYcZCIgpj4Z8Cvf_nR_m8NnedOAB8A",
    "content-type": "application/json"};

queryOrderId = ''
results = []


# 批量查询订单经纬度
def getOrderLocation():
    global queryOrderId
    global results
    reqData = \
        {
            "payTimeStart": "2019-05-01 00:00:00",
            "payTimeEnd": "2019-05-09 23:59:59",
            "pageSize": 100,
            "orderType": -1,
            "lastOrderId": queryOrderId
        }
    respond = requests.post(ORDER_LIST_URL, headers=headers, data=json.dumps(reqData))
    respondObj = json.loads(respond.text)
    print(respond.text)
    data = respondObj['data']
    datas = data['rows']
    nextPage = data['nextPage']
    print(nextPage)
    for data in datas:
        lat = data['latitude']
        lon = data['longitude']
        city = getCityName(lat, lon)
        if city != '':
            city = city.replace('市', '')
            same = False
            addPosition = 0
            for i, val in enumerate(results):
                if val[0] == city:
                    same = True
                    addPosition = i
                    break
            if not same:
                results.append((city, 1))
            else:
                addList = list(results[addPosition])
                addList[1] += 1
                results[addPosition] = (addList[0], addList[1])
                # results[addPosition][1] += 1
    print(results)
    print("最后一个orderId->" + queryOrderId)
    if nextPage:
        # print('还有下一页')
        queryOrderId = str(datas[len(datas) - 1]['orderId'])
        # time.sleep(3)
        getOrderLocation()
    return results


# 根据经纬度查询城市名称
def getCityName(lat, lon):
    location = str(lat) + ',' + str(lon)
    respond = requests.get(url='http://api.map.baidu.com/geocoder/v2/',
                           params={'location': location, 'ak': '4stVAdWqMFaORLbKQemA4I2p9Qs387qU', 'output': 'json'})

    result = json.loads(respond.text)
    city = result['result']['addressComponent']['city']
    return str(city)


# 创建地图点
def createMapPoint(data):
    geo = Geo("2019年5月1日-5月10日用户订单分布图", "from by.huang", title_color="#fff", title_pos="center",
              width=1280, height=640, background_color='#404a59')
    attr, value = geo.cast(data)
    geo.add("", attr, value, visual_range=[0, 2000], visual_text_color="#fff", symbol_size=10, is_visualmap=True)
    geo.show_config()
    geo.render()
    return


# # 创建地图块
# def creatMapBlock(data):
#     map = Map("2019年5月1日-5月10日用户订单分布图", "from by.huang", title_color="#fff", title_pos="center",
#               width=1280, height=640, background_color='#404a59')
#     attr, value = map.cast(data)
#     map.add("", attr, value, visual_range=[0, 50], visual_text_color="#fff",  is_visualmap=True,visual_split_number= 200,
#         geo_cities_coords= str(value),is_piecewise = True)
#     map.show_config()
#     map.render()
#     return


# 连接数据库
# def connect():
#     conn = pymysql.connect(host='RDS-huanan-rm-wz91y7q3f10fc6h4r.mysql.rds.aliyuncs.com:3306',
#                            user='opsuser',
#                            password='2019@Xhdian',
#                            db='db_charge',
#                            charset='utf8')
#     # 创建一个游标
#     cursor = conn.cursor()
#     return


# 启动
# results = [('黄石', 618), ('潍坊', 3641), ('遂宁', 191), ('莆田', 845), ('十堰', 290), ('绵阳', 290), ('铜仁', 1108), ('成都', 3939),
#            ('枣庄', 1884), ('吕梁', 491), ('邵阳', 1141), ('吉安', 6442), ('南充', 1124), ('临沂', 2933), ('聊城', 1184), ('贵阳', 567),
#            ('太原', 1393), ('襄阳', 2512), ('定西', 113), ('南阳', 1028), ('娄底', 445), ('汉中', 2420), ('郑州', 4038),
#            ('乌鲁木齐', 2150), ('长沙', 785), ('济宁', 2744), ('遵义', 1267), ('周口', 1324), ('忻州', 506), ('资阳', 320), ('东营', 561),
#            ('运城', 1332), ('呼和浩特', 1176), ('西安', 2048), ('泸州', 958), ('济南', 2115), ('淮南', 105), ('恩施土家族苗族自治州', 1579),
#            ('青岛', 1463), ('宁德', 3125), ('榆林', 873), ('菏泽', 995), ('邯郸', 1208), ('凉山彝族自治州', 587), ('崇左', 610),
#            ('孝感', 886), ('重庆', 429), ('保定', 584), ('渭南', 904), ('湖州', 114), ('宝鸡', 1535), ('延安', 822), ('漳州', 3674),
#            ('泉州', 1888), ('咸宁', 593), ('内江', 990), ('上饶', 1108), ('德州', 1362), ('阿坝藏族羌族自治州', 976), ('长治', 1243),
#            ('厦门', 567), ('石家庄', 1379), ('新余', 871), ('濮阳', 687), ('荆州', 1724), ('天津', 1281), ('柳州', 1541), ('贵港', 1330),
#            ('河池', 2097), ('抚州', 382), ('安阳', 800), ('岳阳', 424), ('随州', 380), ('衡水', 447), ('沧州', 340), ('萍乡', 1454),
#            ('宜昌', 888), ('黄冈', 563), ('赣州', 164), ('杭州', 332), ('平顶山', 324), ('百色', 1815), ('咸阳', 1273), ('阳泉', 699),
#            ('广州', 52), ('滨州', 146), ('福州', 1243), ('深圳', 142), ('广元', 773), ('兰州', 226), ('庆阳', 384), ('安康', 1354),
#            ('武汉', 1248), ('廊坊', 619), ('南平', 408), ('黄山', 985), ('晋中', 499), ('秦皇岛', 309), ('银川', 3), ('乐山', 566),
#            ('开封', 171), ('伊犁哈萨克自治州', 1529), ('邢台', 404), ('临汾', 108), ('三明', 140), ('晋城', 185), ('张家口', 838),
#            ('石河子', 4), ('常德', 53), ('鹤壁', 573), ('甘孜藏族自治州', 334), ('本溪', 239), ('南昌', 437), ('张掖', 26), ('许昌', 584),
#            ('合肥', 53), ('桂林', 429), ('眉山', 282), ('大同', 334), ('商洛', 76), ('信阳', 154), ('陇南', 1), ('德阳', 363),
#            ('潜江', 24), ('巴中', 531), ('铜川', 150), ('荆门', 575), ('龙岩', 270), ('广安', 74), ('辽源', 71), ('威海', 27),
#            ('佛山', 188), ('哈密地区', 238), ('五家渠', 9), ('昌吉回族自治州', 353), ('仙桃', 47), ('临夏回族自治州', 35), ('三门峡', 44),
#            ('沈阳', 26), ('宁波', 33), ('湘潭', 111), ('唐山', 71), ('洛阳', 57), ('滁州', 22), ('嘉兴', 30), ('河源', 7),
#            ('红河哈尼族彝族自治州', 14), ('武威', 93), ('巴音郭楞蒙古自治州', 37), ('清远', 70), ('长春', 51), ('天门', 56), ('阜阳', 68),
#            ('自贡', 67), ('拉萨', 22), ('东莞', 8), ('昆明', 25), ('莱芜', 9), ('宜春', 8), ('承德', 20), ('泰安', 64), ('吉林', 1),
#            ('鄂州', 9), ('来宾', 57), ('益阳', 31), ('永州', 19), ('北京', 30), ('潮州', 1), ('宜宾', 2), ('无锡', 1), ('金华', 1),
#            ('安顺', 2), ('温州', 9), ('阳江', 1), ('焦作', 1), ('驻马店', 3), ('兴安盟', 1), ('喀什地区', 1), ('乌兰察布', 2), ('揭阳', 1),
#            ('昌都地区', 4), ('钦州', 1), ('南宁', 2), ('海口', 3), ('日照', 1), ('烟台', 1), ('连云港', 1), ('汕尾', 1), ('台州', 1),
#            ('防城港', 1)]
# createMapPoint(results)



