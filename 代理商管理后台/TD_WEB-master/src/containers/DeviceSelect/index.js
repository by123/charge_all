import React from 'react';
import PropTypes from 'prop-types';
import { message, Tabs } from 'antd';
import { connect } from 'react-redux';
import { BindGroup } from '@/components/BindGroup';
import { FilterDevice } from './FilterDevice';
import { NumberInput } from '../../components/DeviceInput/NumberInput';
import { RangeInput } from '../../components/DeviceInput/RangeInput';
import { Select } from '../../components/pop/index';
import FilterItem from '../../components/FilterItem/index';
import { Card } from '../../components/Card/index';
import { UploadFile } from './UploadFile';
import { action as deviceActions } from '../../pages/Device/store';
import { action as personActions } from '../../pages/Personnel/store';
import BizSelect from '../BizSelect';
import './style.less';
import { mapArrayToOptions, splitSnInput } from '../../utils';
import { agentAccountLabel } from '../../utils/enum';

const { TabPane } = Tabs;

const colProps = {
  span: 8,
  style: {
    marginBottom: 16,
  },
};

function formatType(category) {
  return [
    'untie',
    'transfer',
    'billing',
    'taxiAdd',
    'taxiTransfer',
    'taxiUntie',
    'allocate',
    'recall',
  ].indexOf(category) > -1
    ? category
    : 'default';
}

function filterBusinessAgent(agentList) {
  return agentList.filter(agent => {
    return agent.mchType === 1;
  });
}

const currentList = {
  billing: '0',
  untie: '0',
  transfer: '0',
  default: '2',
  taxiAdd: '1',
  taxiUntie: '1',
  taxiTransfer: '4',
  allocate: '2',
  recall: '5',
};

class DeviceSelect extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      value: '',
      agent: undefined,
      current: currentList[formatType(props.type)],
      totalArray: [], // 每个tab的数量，current为索引
    };
  }

  componentDidMount() {
    if (this.props.isAdmin && ['billing', 'transfer', 'taxiTransfer'].indexOf(this.props.type) > -1) {
      this.props.dispatch(personActions.fetchAllUsers());
    }
  }

  handleValueChange = (value) => {
    const { totalArray } = this.state;
    totalArray[1] = splitSnInput(value).length;
    this.setState({
      value,
      totalArray,
    });
  }

  selectDevice = () => {
    if (this.state.current === '0') {
      if (!this.state.agent) {
        message.error('请选择商户');
        return false;
      }
      const { result } = this.props.queryDevice;
      if (!result || result.length === 0) {
        message.error('该商户下没有设备');
        return false;
      }
      return result;
    }
    if (this.state.current === '1') {
      const ids = this.state.value.trim();
      if (!ids || ids === '') {
        message.error('请输入设备编号');
        return false;
      }
      return splitSnInput(ids);
    } else if (this.state.current === '2') {
      return this.rangeInput.getIds();
    }
    const { result } = this.props.queryDevice;
    if (!result || result.length === 0) {
      message.error('请输入条件搜索设备编号');
      return false;
    }
    return result;
  }

  checkIsEditAll = () => {
    return this.state.current === '0';
  }

  // 单独新增方法给解绑和转移页使用，不影响其他页面
  getSelectedDevice = () => {
    const { current } = this.state;
    let selected = {
      current,
      result: false,
    };
    if (current === '0') {
      if (!this.state.agent) {
        message.error('请选择商户');
        return false;
      }
      const { result } = this.props.queryDeviceByMchId;
      if (!result || result.total === 0) {
        message.error('该商户下没有设备');
        return false;
      }
      selected.result = this.state.agent;
      return selected;
    } else if (current === '1') {
      const ids = this.state.value.trim();
      if (!ids || ids === '') {
        message.error('请输入设备编号');
        return false;
      }
      selected.result = splitSnInput(ids);
      return selected;
    } else if (current === '2') {
      let result = this.rangeInput.getIds('initDevice');
      result = result.length ? result : false;
      selected.result = result;
      return selected;
    } else if (current === '4') {
      let value = false;
      if (!this.state.groupId) {
        message.error('请先选择分组');
        selected.result = value;
        return selected;
      }
      const { result } = this.props.queryDeviceByMchId;
      if (!result || result.inActive === 0) {
        message.error('该商户下没有未激活的设备');
      } else {
        value = this.state.groupId;
      }
      selected.result = value;
      return selected;
    } else if (current === '5') {
      const fileList = this.uploadSnFile.getFileList();
      if (!fileList || !fileList.length) {
        message.error('请选择要上传的文件');
        return false;
      }
      selected.result = fileList;
    }
    return selected;
  }

  handleTabChange = (activeKey) => {
    // this.getChoosedDeviceNum();
    this.setState({
      current: activeKey,
      agent: undefined,
    });
  }

  handleSearchDevice = (id, selectedItem) => {
    if (Array.isArray(id)) {
      id = id[id.length - 1];
    }
    this.setState({ agent: id });

    const { type } = this.props;
    if (id) {
      if (['untie', 'transfer'].indexOf(type) > -1) {
        this.props.dispatch(deviceActions.queryDeviceByMchId({ mchId: id }));
      } else if (type === 'billing') {
        let selectedValue = {};
        if (Array.isArray(selectedItem)) {
          selectedValue = selectedItem[selectedItem.length - 1];
        }
        this.props.dispatch(deviceActions.queryDevice({ mchUserId: selectedValue.data.superUser }));
      }

      // TODO
    } else {
      this.props.dispatch(deviceActions.removeQueryDevice());
    }
  }

  handleChooseGroup = (id) => {
    this.setState({ groupId: id });
    if (id) {
      this.props.dispatch(deviceActions.queryDeviceByMchId({ groupId: id }));
    } else {
      this.props.dispatch(deviceActions.removeQueryDevice());
    }
  }

  render() {
    const {
      dispatch,
      queryDevice,
      queryAgent,
      allUsers,
      isAdmin,
      type,
      queryDeviceByMchId,
      multiple,
      groupList,
    } = this.props;
    const ids = queryDevice.result || [];
    const { totalArray } = this.state;
    const { total = 0, active = 0, inActive = 0 } = queryDeviceByMchId.result || {};
    const userList = allUsers.result || [];
    let showStep = true;
    let agentList = queryAgent.result || [];
    let agentKey = 'superUser';
    if (['untie', 'transfer'].indexOf(type) > -1) {
      agentList = filterBusinessAgent(agentList);
      agentKey = 'mchId';
    }
    let tab0Text = '设置';
    if (type === 'untie' || type === 'taxiUntie') {
      showStep = false;
      tab0Text = '解绑';
    } else if (type === 'transfer') {
      tab0Text = '转移';
    } else if (type === 'allocate') {
      tab0Text = '调拨';
    } else if (type === 'recall') {
      tab0Text = '返厂';
      showStep = false;
    }

    const tab0 = (<TabPane tab={`快速按照商户${tab0Text}`} key="0">
      <Card title={`${showStep ? '第一步：' : ''}选择商户`}>
        <div style={{ padding: 20 }}>
          <FilterItem label="商户名称">
            <div>
              {!multiple ? (<Select
                allowClear
                placeholder="请选择商户"
                value={this.state.agent}
                onChange={this.handleSearchDevice}
                style={{ width: 320 }}
              >
                {mapArrayToOptions(agentList, agentKey, agentAccountLabel)}
              </Select>) : (<BizSelect onChange={this.handleSearchDevice} />)}
            </div>
          </FilterItem>
          {this.state.agent && ['untie', 'transfer'].indexOf(this.props.type) > -1 &&
            <div style={{ marginLeft: 100, padding: 20, paddingBottom: 0 }}>
              共{total}个设备，{active}个已激活，{inActive}个未激活
            </div>
          }
          {this.state.agent && this.props.type === 'billing' &&
            <div style={{ marginLeft: 120, padding: 20, paddingBottom: 0 }}>
              共{ids.length || 0}个设备
            </div>
          }
        </div>
      </Card>
    </TabPane>);

    const tab1 = (<TabPane tab={`输入设备编号${tab0Text}`} key="1">
      <Card title={`${showStep ? '第一步：' : ''}输入设备编号`}>
        <div>
          <NumberInput value={this.state.value} onChange={this.handleValueChange} />
          {totalArray[1] !== undefined && <div className="device-total">共{totalArray[1]}个设备</div>}
        </div>
      </Card>
    </TabPane>);

    const tab2 = (<TabPane tab={`按照设备起止编号${tab0Text}`} key="2">
      <Card title={`${showStep ? '第一步：' : ''}选择设备起止编号`}>
        <div>
          <RangeInput wrappedComponentRef={instance => { this.rangeInput = instance; }} />
          {totalArray[2] !== undefined && <div className="device-total">共{totalArray[2]}个设备</div>}
        </div>
      </Card>
    </TabPane>);

    const tab3 = (<TabPane tab={`选择条件${tab0Text}`} key="3">
      <Card title={`${showStep ? '第一步：' : ''}按照搜索条件选择设备`}>
        <div>
          <FilterDevice dispatch={dispatch} colProps={colProps} isAdmin={isAdmin} userList={userList} agentList={agentList} />
          {ids.length > 0 && <p style={{ paddingLeft: 40, margin: 10 }}>已选择设备总数：{ids.length}个</p>}
        </div>
      </Card>
    </TabPane>);

    const tab4 = (<TabPane tab={`快速按照分组${tab0Text}`} key="4">
      <Card title={`${showStep ? '第一步：' : ''}选择分组`}>
        <div style={{ padding: 20 }}>
          <BindGroup dataIndax="srcGroupId" groupList={groupList} onChange={this.handleChooseGroup} />
          {this.state.groupId &&
            <div style={{ marginLeft: 100 }}>
              共{total}个设备，{active}个已激活，{inActive}个未激活
            </div>
          }
        </div>
      </Card>
    </TabPane>);

    const tab5 = (<TabPane tab={`导入表格${tab0Text}`} key="5">
      <Card title={`${showStep ? '第一步：' : ''}上传文件`}>
        <div style={{ padding: 20 }}>
          <UploadFile wrappedComponentRef={instance => { this.uploadSnFile = instance; }} />
        </div>
      </Card>
    </TabPane>);

    const tabList = {
      billing: [tab0, tab1, tab2],
      untie: [tab0, tab1, tab2],
      transfer: [tab0, tab1, tab2],
      default: [tab2, tab1, tab3],
      taxiAdd: [tab1, tab2],
      taxiUntie: [tab1, tab2],
      taxiTransfer: [tab4, tab1, tab2],
      allocate: [tab2, tab1, tab5],
      recall: [tab5],
    };
    return (<div className="select-device-wrap">
      <Tabs size="large" activeKey={this.state.current} onChange={this.handleTabChange}>
        {tabList[formatType(type)]}
      </Tabs>
    </div>);
  }
}

DeviceSelect.propTypes = {
  form: PropTypes.object,
  dispatch: PropTypes.func.isRequired,
  queryDevice: PropTypes.object.isRequired,
  queryDeviceByMchId: PropTypes.object.isRequired,
  queryAgent: PropTypes.object.isRequired,
  allUsers: PropTypes.object.isRequired,
  isAdmin: PropTypes.bool.isRequired,
  type: PropTypes.string.isRequired,
  multiple: PropTypes.bool,
  childUseable: PropTypes.bool,
  groupList: PropTypes.object,
};

DeviceSelect.defaultProps = {
  multiple: false,
  childUseable: false,
  groupList: {},
  form: {},
};

const Container = connect(({ global: { profile, authCode }, personnel: { allUsers }, device: { queryAgent, queryDevice, queryDeviceByMchId } }) => ({
  queryDevice,
  queryDeviceByMchId,
  allUsers,
  queryAgent,
  childUseable: authCode[2] === '1',
  isAdmin: profile.roleType <= 1,
}), null, null, { withRef: true })(DeviceSelect);

export { Container as DeviceSelect };
