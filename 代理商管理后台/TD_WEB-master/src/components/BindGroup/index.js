import React from 'react';
import PropTypes from 'prop-types';
import { Form } from 'antd';
import { Select } from '../pop';
import { mapArrayToOptions } from '../../utils';

import './style.less';

const FormItem = Form.Item;

class BindGroup extends React.PureComponent {
  render() {
    const {
      form: {
        getFieldDecorator,
      },
      formData,
      groupList,
      dataIndax = 'groupId',
    } = this.props;
    const queryList = groupList.result || [];

    const selectOptions = {
      placeholder: '请选择分组',
      style: { width: 200 },
      onChange: this.props.onChange,
    };

    return (<div className="bind-group-wrap">
      <div className="bind-group">
        <span className="label">请选择分组: </span>
        <FormItem className="value">
          {getFieldDecorator(dataIndax, {
            initialValue: formData[dataIndax],
            rules: [
              { required: true, message: '请选择分组' },
            ],
          })(<Select {...selectOptions}>
            {mapArrayToOptions(queryList, 'groupId', 'groupName')}
          </Select>)}
        </FormItem>
      </div>
    </div>);
  }
}
// <AgentFilter column={bizSelectColumns} />

BindGroup.propTypes = {
  form: PropTypes.object.isRequired,
  groupList: PropTypes.object.isRequired,
  formData: PropTypes.object,
  onChange: PropTypes.func,
  dataIndax: PropTypes.string,
};

BindGroup.defaultProps = {
  formData: {},
  onChange: null,
  dataIndax: 'groupId',
};

const BindGroupForm = Form.create()(BindGroup);
export { BindGroupForm as BindGroup };
