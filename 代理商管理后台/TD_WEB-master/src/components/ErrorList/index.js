
import React from 'react';
import PropTypes from 'prop-types';
import { Row, Col, Modal, Alert } from 'antd';

import './index.less';

class ErrorList extends React.PureComponent {

  render() {
    const {
      dataSource,
      message,
      options,
      nameKey,
      valueKey,
      successMessage,
    } = this.props;
    return (<Modal {...options} className="error-list-modal">
      <div>
        <Alert showIcon type="success" message={successMessage} style={{ marginBottom: 10 }} />
        <Alert showIcon type="error" message={message} />
        {
          dataSource.map(val => {
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
  message: PropTypes.string.isRequired,
  options: PropTypes.object.isRequired,
  nameKey: PropTypes.string.isRequired,
  valueKey: PropTypes.string.isRequired,
  successMessage: PropTypes.string.isRequired,
};

export default ErrorList;
