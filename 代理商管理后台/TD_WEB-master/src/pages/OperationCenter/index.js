import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Modal, Row, Col } from 'antd';
import { PageFilter } from '../../containers/PageFilter';
import { PageList } from '../../containers/PageList';
import { action } from './store';
import { datetimeFormat } from '../../utils';
import { OperationLink } from '../../components/OperationLink';

const styles = {
  marginBottom: '15px',
  fontSize: '16px',
  fontWeight: 'bold',
  paddingLeft: '38px',
};

class OperationCenter extends React.Component {

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

  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(action.fetchWechatList(search));
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

  render() {
    const {
      location: { search },
      wechatList: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      },
      confirmVisible,
      untieWechatResult,
    } = this.props;
    let listData = dataSource || [];
    listData = listData.map(val => {
      let { id, tblBusinessUser = {}, tblMch = {}, tblUserUnionid = {} } = val;
      const { headUrl, nickname, unionId, province, city } = tblUserUnionid;
      tblMch = tblMch || {};
      tblBusinessUser = tblBusinessUser || {};
      const { mchId, mchName } = tblMch;
      const address = `${province || ''} ${city || ''}`;
      return {
        headUrl,
        nickname,
        unionId,
        createTime: tblBusinessUser.createTime,
        address,
        mchId,
        mchName,
        id,
      };
    });
    let filterProps = {
      search,
      columns: [
        { dataIndex: 'nickName', title: '微信昵称' },
        { dataIndex: 'mchName', title: '商户名称' },
        { dataIndex: 'mchId', title: '商户编号' },
      ],
    };
    let columns = [
      { dataIndex: 'id', title: '序号' },
      { dataIndex: 'headUrl', title: '微信头像', render: text => <img width="30" src={text} alt="" /> },
      { dataIndex: 'nickname', title: '微信昵称' },
      { dataIndex: 'address', title: '所在地' },
      { dataIndex: 'mchId', title: '商户编号' },
      { dataIndex: 'mchName', title: '绑定商户名称' },
      { dataIndex: 'createTime', title: '绑定时间', render: text => datetimeFormat(text) },
      {
        dataIndex: 'x',
        title: '操作',
        render: (_, record) => {
          const options = [
            { text: '解绑', action: () => { this.openUntieConfirm(record); } },
          ];
          return <OperationLink options={options} />;
        },
      },
    ];
    const listProps = {
      loading,
      rowKey: 'id',
      pagination: {
        current,
        total,
        pageSize,
      },
      columns,
      dataSource: listData,
      // scroll: { x: 1500 },
    };
    const modalOpts = {
      title: '确认解绑',
      visible: confirmVisible,
      // visible: true,
      onOk: this.handleSubmit,
      onCancel: this.closeModal,
      destroyOnClose: true,
      confirmLoading: untieWechatResult.loading,
      cancelButtonProps: {
        disabled: untieWechatResult.loading,
      },
      maskClosable: false,
    };
    const selectedData = this.state.selectedData || {};
    return (<div className="page-order">
      <div className="content-header">
        <h2>商户微信解绑</h2>
      </div>
      <PageFilter {...filterProps} />
      <div className="list-desc">
        <p>
          <span>共 {total} 条数据</span>
        </p>
      </div>
      <PageList {...listProps} />
      <Modal {...modalOpts}>
        <div style={styles}>请再次确认是否解除绑定</div>
        <Row>
          <Col span={8} style={{ textAlign: 'right' }}>商户名称：</Col>
          <Col offset={1} span={15}>{selectedData.mchName}</Col>
        </Row>
        <Row>
          <Col span={8} style={{ textAlign: 'right' }}>微信昵称：</Col>
          <Col offset={1} span={15}>{selectedData.nickname}</Col>
        </Row>
      </Modal>
    </div>);
  }
}

OperationCenter.propTypes = {
  wechatList: PropTypes.object,
  confirmVisible: PropTypes.bool,
  location: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  untieWechatResult: PropTypes.object,
};

OperationCenter.defaultProps = {
  wechatList: {},
  confirmVisible: false,
  untieWechatResult: {},
};

export default connect(({ operationCenter: { wechatList, confirmVisible, untieWechatResult } }) => ({
  wechatList,
  confirmVisible,
  untieWechatResult,
}))(OperationCenter);
