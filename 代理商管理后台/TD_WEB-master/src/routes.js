import React from 'react';
import { Route, Switch } from 'react-router';
import Loadable from 'react-loadable';
import { Spin } from 'antd';

import MainLayout from './pages/MainLayout';
import DocPage from '../docs/';
import { NotFound, NotPermission, ServerCrash } from './pages/error';

const Loading = () => (<div style={{ paddingTop: 100, textAlign: 'center' }}>
  <Spin size="large" />
</div>);

const asyncComponent = (component) => {
  return Loadable({
    loader: component,
    loading: Loading,
  });
};

const Login = asyncComponent(() => import(/* webpackChunkName: "login" */ './pages/Login'));
const Dashboard = asyncComponent(() => import(/* webpackChunkName: "Dashboard" */ './pages/Dashboard'));
const Agent = asyncComponent(() => import(/* webpackChunkName: "Agent" */ './pages/Agent'));

const Device = asyncComponent(() => import(/* webpackChunkName: "Device" */ './pages/Device'));
const EditBillingPage = asyncComponent(() => import(/* webpackChunkName: "Device/Edit" */ './pages/Device/EditBillingPage'));
const TransferDevicePage = asyncComponent(() => import(/* webpackChunkName: "Device/Transfer" */ './pages/Device/TransferDevicePage'));
const BindAgentPage = asyncComponent(() => import(/* webpackChunkName: "Device/Edit" */ './pages/Device/BindAgentPage'));

const Order = asyncComponent(() => import(/* webpackChunkName: "Order" */ './pages/Order'));
const Money = asyncComponent(() => import(/* webpackChunkName: "Money" */ './pages/Money'));
const Personnel = asyncComponent(() => import(/* webpackChunkName: "Personnel" */ './pages/Personnel'));
const Account = asyncComponent(() => import(/* webpackChunkName: "Account" */ './pages/Account'));

const InitializeList = asyncComponent(() => import(/* webpackChunkName: "Initialize" */ './pages/Initialize'));
const InitializeActive = asyncComponent(() => import(/* webpackChunkName: "Initialize" */ './pages/Initialize/InitializeActive'));
const ProductionStatistic = asyncComponent(() => import(/* webpackChunkName: "ProductionStatistic" */ './pages/Initialize/ProductionStatistic'));
const ProductionLogin = asyncComponent(() => import(/* webpackChunkName: "ProductionLogin" */ './pages/Initialize/ProductionLoginPage'));
const SnConfigPage = asyncComponent(() => import(/* webpackChunkName: "ProductionLogin" */ './pages/Initialize/SnConfigPage'));
const DeviceAllocate = asyncComponent(() => import(/* webpackChunkName: "DeviceAllocate" */ './pages/Initialize/DeviceAllocate'));
const DeviceRecall = asyncComponent(() => import(/* webpackChunkName: "DeviceRecall" */ './pages/Initialize/DeviceRecallPage'));

const FinanceCenter = asyncComponent(() => import(/* webpackChunkName: "FinanceCenter" */ './pages/FinanceCenter'));
const FinanceBill = asyncComponent(() => import(/* webpackChunkName: "FinanceBill" */ './pages/FinanceCenter/FinanceBillPage'));
const WithdrawalManage = asyncComponent(() => import(/* webpackChunkName: "FinanceCenter" */ './pages/FinanceCenter/WithdrawalManage'));
const ReportCenter = asyncComponent(() => import(/* webpackChunkName: "ReportCenter" */ './pages/ReportCenter'));
const DeviceReportPage = asyncComponent(() => import(/* webpackChunkName: "DeviceReportPage" */ './pages/ReportCenter/DeviceReportPage'));
const MchHomeWrapPage = asyncComponent(() => import(/* webpackChunkName: "MchHomeWrapPage" */ './pages/ReportCenter/MchHomeWrapPage'));
const ServiceCenter = asyncComponent(() => import(/* webpackChunkName: "ServiceCenter" */ './pages/ServiceCenter'));
const PhoneResolveRecordPage = asyncComponent(() => import(/* webpackChunkName: "PhoneResolveRecordPage" */ './pages/ServiceCenter/PhoneResolveRecordPage'));
const ComplainReportPage = asyncComponent(() => import(/* webpackChunkName: "ComplainReportPage" */ './pages/ServiceCenter/ComplainReportPage'));
const OperationCenter = asyncComponent(() => import(/* webpackChunkName: "OperationCenter" */ './pages/OperationCenter'));
const AdManage = asyncComponent(() => import(/* webpackChunkName: "AdManage" */ './pages/OperationCenter/AdManagePage'));
const EditAdConfigPage = asyncComponent(() => import(/* webpackChunkName: "EditAdConfigPage" */ './pages/OperationCenter/EditAdConfigPage'));
const AdDetail = asyncComponent(() => import(/* webpackChunkName: "AdDetail" */ './pages/OperationCenter/AdDetailPage'));
const NoticeManagePage = asyncComponent(() => import(/* webpackChunkName: "NoticeManagePage" */ './pages/OperationCenter/NoticeManagePage'));
const NoticeEditPage = asyncComponent(() => import(/* webpackChunkName: "NoticeEditPage" */ './pages/OperationCenter/NoticeEditPage'));

const GroupManage = asyncComponent(() => import(/* webpackChunkName: "GroupManage" */ './pages/Taxi/Group/GroupManage'));
const TaxiDevice = asyncComponent(() => import(/* webpackChunkName: "TaxiDevice" */ './pages/Taxi/Device'));
const TaxiOrder = asyncComponent(() => import(/* webpackChunkName: "TaxiOrder" */ './pages/Taxi/Order'));
const AddToGroup = asyncComponent(() => import(/* webpackChunkName: "AddToGroup" */ './pages/Taxi/Device/AddToGroup'));
const TaxiDeviceTransfer = asyncComponent(() => import(/* webpackChunkName: "AddToGroup" */ './pages/Taxi/Device/TransferDevicePage'));
const AfterSales = asyncComponent(() => import(/* webpackChunkName: "AddToGroup" */ './pages/Taxi/AfterSales'));

// 测试页面
const Playground = asyncComponent(() => import(/* webpackChunkName: "Playground" */ './pages/playground/index'));
const UploadPage = asyncComponent(() => import(/* webpackChunkName: "Playground" */ './pages/playground/upload'));
const MultiUploadPage = asyncComponent(() => import(/* webpackChunkName: "Playground" */ './pages/playground/upload/multi-upload'));
const TableDemoPage = asyncComponent(() => import(/* webpackChunkName: "Playground" */ './pages/playground/table'));
const FormDemoPage = asyncComponent(() => import(/* webpackChunkName: "Playground" */ './pages/playground/form'));
const ModalPage = asyncComponent(() => import(/* webpackChunkName: "Playground" */ './pages/playground/modal'));
const TreeDemoPage = asyncComponent(() => import(/* webpackChunkName: "Playground" */ './pages/playground/tree'));
const SortListPage = asyncComponent(() => import(/* webpackChunkName: "Playground" */ './pages/playground/sort-list'));

const routes = (
  <Switch>
    <Route exact path="/login" component={Login} />
    <Route exact path="/upload" component={UploadPage} />
    <Route path="/doc/:docType/:filename" component={DocPage} />
    <Route path="/" component={MainLayout} />
  </Switch>
);

export const childRoutes = (
  <Switch>
    <Route exact path="/" component={Dashboard} />
    <Route exact path="/agent" component={Agent} />
    <Route exact path="/device/editBilling" component={EditBillingPage} />
    <Route exact path="/device/bindAgent" component={BindAgentPage} />
    <Route exact path="/device/bindBusiness" component={BindAgentPage} />
    <Route exact path="/device/transfer" component={TransferDevicePage} />
    <Route exact path="/device/untie" component={TransferDevicePage} />
    <Route exact path="/device" component={Device} />
    <Route exact path="/order" component={Order} />
    <Route exact path="/money" component={Money} />
    <Route exact path="/personnel" component={Personnel} />
    <Route exact path="/account" component={Account} />

    <Route exact path="/initialize" component={InitializeList} />
    <Route exact path="/initialize/active" component={InitializeActive} />
    <Route exact path="/initialize/productionStatistic" component={ProductionStatistic} />
    <Route exact path="/initialize/productionLogin" component={ProductionLogin} />
    <Route exact path="/initialize/snConfig" component={SnConfigPage} />
    <Route exact path="/initialize/deviceAllocate" component={DeviceAllocate} />
    <Route exact path="/initialize/deviceRecall" component={DeviceRecall} />

    <Route exact path="/financeCenter" component={FinanceCenter} />
    <Route exact path="/financeCenter/withdrawalManage" component={WithdrawalManage} />
    <Route exact path="/financeCenter/financeBill" component={FinanceBill} />

    <Route exact path="/serviceCenter" component={ServiceCenter} />
    <Route exact path="/serviceCenter/phoneResolveRecord" component={PhoneResolveRecordPage} />
    <Route exact path="/serviceCenter/complainReport" component={ComplainReportPage} />

    <Route exact path="/reportCenter" component={ReportCenter} />
    <Route exact path="/reportCenter/mchHomePage/:category/:mchId" component={MchHomeWrapPage} />
    <Route exact path="/reportCenter/device" component={DeviceReportPage} />
    <Route exact path="/operationCenter" component={OperationCenter} />
    <Route exact path="/operationCenter/adManage" component={AdManage} />
    <Route exact path="/operationCenter/adDetail/:id" component={AdDetail} />
    <Route path="/operationCenter/adManage/:editType/:id?" component={EditAdConfigPage} />
    <Route exact path="/operationCenter/notice" component={NoticeManagePage} />
    <Route path="/operationCenter/notice/:editType/:id?" component={NoticeEditPage} />

    <Route exact path="/taxi/group/groupManage" component={GroupManage} />
    <Route exact path="/taxi/device" component={TaxiDevice} />
    <Route exact path="/taxi/order" component={TaxiOrder} />
    <Route exact path="/taxi/device/addToGroup" component={AddToGroup} />
    <Route exact path="/taxi/device/transfer/:action" component={TaxiDeviceTransfer} />
    <Route exact path="/taxi/afterSales" component={AfterSales} />

    {/* 测试页面 */}
    {process.env.PUBLISH_ENV !== 'production' && [
      <Route key="/playground" path="/playground" component={Playground} />,
      <Route key="/form" path="/form" component={FormDemoPage} />,
      <Route key="/multiUpload" path="/multiUpload" component={MultiUploadPage} />,
      <Route key="/table" path="/table" component={TableDemoPage} />,
      <Route key="/modal" path="/modal" component={ModalPage} />,
      <Route key="/sort" path="/sort" component={SortListPage} />,
      <Route key="/tree" path="/tree" component={TreeDemoPage} />,
    ]}
    <Route path="/403" component={NotPermission} />
    <Route path="/500" component={ServerCrash} />
    <Route component={NotFound} />
    {/* 写在这里的路由均无效，因为已经被*匹配走了 */}
  </Switch>
);

export default routes;
