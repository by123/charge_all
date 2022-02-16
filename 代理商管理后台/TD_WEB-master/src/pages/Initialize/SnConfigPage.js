import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Button, Icon, Modal, message } from 'antd';
import { PageList } from '../../containers/PageList';
import { PageFilter } from '../../containers/PageFilter';
import { OperationLink } from '../../components/OperationLink';
import { action } from './store';
import { wireTypes1 } from '../../utils/enum';
import { dateFormat } from '../../utils';
import { EDIT, INDEX_WIDTH, ACTION_WIDTH, ADD } from '../../utils/constants';
import { AddSnConfigModal } from './AddSnConfigModal';

class SnConfigPage extends React.Component {
  state = {
    deleteModalVisible: false,
    selectedRowData: {},
  };

  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(action.fetchSnConfigList(search));
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  componentDidMount() {
    this.fetchList();
    this.props.dispatch(action.getVersionList());
  }

  handleAddSn() {
    this.toggleAddModal(true);
  }

  toggleAddModal(visible, editType = ADD, record) {
    this.props.dispatch(action.toggleAddModal(visible, editType, record));
  }

  confirmDelete = (record) => {
    this.setState({
      deleteModalVisible: true,
      selectedRowData: record,
    });
  }

  closeDeleteModal = () => {
    this.setState({
      deleteModalVisible: false,
    });
  }

  deleteSnConfig = () => {
    const { selectedRowData } = this.state;
    this.props.dispatch(action.deleteSnConfig({
      id: selectedRowData.id,
    }, () => {
      this.closeDeleteModal();
      this.props.dispatch(action.refreshSnConfigList());
      message.success('SN配置删除成功');
    }));
  }

  render() {
    const {
      snConfigListResult: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      },
      deleteSnConfigResult,
      location: {
        search,
      },
    } = this.props;
    let filterColumns = [
      { dataIndex: 'sn', title: '设备编号', placeholder: '请输入设备编号' },
    ];
    const filterProps = {
      search,
      columns: filterColumns,
      onChangeSuccess: this.onChangeSuccess,
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
        { dataIndex: 'index', title: '序号', width: INDEX_WIDTH },
        { dataIndex: 'createTime', title: '创建时间', render: text => dateFormat(text) },
        { dataIndex: 'deviceType', title: '设备类型', render: (text) => wireTypes1[text] },
        { dataIndex: 'deviceSnRightBegin', title: '设备起止编号', render: (text, record) => (`${text} - ${record.deviceSnRightEnd}`) },
        { dataIndex: 'countDevice', title: '设备数量' },
        { dataIndex: 'deviceVersion', title: '版本号', render: text => `V${text}` },
        {
          dataIndex: 'k',
          title: '操作',
          fixed: 'right',
          width: ACTION_WIDTH,
          render: (_, record) => {
            const options = [
              { text: '编辑', action: () => { this.toggleAddModal(true, EDIT, record); } },
              { text: '删除', action: () => { this.confirmDelete(record); } },
            ];
            return <OperationLink options={options} />;
          },
        },
      ],
      dataSource,
    };
    const deleteOptions = {
      visible: this.state.deleteModalVisible,
      title: 'SN号段删除',
      onCancel: this.closeDeleteModal,
      onOk: this.deleteSnConfig,
      confirmLoading: deleteSnConfigResult.loading,
      destroyOnClose: true,
    };
    return (<div className="page-device">
      <div className="content-header">
        <h2>SN号管理</h2>
        <Button className="g-btn-black" style={{ marginLeft: 20 }} type="primary" onClick={() => this.handleAddSn()}>
          <Icon type="plus" theme="outlined" />新建号段
        </Button>
      </div>
      <PageFilter {...filterProps} />
      <PageList {...listProps} />
      <Modal {...deleteOptions} >
        <div>删除后将会导致对应号段的设备无法使用，是否确定删除</div>
        {/* <NumberInput value={snInput} label="请仔细核对后，输入设备号进行批量删除：" onChange={this.handleSnInputChange} /> */}
      </Modal>
      <AddSnConfigModal />
    </div>);
  }
}

SnConfigPage.propTypes = {
  dispatch: PropTypes.func.isRequired,
  snConfigListResult: PropTypes.object.isRequired,
  selectedRowData: PropTypes.object,
  deleteSnConfigResult: PropTypes.object,
  location: PropTypes.object.isRequired,
};

SnConfigPage.defaultProps = {
  selectedRowData: {},
  deleteSnConfigResult: {},
};

export default connect(({
  active: {
    snConfigListResult,
    selectedRowData,
    deleteSnConfigResult,
  } }) => ({
  snConfigListResult,
  selectedRowData,
  deleteSnConfigResult,
}))(SnConfigPage);
