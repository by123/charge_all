import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Button, Icon, Drawer, message } from 'antd';
import moment from 'moment';
import { PageFilter } from '../../containers/PageFilter';
import { PageList } from '../../containers/PageList';
import { OperationLink } from '../../components/OperationLink';
import { PhoneResolveDetail } from './PhoneResolveDetail';
import { action as serviceCenterActions } from './store';
import { action as initializeActions } from '../Initialize/store';
import { action as orderActions } from '../Order/store';
import { datetimeFormat, mapObjectToRadios, addDateZero, addEndTime } from '../../utils';
import { INDEX_WIDTH, ACTION_WIDTH_LARGE, DETAIL, EDIT } from '../../utils/constants';
import { EditComplainModal } from '../../containers/EditComplainModal';
import { DeleteConfirmModal } from '../../components/DeleteConfirmModal';
import { complaintsType, resolveType } from '../../utils/enum';
import { push } from '../../store/router-helper';

class PhoneResolveRecordPage extends React.Component {
  state = {
    selectedRowData: {},
    hasOrder: false,
  }

  componentDidMount() {
    const { location: { query } } = this.props;
    this.getAllCustomer();
    this.getDeviceVersion();
    if (!query.beginTime && !query.endTime) {
      const today = moment().format('YYYY-MM-DD');
      const beginTime = addDateZero(today, true);
      const endTime = addEndTime(today, true);
      this.props.dispatch(push(`/serviceCenter/phoneResolveRecord?beginTime=${beginTime}&endTime=${endTime}`));
      return;
    }
    this.fetchList();
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(serviceCenterActions.getTelComplainList(search));
  }

  getAllCustomer = () => {
    this.props.dispatch(serviceCenterActions.getAllCustomer());
  }

  getDeviceVersion = () => {
    this.props.dispatch(initializeActions.getVersionList());
  }

  openDetail = (id, orderId, editType = DETAIL) => {
    const { dispatch } = this.props;
    dispatch(serviceCenterActions.getTelComplainDetail({ id }));
    if (orderId) {
      dispatch(orderActions.fetchOrderDetail({ orderId }));
    }
    dispatch(serviceCenterActions.togglePhoneResolveDetail(true, id, editType));
    this.setState({
      hasOrder: !!orderId,
    });
  }

  togglePhoneResolveDetail = (visible) => {
    this.props.dispatch(serviceCenterActions.togglePhoneResolveDetail(visible));
  }

  toggleDeleteModal = (visible, record) => {
    if (visible) {
      this.setState({
        selectedRowData: record,
      });
    }
    this.props.dispatch(serviceCenterActions.toggleDeleteModal(visible));
  }

  handleDelete = () => {
    const { selectedRowData } = this.state;
    this.props.dispatch(serviceCenterActions.delTelComplain({
      id: selectedRowData.id,
    }, () => {
      this.fetchList();
      message.success('客服处理记录删除成功');
      this.toggleDeleteModal(false);
    }));
  }

  handleGoSummary = () => {
    this.props.dispatch(push('/serviceCenter/complainReport'));
  }

  toggleEditCompainModal = (visible) => {
    this.props.dispatch(serviceCenterActions.toggleCustomerModal(visible));
  }

  render() {
    const {
      location: { search },
      getTelComplainListResult: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      },
      editTelComplainResult,
      getProblemListResult,
      versionListResult,
      getAllCustomerResult: {
        result: customerList = [],
      },
      deleteModalVisible,
      phoneResolveDetailVisible,
      editType,
    } = this.props;
    const { selectedRowData, hasOrder } = this.state;
    const complainTypeList = getProblemListResult.result || {};
    let versionList = versionListResult.result || [];
    versionList = versionList.map(item => {
      item.label = `V${item.deviceVersion}`;
      return item;
    });
    let filterColumns = [
      { dataIndex: 'orderId', title: '订单编号' },
      { dataIndex: 'deviceSn', title: '设备编号' },
      {
        dataIndex: 'deviceVersion',
        title: '设备版本',
        type: 'select',
        list: versionList,
        itemAlias: { value: 'deviceVersion', label: 'label' },
      },
      {
        dataIndex: 'handlerUserId',
        title: '处理客服',
        type: 'select',
        list: customerList,
        itemAlias: { value: 'userId', label: 'name' },
      },
      { dataIndex: 'problemType', title: '设备投诉问题', type: 'select', list: mapObjectToRadios(complainTypeList) },
      { dataIndex: 'complainType', title: '投诉类型', type: 'select', list: mapObjectToRadios(complaintsType) },
      { dataIndex: 'time', title: '提交时间', type: 'dateArea', startKey: 'beginTime', endKey: 'endTime' },
    ];

    filterColumns.push({
      dataIndex: 'mchId',
      title: '代理商账号',
      type: 'agentFilter',
      isFull: true,
      changeOnSelect: true,
      childUseable: true,
      showAll: false,
      width: 350,
      showMchId: true,
    });

    const filterProps = {
      search,
      columns: filterColumns,
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
        { dataIndex: 'telephone', title: '来电号码', width: 150 },
        {
          dataIndex: 'complainType',
          title: '投诉类型',
          render: text => complaintsType[text],
        },
        { dataIndex: 'problemState', title: '解决情况', render: text => resolveType[text] },
        { dataIndex: 'orderId', title: '订单编号', render: text => text || '-' },
        { dataIndex: 'deviceSn', title: '设备编号', render: text => text || '-' },
        { dataIndex: 'deviceVersion', title: '设备版本', render: text => (text !== null ? `V${text}` : '-') },
        { dataIndex: 'problemType', title: '设备投诉问题', render: text => complainTypeList[text] },
        { dataIndex: 'handlerUserName', title: '处理客服' },
        { dataIndex: 'createTime', title: '提交时间', render: text => datetimeFormat(text) },
        {
          dataIndex: 'p',
          title: '操作',
          fixed: 'right',
          width: ACTION_WIDTH_LARGE,
          render: (_, record) => {
            const options = [
              { text: '查看', action: () => this.openDetail(record.id, record.orderId) },
              { text: '编辑', action: () => this.openDetail(record.id, record.orderId, EDIT) },
              { text: '删除', action: () => { this.toggleDeleteModal(true, record); } },
            ];
            return <OperationLink options={options} />;
          },
        },
      ],
      dataSource,
      scroll: { x: 1400 },
    };
    const drawerTitle = '客服处理详情';
    const confirmColumns = [
      { name: '来电号码', value: selectedRowData.telephone },
      { name: '解决情况', value: resolveType[selectedRowData.problemState] },
      { name: '处理客服', value: selectedRowData.handlerUserName },
    ];

    return (<div className="page-agent">
      <div className="content-header">
        <h2>400电话处理</h2>
        <div className="operation">
          <Button
            className="g-btn-black"
            type="primary"
            onClick={this.handleGoSummary}
          >数据汇总</Button>
          <Button
            className="g-btn-black"
            type="primary"
            onClick={() => this.toggleEditCompainModal(true)}
          ><Icon type="plus" theme="outlined" />新增客服处理</Button>
        </div>
      </div>
      <PageFilter {...filterProps} />
      <div className="list-desc">
        <p>共搜索到 {total} 条数据</p>
      </div>
      <PageList {...listProps} />
      <Drawer
        title={drawerTitle}
        width="80%"
        visible={phoneResolveDetailVisible}
        onClose={() => this.togglePhoneResolveDetail(false)}
      >
        <PhoneResolveDetail editType={editType} hasOrder={hasOrder} />
      </Drawer>
      <EditComplainModal onOk={this.fetchList} />
      <DeleteConfirmModal
        onOk={this.handleDelete}
        title="确认删除此条数据？"
        onCancel={() => this.toggleDeleteModal(false)}
        loading={editTelComplainResult.loading}
        visible={deleteModalVisible}
        confirmColumns={confirmColumns}
      />
    </div>);
  }
}

PhoneResolveRecordPage.propTypes = {
  getTelComplainListResult: PropTypes.object.isRequired,
  getProblemListResult: PropTypes.object.isRequired,
  versionListResult: PropTypes.object.isRequired,
  getAllCustomerResult: PropTypes.object.isRequired,
  deleteModalVisible: PropTypes.bool.isRequired,
  phoneResolveDetailVisible: PropTypes.bool.isRequired,
};

PhoneResolveRecordPage.defaultProps = {
};

const mapStateToProps = ({
  serviceCenter: {
    getTelComplainListResult,
    editTelComplainResult,
    getProblemListResult,
    getAllCustomerResult,
    deleteModalVisible,
    phoneResolveDetailVisible,
  },
  active: {
    versionListResult,
  },
}) => ({
  getTelComplainListResult,
  editTelComplainResult,
  getProblemListResult,
  versionListResult,
  getAllCustomerResult,
  deleteModalVisible,
  phoneResolveDetailVisible,
});

export default connect(mapStateToProps)(PhoneResolveRecordPage);
