import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Button, Icon } from 'antd';
import { PageList } from '../../containers/PageList';
import { PageFilter } from '../../containers/PageFilter';
import { DeleteConfirmModal } from '../../components/DeleteConfirmModal';
import { action } from './store';
import { datetimeFormat, checkIsSuperAdmin, mapObjectToRadios } from '../../utils';
import { OperationLink } from '../../components/OperationLink';
import { ADD, INDEX_WIDTH, ACTION_WIDTH } from '../../utils/constants';
import { push } from '../../store/router-helper';
import { adStateList } from '../../utils/enum';

class OperationCenter extends React.Component {

  state = {
    selectedData: null,
    deleteModalVisible: false,
  }

  componentDidMount() {
    this.fetchList();
    this.props.dispatch(action.getPostionList());
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  getPosLabel = (posList, posArr) => {
    let result = posArr.map((pos) => {
      let label = '';
      posList.forEach(element => {
        if (element.value === pos.showPage) {
          label = element.label;
          return false;
        }
      });
      return label;
    });
    return result.join('，');
  }

  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(action.fetchAdList(search));
  }

  handleSubmit = () => {
    const { selectedData } = this.state;
    const { unionId } = selectedData;
    this.props.dispatch(action.untieWechat({ unionId }));
  }

  toggleDeleteModal = (visible, data) => {
    this.setState({
      selectedData: visible ? data : null,
      deleteModalVisible: visible,
    });
  }

  toggleEditModal = (editType, record) => {
    this.props.dispatch(push(`/operationCenter/adManage/${editType}/${record ? record.adId : ''}`));
  }

  fetchAdDetail = (data) => {
    const { adID } = data;
    this.props.dispatch(action.fetchAdDetail(adID));
    this.props.dispatch(action.getAdStatistic({ adID }));
  }

  handleDelete = () => {
    const { selectedData } = this.state;
    this.props.dispatch(action.delAdConfig({ ADId: selectedData.adId }, (dispatch) => {
      this.setState({
        deleteModalVisible: false,
      });
      dispatch(action.refreshAdList());
    }));
  }

  checkDetail = (data) => {
    this.props.dispatch(push(`/operationCenter/adDetail/${data.adId}`));
  }

  render() {
    const {
      location: { search },
      fetchAdListResult: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      },
      delAdConfigResult,
      profile,
    } = this.props;
    const { deleteModalVisible } = this.state;
    const isSuperAdmin = checkIsSuperAdmin(profile);
    let columns = [
      { dataIndex: 'id', title: '序号', fixed: 'left', width: INDEX_WIDTH },
      { dataIndex: 'adId', title: '广告单号', fixed: 'left', width: 140 },
      { dataIndex: 'adName', title: '广告标题' },
      {
        dataIndex: 'startTime',
        title: '广告投放时间',
        render: (text, record) => `${datetimeFormat(text)} - ${datetimeFormat(record.endTime)}`,
      },
      { dataIndex: 'adState', title: '广告状态', render: text => adStateList[text] },
      {
        dataIndex: 'x',
        title: '操作',
        fixed: 'right',
        width: ACTION_WIDTH,
        render: (_, record) => {
          const options = [
            { text: '详情', action: () => this.checkDetail(record) },
          ];
          if (record.adState === 0) {
            options.push(
              { text: '删除', action: () => this.toggleDeleteModal(true, record) },
            );
          }
          return <OperationLink options={options} />;
        },
      },
    ];

    let filterProps = {
      search,
      columns: [
        { dataIndex: 'adId', title: '广告单号' },
        { dataIndex: 'adName', title: '广告标题' },
        {
          dataIndex: 'date',
          title: '投放时间',
          type: 'dateArea',
          startKey: 'startTime',
          endKey: 'endTime',
          isTime: true,
          toZero: true,
        },
        { dataIndex: 'adState', title: '广告状态', type: 'select', list: mapObjectToRadios(adStateList) },
      ],
    };
    if (isSuperAdmin) {
      filterProps.columns.push({
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
      columns.splice(4, 0, ...[
        { dataIndex: 'mchName', title: '代理商', render: (text, record) => `${record.mchId} ${text}` },
        { dataIndex: 'totalShowCount', title: '曝光量' },
        { dataIndex: 'totalUserCount', title: '访客量' },
        { dataIndex: 'totalClickCount', title: '点击量' },
        { dataIndex: 'totalUserclickCount', title: '点击人数' },
        { dataIndex: 'clickRatio', title: '点击率' },
      ]);
    }
    const listProps = {
      loading,
      rowKey: 'adId',
      pagination: {
        current,
        total,
        pageSize,
      },
      columns,
      dataSource,
    };
    isSuperAdmin && (listProps.scroll = { x: 1400 });
    isSuperAdmin && (listProps.columns[3].width = 160);

    const selectedData = this.state.selectedData || {};
    let confirmColumns = [];
    if (selectedData) {
      confirmColumns = [
        { name: '广告单号', value: selectedData.adId },
        { name: '广告标题', value: selectedData.adName },
      ];
      isSuperAdmin && (confirmColumns.push(
        { name: '代理商', value: `${selectedData.mchId} ${selectedData.mchName}` },
      ));
    }
    return (<div className="page-order">
      <div className="content-header">
        <h2>广告管理</h2>
        <div className="operation">
          <Button className="g-btn-black" type="primary" onClick={() => this.toggleEditModal(ADD)} >
            <Icon type="plus" theme="outlined" />新建广告</Button>
        </div>
      </div>
      <PageFilter {...filterProps} />
      <div className="list-desc">
        <p>
          <span>共搜索到 {total} 条数据</span>
        </p>
      </div>
      <PageList {...listProps} />
      <div>
        <p>广告效果统计说明：</p>
        <p>曝光量：广告投放时间内，广告被看到的次数。被看到，即用户打开含有广告位的页面，即算1个曝光量；</p>
        <p>访客量：曝光量去重，即1个人多次看到广告，算作1个访客量；</p>
        <p>点击量：广告投放时间内，广告被点击的次数。被点击，即用户点击广告位，即算1个点击量；</p>
        <p>点击人数：点击量去重，即1个人点击多次，算作1个点击人数；</p>
        <p>点击率：点击量/曝光量；</p>
      </div>

      <DeleteConfirmModal
        onOk={this.handleDelete}
        onCancel={() => this.toggleDeleteModal(false)}
        loading={delAdConfigResult.loading}
        visible={deleteModalVisible}
        confirmColumns={confirmColumns}
      />

    </div>);
  }
}

OperationCenter.propTypes = {
  fetchAdListResult: PropTypes.object,
  location: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  delAdConfigResult: PropTypes.object,
  listUpdateTime: PropTypes.number.isRequired,
  getPositionListResult: PropTypes.object.isRequired,
};

OperationCenter.defaultProps = {
  fetchAdListResult: {},
  delAdConfigResult: {},
};

export default connect(({
  operationCenter: {
    fetchAdListResult,
    delAdConfigResult,
    listUpdateTime,
    getPositionListResult,
  },
  global: {
    profile,
  },
}) => ({
  fetchAdListResult,
  delAdConfigResult,
  listUpdateTime,
  getPositionListResult,
  profile,
}))(OperationCenter);
