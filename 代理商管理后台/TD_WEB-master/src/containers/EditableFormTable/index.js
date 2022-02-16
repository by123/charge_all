import React from 'react';
import { Table, Popconfirm, Form, InputNumber, Input } from 'antd';

const EditableContext = React.createContext();

class EditableCell extends React.Component {
  getInput = () => {
    const { inputType, min, max } = this.props;
    if (inputType === 'number') {
      return <InputNumber min={min} max={max} />;
    }
    return <Input />;
  };

  renderCell = ({ getFieldDecorator }) => {
    const {
      editing,
      dataIndex,
      title,
      inputType,
      record,
      index,
      children,
      ...restProps
    } = this.props;
    return (
      <td {...restProps}>
        {editing ? (
          <Form.Item style={{ margin: 0 }}>
            {getFieldDecorator(dataIndex, {
              initialValue: record[dataIndex],
            })(this.getInput())}
          </Form.Item>
        ) : (
          children
        )}
      </td>
    );
  };

  render() {
    return <EditableContext.Consumer>{this.renderCell}</EditableContext.Consumer>;
  }
}

class EditableTable extends React.Component {
  constructor(props) {
    super(props);
    this.state = { editingKey: '' };
  }

  isEditing = record => {
    return this.getKey(record) === this.state.editingKey;
  }

  cancel = () => {
    this.setState({ editingKey: '' });
  }

  save(form, key) {
    const { tableProps: { dataSource, onSave } } = this.props;
    form.validateFields((error, values) => {
      if (error) {
        return;
      }

      const newData = [...dataSource];
      const index = newData.findIndex(item => key === this.getKey(item));
      if (index > -1) {
        onSave && onSave(values, newData[index]);
        this.setState({
          editingKey: '',
        });
      }
    });
  }

  edit(key) {
    this.setState({ editingKey: key });
  }

  getKey = (record) => {
    const { tableProps: { rowKey } } = this.props;
    return record[rowKey] || '';
  }

  addEditItem = (columns) => {
    if (columns[columns.length - 1].dataIndex === 'operation') return;
    columns.push({
      title: '操作',
      dataIndex: 'operation',
      render: (text, record) => {
        const { editingKey } = this.state;
        const editable = this.isEditing(record);
        return editable ? (
          <span>
            <EditableContext.Consumer>
              {form => (
                <a
                  onClick={() => this.save(form, this.getKey(record))}
                  style={{ marginRight: 8 }}
                >
                  保存
                </a>
              )}
            </EditableContext.Consumer>
            <Popconfirm title="确定取消编辑吗？" onConfirm={() => this.cancel(this.getKey(record))}>
              <a>取消</a>
            </Popconfirm>
          </span>
        ) : (
          <a disabled={editingKey !== ''} onClick={() => this.edit(this.getKey(record))}>
            编辑
          </a>
        );
      },
    });
  }

  render() {
    const {
      tableProps,
    } = this.props;
    const components = {
      body: {
        cell: EditableCell,
      },
    };
    let columns = this.props.tableProps.columns;
    this.addEditItem(columns);
    columns = columns.map(col => {
      if (!col.editable) {
        return col;
      }
      return {
        ...col,
        onCell: record => ({
          record,
          inputType: col.inputType || 'number',
          min: col.min,
          dataIndex: col.dataIndex,
          title: col.title,
          editing: this.isEditing(record),
        }),
      };
    });

    return (
      <EditableContext.Provider value={this.props.form}>
        <Table
          components={components}
          {...tableProps}
          columns={columns}
          rowClassName="editable-row"
        />
      </EditableContext.Provider>
    );
  }
}

const EditableFormTable = Form.create()(EditableTable);
export { EditableFormTable };
