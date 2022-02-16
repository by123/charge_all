import React from 'react';
import { Radio, message } from 'antd';

import { NumberInput } from './NumberInput';
import { RangeInput } from './RangeInput';

const RadioGroup = Radio.Group;
const RadioButton = Radio.Button;


export class DeviceInput extends React.PureComponent {
  state = {
    current: 1,
    value: '', // 设备sn，使用逗号分割
  }
  changeInput = (e) => {
    this.setState({ current: e.target.value });
  }
  changeValue = (value) => {
    this.setState({ value });
  }
  /**
   * 获取输入的设备sn，或者根据输入范围生成sn
   * @returns {*} Array
   */
  getIds = () => {
    if (this.state.current === 1) {
      const ids = this.state.value.trim();
      if (!ids || ids === '') {
        message.error('请输入设备编号');
        return false;
      }
      return ids.split(',');
    }
    return this.rangeInput.getIds();
  }
  render() {
    const { current, value } = this.state;
    return (<div className="input-device-wrap">
      <div className="steps-switch">
        <RadioGroup value={current} onChange={this.changeInput}>
          <RadioButton value={1}>输入设备编号分配</RadioButton>
          <RadioButton value={2}>按照设备起止编号添加</RadioButton>
        </RadioGroup>
      </div>
      <div>
        { current === 1 && <NumberInput value={value} onChange={this.changeValue} /> }
        { current === 2 && <RangeInput wrappedComponentRef={instance => { this.rangeInput = instance; }} /> }
      </div>
    </div>);
  }
}

// DeviceInput.propTypes = {
//   onChange: PropTypes.func.isRequired,
// };
