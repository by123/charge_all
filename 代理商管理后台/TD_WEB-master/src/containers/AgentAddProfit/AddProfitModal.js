import React from 'react';
import PropTypes from 'prop-types';
import { Modal, Alert, Form, InputNumber } from 'antd';
import { connect } from 'react-redux';
import { action as agentActions } from '../../pages/Agent/store';
import { action as globalActions } from '../../store/global';

import './style.less';
import { sub } from '../../utils';
import { FAILURE } from '../../utils/constants';
import ErrorList from '../../containers/ErrorList';

const FormItem = Form.Item;
const formItemLayout = {
  labelCol: { span: 9 },
  wrapperCol: { span: 14 },
};

class AddProfitModal extends React.PureComponent {
  changePercent = (value) => {
    this.setState({ profit: value });
  }
  handleOk = () => {
    const { form, dispatch, selectedKeys } = this.props;
    form.validateFieldsAndScroll((err, values) => {
      if (err) return;
      // : {
      //     mchIds: ids,
      //       profitSubAgent: profit,
      //   }
      values.mchIds = selectedKeys;
      dispatch(agentActions.updateAgentProfit(values, (_, getState) => {
        const { updateProfit } = getState().agent;
        const { errorList } = this.getErrorList(updateProfit);
        if (errorList.length) {
          dispatch(globalActions.toggleErrorList(true));
        } else {
          dispatch(agentActions.updateProfitSuccess());
        }

        const { location: { search } } = getState().router;
        dispatch(agentActions.fetchAgentList(search));
      }));
    });
  };
  handleCancel = () => {
    this.props.dispatch(agentActions.toggleAddProfitModal(false));
  }
  getErrorList = (data) => {
    const { result = [] } = data;
    const errorList = result.filter(val => {
      return !val.bresult;
    });
    return {
      errorList,
      successTotal: result.length - errorList.length,
    };
  }
  onErrorListClose = () => {
    const { dispatch } = this.props;
    dispatch(agentActions.toggleAddProfitModal(false));
    dispatch(agentActions.selectedRow([], []));
  }

  render() {
    const {
      visible,
      selectedAgents,
      selectedKeys,
      updateProfit,
      totalProfit,
      form: {
        getFieldDecorator,
        getFieldValue,
        resetFields,
      },
    } = this.props;
    const modalOpts = {
      title: '批量编辑分润规则',
      visible,
      width: 600,
      onOk: this.handleOk,
      confirmLoading: updateProfit.loading,
      cancelButtonProps: {
        disabled: updateProfit.loading,
      },
      maskClosable: false,
      afterClose: () => resetFields(),
      onCancel: this.handleCancel,
    };
    const remainProfit = () => {
      const agentProfit = getFieldValue('profitSubAgent');
      if (!agentProfit) return totalProfit;
      let remain = sub(totalProfit, getFieldValue('profitSubAgent'));
      remain = remain > totalProfit ? totalProfit : remain;
      return remain < 0 ? 0 : remain;
    };
    const errorList = this.getErrorList(updateProfit);
    return (<div>
      <Modal {...modalOpts}>
        <div className="add-profit">
          <div>已选择{selectedKeys.length}个，代理商／商户名称如下：</div>
          <div className="g-selected-area">{selectedAgents.map(item => item.mchName).join(',')}</div>
          {updateProfit.status === FAILURE && <Alert type="error" className="alert-info" showIcon message={updateProfit.error.msg} />}
          <div className="card">
            <div className="title">设置利润分配比例:</div>
            <div className="content">
              {/*<Row type="flex" align="middle">
                <Col span={8}>我的剩余利润比例:</Col>
                <Col className="bold-num" span={5}>60%</Col>
                <Col span={11}>（以100元为例，我的例如约60元）</Col>
              </Row>
              <Row type="flex" align="middle">
                <Col span={8}>其他固定分润比例:</Col>
                <Col span={5}>平台10%</Col>
                <Col span={11}>（以100元为例，约30元）</Col>
              </Row>*/}
              <FormItem label="我的总利润比例" {...formItemLayout}>
                <span>{totalProfit}%</span>
              </FormItem>
              <FormItem label="设置子级代理商分润比例" {...formItemLayout}>
                {getFieldDecorator('profitSubAgent', {
                  initialValue: 0,
                  rules: [
                    { required: true, message: '请设置子级代理商分润比例' },
                    {
                      max: totalProfit,
                      type: 'number',
                      message: `最大值为${totalProfit}%`,
                    },
                    {
                      min: 0,
                      type: 'number',
                      message: '最小值为0%',
                    },
                  ],
                })(<InputNumber precision={2} />)}%
                <span>（我的剩余利润比例：{remainProfit()}%）</span>
              </FormItem>
            </div>
          </div>
        </div>
      </Modal>
      <ErrorList
        dataSource={errorList.errorList}
        onClose={this.onErrorListClose}
        nameKey="mchName"
        result="bresult"
        message={`以下${errorList.errorList.length}个代理商／商户编辑失败`}
        successMessage={`${errorList.successTotal}个代理商／商户编辑成功`}
      />
    </div>);
  }
}

AddProfitModal.propTypes = {
  form: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  selectedKeys: PropTypes.array.isRequired,
  updateProfit: PropTypes.object.isRequired,
  selectedAgents: PropTypes.array,
  errorListVisible: PropTypes.bool.isRequired,
  totalProfit: PropTypes.number,
};

AddProfitModal.defaultProps = {
  selectedAgents: [],
  totalProfit: 100,
};

const AddProfitForm = Form.create()(AddProfitModal);

const Container = connect(({ agent: { selfInfo, addProfitVisible, selectedKeys, selectedAgents, updateProfit, errorListVisible } }) => ({
  visible: addProfitVisible,
  selectedKeys,
  selectedAgents,
  updateProfit,
  totalProfit: selfInfo.totalPercent,
  errorListVisible,
}))(AddProfitForm);

export { Container as AddProfitModal };
