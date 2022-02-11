import requests
import json
import demjson


rootUrl = 'https://www.weikeyingxiao.com/appserver'
creatOrderUrl = rootUrl + '/miniApp/order/createChargeOrderForBossHuangTest'
getLastOrderUrl = rootUrl + '/miniApp/order/getLastOrderState'
closeOrderUrl = rootUrl + '/miniApp/order/closeOrder?orderId='
getOrderDetailUrl = rootUrl + '/miniApp/order/getOrderDetail?orderId='

startSn = 7770001000080000
endSn = 7770001000090000

headers =  \
    {
        "content-type": "application/json",
            "authorization": "Bearer;eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJVNjc2NzQ0Nzk3Iiwib3BlbmlkIjoib0RTOVc0MTNWYkhWMVpaWnlxY2tUYTU4bldEQSIsInNlc3Npb25LZXkiOiJqTndERWdmRkduVENsK0czVkZzcVRnPT0iLCJ0b2tlblR5cGUiOiIwIiwiaXNzIjoicmVzdGFwaXVzZXIiLCJhdWQiOiJVNjc2NzQ0Nzk3IiwiZXhwIjoxNTU3NzQzMjU4fQ.zGbDLfTSyGAnaLowq55coZBEZm4q3jqN8KIue_aWstc",
            
            };

###################创建订单###################
def createOrder():


    json_data = \
               {
                "deviceSn":startSn,
                "latitude":22.53332,
                "longitude":113.93041,
                "location":"",
                "renewFlag":0,
                "scale":3,
                "formId":"the formId is a mock one",
                "model":"iPhone 7 Plus",
                "brand":"devtools",
                "system":"iOS 10.0.1",
                "version":"6.6.3",
                "platform":"devtools"
                }
    createRequest = requests.post(creatOrderUrl , headers = headers, data = json.dumps(json_data))
    print("创建订单成功=>orderId=\n"+ createRequest.text)
    return getLastOrder()

#########################################################


###################获取充电密码###################

def getLastOrder():
   lastOrderRequest = requests.get(getLastOrderUrl , headers = headers)
   jsonObj = json.loads(lastOrderRequest.text)
   data = jsonObj['data']
   status = jsonObj['status']
   if status == "0":
       orderId = data['orderId']
       print("当前订单号=>\n"+orderId)
       password = data['password']
       print("获取最后一笔订单的密码=>\n"+password)
       psw = getPassword(orderId)
       print("通过订单获取的密码=>\n"+psw)
       if password == psw :
           closeOrder(orderId)
           return 1
       else:
           return 0
   else :
       print("网络异常")
       return -1




#########################################################




###################结束订单###################
def closeOrder(orderId):
    closeOrderReq = requests.get(closeOrderUrl + orderId, headers = headers)
    print("结束订单返回=>\n"+closeOrderReq.text)
    return

#########################################################


###################根据订单号获取密码###################
def getPassword(orderId):
   getPasswordReq = requests.get(getOrderDetailUrl + orderId, headers = headers)
   jsonObj = json.loads(getPasswordReq.text)
   data = jsonObj['data']
   tblOrder = data['tblOrder']
   password = tblOrder['pwd']
   return password

#########################################################


#main

count = 0
while (endSn >= startSn):
    result = createOrder()
    if result == 1:
        startSn = startSn + 1
        count = count + 1
        print("----------------------密码匹配，已创建" + str(count) + "个订单----------------------")
    elif result == -1:
        print("##########################网络异常##########################")
    else :
        print("###########################密码不匹配###########################")




