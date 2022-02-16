import React from 'react';
import PropTypes from 'prop-types';
import { Radio, Divider, Form, Input } from 'antd';
import { Select } from '../pop';
import { mapArrayToOptions } from '../../utils';
import { agentAccountLabel, agentAccountValue } from '../../utils/enum';
import AgentFilter from '../../containers/AgentFilter';

import './style.less';
import BizSelect from '../../containers/BizSelect';

const RadioGroup = Radio.Group;
const FormItem = Form.Item;

export class BindAgent extends React.PureComponent {
  changeType = (e) => {
    this.props.form.setFieldsValue({ agentType: e.target.value });
    this.props.form.setFieldsValue({ agent: undefined });
    this.props.form.setFieldsValue({ biz: undefined });
    // this.props.form.resetFields(['agent', 'biz']);
  }

  onChangeAgent = (value) => {
    this.props.form.setFieldsValue({ agent: value });
  }

  onChangeBiz = (value) => {
    this.props.form.setFieldsValue({ biz: value });
  }

  render() {
    const {
      form: {
        getFieldDecorator,
        getFieldValue,
      },
      formData,
      queryAgent,
      disabled = false,
      category,
      childUseable,
      multiple, // 是否使用级联选择器
    } = this.props;
    const queryList = queryAgent.result || [];
    const agentList = queryList.filter(item => item.mchType === 0);
    const bizList = queryList.filter(item => item.mchType === 1);
    const initialType = formData.agentType || 1;
    getFieldDecorator('agentType', { initialValue: initialType });
    let type = getFieldValue('agentType') || initialType;
    if (category) {
      type = category === 'agent' ? 1 : 2;
    }
    // 代理商账号过滤
    const agentFilter = item => {
      return item.mchType === 0;
    };
    const agentSelectColumns = {
      placeholder: '请选择代理商账号',
      changeOnSelect: true,
      childUseable,
      listFilter: agentFilter,
      showMchId: true,
      disabled: disabled || type === 2,
      mchType: 0,
    };
    // const bizSelectColumns = {
    //   placeholder: '请选择商户账号',
    //   changeOnSelect: false,
    //   childUseable,
    //   listFilter: bizFilter,
    //   showMchId: true,
    //   checkUseable,
    //   disabled: disabled || type === 1,
    // };
    return (<div className="bind-agent-wrap">
      <div className="bind-agent">
        <RadioGroup style={{ width: '100%' }} onChange={this.changeType} value={type}>
          {(!category || category === 'agent') && (<Radio value={1} disabled={disabled}>
            <span className="label">绑定子级代理商: </span>
            {multiple ? (
              <FormItem className="value js-bind-agent">
                {
                  getFieldDecorator('agent', {
                    initialValue: formData.agent,
                    rules: [
                      { required: type === 1, message: '请选择代理商账号' },
                    ],
                  })(<Input hidden />)
                }
                <AgentFilter onChange={this.onChangeAgent} column={agentSelectColumns} />
              </FormItem>
            ) : (
              <FormItem className="value">
                {getFieldDecorator('agent', {
                  initialValue: formData.agent,
                  rules: [
                    { required: type === 1, whitespace: true, message: '请选择代理商账号' },
                  ],
                })(<Select style={{ width: '100%' }} placeholder="请选择代理商账号" disabled={disabled || type === 2} >
                  {mapArrayToOptions(agentList, agentAccountValue, agentAccountLabel)}
                </Select>)}
              </FormItem>
            )}
          </Radio>)}
          {!category && <Divider />}
          {(!category || category === 'business') && (
            <Radio value={2} disabled={disabled}>
              <span className="label">选择商户（直属）: </span>
              {!multiple ? (<FormItem className="value">
                {getFieldDecorator('biz', {
                  initialValue: formData.biz,
                  rules: [
                    { required: type === 2, whitespace: true, message: '请选择商户账号' },
                  ],
                })(<Select style={{ width: '100%' }} placeholder="请选择商户账号" disabled={disabled || type === 1} >
                  {mapArrayToOptions(bizList, 'superUser', agentAccountLabel)}
                </Select>)}
              </FormItem>) : (<FormItem className="value">
                {
                  getFieldDecorator('biz', {
                    initialValue: formData.biz,
                    rules: [
                      { required: type === 2, message: '请选择商户账号' },
                    ],
                  })(<Input hidden />)
                }
                <BizSelect
                  // form={this.props.form}
                  onChange={this.onChangeBiz}
                />
              </FormItem>)
              }
            </Radio>)
          }
        </RadioGroup>
      </div>
    </div>);
  }
}
// <AgentFilter column={bizSelectColumns} />

BindAgent.propTypes = {
  form: PropTypes.object.isRequired,
  queryAgent: PropTypes.object.isRequired,
  formData: PropTypes.object,
  defaultValue: PropTypes.string,
  disabled: PropTypes.bool,
  category: PropTypes.string,
  childUseable: PropTypes.bool,
  multiple: PropTypes.bool,
};

BindAgent.defaultProps = {
  defaultValue: '',
  formData: {},
  disabled: false,
  category: '',
  childUseable: false,
  multiple: false,
};
