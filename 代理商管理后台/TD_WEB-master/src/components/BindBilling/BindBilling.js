import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { InputNumber, Form, Icon } from 'antd';
import isEqual from 'lodash/isEqual';
import isArray from 'lodash/isArray';
import { Select } from '../pop/index';
import { deviceTimes, ruleStatus } from '../../utils/enum';
import { action as deviceActions } from '../../pages/Device/store';

import './style.less';

const FormItem = Form.Item;
const { Option } = Select;
const simpleRules = {
  1: {
    service: [{ price: 2, time: '60' }, { price: 3, time: '1440' }],
  },
  2: {
    service: [{ price: 2, time: '60' }, { price: 5, time: '480' }],
  },
  3: {
    service: [{ price: 1, time: '60' }, { price: 2, time: '180' }, { price: 12, time: '1440' }],
  },
};
let uuid = 1;

const defaultKeys = Object.keys(deviceTimes);

class BindBilling extends React.Component {
  state = {
    simpleRule: null,
    pledge: null,
    rules: [],
    usePre: false,
  }

  componentDidMount() {
    const { formData: { service, serviceType }, dispatch } = this.props;
    console.log('by666');
    console.log(serviceType);
    dispatch(deviceActions.getMinPrice());
    if (service) {
      this.removeAllRule();
      if (serviceType === 'undefined' || serviceType === null) {
        service.forEach((rule) => {
          this.addRule(rule);
        });
      } else if (serviceType === 1 || serviceType === '1' || serviceType === '') {
        service.forEach((rule) => {
          this.addRule(rule);
        });
      }
      /* eslint-disable */
      this.setState({
        usePre: (serviceType === 2 || serviceType === '2'),
      });
      /* eslint-enable */
    } else {
      this.addRule(); // 默认先添加一条
    }
    // this.state.usePre = (serviceType === 2 || serviceType === '2');
  }

  componentDidUpdate(prevProps) { // 第一次加载
    if (!isEqual(prevProps.formData, this.props.formData)) {
      const { service, serviceType } = this.props.formData;
      this.removeAllRule();
      if (serviceType === 'undefined' || serviceType === null) {
        service.forEach((rule) => {
          this.addRule(rule);
        });
      } else if (serviceType === 1 || serviceType === '1') {
        service.forEach((rule) => {
          this.addRule(rule);
        });
      }
    }
  }
  addRule = (rule = {}) => {
    const { form } = this.props;
    const keys = form.getFieldValue('keys');
    const key = {
      key: uuid,
      initialPrice: rule.price,
      initialTime: rule.time,
    };
    const nextKeys = keys.concat(key);
    form.setFieldsValue({ keys: nextKeys });
    uuid++;
    // if (rule) {
    //   setTimeout(() => {
    //     form.setFieldsValue({ [`service[${key}]`]: rule });
    //   }, 500);
    // }
  }
  handleAddRule = () => {
    this.resetSimpleRule();
    this.addRule();
  }
  handleRemoveRule = (k) => {
    const { form } = this.props;
    const keys = form.getFieldValue('keys');
    if (keys.length === 1) return;
    form.setFieldsValue({
      keys: keys.filter(key => key.key !== k),
    });
  }
  removeAllRule = () => {
    this.props.form.setFieldsValue({
      keys: [],
    });
  }
  resetSimpleRule = () => {
    if (this.state.simpleRule) { // 常用规则被选中情况下
      this.setState({ simpleRule: null });
    }
  }
  handleCheckRule = (simpleRule) => {
    if (this.state.simpleRule === simpleRule) {
      this.setState({ simpleRule: null });
      // resetForm
      this.removeAllRule();
      this.addRule();
    } else {
      this.removeAllRule();
      this.setState({ simpleRule });
      const { service } = simpleRules[simpleRule];
      service.forEach((rule) => {
        this.addRule(rule);
      });
    }
  }
  handlePledgeChange = (value) => {
    this.setState({ pledge: value });
  }

  onChangePrepaId = (value) => {
    // const { form } = this.props;
    // const key = {
    //   prepaId: value * 100,
    // };
    // form.setFieldsValue({ service: key });
  }

  onChangeMaxMoeny = (value) => {
  }

  onChangeMinHour = (value) => {
  }

  onChangeMinMoney = (value) => {
  }

  onChangeStepHour = (value) => {
  }

  onChangePrice = (value) => {
  }

  onChangeRule = (value) => {
    this.setState({
      usePre: value === 2 || value === '2',
    }, () => {
      console.log(this.state.usePre);
    });
  }

  generateOptions = () => {
    let options = Object.keys(ruleStatus).map(index => {
      return <Option key={parseInt(index, 0) + 1}>{ruleStatus[index]}</Option>;
    });
    return options;
  }

  // 因为有可能会删除，如果新添加的key值和被删的一样，Form会把被删的老数据存到新的上面
  // 所以这里key值只能自增，序号单独用index控制
  renderRuleItem = ({ key, initialTime, initialPrice }, index) => {
    const { form: { getFieldValue, getFieldsValue, getFieldDecorator }, getMinPriceResult } = this.props;
    const minPrice = getMinPriceResult.result || 0;
    const keys = getFieldValue('keys');
    let selected = [];
    // 只有一条时不用考虑哪些选项需要被禁用，而且这个方法在生成表单之前执行，
    // getFieldValue在getFieldDecorator之前执行是有warning警告的，也拿不到值，因为还没生成
    const { service } = getFieldsValue();
    if (isArray(service)) {
      selected = service.map(s => s.time);
    }
    const Options = defaultKeys.map(i => {
      return <Option key={i} disabled={selected.includes(i)}>{deviceTimes[i]}</Option>;
    });
    return (<div key={key} className="item child">
      <div className="label">第{index + 1}档：</div>
      <FormItem>
        {getFieldDecorator(`service[${key}].time`, {
          initialValue: initialTime,
          rules: [
            { required: true, message: '请输入时间' },
          ],
        })(
          <Select onChange={this.resetSimpleRule} placeholder="时间" style={{ width: '100px' }}>{Options}</Select>
        )}
        <span>时</span>
      </FormItem>
      <FormItem>
        {getFieldDecorator(`service[${key}].price`, {
          initialValue: initialPrice,
          rules: [
            { required: true, message: '请输入金额' },
            { min: minPrice, type: 'number', message: `最小金额为${minPrice}元` },
          ],
        })(
          <InputNumber
            // min={minPrice}
            precision={2}
            onChange={this.resetSimpleRule}
            placeholder="金额"
            style={{ width: '100px' }}
          />
        )}
        <span>元</span>
        {keys.length > 1 ? (
          <Icon
            className="delete-btn"
            type="minus-circle-o"
            disabled={keys.length === 1}
            onClick={() => this.handleRemoveRule(key)}
          />
        ) : null}
      </FormItem>

    </div>);
  }

  render() {
    const { form, showTitle, isEditBiz, formData } = this.props;
    const { usePre } = this.state;
    const { getFieldDecorator, getFieldValue } = form;
    getFieldDecorator('keys', { initialValue: [] });
    getFieldDecorator('pledge', { initialValue: 0 });
    const keys = getFieldValue('keys');
    const titleText = isEditBiz ? '商户默认计费规则' : '设备计费规则';
    const { service } = formData;
    const selectRuleStr = ruleStatus[usePre ? 1 : 0];
    return (<div className="bind-billing-wrap">
      {showTitle && <h3 className="billing-title">{titleText}</h3>}
      <div className="bind-billing">
        <div className="item ant-form-item-required">
          <div className="label">计费规则：</div>
          {getFieldDecorator('serviceType', {
            rules: [
              { required: true, message: '' },
            ],
          })(
            <Select
              style={{ width: 200 }}
              placeholder="请选择"
              onChange={this.onChangeRule}
            >
              {this.generateOptions()}
            </Select>
          )}
        </div>
        {usePre ? (<div>
          <div className="item ant-form-item-required" >
            <div className="label">预付金额：</div>
            {getFieldDecorator('service.prepaid', {
              initialValue: service === undefined || service === null ? '0' : (service.prepaid / 100),
              rules: [
                { required: true, message: '请输入预付金额' },
              ],
            })(
              <InputNumber min={0} onChange={this.onChangePrepaId} />
            )}
            <div className="label margin-left">元</div>
          </div>
          <div className="item ant-form-item-required" >
            <div className="label">封顶金额：</div>
            {getFieldDecorator('service.maxMoney', {
              initialValue: service === undefined || service === null ? '0' : (service.maxMoney / 100),
              rules: [
                { required: true, message: '请输入封顶金额' },
              ],
            })(
              <InputNumber min={0} onChange={this.onChangeMaxMoeny} />
            )}
            <div className="label margin-left">元</div>
          </div>
          <div className="item ant-form-item-required" >
            <div className="label">首次</div>
            {getFieldDecorator('service.minMinutes', {
              initialValue: service === undefined || service === null ? '0' : (service.minMinutes / 60),
              rules: [
                { required: true, message: '请输入首次时间' },
              ],
            })(
              <InputNumber min={0} onChange={this.onChangeMinHour} />
            )}
            <div className="label margin-left">小时</div>
            {getFieldDecorator('service.minMoney', {
              initialValue: service === undefined || service === null ? '0' : (service.minMoney / 100),
              rules: [
                { required: true, message: '请输入首次金额' },
              ],
            })(
              <InputNumber min={0} onChange={this.onChangeMinMoney} />
            )}
            <div className="label margin-left">元</div>
          </div>
          <div className="item ant-form-item-required" >
            <div className="label">超过每</div>
            {getFieldDecorator('service.stepMinutes', {
              initialValue: service === undefined || service === null ? '0' : (service.stepMinutes / 60),
              rules: [
                { required: true, message: '请输入超时时间' },
              ],
            })(
              <InputNumber min={0} onChange={this.onChangeStepHour} />
            )}
            <div className="label margin-left">小时</div>
            {getFieldDecorator('service.price', {
              initialValue: service === undefined || service === null ? '0' : (service.price / 100),
              rules: [
                { required: true, message: '请输入超时金额' },
              ],
            })(
              <InputNumber min={0} onChange={this.onChangePrice} />
            )}
            <div className="label margin-left">元</div>
          </div>
        </div>
        ) : (<div className="item ant-form-item-required" >
          <div className="label align-top">计费：</div>
          <div className="value">
            {keys.map((key, index) => { return this.renderRuleItem(key, index); })}
            {keys.length < 10 && <div className="add-rule-btn"><a onClick={this.handleAddRule}>+新增计费规则</a></div>}
          </div>
        </div>
        )}
      </div>
    </div>);
  }
}

BindBilling.propTypes = {
  form: PropTypes.object.isRequired,
  formData: PropTypes.object,
  defaultRules: PropTypes.object,
  showTitle: PropTypes.bool,
  isEditBiz: PropTypes.bool,
  getMinPriceResult: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  onChangeRule: PropTypes.func,
};

BindBilling.defaultProps = {
  defaultRules: null,
  formData: {},
  showTitle: false,
  isEditBiz: false,
  onChangeRule: null,
};

const Container = connect(({ device: { getMinPriceResult } }) => ({
  getMinPriceResult,
}))(BindBilling);

export { Container as BindBilling };
