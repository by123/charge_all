import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Alert, Modal } from 'antd';
import { action as personnelActions } from '../../pages/Personnel/store';

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

class AgentDeleteModal extends React.Component {

  toggleDeleteModal = (visible) => {
    this.props.dispatch(personnelActions.toggleDeleteModal(visible));
  }

  handleDelete = () => {
    const { onOk } = this.props;
    onOk && onOk();
  }

  render() {
    const {
      deleteModalVisible,
      loading,
      confirmColumns,
    } = this.props;

    return (<Modal
      title="确认删除"
      visible={deleteModalVisible}
      wrapClassName="add-personnel"
      onOk={this.handleDelete}
      onCancel={() => this.toggleDeleteModal(false)}
      okText="确定"
      maskClosable={false}
      closable={false}
      cancelButtonProps={{ loading }}
      okButtonProps={{ loading }}
    >
      <Alert showIcon message="删除后将会导致对应账户无法登陆，是否确定删除？" />
      {
        confirmColumns.map(item => (<div key={`${item.name}${item.value}`} style={styles.wrapper}>
          <div style={styles.itemLabel}>{item.name}：</div>
          <div style={styles.itemValue}>{item.value}</div>
        </div>))
      }
    </Modal>);
  }
}

AgentDeleteModal.propTypes = {
  deleteModalVisible: PropTypes.bool.isRequired,
  deleteResult: PropTypes.object,
  dispatch: PropTypes.func.isRequired,
  onOk: PropTypes.func.isRequired,
  confirmColumns: PropTypes.array,
  loading: PropTypes.bool,
};

AgentDeleteModal.defaultProps = {
  deleteResult: {},
  confirmColumns: [],
  loading: false,
};

const Container = connect(({ personnel: { deleteModalVisible, deleteResult } }) => ({
  deleteModalVisible,
  deleteResult,
}))(AgentDeleteModal);

export { Container as AgentDeleteModal };
