import React from 'react';
import PropTypes from 'prop-types';
import { Alert, Modal } from 'antd';

const styles = {
  wrapper: {
    display: 'flex',
    fontWeight: 'bold',
    marginTop: 20,
  },
  itemLabel: {
    flex: 2,
    textAlign: 'right',
  },
  itemValue: {
    flex: 3,
    textAlign: 'left',
  },
};

class DeleteConfirmModal extends React.Component {

  render() {
    const {
      visible,
      loading,
      message,
      onOk,
      onCancel,
      confirmColumns,
      title,
    } = this.props;

    return (<Modal
      title="确认删除"
      visible={visible}
      wrapClassName="add-personnel"
      onOk={onOk}
      onCancel={onCancel}
      okText="确定"
      maskClosable={false}
      closable={false}
      cancelButtonProps={{ loading }}
      okButtonProps={{ loading }}
    >
      {message && <Alert showIcon message={message} />}
      {title && <h3 style={{ fontWeight: '600' }}>{title}</h3>}
      {
        confirmColumns.map(item => (<div key={`${item.name}${item.value}`} style={styles.wrapper}>
          <div style={styles.itemLabel}>{item.name}：</div>
          <div style={styles.itemValue}>{item.value}</div>
        </div>))
      }
    </Modal>);
  }
}

DeleteConfirmModal.propTypes = {
  visible: PropTypes.bool.isRequired,
  onOk: PropTypes.func.isRequired,
  confirmColumns: PropTypes.array,
  loading: PropTypes.bool,
  onCancel: PropTypes.func.isRequired,
  message: PropTypes.string,
  title: PropTypes.string,
};

DeleteConfirmModal.defaultProps = {
  confirmColumns: [],
  loading: false,
  message: '',
  title: '',
};

export { DeleteConfirmModal };
