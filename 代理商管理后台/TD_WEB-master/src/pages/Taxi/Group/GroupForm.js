import React from 'react';
import PropTypes from 'prop-types';
import { Form, Row, Col, Divider, InputNumber, Input } from 'antd';
import { FormInput } from '@/components/FormInput';
import { Cascader } from '@/components/pop';
import { pattern } from '@/utils/constants';
import { sub, mapArrayToOptions } from '@/utils';
import address from '@/store/address/address';

const FormItem = Form.Item;

const styles = {
  divider: { marginTop: 0, marginBottom: 10 },
  itemTitle: { marginLeft: 10, marginBottom: 10, paddingLeft: 10 },
  tip: { padding: '0 10px 14px 110px', color: '#999999' },
  frozen: { padding: '0 30px 30px 30px' },
};

const formWrapLayout = { xs: 24, md: 12 };
const addressLayout = { labelCol: { span: 7 }, wrapperCol: { xs: 14, md: 16 } };
const detailAddrLayout = { xs: { span: 14, offset: 6 }, md: { span: 20, offset: 0 } };

const childAgentLayout = {
  labelCol: { md: 10, xs: 10 },
  wrapperCol: { md: 12, xs: 12 },
};
const childAgentLayout1 = {
  labelCol: { md: 8, xs: 10 },
  wrapperCol: { md: 12, xs: 12 },
};

class GroupForm extends React.Component {
  state = {
    confirmDirty: false,
    bizType: '',
  };

  render() {
    const {
      form,
      totalProfit = 100,
      groupData, // 代理商/商户 详情，编辑时才有值
      userList,
      taxiConfig = {},
    } = this.props;
    let formData = groupData || {};
    const totalPercent = totalProfit;
    let { time } = taxiConfig;
    time /= 60;
    formData = Object.assign(formData);
    // formData.service && console.log('asdad', formData.service);
    formData.defaultPrice = formData.service ? JSON.parse(formData.service)[0].price / 100 : '';
    formData.depositDefault = formData.deposit || formData.deposit === 0 ? formData.deposit / 100 : '';
    formData.preAddress = formData.presaleArea && [formData.presaleProvince, formData.presaleCity, formData.presaleArea];
    formData.afterAddress = formData.aftersaleArea && [formData.aftersaleProvince, formData.aftersaleCity, formData.aftersaleArea];
    const { getFieldDecorator, getFieldValue } = form;
    getFieldDecorator('groupId', { initialValue: formData.groupId || null });

    const phoneRules = [
      {
        pattern: pattern.mobile,
        message: '请输入正确的手机号码',
      },
    ];
    const remainProfit = () => {
      const agentProfit = getFieldValue('profitPercentTaxi');
      if (!agentProfit) return totalPercent;
      let remain = sub(totalPercent, getFieldValue('profitPercentTaxi'));
      remain = remain > totalPercent ? totalPercent : remain;
      return remain < 0 ? 0 : remain.toFixed(2);
    };
    return (<Form layout="horizontal" autoComplete="off">
      <Row>
        <Col {...formWrapLayout}>
          <FormInput
            form={form}
            label="分组名称"
            name="groupName"
            required
            defaultValue={formData.groupName}
          />
        </Col>
        <Col {...formWrapLayout}>
          <FormInput
            form={form}
            type="select"
            options={mapArrayToOptions(userList, 'userId', 'name')}
            label="关联业务员"
            name="salesId"
            defaultValue={formData.salesId}
          />
        </Col>
      </Row>
      <Divider style={styles.divider} />
      <Row>
        <Col {...formWrapLayout}>
          <FormItem label="设置司机分润比例" {...childAgentLayout}>
            {getFieldDecorator('profitPercentTaxi', {
              initialValue: formData.profitPercentTaxi,
              rules: [{
                required: true,
                type: 'number',
                message: '司机分润比例为必填项',
              },
              {
                max: totalPercent,
                type: 'number',
                message: `最大值为${totalPercent}%`,
              },
              {
                min: 0,
                type: 'number',
                message: '最小值为0%',
              }],
            })(<InputNumber precision={2} max={totalPercent} />)}  %
          </FormItem>
        </Col>
        <Col {...formWrapLayout}>
          <FormItem>我的总利润比例为：{totalPercent}%，剩余分润：{remainProfit()}%</FormItem>
        </Col>
      </Row>
      <Divider style={styles.divider} />
      <Row>
        <Col {...formWrapLayout}>
          <FormItem label="设备计费规则" {...childAgentLayout1}>
            {getFieldDecorator('price', {
              initialValue: formData.defaultPrice,
              rules: [{
                required: true,
                type: 'number',
                message: '设备计费规则为必填项',
              },
              {
                min: 0.01,
                type: 'number',
                message: '最小值为0.01',
              }],
            })(<InputNumber precision={2} />)}  元/{time}小时
          </FormItem>
        </Col>
        <Col {...formWrapLayout}>
          <FormItem>出租车所用设备只有1档计费规则</FormItem>
        </Col>
      </Row>
      <Divider style={styles.divider} />
      <Row>
        <Col {...formWrapLayout}>
          <FormItem label="设备冻结款" {...childAgentLayout1}>
            {getFieldDecorator('deposit', {
              initialValue: formData.depositDefault,
              rules: [{
                required: true,
                type: 'number',
                message: '设备冻结款为必填项',
              },
              {
                min: 0,
                type: 'number',
                message: '设备冻结款最小为0元',
              },
              {
                max: 99,
                type: 'number',
                message: '设备冻结款最大为99元',
              }],
            })(<InputNumber precision={0} />)}  元
          </FormItem>
        </Col>
      </Row>
      <Row style={styles.frozen}>
        <div>1，设备冻结款是指代理商从司机的账户余额中冻结充电线成本费用，之后会将冻结款转移到代理商账户；</div>
        <div>2，司机激活本分组的设备，将按照您在此设置的金额来冻结费用；</div>
        <div>3，请根据实际运营情况设置设备冻结款，如您未来无需从司机账户中扣除此费用，请将设备冻结款设置为0元；</div>
        <div>4，司机的收益超过冻结款的部分才可提现；</div>
      </Row>
      <Divider style={styles.divider} />
      <div>
        <h3 style={styles.itemTitle}>售前信息</h3>
        <Row>
          <Col {...formWrapLayout}>
            <FormInput
              form={form}
              label="联系人"
              name="presaleContactName"
              required={false}
              defaultValue={formData.presaleContactName}
            />
          </Col>
          <Col {...formWrapLayout}>
            <FormInput
              form={form}
              label="手机号码"
              name="presaleContactTel"
              rules={phoneRules}
              required
              defaultValue={formData.presaleContactTel}
            />
          </Col>
        </Row>
        <Row>
          <Col {...formWrapLayout}>
            <FormItem label="区域位置" {...addressLayout}>
              {getFieldDecorator('preAddress', {
                initialValue: formData.preAddress,
              })(<Cascader fieldNames={{ value: 'label' }} placeholder="请选择省市区" options={address} />)}
            </FormItem>
          </Col>
          <Col {...formWrapLayout}>
            <FormItem wrapperCol={detailAddrLayout}>
              {getFieldDecorator('presaleDetailAddr', {
                initialValue: formData.presaleDetailAddr,
              })(<Input placeholder="详细地址" />)}
            </FormItem>
          </Col>
        </Row>
        <div style={styles.tip}>司机可前往此地址购买设备</div>
      </div>
      <Divider style={styles.divider} />
      <div>
        <h3 style={styles.itemTitle}>售后信息</h3>
        <Row>
          <Col {...formWrapLayout}>
            <FormInput
              form={form}
              label="联系人"
              name="aftersaleContactName"
              required={false}
              defaultValue={formData.aftersaleContactName}
            />
          </Col>
          <Col {...formWrapLayout}>
            <FormInput
              form={form}
              label="手机号码"
              name="aftersaleContactTel"
              rules={phoneRules}
              defaultValue={formData.aftersaleContactTel}
            />
          </Col>
        </Row>
        <Row>
          <Col {...formWrapLayout}>
            <FormItem label="区域位置" {...addressLayout}>
              {getFieldDecorator('afterAddress', {
                initialValue: formData.afterAddress,
              })(<Cascader fieldNames={{ value: 'label' }} placeholder="请选择省市区" options={address} />)}
            </FormItem>
          </Col>
          <Col {...formWrapLayout}>
            <FormItem wrapperCol={detailAddrLayout}>
              {getFieldDecorator('aftersaleDetailAddr', {
                initialValue: formData.aftersaleDetailAddr,
              })(<Input placeholder="详细地址" />)}
            </FormItem>
          </Col>
        </Row>
        <div style={styles.tip}>司机可前往此地址更换或维修设备</div>
      </div>
    </Form>);
  }
}

GroupForm.propTypes = {
  form: PropTypes.object.isRequired,
  totalProfit: PropTypes.number.isRequired,
  groupData: PropTypes.object.isRequired,
  userList: PropTypes.array.isRequired,
  taxiConfig: PropTypes.object.isRequired,
};

const Container = Form.create()(GroupForm);

export { Container as GroupForm };
