import React from 'react';
import PropTypes from 'prop-types';
import { Form, Input, Row, Col, Button } from 'antd';
import { connect } from 'react-redux';
import { action as commonActions } from '../../store/global';
import './index.less';

const FormItem = Form.Item;
const formItemLayout = {
  labelCol: {
    span: 6,
  },
  wrapperCol: {
    span: 14,
  },
};
const codeItemLayout = {
  labelCol: {
    span: 9,
  },
  wrapperCol: {
    span: 12,
  },
};

const countTime = 60;

class FindPassword extends React.Component {
  state = {
    confirmDirty: false,
    time: countTime,
    countMsg: `${countTime}s后可重新发送`,
    disabled: true,
    timer: null,
    isCount: false,
  };
  componentDidMount() {
    const { dispatch, step } = this.props;
    if (step === 1) {
      dispatch(commonActions.generateUuid('findPasswordCode'));
      dispatch(commonActions.getImageCode('findPasswordCode'));
    } else if (step === 2) {
      !this.state.isCount && this.startCount();
    }
  }
  componentWillUnmount() {
    clearInterval(this.state.timer);
  }
  handleConfirmBlur = (e) => {
    const value = e.target.value;
    this.setState({ confirmDirty: this.state.confirmDirty || !!value });
  }
  handleCheckPassword = (rule, value, callback) => {
    const form = this.props.form;
    if (value && value !== form.getFieldValue('password')) {
      callback('两次密码不一致，请重新填写!');
    } else {
      callback();
    }
  }
  handleCheckConfirm = (rule, value, callback) => {
    const form = this.props.form;
    if (value && this.state.confirmDirty) {
      form.validateFieldsAndScroll(['confirm'], { force: true });
    }
    callback();
  }
  getImageCode = () => {
    const { dispatch } = this.props;
    dispatch(commonActions.generateUuid('findPasswordCode'));
    dispatch(commonActions.getImageCode('findPasswordCode'));
  }
  startCount = () => {
    let { time, timer } = this.state;
    clearInterval(timer);
    timer = setInterval(() => {
      if (time > 0) {
        this.setState({
          time: --time,
          disabled: true,
          countMsg: `${time}s后可重新发送`,
        });
      } else {
        this.setState({
          disabled: false,
          time: countTime,
          countMsg: '发送验证码',
        });
        clearInterval(timer);
      }
    }, 1000);
    this.setState({
      timer,
      isCount: true,
    });
  }
  getMessageCode = () => {
    const { tmpData: {
      userName,
    } } = this.props;
    this.props.dispatch(commonActions.findGetSmsCodeAgain({ userName }, () => {
      this.setState({
        time: countTime,
        isCount: false,
      });
      this.startCount();
    }));
  }
  render() {
    const {
      form: {
        getFieldDecorator,
      },
      step = 1,
      findPasswordCode = {},
      findPasswordResult = {},
      tmpData,
    } = this.props;
    const { disabled } = this.state;
    const phoneNumber = findPasswordResult.result || tmpData.phoneNumber || '';
    const codeSrc = `data:image/png;base64,${findPasswordCode.result}`;
    return (<Form layout="horizontal" autoComplete="off" className="find-password-wrapper">
      {step === 1 && <div>
        <FormItem label="登录账号" {...formItemLayout}>
          {getFieldDecorator('userName', {
            rules: [
              {
                required: true,
                whitespace: true,
                message: '请填写登录账号',
              },
            ],
          })(
            <Input placeholder="请填写登录账号" />
          )}
        </FormItem>
        <Row span={24} className="">
          <Col span={16}>
            <FormItem label="验证码" {...codeItemLayout}>
              {getFieldDecorator('code', {
                rules: [
                  { required: true, whitespace: true, message: '请输入验证码' },
                ],
              })(<Input autoComplete="off" size="large" placeholder="验证码" />)}
            </FormItem>
          </Col>
          <Col span={8} className="code-img">
            {findPasswordCode.result && <img src={codeSrc} alt="验证码" onClick={this.getImageCode} />}
          </Col>
        </Row>
      </div>}
      {step === 2 && <div>
        <FormItem>已将验证码发送至您的账号联系手机（{phoneNumber}）</FormItem>
        <Row>
          <Col span={16}>
            <FormItem label="手机验证码" {...codeItemLayout}>
              {getFieldDecorator('smsCode', {
                rules: [
                  {
                    required: true,
                    whitespace: true,
                    message: '请填写手机验证码',
                  },
                ],
              })(<Input placeholder="请输入验证码" />)}
            </FormItem>
          </Col>
          <Col span={6}>
            <FormItem><Button disabled={disabled} type="primary" onClick={this.getMessageCode}>{this.state.countMsg}</Button></FormItem>
          </Col>
        </Row>
      </div>}
      {step === 3 && <div>
        <FormItem label="设置新密码" {...formItemLayout}>
          {getFieldDecorator('password', {
            rules: [
              {
                required: true,
                whitespace: true,
                message: '请填写新密码',
              },
              {
                min: 6,
                message: '最少6个字符',
              },
              {
                max: 20,
                message: '最多20个字符',
              },
              {
                validator: this.handleCheckConfirm,
              }],
          })(<Input type="password" autoComplete="off" placeholder="最少6个字符" />)}
        </FormItem>
        <FormItem label="确认新密码" hasFeedback {...formItemLayout}>
          {getFieldDecorator('confirmPassword', {
            rules: [
              {
                required: true,
                whitespace: true,
                message: '请重复填写新密码',
              },
              {
                min: 6,
                message: '最少6个字符',
              },
              {
                max: 20,
                message: '最多20个字符',
              },
              {
                validator: this.handleCheckPassword,
              }],
          })(<Input type="password" autoComplete="off" placeholder="请重复填写新密码" onBlur={this.handleConfirmBlur} />)}
        </FormItem>
      </div>}
    </Form>);
  }
}

FindPassword.propTypes = {
  form: PropTypes.object.isRequired,
  findPasswordCode: PropTypes.object.isRequired,
  findPasswordResult: PropTypes.object.isRequired,
  dispatch: PropTypes.bool.isRequired,
  step: PropTypes.number.isRequired,
  tmpData: PropTypes.object.isRequired,
};

export default connect(({ global: { findPasswordCode, findPasswordResult } }) => ({
  findPasswordCode,
  findPasswordResult,
}))(Form.create()(FindPassword));
