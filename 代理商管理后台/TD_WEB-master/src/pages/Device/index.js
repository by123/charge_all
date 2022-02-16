import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Button, Drawer, message, Alert } from 'antd';
import { PageFilter } from '../../containers/PageFilter';
import { PageList } from '../../containers/PageList';
import { OperationLink } from '../../components/OperationLink';
import { action as deviceActions } from './store';
import { action as personActions } from '../Personnel/store';
import { deviceStatus, agentAccountColProps, agentAccountLabel } from '../../utils/enum';
import { mapObjectToRadios, dateFormat, formatIndustyToOptions, checkIsSuperAdmin } from '../../utils';
import { DeviceDetail } from '../../containers/DeviceDetail';
import { AddDeviceModal } from '../../containers/DeviceAdd/AddDeviceModal';
import { EditDeviceModal } from './EditDeviceModal';
import { BindAgentModal } from './BindAgentModal';
import ErrorList from '../../containers/ErrorList';
import { TransferDeviceModal } from './TransferDeviceModal';
import { UntieDeviceModal } from './UntieDeviceModal';
import { BindBillingModal } from './BindBillingModal';
import { ResultModal } from '../../components/Device/ResultModal';
import { EDIT, INDEX_WIDTH, ACTION_WIDTH, pattern } from '../../utils/constants';

class DevicePage extends React.Component {
  state = {
    visible: false,
    allMchAccount: [],
  }

  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(deviceActions.fetchDeviceList(search));
  }

  componentDidMount() {
    this.fetchList();
    this.queryAgent();
    this.fetchInsdustyList();
    // this.props.dispatch(deviceActions.queryAgent({ mchId: this.props.mchId }));
    if (this.props.isAdmin) {
      this.props.dispatch(personActions.fetchAllUsers());
    }
  }
  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }
  componentWillUnmount() {
    this.props.dispatch(deviceActions.removeQueryAgent());
    this.props.dispatch(deviceActions.selectedRow([], []));
  }

  onSelectChange = (selectedKeys, selectedRows) => {
    this.props.dispatch(deviceActions.selectedRow(selectedKeys, selectedRows));
  }

  fetchInsdustyList = () => {
    this.props.dispatch(deviceActions.fetchIndustryList());
  }

  openDetail = (id) => {
    this.props.dispatch(deviceActions.fetchDeviceDetail(id));
    this.setState({
      visible: true,
    });
  }

  closeDetail = () => {
    this.setState({
      visible: false,
    });
  }

  isSelected = () => {
    if (this.props.selectedKeys.length > 0) return true;
    message.info('请先选择列表条目');
    return false;
  }

  handleEditDevice = () => {
    this.isSelected() && this.props.dispatch(deviceActions.toggleEditDeviceModal(true));
  }

  handleBindAgent = () => {
    this.isSelected() && this.props.dispatch(deviceActions.toggleBindAgentModal(true));
  }

  handleEditBilling = () => {
    this.isSelected() && this.props.dispatch(deviceActions.toggleEditBillingModal(true));
  }

  handleUntieDevice = () => {
    this.isSelected() && this.props.dispatch(deviceActions.toggleUntieDeviceModal(true));
  }

  handleTransferDevice = () => {
    this.isSelected() && this.props.dispatch(deviceActions.toggleTransferDeviceModal(true));
  }

  editSingleDevice = (sn) => {
    this.props.dispatch(deviceActions.fetchDeviceDetail(sn));
    this.props.dispatch(deviceActions.toggleEditDeviceModal(true, sn));
  }

  renderAgentName = (list, type) => {
    if (type === 0) { // 商户
      const agent = list.find(item => item.mchType === 1) || {};
      return agent.mchName || '-';
    }

    // 代理商
    const agent = list.find(item => item.level === type && item.mchType === 0) || {};
    return agent.mchName || '-';
  }

  queryAgent = () => {
    const { mchId, dispatch } = this.props;
    dispatch(deviceActions.queryAgent({ mchId }));
  }

  onErrorListClose = () => {
    const { dispatch } = this.props;
    dispatch(deviceActions.toggleUntieDeviceModal(false));
    dispatch(deviceActions.toggleTransferDeviceModal(false));
    dispatch(deviceActions.refreshList());
  }

  onChangeSuccess = () => {
    this.props.dispatch(deviceActions.selectedRow([], []));
  }

  render() {
    const {
      dispatch,
      location: { search },
      allUsers,
      isAdmin,
      deviceList: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      },
      selectedKeys,
      editDevice,
      deviceResultVisible,
      queryAgent,
      editDeviceResult,
      industryList,
    } = this.props;
    const userList = allUsers.result || [];
    const agentList = queryAgent.result || [];
    const formatedDeviceStatus = { ...deviceStatus };
    const industryListResult = industryList.result || [];
    delete formatedDeviceStatus['0'];

    const validateMchId = {
      rules: [{ pattern: pattern.mchId, message: '请输入正确的代理商账号' }],
      validateTrigger: 'onBlur',
    };
    let filterColumns = [
      { dataIndex: 'sn', title: '设备编码', placeholder: '输入设备编号' },
      { dataIndex: 'state', title: '投放状态', type: 'select', list: mapObjectToRadios(formatedDeviceStatus) },
      { dataIndex: 'mchNo', title: '代理商编号', validateProps: validateMchId },
      { dataIndex: 'contactUser', title: '代理人姓名' },
      { dataIndex: 'mchName', title: '代理商名称' },
      { dataIndex: 'industry', title: '商户行业', type: 'select', list: formatIndustyToOptions(industryListResult) },
    ];
    if (isAdmin) {
      filterColumns.splice(2, 0, { dataIndex: 'userId', title: '关联业务员', type: 'select', list: userList, itemAlias: { value: 'userId', label: 'name' } });
    }
    // 后期增加功能，不能删除
    // if (isSuperAdmin) {
    //   filterColumns.unshift({
    //     dataIndex: 'mchUserId',
    //     key: 'allLstMchId',
    //     loadData: this.loadData,
    //     title: '代理商账号',
    //     changeOnSelect: true,
    //     type: 'lazyCascader',
    //     options: this.state.allMchAccount,
    //     className: 'agent-filter-item',
    //   });
    // } else {
    filterColumns.push({
      dataIndex: 'mchUserId',
      title: '代理商账号',
      type: 'select',
      colProps: agentAccountColProps,
      list: agentList,
      width: 300,
      itemAlias: { value: 'superUser', label: agentAccountLabel } });
    // }
    filterColumns.splice(2, 0, { dataIndex: 'date', title: '激活时间', type: 'dateArea', startKey: 'startTime', endKey: 'endTime' });
    const filterProps = {
      search,
      columns: filterColumns,
      onChangeSuccess: this.onChangeSuccess,
    };
    const listProps = {
      loading,
      rowKey: 'deviceSn',
      rowSelection: {
        selectedRowKeys: selectedKeys,
        onChange: this.onSelectChange,
      },
      pagination: {
        current,
        total,
        pageSize,
      },
      columns: [
        { dataIndex: 'id', title: '序号', fixed: 'left', width: INDEX_WIDTH },
        { dataIndex: 'deviceSn', title: '设备编码', fixed: 'left', width: 140 },
        { dataIndex: 'deviceState', title: '状态', render: (text) => deviceStatus[text] },
        { dataIndex: 'activeTime', title: '激活时间', render: text => dateFormat(text) },
        {
          title: '代理层级',
          children: [
            { dataIndex: 'mchList', key: 'agent1', width: 120, title: '省代', render: list => this.renderAgentName(list, 1) },
            { dataIndex: 'mchList', key: 'agent2', width: 120, title: '市代', render: list => this.renderAgentName(list, 2) },
            { dataIndex: 'mchList', key: 'agent3', width: 120, title: '区／县代', render: list => this.renderAgentName(list, 3) },
            { dataIndex: 'mchList', key: 'agent4', width: 120, title: '连锁门店', render: list => this.renderAgentName(list, 4) },
            { dataIndex: 'mchList', key: 'biz', width: 120, title: '商户', render: list => this.renderAgentName(list, 0) },
          ],
        },
        { dataIndex: 'salerName', title: '关联业务员', width: 130 },
        { dataIndex: 'place', title: '位置区域', width: 150 },
        { dataIndex: 'lastUseTime', title: '最近交易时间', render: text => dateFormat(text) },
        {
          dataIndex: 'k',
          title: '操作',
          fixed: 'right',
          width: ACTION_WIDTH,
          render: (_, record) => {
            const options = [
              { text: '查看', action: () => { this.openDetail(record.deviceSn); } },
            ];
            record.deviceState === 2 && (options.push({
              text: '编辑', action: () => { this.editSingleDevice(record.deviceSn); },
            }));
            return <OperationLink options={options} />;
          },
        },
      ],
      dataSource,
      scroll: { x: 1720 },
    };
    const deviceResult = editDeviceResult.result || [];
    return (<div className="page-device">
      <div className="content-header">
        <h2>设备管理</h2>
        {/* <div className="operation">
          <Button className="g-btn-black" type="primary" onClick={() => dispatch(deviceActions.toggleAddDeviceModal(true))} >
            <Icon type="plus" theme="outlined" />新增设备</Button>
        </div> */}
      </div>
      <PageFilter {...filterProps} />
      <div className="list-operation">
        {/* <Button onClick={this.handleEditDevice}>批量编辑设备</Button> */}
        <Button onClick={this.handleBindAgent}>批量绑定商户</Button>
        <Button onClick={this.handleEditBilling}>批量编辑计费规则</Button>
        <Button onClick={this.handleUntieDevice}>批量解绑设备</Button>
        <Button onClick={this.handleTransferDevice}>批量转移设备</Button>
      </div>
      <div className="list-desc">
        <p>共搜索到 {total} 个设备</p>
        {selectedKeys.length > 0 && <Alert showIcon message={`已选择 ${selectedKeys.length} 项数据。`} />}
      </div>
      <PageList {...listProps} />
      <AddDeviceModal />
      <EditDeviceModal />
      <BindAgentModal />
      <BindBillingModal />
      <UntieDeviceModal />
      <TransferDeviceModal />
      <Drawer title="设备详情" width="80%" visible={this.state.visible} onClose={this.closeDetail}>
        <DeviceDetail />
      </Drawer>
      <ResultModal type={EDIT} dispatch={dispatch} visible={deviceResultVisible} result={editDevice.result} />
      <ErrorList dataSource={deviceResult} onClose={this.onErrorListClose} />
    </div>);
  }
}

DevicePage.propTypes = {
  dispatch: PropTypes.func.isRequired,
  deviceList: PropTypes.object.isRequired,
  selectedKeys: PropTypes.array.isRequired,
  isAdmin: PropTypes.bool.isRequired,
  isSuperAdmin: PropTypes.bool.isRequired,
  location: PropTypes.object.isRequired,
  mchId: PropTypes.string.isRequired,
  allUsers: PropTypes.object.isRequired,
  editDevice: PropTypes.object.isRequired,
  deviceResultVisible: PropTypes.bool.isRequired,
  queryAgent: PropTypes.object.isRequired,
  industryList: PropTypes.object.isRequired,
  editDeviceResult: PropTypes.object.isRequired,
};

export default connect(({ global: { profile }, personnel: { allUsers },
  device: {
    queryAgent,
    deviceList,
    selectedKeys,
    editDevice,
    deviceResultVisible,
    editDeviceResult,
    industryList,
  } }) => ({
  deviceList,
  selectedKeys,
  allUsers,
  editDevice,
  deviceResultVisible,
  queryAgent,
  isAdmin: profile.roleType <= 1,
  isSuperAdmin: checkIsSuperAdmin(profile),
  mchId: profile.mchId,
  editDeviceResult,
  industryList,
}))(DevicePage);
