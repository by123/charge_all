import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Button, Icon, Alert, Drawer, message } from 'antd';
import { PageFilter } from '../../containers/PageFilter';
import { PageList } from '../../containers/PageList';
import { OperationLink } from '../../components/OperationLink';
import { AgentDetail } from '../../containers/AgentDetail';
import { EditAgentModal } from '../../containers/AgentEdit/EditAgentModal';
import { AddProfitModal } from '../../containers/AgentAddProfit/AddProfitModal';
import { AgentDeleteModal } from '../../containers/AgentDeleteModal';
import { action as agentActions } from './store';
import { action as personActions } from '../Personnel/store';
import { action as deviceActions } from '../Device/store';
import {
  dateFormat,
  formatDecimal,
  concatLabel,
  formatAgentSelect,
  formatAgentType,
  checkIsSuperAdmin,
} from '../../utils';
import { AGENT, BIZ, INDEX_WIDTH, ACTION_WIDTH_LARGE, ACTION_WIDTH, CHAIN, STORE, pattern } from '../../utils/constants';
import { AgentTransferModal } from './AgentTransferModal';

const mchTypeList = [
  { label: '代理商', value: 0 },
  { label: '商户', value: 1 },
  { label: '连锁门店', value: 2 },
];

class AgentPage extends React.Component {
  state = {
    // selectedKeys: [],
    id: null,
    visible: false,
    mchType: null,
    allMchAccount: [],
    selectedRowData: {},
  }

  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(agentActions.fetchAgentList(search));
  }

  componentDidMount() {
    this.props.dispatch(personActions.fetchAllUsers());
    this.props.dispatch(deviceActions.queryAgent({ mchId: this.props.mchId }, () => {
      this.setState({
        allMchAccount: formatAgentSelect(this.props.queryAgent.result || []),
      });
    }));
    this.fetchList();
    this.checkCanAddAgent();
    this.props.dispatch(deviceActions.fetchIndustryList());
  }

  checkCanAddAgent = () => {
    const { dispatch } = this.props;
    dispatch(agentActions.fetchSelfInfo());
    // dispatch();
  }

  componentWillUnmount() {
    this.props.dispatch(agentActions.selectedRow([], []));
    this.props.dispatch(deviceActions.removeQueryAgent());
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  onSelectChange = (selectedKeys, selectedRows) => {
    this.props.dispatch(agentActions.selectedRow(selectedKeys, selectedRows));
  }

  openDetail = (mchType, id) => {
    this.props.dispatch(agentActions.fetchAgentDetail(id));
    this.setState({
      visible: true,
      mchType,
    });
  }

  closeDetail = () => {
    this.setState({
      visible: false,
    });
  }

  openAddProfitModel = () => {
    const { dispatch, selectedKeys } = this.props;
    if (selectedKeys.length > 0) {
      dispatch(agentActions.showAddProfitModal());
    } else {
      message.info('请先选择列表条目');
    }
  }

  toggleDeleteModal = (visible, record = {}) => {
    this.props.dispatch(personActions.toggleDeleteModal(visible));
    this.setState({
      selectedRowData: record,
    });
  }

  handleDelete = () => {
    const { selectedRowData } = this.state;
    this.props.dispatch(agentActions.deleteAgent({
      mchId: selectedRowData.mchId,
    }, () => {
      this.fetchList();
      message.success('代理商/商户删除成功');
      this.toggleDeleteModal(false);
    }));
  }

  transferAgent = () => {
    const { selectedKeys, dispatch } = this.props;
    let errMsg = '';
    if (!selectedKeys || !selectedKeys.length) {
      errMsg = '请选择要转移的代理商或商户';
    } else if (selectedKeys.length !== 1) {
      errMsg = '不支持同时转移多个代理商';
    }
    if (errMsg) {
      message.error(errMsg);
      return;
    }
    dispatch(agentActions.queryTransferAgentInfo({ mchId: selectedKeys[0] }));
    dispatch(agentActions.toggleTransferAgentModal(true));
  }

  render() {
    const {
      location: { search },
      dispatch,
      selectedKeys,
      allUsers,
      isAdmin,
      agentData: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      },
      selfInfo,
      authCode,
      deleteResult,
      isSuperAdmin,
    } = this.props;
    const { selectedRowData } = this.state;
    const userList = allUsers.result || [];
    const validateMchId = {
      rules: [{ pattern: pattern.mchId, message: '请输入正确的代理商账号' }],
      validateTrigger: 'onBlur',
    };
    const validateMobile = {
      rules: [{ pattern: pattern.mobile, message: '请输入正确的手机号' }],
      validateTrigger: 'onBlur',
    };
    let filterColumns = [
      { dataIndex: 'contactName', title: '代理人姓名' },
      { dataIndex: 'mchName', title: '代理商名称' },
      { dataIndex: 'mchNo', title: '代理商编号', validateProps: validateMchId },
      { dataIndex: 'mchUserMobile', title: '代理商手机', validateProps: validateMobile },
      { dataIndex: 'mchForm', title: '代理商类型', type: 'select', list: mchTypeList },
    ];
    if (isAdmin) {
      filterColumns.push({ dataIndex: 'salesId', title: '关联业务员', type: 'select', list: userList, itemAlias: { value: 'userId', label: 'name' } });
    }
    filterColumns.push({
      dataIndex: 'lstMchId',
      title: '代理商账号',
      type: 'agentFilter',
      isFull: true,
      changeOnSelect: true,
      childUseable: authCode[0] === '1',
      showAll: true,
      width: 250,
    });

    const filterProps = {
      search,
      columns: filterColumns,
    };
    const listProps = {
      loading,
      rowKey: 'mchId',
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
        { dataIndex: 'superUser', title: '代理商账号', fixed: 'left', width: 150 },
        {
          dataIndex: 'mchType',
          title: '代理商类型',
          render: (text, record) => formatAgentType(text, record.level),
        },
        { dataIndex: 'mchName', width: 120, title: '代理商名称' },
        {
          title: '代理商总数',
          children: [{
            title: '市代',
            dataIndex: 'agentLevel2Total',
          }, {
            title: '区／县代',
            dataIndex: 'agentLevel3Total',
          }, {
            title: '连锁门店',
            dataIndex: 'agentLevel4Total',
          }, {
            title: '商户',
            dataIndex: 'tenantTotal',
          }],
        },
        { dataIndex: 'deviceTotal', title: '设备总数' },
        { dataIndex: 'deviceActiveTotal', title: '激活数' },
        { dataIndex: 'transTotal', title: '订单数' },
        { dataIndex: 'moneyTotalYun', title: '订单总金额', render: text => formatDecimal(text) },
        { dataIndex: 'totalPercent', title: '分润比例', render: text => concatLabel(text, '%') },
        { dataIndex: 'contactUser', title: '代理人姓名', width: 120 },
        { dataIndex: 'contactPhone', title: '代理人电话' },
        { dataIndex: 'salesName', title: '关联业务员' },
        { dataIndex: 'createTime', title: '账号创建日期', render: text => dateFormat(text) },
        {
          dataIndex: 'p',
          title: '操作',
          fixed: 'right',
          width: isSuperAdmin ? ACTION_WIDTH_LARGE : ACTION_WIDTH,
          render: (_, record) => {
            const options = [
              { text: '查看', action: () => { this.openDetail(record.mchType, record.mchId); } },
              { text: '编辑', action: () => { dispatch(agentActions.showEditAgent(record.mchType, record.mchId, record.level)); } },
            ];
            isSuperAdmin && options.push({ text: '删除', action: () => { this.toggleDeleteModal(true, record); } });
            return <OperationLink options={options} />;
          },
        },
      ],
      dataSource,
      scroll: { x: 1700 },
    };
    const drawerTitle = this.state.mchType === 0 ? '代理商详情' : '商户详情';
    const confirmColumns = [
      { name: '代理商名称', value: selectedRowData.mchName },
      { name: '代理商类型', value: formatAgentType(selectedRowData.mchType, selectedRowData.level) },
      { name: '代理商账号', value: selectedRowData.superUser },
    ];
    const deleteLoading = deleteResult.result ? deleteResult.result.loading : false;

    return (<div className="page-agent">
      <div className="content-header">
        <h2>代理商管理</h2>
        <div className="operation">
          {selfInfo.level < 3 && <Button
            className="g-btn-black"
            type="primary"
            onClick={() => dispatch(agentActions.showAddAgent(AGENT))}
          >
            <Icon type="plus" theme="outlined" />添加子代理
          </Button>}
          {selfInfo.level < 4 && <Button
            className="g-btn-black"
            type="primary"
            onClick={() => dispatch(agentActions.showAddAgent(CHAIN))}
          ><Icon type="plus" theme="outlined" />添加连锁门店</Button>}
          {selfInfo.level === 4 && <Button
            className="g-btn-black"
            type="primary"
            onClick={() => dispatch(agentActions.showAddAgent(STORE))}
          ><Icon type="plus" theme="outlined" />添加分店</Button>}
          {selfInfo.level !== 4 && <Button
            className="g-btn-black"
            type="primary"
            onClick={() => dispatch(agentActions.showAddAgent(BIZ))}
          ><Icon type="plus" theme="outlined" />添加商户</Button>}
        </div>
      </div>
      <PageFilter {...filterProps} />
      {isAdmin && <div className="list-operation">
        <Button onClick={this.openAddProfitModel}>批量编辑分润比例</Button>
        {isSuperAdmin && <Button onClick={this.transferAgent}>代理商转移</Button>}
      </div>}
      <div className="list-desc">
        <p>共搜索到 {total} 条数据</p>
        {selectedKeys.length > 0 && <Alert showIcon message={`已选择 ${selectedKeys.length} 项数据。`} />}
      </div>
      <PageList {...listProps} />
      <Drawer title={drawerTitle} width="80%" visible={this.state.visible} onClose={this.closeDetail}>
        <AgentDetail />
      </Drawer>
      <EditAgentModal />
      <AddProfitModal />
      <AgentTransferModal />
      <AgentDeleteModal onOk={this.handleDelete} loading={deleteLoading} confirmColumns={confirmColumns} />
    </div>);
  }
}

AgentPage.propTypes = {
  agentData: PropTypes.object,
  selectedKeys: PropTypes.array.isRequired,
  selfInfo: PropTypes.object,
  selectedAgents: PropTypes.array.isRequired,
  deleteResult: PropTypes.object,
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.object.isRequired,
  mchId: PropTypes.string.isRequired,
  queryAgent: PropTypes.object.isRequired,
  allUsers: PropTypes.object.isRequired,
  isAdmin: PropTypes.bool.isRequired,
  authCode: PropTypes.string.isRequired,
  isSuperAdmin: PropTypes.bool.isRequired,
};

AgentPage.defaultProps = {
  agentData: {},
  selfInfo: {},
  deleteResult: {},
};


export default connect(({ global: { profile, authCode },
  personnel: { allUsers },
  agent: { agentData, selectedKeys, selfInfo, selectedAgents, deleteResult },
  device: { queryAgent } }) => ({
  agentData,
  selectedKeys,
  allUsers,
  selfInfo,
  isAdmin: profile.roleType <= 1,
  mchId: profile.mchId,
  isSuperAdmin: checkIsSuperAdmin(profile),
  queryAgent,
  selectedAgents,
  authCode,
  deleteResult,
}))(AgentPage);
