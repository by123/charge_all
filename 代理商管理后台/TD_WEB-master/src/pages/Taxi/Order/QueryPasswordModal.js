import React from 'react';
import PropTypes from 'prop-types';
import { Modal, Button, List, Skeleton, Checkbox, Row, Col, Icon } from 'antd';
import { connect } from 'react-redux';
import { action as orderActions } from './store';

import './style.less';

class QueryPasswordModal extends React.Component {

  toggleQueryPwd = (visible) => {
    this.props.dispatch(orderActions.toggleQueryPwdModal(visible));
    if (!visible) {
      this.props.dispatch(orderActions.resetPwdData());
    }
  }

  toggleQueryPwdResult = (visible) => {
    this.props.dispatch(orderActions.toggleQueryPwdResultModal(visible));
    if (!visible) {
      const { orderDetail: { result: { tblOrder: { orderId } } } } = this.props;
      this.props.dispatch(orderActions.fetchOrderDetail({ orderId }));
    }
  }

  onLoadMore = (isUp) => {
    this.props.dispatch(orderActions.queryPwdListByAction(isUp ? 'up' : 'down'));
  }

  onChange = (index) => {
    this.props.dispatch(orderActions.changePwdSelected(index));
  }

  onOk = () => {
    const { pwdList, dispatch, queryPwdDisabled, orderDetail: { result: { tblOrder: { orderId } } } } = this.props;
    const selected = this.getSelectedIndex();
    if (selected > -1 && !queryPwdDisabled) {
      dispatch(orderActions.changePwdLocation({
        orderId,
        pwdCount: pwdList[selected].pwdCount,
      }));
    } else {
      this.toggleQueryPwd(false);
    }
  }

  getSelectedIndex = () => {
    const { pwdList } = this.props;
    let index = -1;
    pwdList.every((val, ind) => {
      if (val.checked) {
        index = ind;
        return false;
      }
      return true;
    });
    return index;
  }

  render() {
    const {
      visible,
      changePwdResult: {
        loading: changeLoading = false,
      },
      pwdList,
      pwdListResult: {
        loading = false,
        result: {
          deviceOrderCount = 0,
        } = {},
      },
      queryPwdResultVisible,
      queryPwdDisabled,
    } = this.props;
    const selected = this.getSelectedIndex();
    const okText = (selected > -1) && !queryPwdDisabled ? '软件密码修改' : '确定';
    const modalOpts = {
      title: '查询密码',
      centered: true,
      visible,
      width: 600,
      onCancel: () => this.toggleQueryPwd(false),
      onOk: this.onOk,
      maskClosable: false,
      destroyOnClose: true,
      okText,
      confirmLoading: changeLoading,
    };
    const resultModalOpts = {
      title: '密码修改结果',
      visible: queryPwdResultVisible,
      onCancel: () => this.toggleQueryPwdResult(false),
      footer: null,
      maskClosable: false,
      className: 'query-pwd-result',
    };
    const loadMore = (isUp = false) => {
      return !loading ? (
        <div className="query-pwd-more" style={{ marginTop: isUp ? 0 : 10 }}>
          <Button onClick={() => this.onLoadMore(isUp)} size="small">{isUp ? '上一页' : '下一页'}</Button>
        </div>
      ) : null;
    };
    return (
      <div>
        <Modal {...modalOpts} className="query-pwd-modal">
          <div className="query-pwd-header">此设备共产生过 {deviceOrderCount} 个订单</div>
          <List
            loading={loading}
            style={{ width: 400, margin: '0 auto', height: 450, overflowY: 'scroll' }}
            itemLayout="horizontal"
            loadMore={loadMore()}
            dataSource={pwdList}
            renderItem={(item, index) => (
              <List.Item>
                <Skeleton avatar title={false} loading={false} active>
                  {item.isUp ? loadMore(true) : <Row className={`query-pwd-item ${item.isCurrent ? 'current-item' : ''}`}>
                    <Col span={2} offset={4}>
                      <Checkbox onChange={() => this.onChange(index)} checked={item.checked} disabled={queryPwdDisabled} />
                    </Col>
                    <Col span={8}>
                      <span>{item.password}</span>
                    </Col>
                    <Col span={7} offset={2} style={{ textAlign: 'left' }}>
                      <span>{item.pwdCount} {item.isCurrent ? '（当前位）' : ''}</span>
                    </Col>
                  </Row>
                  }
                </Skeleton>
              </List.Item>
            )}
          />
        </Modal>
        <Modal {...resultModalOpts}>
          <div className="result-text"><Icon className="result-icon" type="check-circle" theme="twoTone" /> 软件密码修改成功</div>
          <div className="result-btn"><Button type="primary" onClick={() => this.toggleQueryPwdResult(false)}>知道了</Button></div>
        </Modal>
      </div>
    );
  }
}

QueryPasswordModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  queryPwdResultVisible: PropTypes.bool.isRequired,
  changePwdResult: PropTypes.object.isRequired,
  pwdList: PropTypes.array.isRequired,
  pwdListResult: PropTypes.object.isRequired,
  queryPwdDisabled: PropTypes.bool.isRequired,
  orderDetail: PropTypes.object.isRequired,
};

const Container = connect(({ order: { queryPwdVisible, queryPwdResultVisible, changePwdResult, pwdList, pwdListResult, orderDetail, queryPwdDisabled } }) => ({
  visible: queryPwdVisible,
  queryPwdResultVisible,
  pwdList,
  changePwdResult,
  orderDetail,
  pwdListResult,
  queryPwdDisabled,
}))(QueryPasswordModal);

export { Container as QueryPasswordModal };
