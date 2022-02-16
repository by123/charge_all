import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Form, Input, Button, Row, Checkbox, Col } from 'antd';

import { action as commonActions } from '../../store/global';

import { ModifyPasswordModal } from '../../containers/ModifyPassword';
import { FindPasswordModal } from '../../containers/FindPassword';
import { SYSTEM_NAME } from '../../utils/constants';

import loginBg from '../../images/login_bg.png';
import loginLogo from '../../images/logo.png';
import Footer from '../../components/layout/footer';

import './login.less';

const FormItem = Form.Item;
class Login extends React.Component {
  state = {
    accountClass: '',
    passwordClass: '',
    codeClass: '',
  }

  handlePasswordChange = (e) => {
    const { dispatch, loginErr } = this.props;
    loginErr.validateStatus && dispatch(commonActions.resetLoginErrInfo());

    this.setState({
      passwordClass: this.formatClass(e.currentTarget.value),
    });
  };

  handleSubmit = (e) => {
    e.preventDefault();
    const { dispatch, form: { validateFieldsAndScroll } } = this.props;
    validateFieldsAndScroll((errors, values) => {
      if (errors) {
        return;
      }
      values.userName = values.userName.trim();
      values.password = values.password.trim();
      dispatch(commonActions.login(values));
      this.resetCodeInput();
    });
  };

  getImageCode = () => {
    const { dispatch } = this.props;
    dispatch(commonActions.generateUuid());
    dispatch(commonActions.getImageCode());
  };

  componentDidMount = () => {
    this.getImageCode();
    this.getPassword();

    setTimeout(this.setInputClass, 1000);
  };

  handleAccountChange = (e) => {
    this.setState({
      accountClass: this.formatClass(e.currentTarget.value),
    });
  };

  handleCodeChange = (e) => {
    this.setState({
      codeClass: this.formatClass(e.currentTarget.value),
    });
  };

  setInputClass = () => {
    const { form: { getFieldsValue } } = this.props;
    const { code, password, userName } = getFieldsValue(['userName', 'password', 'code']);
    this.setState({
      accountClass: this.formatClass(userName),
      passwordClass: this.formatClass(password),
      codeClass: this.formatClass(code),
    });
  };

  formatClass = (value) => {
    if (value === undefined) return '';
    return String(value).length > 0 ? 'active-item' : '';
  };

  resetCodeInput = () => {
    const { form: { setFieldsValue } } = this.props;
    setFieldsValue({ code: '' });
    this.getImageCode();
    this.setState({
      codeClass: '',
    });
  };

  getPassword = () => {
    const { dispatch } = this.props;
    dispatch(commonActions.getAccountInfo());
  }

  toggleFindPassword = (visible) => {
    this.props.dispatch(commonActions.toggleFindPassword(visible));
  }

  render() {
    const {
      loginErr,
      loginData,
      form: {
        getFieldDecorator,
      },
      codeData,
      accountInfo,
    } = this.props;
    const { passwordClass, accountClass, codeClass } = this.state;
    const codeSrc = `data:image/png;base64,${codeData.result}`;
    const { errType } = loginErr;
    let formObj = {
      codeClass,
      passwordClass,
      accountClass,
      accountErr: {},
      passwordErr: {},
      codeErr: {},
    };
    if (errType) {
      formObj[`${errType}Err`] = loginErr;
      formObj[`${errType}Class`] = 'error-item';
    }
    return (
      <div>
        <div className="login-wrapper">
          <img className="login-bg" alt={'loginBg'} src={loginBg} />
          <div className="login-form-wrap">
            <div className="login-form">
              <div className="login-logo">
                <img alt={'loginLogo'} src={loginLogo} />
                <span>{SYSTEM_NAME}</span>
              </div>
              <Form>
                <FormItem {...formObj.accountErr} className={`login-form-item first-item ${formObj.accountClass}`}>
                  {getFieldDecorator('userName', {
                    initialValue: accountInfo.userName || '',
                    rules: [
                      { required: true, whitespace: true, message: '请输入登录账号' },
                    ],
                  })(<Input size="large" onPressEnter={this.handleSubmit} onChange={this.handleAccountChange} placeholder="请输入登录账号" />)}
                </FormItem>
                <FormItem {...formObj.passwordErr} className={`login-form-item ${formObj.passwordClass}`}>
                  {getFieldDecorator('password', {
                    initialValue: accountInfo.password || '',
                    rules: [
                      { required: true, whitespace: true, message: '请输入登录密码' },
                    ],
                  })(<Input size="large" type="password" onPressEnter={this.handleSubmit} onChange={this.handlePasswordChange} placeholder="请输入登录密码" />)}
                </FormItem>
                <Row span={24} className={`login-form-item login-code-item ${formObj.codeClass}`}>
                  <Col span={12}>
                    <FormItem {...formObj.codeErr}>
                      {getFieldDecorator('code', {
                        rules: [
                          { required: true, whitespace: true, message: '请输入验证码' },
                        ],
                      })(<Input size="large" className="login-code-input" onChange={this.handleCodeChange} onPressEnter={this.handleSubmit} placeholder="验证码" />)}
                    </FormItem>
                  </Col>
                  <Col span={12} className="login-code-img">
                    {codeData.result && <img src={codeSrc} alt="验证码" onClick={this.getImageCode} />}
                  </Col>
                </Row>
                <Row className="login-remember-item">
                  <Col span={12} className="rememeber-checkbox">
                    {getFieldDecorator('remember')(<Checkbox>记住密码</Checkbox>)}
                  </Col>
                  <Col span={12} className="remember-a">
                    <a onClick={() => this.toggleFindPassword(true)}>找回密码</a>
                  </Col>
                </Row>
                <Row className="login-btn-item">
                  <Button className="login-btn" type="primary" onClick={this.handleSubmit} loading={loginData.loading}>
                    登录
                  </Button>
                </Row>
              </Form>
            </div>
          </div>
          {/* <Footer className="login-footer" /> */}
          <div className="login-footer"><Footer /></div>
        </div>
        <ModifyPasswordModal />
        <FindPasswordModal />
      </div>
    );
  }
}

Login.propTypes = {
  dispatch: PropTypes.func.isRequired,
  form: PropTypes.object.isRequired,
  loginData: PropTypes.object.isRequired,
  loginErr: PropTypes.object.isRequired,
  codeData: PropTypes.object.isRequired,
  accountInfo: PropTypes.object,
};

Login.defaultProps = {
  accountInfo: {},
};

const LoginForm = Form.create()(Login);
export default connect(({ global: { loginData, loginErr, codeData, accountInfo } }) => ({
  loginData, loginErr, codeData, accountInfo,
}))(LoginForm);
