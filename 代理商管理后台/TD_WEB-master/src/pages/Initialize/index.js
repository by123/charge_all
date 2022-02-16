import React, { Component } from 'react';
import { Button, Icon, Modal, message, Radio, Divider } from 'antd';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { push } from '@/store/router-helper';
import { PageFilter } from '../../containers/PageFilter';
import { PageList } from '../../containers/PageList';
import { DeviceInitDetail } from '../../containers/DeviceInitDetail';
import ErrorList from '../../containers/ErrorList';
import { NumberInput } from '../../components/DeviceInput/NumberInput';
import { action as initializeActions } from './store';
import { action as globalActions } from '../../store/global';
import { RangeInput } from '../../components/DeviceInput/RangeInput';
import { deviceInitStatus, agentAccountLabel, agentAccountColProps } from '../../utils/enum';
import { datetimeFormat, setkey, splitSnInput } from '../../utils';
import './style.less';
import { INDEX_WIDTH, ACTION_WIDTH } from '../../utils/constants';

const RadioGroup = Radio.Group;

class InitializeList extends Component {
  state = {
    snInput: '',
    snNumber: 0,
    deleteType: 1,
  }

  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(initializeActions.fetchDeviceInitList(search));
  }
  toDeviceInit = () => {
    this.props.dispatch(push('/initialize/active'));
  }

  // setkey = (obj) => {
  //   let snList = [];
  //   let mchName = '';
  //   if (obj) {
  //     obj.forEach((item, index) => {
  //       let taskContent = JSON.parse(item.taskContent);
  //       item.snList = taskContent.snList;
  //       item.mchName = taskContent.mchName;
  //     });
  //   }
  //   return obj;
  // }
  openDetail = (taskId) => {
    this.props.dispatch(initializeActions.fetchDeviceInitDetail({ taskId }));
    this.props.dispatch(initializeActions.toggleDeviceInitDetailModal(true));
  }

  closeDetail = () => {
    this.props.dispatch(initializeActions.toggleDeviceInitDetailModal(false));
  }

  componentDidMount() {
    this.fetchList();
    this.props.dispatch(initializeActions.queryFirstAgent({ mchType: 0 }));
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  openDeleteDevice = () => {
    const { dispatch } = this.props;
    dispatch(initializeActions.toggleDeviceDelete(true));
    this.resetSnInput();
  }

  closeDeleteModal = () => {
    this.props.dispatch(initializeActions.toggleDeviceDelete(false));
    this.resetSnInput();
  }

  deleteDevice = () => {
    let { snInput, deleteType } = this.state;
    const { dispatch } = this.props;
    let deviceSnList = [];

    if (deleteType === 2) {
      snInput = snInput.trim();
      if (!snInput) {
        message.error('请输入设备编号');
        return;
      }
      deviceSnList = splitSnInput(snInput);
      if (deviceSnList.length > 100) {
        return message.error('最多添加100个设备');
      }
    } else if (deleteType === 1) {
      deviceSnList = this.rangeInput.getIds();
      if (!deviceSnList.length) {
        return;
      }
    }
    dispatch(initializeActions.deleteDevice({
      deviceSnLst: deviceSnList,
    }, (_, getState) => {
      const { deleteResult } = getState().active;
      let { result } = deleteResult;
      result = result.filter(val => {
        return !val.deleteResult;
      });
      if (result && result.length === 0) {
        dispatch(initializeActions.toggleDeviceDelete(false));
        message.success('已成功删除');
        this.resetSnInput();
      } else {
        dispatch(globalActions.toggleErrorList(true));
      }

      // const { success } = deleteResult.result;
    }));
  }

  resetSnInput = () => {
    this.setState({
      snInput: '',
      snNumber: 0,
    });
  }

  onErrorListClose = () => {
    const { dispatch } = this.props;
    dispatch(initializeActions.toggleDeviceDelete(false));
    dispatch(initializeActions.clearErrorList());
  }

  handleSnInputChange = (value) => {
    let valueArr = splitSnInput(value);
    if (valueArr.length && !valueArr[valueArr.length - 1] && !valueArr[valueArr.length - 1].length) valueArr.splice(-1, 1);
    this.setState({
      snInput: value,
      snNumber: valueArr.length,
    });
  }

  changeDeleteType = (e) => {
    this.setState({
      deleteType: e.target.value,
    });
  }

  render() {
    const {
      location: { search },
      deviceInitList: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      } = {},
      DeviceInitdetailVisible = false,
      queryFirstAgentList,
      deleteModalVisible,
      deleteResult: {
        loading: deleteLoading,
        result: deleteResult = [],
      } = {},
    } = this.props;
    const { snNumber, snInput } = this.state;
    if (dataSource) {
      setkey(dataSource);
    }
    const agentList = queryFirstAgentList.result || [];
    const filterProps = {
      search,
      columns: [
        { dataIndex: 'date', title: '新增设备出厂时间', width: 100, type: 'dateArea', startKey: 'startDate', endKey: 'endDate' },
        { dataIndex: 'mchId', title: '搜索代理商', type: 'select', colProps: agentAccountColProps, width: 300, list: agentList, itemAlias: { value: 'superUser', label: agentAccountLabel } },
      ],
    };
    const listProps = {
      loading,
      rowKey: 'id',
      pagination: {
        current,
        total,
        pageSize,
      },
      columns: [
        { dataIndex: 'index', title: '序号', fixed: 'left', width: INDEX_WIDTH },
        { dataIndex: 'createTime', title: '初始化操作日期', render: text => datetimeFormat(text) },
        {
          dataIndex: 'snList',
          title: '设备起始编号',
          render: text => {
            return (
              text.map((item, index) => {
                return (
                  <div key={index}>
                    <p>{`${item[0]}-${item[1]}`}</p>
                  </div>
                );
              })
            );
          },
        },
        { dataIndex: 'completeNum', title: '设备数量', render: text => text },
        { dataIndex: 'taskContent', title: '绑定代理商', render: text => JSON.parse(text).mchName },
        { dataIndex: 'taskStatus', title: '状态', render: text => deviceInitStatus[text] },
        {
          dataIndex: 'x',
          title: '操作',
          fixed: 'right',
          width: ACTION_WIDTH,
          render: (_, record) => {
            // const options = [
            //   { text: '查看', action: () => { this.openDetail(record.id); } },
            // ];
            // return <OperationLink options={options} />;
            return <span onClick={() => { this.openDetail(record.id); }} key={record.id} className="look-color" >查看</span>;
          },
        },
      ],
      dataSource,
    };
    const deviceInitDetailOpts = {
      visible: DeviceInitdetailVisible,
      onCancel: this.closeDetail,
      onOk: this.closeDetail,
    };
    const deleteOptions = {
      visible: deleteModalVisible,
      title: '出厂设备删除',
      width: 700,
      onCancel: this.closeDeleteModal,
      onOk: this.deleteDevice,
      confirmLoading: deleteLoading,
      destroyOnClose: true,
    };
    const { deleteType } = this.state;
    return (
      <div className="page-initialize">
        <div className="content-header">
          <h2>设备出厂</h2>
          <div className="operation">
            <Button className="g-btn-black" type="primary" onClick={this.toDeviceInit}>
              <Icon type="plus" theme="outlined" />新增设备出厂
            </Button>
            <Button className="g-btn-black" type="primary" onClick={this.openDeleteDevice}>
              <Icon type="minus" theme="outlined" />出厂设备删除
            </Button>
          </div>
        </div>
        <PageFilter {...filterProps} />
        <div className="list-desc">
          <p>共搜索到 {total} 条记录</p>
        </div>
        <PageList {...listProps} />
        <DeviceInitDetail {...deviceInitDetailOpts} />
        <Modal
          {...deleteOptions}
        >
          <RadioGroup onChange={this.changeDeleteType} value={deleteType}>
            <Radio value={1}>
              <span className="label">按设备编号起止区间删除: </span>
              <RangeInput wrappedComponentRef={instance => { this.rangeInput = instance; }} />
            </Radio>
            <Divider />
            <Radio value={2} style={{ width: '100%' }}>
              <span className="label">输入设备编号删除: </span>
              <NumberInput disabled={deleteType === 1} label="" value={snInput} onChange={this.handleSnInputChange} />
              <div className="initialize-delete-number">设备数量：{snNumber || 0}个</div>
            </Radio>
          </RadioGroup>
          {/* <NumberInput value={snInput} label="请仔细核对后，输入设备号进行批量删除：" onChange={this.handleSnInputChange} /> */}
        </Modal>
        <ErrorList dataSource={deleteResult} resultKey="deleteResult" onClose={this.onErrorListClose} />
      </div>
    );
  }
}

InitializeList.propTypes = {
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.object.isRequired,
  deviceInitList: PropTypes.object.isRequired,
  DeviceInitdetailVisible: PropTypes.bool.isRequired,
  queryFirstAgentList: PropTypes.object.isRequired,
  deleteModalVisible: PropTypes.bool.isRequired,
  deleteResult: PropTypes.object.isRequired,
};

InitializeList.defaultProps = {};

export default connect(({ active: {
  deviceInitList,
  DeviceInitdetailVisible,
  deviceInitDetail,
  queryFirstAgentList,
  deleteModalVisible,
  deleteFailVisible,
  deleteResult,
} }) => ({
  deviceInitList,
  DeviceInitdetailVisible,
  deviceInitDetail,
  queryFirstAgentList,
  deleteModalVisible,
  deleteFailVisible,
  deleteResult,
}))(InitializeList);
