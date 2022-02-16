import React from 'react';
import PropTypes from 'prop-types';

import { Form, Input, Button, Col, Row, Icon } from 'antd';
import { FileInput } from '@/components/InputFile';

const FormItem = Form.Item;
const formItemLayout = {
  labelCol: { span: 6 },
  wrapperCol: { span: 14 },
};

const leftColLayout = {
  labelCol: { span: 12 },
  wrapperCol: { span: 12 },
};

const rightColLayout = {
  labelCol: { span: 4 },
  wrapperCol: { span: 12 },
};

const buttonItemLayout = {
  wrapperCol: { offset: 6, span: 8 },
};

class DynamicForm extends React.Component {
  state = {
    childForm: [],
    initialChild: null,
  }
  componentWillUnmount() {
    this.initPending && this.initPending.cancel();
  }

  handleAddChild = () => {
    const childForm = this.state.childForm;

    // const { getFieldValue, setFieldsValue } = this.props.form;
    // const initialValue = getFieldValue('initialChild');
    // setFieldsValue({ initialChild: null });
    let k = 0;
    if (childForm.length > 0) {
      k = childForm[childForm.length - 1].key;
      k++;
    }
    const item = {
      key: k,
      name: 'cars',
      initialValue: this.state.initialChild,
    };

    const nextChildForm = childForm.concat(item);
    this.setState({
      childForm: nextChildForm,
      initialChild: null,
    });
  }

  handleInitialChild = (e) => {
    this.setState({
      initialChild: e.target.value,
    });
  }
  handleRemoveChild = (index) => {
    // console.log(index);
    const childForm = [...this.state.childForm];
    childForm.splice(index, 1);
    this.setState({ childForm });
  }

  handleSubmit = (e) => {
    e.preventDefault();
    this.props.form.validateFieldsAndScroll((err, data) => {
      if (err) {
        return;
      }
      console.log(data);
    });
  }

  renderChildForm = () => {
    const { getFieldDecorator } = this.props.form;
    return this.state.childForm.map((child, index) => (
      <Row key={child.key} >
        <Col span={12}>
          <FormItem label="标题12" {...leftColLayout}>
            {getFieldDecorator(`${child.name}[${child.key}]['a']`, {
              rules: [
                {
                  required: true,
                  message: '请填写标题',
                },
                {
                  max: 30,
                  message: '您输入的标题过长，请控制在30个字以内',
                },
              ],
            })(<Input />)}
          </FormItem>
        </Col>
        <Col span={12}>
          <FormItem label="标题22" {...rightColLayout}>
            {getFieldDecorator(`${child.name}[${child.key}]['b']`, {
              rules: [
                {
                  required: true,
                  message: '请填写标题',
                },
                {
                  max: 30,
                  message: '您输入的标题过长，请控制在30个字以内',
                },
              ],
            })(<Input style={{ width: '80%', marginRight: 20 }} />)}
            <Icon
              style={{ fontSize: 16, color: '#108ee9' }}
              type="minus-circle"
              onClick={this.handleRemoveChild.bind(null, index)}
            />
          </FormItem>
        </Col>
      </Row>
    ));
  }
  render() {
    const { getFieldDecorator } = this.props.form;
    const fileInputProps = {
      formItemProps: {
        label: '资料上传',
        ...formItemLayout,
      },
      form: this.props.form,
      rules: [{ message: '请上传资料', required: true }],
      maxLength: 5,
      maxSize: 1024 * 5,
      initialValue: 'Fu69ZXzMPKX1_9CNmcP5fZ8ho29N',
    };

    const normalFileProps = {
      ...fileInputProps,
      type: 'text',
      name: 'file1',
      maxLength: 10,
    };
    const tableFileProps = {
      ...fileInputProps,
      type: 'table',
      name: 'file6',
      maxLength: 10,
    };
    const imageFileProps = {
      ...fileInputProps,
      type: 'picture',
      name: 'file2',

    };
    const imageCardProps = {
      ...imageFileProps,
      type: 'picture-card',
      name: 'file3',
    };
    const imageDescProps = {
      ...imageFileProps,
      type: 'picture-desc',
      initialValue: [{ uuid: 'Fu69ZXzMPKX1_9CNmcP5fZ8ho29N', desc: '' }, { uuid: 'FuC7VIzefdD47S72ak4abWOuzqRk', desc: '哈哈哈' }, { uuid: 'FuC7VIzefdD47S72ak4abWOuzqRk', desc: '' }, { uuid: 'FuC7VIzefdD47S72ak4abWOuzqRk', desc: '' }, { uuid: 'FoVoK4arLNgb9g81-K51y3chuRp-', desc: '' }, { uuid: 'FuC7VIzefdD47S72ak4abWOuzqRk', desc: '哈哈哈' }, { uuid: 'FuC7VIzefdD47S72ak4abWOuzqRk', desc: '' }, { uuid: 'FuC7VIzefdD47S72ak4abWOuzqRk', desc: '' }],
      name: 'file4',
      descPlaceholder: '请输入描述',
      maxLength: 10,
    };
    // console.log('file1', getFieldValue('file1'));
    getFieldDecorator('hidden', { initialValue: 'aaaaa' }); // 自动生成的字段，无需用户去填写的，可用这种方式
    return (
      <div className="form-wrapper">
        <Form onSubmit={this.handleSubmit}>
          <Row>
            <Col span={12}>
              <FormItem label="标题" {...leftColLayout}>
                {getFieldDecorator('title', {
                  initialValue: 'aaaaa',
                  rules: [
                    {
                      required: true,
                      message: '请填写标题',
                    },
                    {
                      max: 30,
                      message: '您输入的标题过长，请控制在30个字以内',
                    },
                  ],
                })(<Input />)}
              </FormItem>
            </Col>
            <Col span={12}>
              <FormItem label="标题" {...rightColLayout}>
                {getFieldDecorator('title1', {
                  initialValue: 'aaaaa',
                  rules: [
                    {
                      required: true,
                      message: '请填写标题',
                    },
                    {
                      max: 30,
                      message: '您输入的标题过长，请控制在30个字以内',
                    },
                  ],
                })(<Input />)}
              </FormItem>
            </Col>
          </Row>
          <FormItem label="标题" {...formItemLayout}>
            {getFieldDecorator('title1', {
              initialValue: 'aaaaa',
              rules: [
                {
                  required: true,
                  message: '请填写标题',
                },
                {
                  max: 30,
                  message: '您输入的标题过长，请控制在30个字以内',
                },
              ],
            })(<Input />)}
          </FormItem>
          <FileInput {...normalFileProps} />
          <FileInput {...tableFileProps} />
          <FileInput {...imageFileProps} />
          <FileInput {...imageCardProps} />
          <FileInput {...imageDescProps} />

          <FormItem {...buttonItemLayout}>
            <Button type="default" onClick={this.handleAddChild}>加一个</Button>
          </FormItem>
          {this.renderChildForm()}
          <FormItem {...buttonItemLayout}>
            <Button type="primary" htmlType="submit" className="margin-right">保存</Button>
            <Button type="default" onClick={this.handleBackList}>返回</Button>
          </FormItem>
        </Form>

      </div>
    );
  }
}

DynamicForm.propTypes = {
  form: PropTypes.object.isRequired,
};

export default Form.create()(DynamicForm);
