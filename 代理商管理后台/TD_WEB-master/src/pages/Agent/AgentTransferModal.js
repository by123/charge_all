import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Alert, Modal, Card, Form, Row, Col, List, Divider, message, Input } from 'antd';
import { action } from './store';
import AgentFilter from '../../containers/AgentFilter';

const FormItem = Form.Item;

const formItemLayout = {
  labelCol: {
    span: 5,
  },
  wrapperCol: {
    span: 19,
  },
};

const styles = {
  listHead: { margin: '10px 0' },
  listWrap: {
    padding: '10px 40px',
    border: '1px solid rgb(217, 217, 217)',
    borderRadius: '4px',
    background: 'rgb(242, 242, 242)',
  },
  card: { marginBottom: 0 },
};

class AgentTransferModal extends React.Component {

  toggleModal = (visible) => {
    this.props.dispatch(action.toggleTransferAgentModal(visible));
  }

  handleOk = () => {
    const { form: { validateFieldsAndScroll }, dispatch, queryTransferAgentInfoResult } = this.props;
    validateFieldsAndScroll((err, values) => {
      if (err) return;
      if (!values.newParentId) {
        message.error('请选择要转移至的代理商账号');
        return;
      }
      const { mchId } = queryTransferAgentInfoResult.result || {};
      dispatch(action.transferAgent({ mchId, newParentId: values.newParentId[values.newParentId.length - 1] }, (_, getState) => {
        const { location: { search } } = getState().router;
        message.success('代理商转移成功');
        dispatch(action.fetchAgentList(search));
        dispatch(action.toggleTransferAgentModal(false));
      }));
    });
  }

  generateTransAgentInfo = () => {
    const { queryTransferAgentInfoResult: { result: transferAgentInfo = {} } = {} } = this.props;
    const {
      mchName,
      mchId,
      contactUser,
      totalPercent,
      totalAgentNum,
      descendantAgentNum,
      sonAgentNum,
      totalTenantNum,
      descendantTenantNum,
      sonTenantNum,
      totalDeviceNum,
      unActiveDeviceNum,
      activeDeviceNum,
    } = transferAgentInfo;

    const agentNum = `${totalAgentNum} （直属代理商：${sonAgentNum}，非直属代理商：${descendantAgentNum}）`;
    const bizNum = `${totalTenantNum} （直属商户：${sonTenantNum}，非直属商户：${descendantTenantNum}）`;
    const deviceNum = `${totalDeviceNum} （已激活设备：${activeDeviceNum}，未激活设备：${unActiveDeviceNum}）`;
    return [
      { label: '代理商名称', value: mchName },
      { label: '代理商编号', value: mchId },
      { label: '联系人', value: contactUser },
      { label: '分润比例', value: `${totalPercent}%` },
      { label: '', value: '', isSplit: true },
      { label: '代理商数量', value: agentNum },
      { label: '商户数量', value: bizNum },
      { label: '设备数量', value: deviceNum },
    ];
  }

  onChangeAgent = (value) => {
    this.props.form.setFieldsValue({ newParentId: value });
  }

  render() {
    const {
      transferAgentModalVisible: visible,
      transferAgentResult: {
        loading,
      },
      form: {
        getFieldDecorator,
      },
    } = this.props;

    const agentFilter = val => {
      return val.mchType !== 1;
    };
    const agentOptions = {
      dataIndex: 'newParentId',
      title: '代理商账户',
      type: 'agentFilter',
      changeOnSelect: true,
      childUseable: true,
      width: 240,
      listFilter: agentFilter,
    };
    const agentInfo = this.generateTransAgentInfo();
    const listItemRender = item => {
      return (<List.Item>
        {!item.isSplit ? (<Row gutter={24} style={{ width: '100%' }}>
          <Col span={8}>{item.label}:</Col>
          <Col span={16}>{item.value}</Col>
        </Row>) : (<Divider style={{ margin: '0' }} />)}
      </List.Item>);
    };
    const listProps = {
      size: 'small',
      split: false,
      bordered: false,
      header: null,
      footer: null,
      dataSource: agentInfo,
      renderItem: listItemRender,
    };
    return (<Modal
      title="代理商转移"
      visible={visible}
      wrapClassName="add-personnel"
      onOk={this.handleOk}
      onCancel={() => this.toggleModal(false)}
      okText="提交"
      maskClosable={false}
      closable={false}
      width={700}
      cancelButtonProps={{ loading }}
      okButtonProps={{ loading }}
    >
      <Alert showIcon message="转移后将影响设备，订单，收益等，请谨慎操作" />
      <div>
        <div style={styles.listHead}>已选择的代理商／商户信息如下：</div>
        <div style={styles.listWrap}>
          <List {...listProps} />
        </div>
      </div>
      <Card title="转移至其他代理商账号下">
        <Form>
          <FormItem label="代理商账户" {...formItemLayout} style={styles.card}>
            {
              getFieldDecorator('newParentId', {
                rules: [
                  { required: true, message: '请选择代理商账户' },
                ],
              })(<Input hidden />)
            }
            <AgentFilter
              column={agentOptions}
              onChange={this.onChangeAgent}
            />
          </FormItem>
        </Form>
      </Card>
    </Modal>);
  }
}

AgentTransferModal.propTypes = {
  transferAgentModalVisible: PropTypes.bool.isRequired,
  transferAgentResult: PropTypes.object,
  dispatch: PropTypes.func.isRequired,
  queryTransferAgentInfoResult: PropTypes.object.isRequired,
  onOk: PropTypes.func,
  form: PropTypes.object.isRequired,
};

AgentTransferModal.defaultProps = {
  transferAgentResult: {},
  onOk: () => {},
};

const AgentTransferModalForm = Form.create()(AgentTransferModal);

const Container = connect(({ agent: {
  transferAgentModalVisible,
  transferAgentResult,
  queryTransferAgentInfoResult,
} }) => ({
  transferAgentModalVisible,
  transferAgentResult,
  queryTransferAgentInfoResult,
}))(AgentTransferModalForm);

export { Container as AgentTransferModal };
