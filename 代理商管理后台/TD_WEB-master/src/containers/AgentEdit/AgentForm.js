import React from 'react';
import PropTypes from 'prop-types';
import compact from 'lodash/compact';
import { Form, Row, Col, Divider, InputNumber, Input, Select, Icon } from 'antd';
import moment from 'moment';
import { FormInput } from '../../components/FormInput';
import { Cascader } from '../../components/pop';
import { AGENT, ADD, BIZ, pattern, EDIT, CHAIN, STORE } from '../../utils/constants';
import { allAgentLevelTypes, bizTypeList } from '../../utils/enum';
import { sub, mapObjectToOptions, mapArrayToOptions } from '../../utils';
import address from '../../store/address/address';
import { BindBilling } from '../../components/BindBilling/BindBilling';

const { Option } = Select;
const FormItem = Form.Item;
let isSetting = false;

const formWrapLayout = {
  xs: 24,
  md: 12,
};
const formItemLayout = {
  labelCol: {
    span: 7,
  },
  wrapperCol: {
    span: 14,
  },
};

const addressLayout = {
  labelCol: { span: 7 },
  wrapperCol: {
    xs: 14,
    md: 16,
  },
};

const detailAddrLayout = { xs: { span: 14, offset: 6 }, md: { span: 20, offset: 0 } };

const childAgentLayout = {
  labelCol: { md: 11, xs: 10 },
  wrapperCol: { md: 12, xs: 12 },
};

const labelPrefixObj = {
  [BIZ]: { nameLabel: '商户', profitLabel: '商户', contactLabel: '联系人' },
  [CHAIN]: { nameLabel: '连锁门店', profitLabel: '连锁门店', contactLabel: '联系人' },
  [STORE]: { nameLabel: '分店', profitLabel: '分店', contactLabel: '联系人' },
  [AGENT]: { nameLabel: '代理商', profitLabel: '子代理商', contactLabel: '代理人' },
};

class AgentForm extends React.Component {
  state = {
    confirmDirty: false,
    bizType: '',
  };

  generateBizOptions = () => {
    let options = Object.keys(bizTypeList).map(val => {
      return <Option key={val}>{bizTypeList[val]}</Option>;
    });
    return options;
  }

  changeBizType = (value) => {
    const { onTypeChange } = this.props;
    onTypeChange && onTypeChange(value);
  }

  filterChainAgent = (agentList) => {
    return agentList.filter(val => {
      return val.mchType === 0 && val.level === 4;
    });
  }

  // 改变连锁门店时重新获取分润信息
  onChainChange = (value) => {
    if (!value) return;
    this.props.onChainChange && this.props.onChainChange(value);
  }

  getIndustryIndex(industry) {
    const { insdustyPrice } = this.props;
    let index;
    insdustyPrice.forEach((val, ind) => {
      if (val.industry === industry) {
        index = String(ind);
        return false;
      }
    });
    return Number(index);
  }

  changeIndustry = (industry) => {
    const { insdustyPrice, onChangeIndustry } = this.props;
    let index = -1;
    insdustyPrice.forEach((val, ind) => {
      if (val.industry === industry) {
        index = ind;
        return false;
      }
    });
    if (index < 0) return;
    // let service = insdustyPrice[index].rule;
    // service = service.map(rule => ({
    //   ...rule,
    //   price: rule.price / 100,
    // }));
    // this.setState({
    //   defaultPrice: {
    //     service,
    //     pledge: 0,
    //   },
    // });
    onChangeIndustry && onChangeIndustry();
  }

  setIndustry = (industry) => {
    if (!industry || isSetting || this.props.isIndustryChanged) return;
    isSetting = true;
    setTimeout(() => {
      this.changeIndustry(industry);
      isSetting = false;
    }, 50);
  }

  render() {
    const {
      form,
      agentType,
      editType,
      totalProfit = 0,
      agent, // 代理商/商户 详情，编辑时才有值
      userList,
      level,
      isPlatform = false,
      parentChainData,
      queryAgent,
      isNextAndCreateStore, // 是否可以创建下一个分店
      insdustyPrice = [], // 默认行业价格，添加商户时使用
      isIndustryChanged,
    } = this.props;
    const { defaultPrice } = this.state;
    let formData = editType === EDIT ? agent || {} : {};
    const totalPercent = totalProfit;
    if (agentType === STORE && editType === ADD && parentChainData) {
      formData.industry = parentChainData.industry;
      this.setIndustry(parentChainData.industry);
      formData.salesId = parentChainData.salesId;
    }
    formData.address = formData.area && [formData.province, formData.city, formData.area];
    formData.contractTime = formData.contractTime && moment(formData.contractTime, 'x');
    formData.blockedAmountYuan = formData.blockedAmountYuan ? Number(formData.blockedAmountYuan) : 0;
    const labelPrefix = labelPrefixObj[agentType];
    const isAddAgent = agentType === AGENT && editType === ADD;
    const isEditBiz = (agentType === BIZ || agentType === STORE) && editType === EDIT;
    const isTypeBiz = agentType === BIZ || agentType === CHAIN;
    const canEditAgentOrChain = isPlatform && editType === EDIT && (agentType === AGENT || agentType === CHAIN);
    const isTypeStore = agentType === BIZ || agentType === STORE;

    const { getFieldDecorator, getFieldValue } = form;
    let billingData = {};
    if (isEditBiz && formData.mchPriceRule && formData.mchPriceRule[0]) {
      const { service, pledgeYuan, serviceType } = formData.mchPriceRule[0];
      if (serviceType === 1 || serviceType === '1') {
        billingData.service = JSON.parse(service) || [];
        billingData.service = compact(billingData.service); // 去掉数组中的空项
        billingData.service = billingData.service.map(rule => ({
          ...rule,
          price: rule.price,
        }));
      } else {
        billingData.service = JSON.parse(service);
      }
      billingData.serviceType = serviceType;
      billingData.pledge = pledgeYuan;
    }
    if (isIndustryChanged) {
      billingData = defaultPrice;
    }
    getFieldDecorator('mchId', { initialValue: formData.mchId });
    const phoneRules = [
      {
        pattern: pattern.mobile,
        message: '请输入正确的手机号码',
      },
    ];
    let availableLevel = {};
    for (let key in allAgentLevelTypes) {
      if (key > level) {
        availableLevel[key] = allAgentLevelTypes[key];
      }
    }
    const remainProfit = () => {
      const agentProfit = getFieldValue('profitSubAgent');
      if (!agentProfit) return totalPercent;
      let remain = sub(totalPercent, getFieldValue('profitSubAgent'));
      remain = remain > totalPercent ? totalPercent : remain;
      return remain < 0 ? 0 : remain.toFixed(2);
    };

    let showBizTypeSelect = false;
    if (editType === ADD) {
      showBizTypeSelect = agentType === BIZ || (agentType === STORE && !isNextAndCreateStore);
    }
    const showParentSelect = agentType === STORE && editType === ADD && !isNextAndCreateStore;
    const changeBizTypeDisable = level === 4;
    // 连锁门店列表
    const chainList = this.filterChainAgent(queryAgent.result || []);
    const phoneRequire = agentType !== STORE;
    const defaultLevel = editType === ADD ? `${level + 1}` : `${formData.level}`;
    return (<Form layout="horizontal" autoComplete="off">
      <Row>
        {(isAddAgent || canEditAgentOrChain) && <Col {...formWrapLayout}>
          <FormInput
            form={form}
            label="代理商级别"
            type="select"
            options={mapObjectToOptions(availableLevel)}
            name="level"
            defaultValue={defaultLevel}
          />
        </Col>}
        {agentType === CHAIN && <Col {...formWrapLayout}>
          <FormItem label="商户类型" {...formItemLayout}>
            <Input disabled value={labelPrefix.nameLabel} />
          </FormItem>
        </Col>}
        {showBizTypeSelect && <Col {...formWrapLayout}>
          <FormItem label="商户类型" {...formItemLayout}>
            <Select
              disabled={changeBizTypeDisable}
              style={{ width: '100%' }}
              placeholder="请选择商户类型"
              defaultValue={this.props.agentType}
              onChange={this.changeBizType}
            >
              {this.generateBizOptions()}
            </Select>
          </FormItem>
        </Col>}
        {showParentSelect && !changeBizTypeDisable && <Col {...formWrapLayout}>
          <FormItem label="连锁门店" {...formItemLayout}>
            {getFieldDecorator('mchParentChainAgentId', {
              initialValue: formData.mchParentChainAgentId,
              rules: [
                { required: true, message: '请选择连锁门店' },
              ],
            })(
              <Select onChange={this.onChainChange} placeholder="请选择连锁门店">{mapArrayToOptions(chainList, 'mchId', 'mchName mchId')}</Select>
            )}
          </FormItem>
        </Col>}
        <Col {...formWrapLayout}>
          <FormInput form={form} label={`${labelPrefix.nameLabel}名称`} name="mchName" defaultValue={formData.mchName} />
        </Col>
        <Col {...formWrapLayout}>
          <FormInput form={form} label={`${labelPrefix.contactLabel}姓名`} name="contactUser" defaultValue={formData.contactUser} />
        </Col>
        {agentType !== STORE && <Col {...formWrapLayout}>
          <FormInput
            form={form}
            type="select"
            options={mapArrayToOptions(userList, 'userId', 'name')}
            label="关联业务员"
            name="salesId"
            required={false}
            defaultValue={formData.salesId}
          />
        </Col>}
        <Col {...formWrapLayout}>
          <FormInput
            form={form}
            label={`${labelPrefix.contactLabel}手机`}
            rules={phoneRules}
            name="contactPhone"
            required={phoneRequire}
            defaultValue={formData.contactPhone}
          />
          {(agentType === STORE || agentType === BIZ) && <div style={{ paddingLeft: 100, marginBottom: 10 }}>
            <Icon type="exclamation-circle" theme="twoTone" twoToneColor="#52c41a" />
            <span style={{ marginLeft: 6 }}>手机号码填写错误，商户将无法提现</span>
          </div>}
        </Col>
        {(isTypeBiz || agentType === STORE) && <Col {...formWrapLayout}>
          <FormInput
            form={form}
            type="select"
            options={mapArrayToOptions(insdustyPrice, 'industry', 'industry')}
            label="所属行业"
            name="industry"
            required={!!true}
            onChange={this.changeIndustry}
            defaultValue={formData.industry}
          />
        </Col>}
        {agentType === AGENT && <Col {...formWrapLayout}>
          <FormInput
            form={form}
            label="合同结束期"
            type="date"
            name="contractTime"
            required={false}
            defaultValue={formData.contractTime}
          />
        </Col>}
      </Row>
      <Row>
        <Col {...formWrapLayout}>
          <FormItem label="区域位置" {...addressLayout}>
            {getFieldDecorator('address', {
              initialValue: formData.address,
              rules: [
                { required: isTypeStore, message: '请选择省市区' },
              ],
            })(<Cascader fieldNames={{ value: 'label' }} placeholder="请选择省市区" options={address} />)}
          </FormItem>
        </Col>
        <Col {...formWrapLayout}>
          <FormItem wrapperCol={detailAddrLayout}>
            {getFieldDecorator('detailAddr', {
              initialValue: formData.detailAddr,
              rules: [
                { required: isTypeStore, message: '请填写详细地址' },
              ],
            })(<Input placeholder="详细地址" />)}
          </FormItem>
        </Col>
      </Row>
      <Divider style={{ marginTop: 0 }} />
      <Row>
        <Col {...formWrapLayout}>
          <FormItem label={`设置${labelPrefix.profitLabel}分润比例`} {...childAgentLayout}>
            {getFieldDecorator('profitSubAgent', {
              initialValue: formData.totalPercent,
              rules: [{
                required: true,
                type: 'number',
                message: `${labelPrefix.profitLabel}分润比例为必填项`,
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
      <div>
        <Divider style={{ marginTop: 0 }} />
        {isPlatform && editType === ADD && <Row>
          <Col span={5}><FormItem label={`设置${labelPrefix.profitLabel}结算周期`} required /></Col>
          <Col span={1}><FormItem style={{ fontWeight: 600, fontSize: 18 }}>T + </FormItem></Col>
          <Col span={3}>
            <FormItem>
              {getFieldDecorator('settementPeriod', {
                initialValue: formData.settementPeriod,
                rules: [
                  { required: true, message: `请输入${labelPrefix.profitLabel}结算周期` },
                ],
              })(<InputNumber precision={0} min={0} max={10000} />)}
            </FormItem>
          </Col>
          <Col span={1}><FormItem>日</FormItem></Col>
        </Row>}
        <Row>
          <Col {...formWrapLayout}>
            <FormItem label="设置冻结金额" {...childAgentLayout}>
              {getFieldDecorator('blockedAmount', {
                initialValue: formData.blockedAmountYuan,
                rules: [{
                  min: 0,
                  type: 'number',
                  message: '最小值为0',
                }],
              })(<InputNumber precision={2} />)}  元
            </FormItem>
          </Col>
        </Row>
      </div>
      {(agentType === BIZ || agentType === STORE) && <div>
        <Divider style={{ marginTop: 0 }} />
        <BindBilling form={form} formData={billingData} showTitle={!!true} isEditBiz={editType === EDIT} />
        {/* <Divider /> */}
        {/* <Row>
          <Col {...formWrapLayout}>
            <FormInput
              form={form}
              label="登陆账号"
              name="superUser"
              rules={[
                {
                  pattern: pattern.mobile,
                  message: '登陆账号格式不正确',
                },
              ]}
              defaultValue={0}
            />
          </Col>
          <Col {...formWrapLayout}>
            <FormItem style={{ marginTop: 8 }} extra="请填写手机号码，用于生成账号，可与联系电话相同" />
          </Col>
        </Row> */}
      </div>}
    </Form>);
  }
}

AgentForm.propTypes = {
  form: PropTypes.object.isRequired,
  onTypeChange: PropTypes.func,
  onChainChange: PropTypes.func,
  insdustyPrice: PropTypes.array.isRequired,
  agentType: PropTypes.string.isRequired,
  editType: PropTypes.string.isRequired,
  totalProfit: PropTypes.number,
  agent: PropTypes.object,
  userList: PropTypes.array.isRequired,
  level: PropTypes.number,
  isPlatform: PropTypes.bool.isRequired,
  parentChainData: PropTypes.object,
  queryAgent: PropTypes.object.isRequired,
  isNextAndCreateStore: PropTypes.bool.isRequired,
  isIndustryChanged: PropTypes.bool.isRequired,
  onChangeIndustry: PropTypes.func,
};

AgentForm.defaultProps = {
  onChainChange: null,
  onTypeChange: null,
  parentChainData: null,
  totalProfit: 100,
  level: 0,
  onChangeIndustry: null,
  agent: {},
};

const Container = Form.create()(AgentForm);

export { Container as AgentForm };
