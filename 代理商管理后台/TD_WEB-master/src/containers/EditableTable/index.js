import {
  Table, Button, Form,
} from 'antd';
import React from 'react';
import PropTypes from 'prop-types';
import { EditableCell, EditableFormRow } from './EditableFormRow';

class EditableTable extends React.Component {
  state = {
    editing: false,
    formArr: [],
  }

  toggleEdit = (isEdit) => {
    this.setState({
      editing: isEdit,
    });
  }

  formatValuesToArr = (values) => {
    let result = [];
    Object.keys(values).map((val) => {
      const valArr = val.split('$');
      const index = valArr[1];
      const dataIndex = valArr[0];
      result[index] = result[index] || {};
      result[index][dataIndex] = values[val];
      return null;
    });
    return result;
  }

  formatDate = (date) => {
    // return moment(date).format('YYYY-MM-DD');
    return date;
  }

  handleSave = () => {
    const { dataSource, form, handleSave } = this.props;
    form.validateFields((error, values) => {
      if (error) return;
      const formDataArr = this.formatValuesToArr(values);
      const newData = formDataArr.map((item, ind) => {
        let result = dataSource[ind];
        result = {
          ...result,
          ...item,
        };
        if (result.planDate) {
          result.planDate = this.formatDate(result.planDate);
        }
        if (result.deliverDate) {
          result.deliverDate = this.formatDate(result.deliverDate);
        }
        return result;
      });
      handleSave && handleSave(newData);
      this.toggleEdit(false);
    });
  }

  renderEditBtn = () => {
    return (<div style={{ marginTop: 20, textAlign: 'center' }}>
      {!this.state.editing && <Button type="primary" onClick={() => this.toggleEdit(true)}>编辑</Button>}
      {this.state.editing && (<div>
        <Button type="primary" onClick={this.handleSave}>保存</Button>
        <Button style={{ marginLeft: 20 }} onClick={() => this.toggleEdit(false)}>取消</Button>
      </div>)}
    </div>);
  }

  saveInstance = (index, form) => {
    const { formArr } = this.state;
    formArr[index] = form;
    this.setState({
      formArr,
    });
  }

  render() {
    const components = {
      body: {
        row: EditableFormRow,
        cell: EditableCell,
      },
    };
    let { columns, dataSource, form, ...otherProps } = this.props;
    const { editing } = this.state;
    columns = columns.map((col) => {
      if (!col.editable) {
        return col;
      }
      return {
        ...col,
        onCell: (record, index) => ({
          record,
          editing,
          saveInstance: this.saveInstance,
          editable: col.editable,
          dataIndex: col.dataIndex,
          title: col.title,
          form,
          index,
          handleSave: this.handleSave,
        }),
      };
    });
    return (
      <div>
        <Table
          components={components}
          rowClassName={() => 'editable-row'}
          bordered
          dataSource={dataSource}
          columns={columns}
          {...otherProps}
        />
        {this.renderEditBtn()}
      </div>
    );
  }
}

EditableTable.propTypes = {
  columns: PropTypes.array.isRequired,
  dataSource: PropTypes.array,
  editing: PropTypes.bool,
  form: PropTypes.object.isRequired,
  handleSave: PropTypes.func,
};

EditableTable.defaultProps = {
  editing: false,
  dataSource: [],
  handleSave: null,
};

const EditableFormTable = Form.create()(EditableTable);

export { EditableFormTable as EditableTable };
