import React from 'react';
import { Row, Col, Form } from 'antd';

const FormItem = Form.Item;

class FormItemWrapper extends React.Component {

  render() {
    const {
      label,
      children,
      extraText,
      required = true,
    } = this.props;

    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 16 },
    };
    return (<Row>
      <Col span={18}>
        <FormItem label={label} required={required} {...formItemLayout}>{children}</FormItem>
      </Col>
      {extraText && <Col span={4}><span className="tip">{extraText}</span></Col>}
    </Row>);
  }
}

export { FormItemWrapper };
