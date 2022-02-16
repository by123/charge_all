import React from 'react';
import PropTypes from 'prop-types';

import { Button, Modal, Table, Form, Input } from 'antd';

const FormItem = Form.Item;

const data = [
  {
    id: 1,
    name: 'caicai',
    age: 20,
  },
  {
    id: 21,
    name: 'ddddd',
    age: 20,
  },
  {
    id: 3,
    name: 'eee',
    age: 22,
  },
  {
    id: 4,
    name: 'caicai',
    age: 23,
  },
];
class TableDemo extends React.Component {
  state = {
    visible: false,
    sum: null,
    selectedRowKeys: [21],
  }
  handleOpenModal = () => {
    this.setState({
      visible: true,
      sum: null,
    });
  }
  handleOk = () => {
    const fields = this.props.form.getFieldsValue();
    console.log(fields);
  }

  render() {
    const { visible, sum, selectedRowKeys } = this.state;
    const {
      form: {
        getFieldDecorator,
      },
    } = this.props;
    const modalProps = {
      title: '测试Table',
      visible,
      onOk: this.handleOk,
      onCancel: () => this.setState({ visible: false, sum: null, selectedRowKeys: [] }),
    };
    const columns = [
      { title: '姓名', dataIndex: 'name' },
      { title: '年龄', dataIndex: 'age' },
    ];
    const rowSelection = {
      selectedRowKeys,
      onChange: (keys, rows) => {
        console.log('key:', keys, rows);
        const age = rows.reduce((pre, next) => {
          return pre + next.age;
        }, 0);
        this.setState({ sum: age, selectedRowKeys: keys });
      },
    };
    return (<div>
      <h1>表格Demo</h1>
      <Button onClick={this.handleOpenModal}>打开Modal</Button>
      <Modal {...modalProps}>
        <Table rowKey="id" columns={columns} dataSource={data} rowSelection={rowSelection} />
        <FormItem label="合计">
          {getFieldDecorator('sum', { initialValue: sum })(<Input />)}
        </FormItem>
      </Modal>
    </div>);
  }
}

TableDemo.propTypes = {
  form: PropTypes.object.isRequired,
};

export default Form.create()(TableDemo);
