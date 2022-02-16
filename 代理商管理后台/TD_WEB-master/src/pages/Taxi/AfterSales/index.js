import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Form, Alert, Row, Col } from 'antd';
import { SaveBtn } from '@/components/SaveBtn';
import { Card } from '@/components/Card';
import { push } from '@/store/router-helper';
import { FormInput } from '@/components/FormInput';
import { action as afterSalesActions } from './store';
import { NoGroupModal } from '../Group/NoGroupModal';

const styles = {
  row: {
    marginTop: 20,
  },
};

class AfterSalesPage extends React.Component {
  componentDidMount() {
    // this.props.dispatch(deviceActions.queryAgent({ mchId: this.props.profile.mchId }));
  }

  handleSubmit = () => {
    const { form, dispatch } = this.props;
    form.validateFieldsAndScroll((err, values) => {
      if (err) return;
      dispatch(afterSalesActions.exchangeDevice(values));
    });
  }

  render() {
    const { dispatch, form, exchangeDeviceResult } = this.props;
    const saveProps = {
      onOk: this.handleSubmit,
      onCancel: () => dispatch(push('/taxi/device')),
      okText: '保存',
      cancelText: '返回设备列表',
      confirmLoading: exchangeDeviceResult.loading,
    };
    return (<div className="bind-agent-page">
      <div className="content-header">
        <h2>售后换线</h2>
      </div>
      <Alert
        style={{ maxWidth: 920, margin: '0 auto' }}
        type="info"
        showIcon
        message=" 1，仅当出租车设备损坏，需要返厂维修时；2，新设备替换旧设备后，司机可免激活直接使用"
      />
      <Card title="第一步：输入旧设备编号">
        <Row style={styles.row}>
          <Col span={14}>
            <FormInput
              form={form}
              label="旧设备编号"
              name="srcDeviceSn"
            />
          </Col>
        </Row>
      </Card>
      <Card title="第二步：输入新设备编号">
        <Row style={styles.row}>
          <Col span={14}>
            <FormInput
              form={form}
              label="新设备编号"
              name="dstDeviceSn"
            />
          </Col>
        </Row>
      </Card>
      <SaveBtn {...saveProps} />
      <NoGroupModal />
    </div>);
  }
}

AfterSalesPage.propTypes = {
  form: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  exchangeDeviceResult: PropTypes.object,
};

AfterSalesPage.defaultProps = {
  exchangeDeviceResult: {},
};

const AfterSalesPageForm = Form.create()(AfterSalesPage);

export default connect(({ taxiAfterSales: { exchangeDeviceResult } }) => ({
  exchangeDeviceResult,
}))(AfterSalesPageForm);
