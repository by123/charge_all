import React from 'react';
import { Button } from 'antd';
import PropTypes from 'prop-types';

import './style.less';

export const SaveBtn = ({ onOk, onCancel, cancelText, okText, confirmLoading }) => {
  return (<div className="save-btn-wrapper">
    {cancelText && <Button onClick={onCancel}>{cancelText}</Button>}
    <Button type="primary" loading={confirmLoading} onClick={onOk}>{okText}</Button>
  </div>);
};

SaveBtn.propTypes = {
  onOk: PropTypes.func.isRequired,
  onCancel: PropTypes.func,
  okText: PropTypes.string,
  cancelText: PropTypes.string,
  confirmLoading: PropTypes.bool,
};

SaveBtn.defaultProps = {
  okText: '确定',
  cancelText: '取消',
  confirmLoading: false,
  onCancel: () => {},
};
