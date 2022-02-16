import React from 'react';
import PropTypes from 'prop-types';
import { Form, Input } from 'antd';

const FormItem = Form.Item;
const formItemLayout = {
  labelCol: {
    span: 6,
  },
  wrapperCol: {
    span: 14,
  },
};
const styles = {
  firstTip: {
    textAlign: 'center',
  },
};

class ModifyPassword extends React.Component {
  state = {
    confirmDirty: false,
  };
  componentDidMount() {
  }
  handleConfirmBlur = (e) => {
    const value = e.target.value;
    this.setState({ confirmDirty: this.state.confirmDirty || !!value });
  }
  handleCheckPassword = (rule, value, callback) => {
    const form = this.props.form;
    if (value && value !== form.getFieldValue('submitPwd')) {
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
  render() {
    const {
      form: {
        getFieldDecorator,
      },
      isFirst,
    } = this.props;
    return (<Form layout="horizontal" autoComplete="off">
      {!isFirst && <FormItem label="原密码" {...formItemLayout}>
        {getFieldDecorator('oldPwd', {
          rules: [
            {
              required: true,
              whitespace: true,
              message: '请填写原密码',
            },
          ],
        })(
          <Input type="password" placeholder="请填写原密码" />
        )}
      </FormItem>
      }
      {isFirst && <FormItem>
        <div className="first-tip" style={styles.firstTip}>为了您的账号安全，首次登录请修改初始密码</div>
      </FormItem>}
      <FormItem label="新密码" hasFeedback {...formItemLayout}>
        {getFieldDecorator('submitPwd', {
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
        })(<Input type="password" placeholder="最少6个字符" />)}
      </FormItem>
      <FormItem label="重复新密码" hasFeedback {...formItemLayout}>
        {getFieldDecorator('conformPwd', {
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
        })(<Input type="password" placeholder="请重复填写新密码" onBlur={this.handleConfirmBlur} />)}
      </FormItem>
    </Form>);
  }
}

ModifyPassword.propTypes = {
  form: PropTypes.object.isRequired,
  isFirst: PropTypes.bool.isRequired,
};

export default Form.create()(ModifyPassword);
