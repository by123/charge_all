
import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Row, Col, Modal, Alert } from 'antd';
import { action as globalActions } from '../../store/global';

import './index.less';

class ErrorList extends React.PureComponent {
  toggleErrorList = (visible) => {
    this.props.dispatch(globalActions.toggleErrorList(visible));
  }
  onCancel = () => {
    const { onClose } = this.props;
    this.toggleErrorList(false);
    onClose && onClose();
  }
  onOk = () => {
    const { onOk, onClose } = this.props;
    if (onOk) {
      onOk();
    } else {
      this.toggleErrorList(false);
    }
    onClose && onClose();
  }

  render() {
    const {
      dataSource,
      nameKey,
      valueKey,
      resultKey,
      errorListVisible,
      message,
      successMessage,
    } = this.props;
    const modalOptions = {
      visible: errorListVisible,
      onCancel: this.onCancel,
      onOk: this.onOk,
      zIndex: 1001,
      destoryOnClose: true,
    };
    const failResult = dataSource.filter(val => {
      return !val[resultKey];
    });
    const successResult = dataSource.filter(val => {
      return val[resultKey];
    });

    let _successMessage = successMessage || `${successResult.length}个设备提交成功`;
    let _errorMessage = message || `${failResult.length}个设备提交失败`;
    return (<Modal {...modalOptions} className="error-list-modal">
      <div>
        <Alert showIcon type="success" message={_successMessage} style={{ marginBottom: 10 }} />
        <Alert showIcon type="error" message={_errorMessage} />
        {
          failResult.map(val => {
            return (<div key={val[nameKey]}>
              <Row className="g-selected-area">
                <Col span={8}>{val[nameKey]}</Col>
                <Col offset={1} span={15} style={{ textAlign: 'right' }}>{val[valueKey]}</Col>
              </Row>
            </div>);
          })
        }
      </div>
    </Modal>);
  }
}

ErrorList.propTypes = {
  dataSource: PropTypes.array.isRequired,
  dispatch: PropTypes.func.isRequired,
  nameKey: PropTypes.string,
  valueKey: PropTypes.string,
  resultKey: PropTypes.string,
  onClose: PropTypes.func,
  message: PropTypes.string,
  successMessage: PropTypes.string,
  onOk: PropTypes.func,
  errorListVisible: PropTypes.bool,
};
ErrorList.defaultProps = {
  nameKey: 'deviceSn',
  valueKey: 'errMsg',
  resultKey: 'result',
  onClose: () => {},
  onOk: null,
  message: '',
  successMessage: '',
  errorListVisible: false,
};

export default connect(({ global: { errorListVisible } }) => ({
  errorListVisible,
}))(ErrorList);
