import {
  Form, InputNumber,
} from 'antd';
import PropTypes from 'prop-types';
import React from 'react';

const FormItem = Form.Item;
const EditableContext = React.createContext();

const EditableRow = ({ form, index, ...props }) => (
  <EditableContext.Provider value={form}>
    <tr {...props} />
  </EditableContext.Provider>
);

const EditableFormRow = Form.create()(EditableRow);

class EditableCell extends React.Component {
  save = (e) => {
    const { record, handleSaveItem } = this.props;
    this.form.validateFields((error, values) => {
      if (error && error[e.currentTarget.id]) {
        return;
      }
      this.toggleEdit();
      handleSaveItem({ ...record, ...values });
    });
  }

  render() {
    const {
      editable,
      dataIndex,
      title,
      record,
      index,
      handleSave,
      editing,
      form: wrapForm,
      saveInstance,
      ...restProps
    } = this.props;
    return (
      <td {...restProps}>
        {editable ? (
          <EditableContext.Consumer>
            {() => {
              return (
                editing ? (
                  <FormItem style={{ margin: 0 }}>
                    {wrapForm.getFieldDecorator(`${dataIndex}$${index}`, {
                      initialValue: record[dataIndex],
                      rules: [
                        {
                          type: 'number',
                          min: 0,
                          message: '最小值为0',
                        },
                      ],
                    })(
                      <InputNumber
                        precision={0}
                        ref={node => { this.input = node; }}
                      />
                    )}
                  </FormItem>
                ) : (
                  <div
                    className="editable-cell-value-wrap"
                    style={{ paddingRight: 24 }}
                  >
                    {restProps.children}
                  </div>
                )
              );
            }}
          </EditableContext.Consumer>
        ) : restProps.children}
      </td>
    );
  }
}

EditableCell.propTypes = {
  form: PropTypes.object.isRequired,
  record: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired,
  handleSaveItem: PropTypes.func.isRequired,
  editable: PropTypes.bool.isRequired,
  dataIndex: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
  saveInstance: PropTypes.func.isRequired,
  handleSave: PropTypes.func.isRequired,
  editing: PropTypes.bool.isRequired,
};

EditableCell.defaultProps = {

};

EditableRow.propTypes = {
  form: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired,
  saveInstance: PropTypes.func.isRequired,
  handleSave: PropTypes.func.isRequired,
  editing: PropTypes.bool.isRequired,
};

export { EditableCell, EditableFormRow };
