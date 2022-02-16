import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Button, Icon, Alert, message } from 'antd';
import { PageFilter } from '../../containers/PageFilter';
import { PageList } from '../../containers/PageList';
import { DeleteConfirmModal } from '../../components/DeleteConfirmModal';
import { action } from './store';
import { datetimeFormat, mapObjectToRadios } from '../../utils';
import { noticeType } from '../../utils/enum';
import { push } from '../../store/router-helper';
import { OperationLink } from '../../components/OperationLink';

class NoticeManagePage extends React.Component {

  state = {
    selectedData: null,
  }

  componentDidMount() {
    this.fetchList();
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  onSelectChange = (selectedKeys, selectedRows) => {
    this.props.dispatch(action.selectedRow(selectedKeys, selectedRows));
  }

  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(action.fetchNoticeList(search));
  }

  openUntieConfirm = (data) => {
    this.setState({
      selectedData: data,
    });
    this.props.dispatch(action.toggleUntieComfirm(true));
  }

  handleSubmit = () => {
    const { selectedData } = this.state;
    const { unionId } = selectedData;
    this.props.dispatch(action.untieWechat({ unionId }));
  }

  closeModal = () => {
    this.props.dispatch(action.toggleUntieComfirm(false));
    this.setState({
      selectedData: null,
    });
  }

  addNotice = () => {
    this.props.dispatch(push('/operationCenter/notice/add'));
  }

  checkDetail = (record) => {
    const { id } = record;
    this.props.dispatch(push(`/operationCenter/notice/detail/${id}`));
  }

  onDeleteNotice = (record) => {
    this.setState({
      selectedData: record,
    });
    this.toggleDeleteModal(true);
  }

  deleteNotice = () => {
    const { selectedData } = this.state;
    const { dispatch } = this.props;
    dispatch(action.delNotice({ id: selectedData.id }, () => {
      this.toggleDeleteModal(false);
      dispatch(action.refreshNoticeList());
      message.success('删除通知成功');
    }));
  }

  renderTarget = (text) => {
    let result = noticeType[String(text)];
    result = text === -1 ? '全部' : result;
    return result;
  }

  toggleDeleteModal = (visible) => {
    this.props.dispatch(action.toggleDeleteModal(visible));
  }

  render() {
    const {
      location: { search },
      fetchNoticeListResult: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      },
      visible,
      selectedKeys,
      delNoticeResult,
    } = this.props;
    let listData = dataSource || [];

    let filterProps = {
      search,
      columns: [
        { dataIndex: 'mchType', title: '推送对象', type: 'select', list: mapObjectToRadios(noticeType) },
        // { dataIndex: 'beginTime', title: '推送时间', type: 'datePicker', format: 'YYYY-MM-DD HH:mm:ss' },
      ],
    };
    let columns = [
      { dataIndex: 'index', title: '序号' },
      { dataIndex: 'title', title: '公告标题' },
      { dataIndex: 'mchType', title: '推送对象', render: text => this.renderTarget(text) },
      { dataIndex: 'publishTime', title: '推送时间', render: text => datetimeFormat(text) },
      {
        dataIndex: 'x',
        title: '操作',
        render: (_, record) => {
          const options = [
            { text: '详情', action: () => { this.checkDetail(record); } },
          ];
          if (record.noticeState === 0) {
            options.push({ text: '删除', action: () => { this.onDeleteNotice(record); } });
          }
          return <OperationLink options={options} />;
        },
      },
    ];
    const listProps = {
      loading,
      rowKey: 'id',
      rowSelection: {
        selectedRowKeys: selectedKeys,
        onChange: this.onSelectChange,
      },
      pagination: {
        current,
        total,
        pageSize,
      },
      columns,
      dataSource: listData,
    };
    const selectedData = this.state.selectedData || {};
    let confirmColumns = [];
    if (selectedData) {
      confirmColumns = [
        { name: '公告标题', value: selectedData.title },
        { name: '推送对象', value: this.renderTarget(selectedData.mchType) },
      ];
    }

    return (<div className="page-order">
      <div className="content-header">
        <h2>消息列表</h2>
      </div>
      <PageFilter {...filterProps} />
      <div className="list-desc">
        <p>
          <span>共 {total} 条数据</span>
          {/* <Button
            style={{ marginLeft: 30 }}
            className="g-btn-black"
            type="primary"
            onClick={() => this.checkDownload(total)}
          >
            批量删除
          </Button> */}
          <Button
            style={{ marginLeft: 30 }}
            className="g-btn-black"
            type="primary"
            onClick={() => this.addNotice()}
          >
            <Icon type="plus" theme="outlined" />新建通知
          </Button>
        </p>
        {selectedKeys.length > 0 && <Alert style={{ marginTop: 10 }} message={`已选择 ${selectedKeys.length} 项数据。`} />}
      </div>
      <PageList {...listProps} />
      <DeleteConfirmModal
        onOk={this.deleteNotice}
        onCancel={() => this.toggleDeleteModal(false)}
        loading={delNoticeResult.loading}
        visible={visible}
        message="是否确认删除该通知"
        confirmColumns={confirmColumns}
      />
    </div>);
  }
}

NoticeManagePage.propTypes = {
  fetchNoticeListResult: PropTypes.object,
  confirmVisible: PropTypes.bool,
  location: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  untieWechatResult: PropTypes.object,
  delNoticeResult: PropTypes.object,
  visible: PropTypes.bool.isRequired,
};

NoticeManagePage.defaultProps = {
  fetchNoticeListResult: {},
  confirmVisible: false,
  untieWechatResult: {},
  delNoticeResult: {},
};

export default connect(({
  operationCenter: {
    fetchNoticeListResult,
    confirmVisible,
    untieWechatResult,
    selectedKeys,
    deleteModalVisible,
    delNoticeResult,
  } }) => ({
  fetchNoticeListResult,
  confirmVisible,
  untieWechatResult,
  selectedKeys,
  visible: deleteModalVisible,
  delNoticeResult,
}))(NoticeManagePage);
