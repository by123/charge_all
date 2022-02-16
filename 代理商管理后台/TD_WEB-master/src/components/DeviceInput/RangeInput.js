import React from 'react';
import PropTypes from 'prop-types';
import { Input, Form, Row, Col, Icon, message } from 'antd';
import uniq from 'lodash/uniq';

import './style.less';

const InputGroup = Input.Group;

const colProps = {
  col1: { span: 5, style: { textAlign: 'right' } },
  col2: { span: 14 },
  col3: { span: 4 },
};

let uuid = 0;

/**
 * 根据输入范围生成设备sn号
 * @param start String
 * @param end   String
 * @returns {Array}
 */
function generatorDeviceIds(start, end) {
  function newDeviceId(prefix, index) {
    const base = 10000000000; // 10个0，补0
    return prefix + (base + index).toString().substr(1, 10);
  }
  function getDeviceSequence(sn) {
    return +(sn.substr(-10, 10));
  }
  const startIndex = getDeviceSequence(start);
  const endIndex = getDeviceSequence(end);
  const prefix = start.substring(0, 6);
  const snArr = [];
  for (let i = startIndex; i <= endIndex; i++) {
    snArr.push(newDeviceId(prefix, i));
  }
  return snArr;
}

class RangeInput extends React.PureComponent {
  componentDidMount() {
    this.handleAddRange(); // 默认先添加一条
  }

  handleAddRange = () => {
    const { form } = this.props;
    const keys = form.getFieldValue('keys');
    const nextKeys = keys.concat(uuid);
    uuid++;
    form.setFieldsValue({ keys: nextKeys });
  }

  handleRemoveRange = (k) => {
    const { form } = this.props;
    const keys = form.getFieldValue('keys');
    if (keys.length === 1) return;
    form.setFieldsValue({
      keys: keys.filter(key => key !== k),
    });
  }

  getIds = (type) => {
    const range = this.props.form.getFieldValue('range');
    // range
    let snArr = [];
    let snArr3 = [];
    range.forEach((item) => {
      let snArr2 = [];
      const { start, end } = item;
      if (!start || !end) {
        message.error('请输入设备编号范围');
        return false;
      }
      if ((start.length !== 16 || end.length !== 16)) {
        message.error('请输入正确的设备编号');
        return false;
      }
      const count = end.substr(-10, 10) - start.substr(-10, 10) + 1;
      if (!count || count < 1) {
        message.error('输入范围不正确');
        return false;
      }
      snArr = snArr.concat(generatorDeviceIds(start, end));
      if (type === 'initDevice') {
        snArr2[0] = start;
        snArr2[1] = end;
        snArr3.push(snArr2);
      }
    });
    snArr = uniq(snArr);
    if (type === 'initDevice') {
      return snArr3;
    }
    return snArr;
  }

  getRangeCount = (key) => {
    const { getFieldValue } = this.props.form;
    const range = getFieldValue(`range[${key}]`);
    if (!range) return '';
    const { start, end } = range;
    if (!start || !end) return '';
    if (start.length !== 16 || end.length !== 16) return '???';
    const count = end.substr(-10, 10) - start.substr(-10, 10) + 1;
    if (!count || count < 1) return '输入范围不正确';
    return `${count} 个`;
  }

  renderRangeItem = (key) => {
    const {
      form: {
        getFieldDecorator,
        getFieldValue,
      },
    } = this.props;
    const keys = getFieldValue('keys');
    return (<Row key={key} type="flex" justify="center" align="middle" gutter={10}>
      <Col {...colProps.col1}>设备编号起止区间:</Col>
      <Col {...colProps.col2}>
        <InputGroup compact>
          {getFieldDecorator(`range[${key}].start`)(
            <Input maxLength={16} style={{ width: '45%', textAlign: 'center' }} placeholder="请输入起始编号" />
          )}
          <Input style={{ width: '10%', borderLeft: 0, pointerEvents: 'none', backgroundColor: '#fff' }} placeholder="~" disabled />
          {getFieldDecorator(`range[${key}].end`)(
            <Input maxLength={16} style={{ width: '45%', textAlign: 'center', borderLeft: 0 }} placeholder="请输入终止编号" />
          )}
        </InputGroup>
      </Col>
      <Col {...colProps.col3}>
        <span>{this.getRangeCount(key)}</span>
        {keys.length > 1 ? (
          <Icon
            className="delete-btn"
            type="minus-circle-o"
            disabled={keys.length === 1}
            onClick={() => this.handleRemoveRange(key)}
          />
        ) : null}
      </Col>
    </Row>);
  }

  getTotalCount = () => {
    const keys = this.props.form.getFieldValue('keys');
    if (!keys) return 0;
    let total = 0;
    total = keys.map((key) => {
      const countText = this.getRangeCount(key);
      let countTextArray = countText.split(' 个');
      if (countText && countTextArray.length) {
        return Number(countTextArray[0]);
      }
      return 0;
    }).reduce((previousValue, currentValue) => {
      return previousValue + currentValue;
    }, 0);
    return total;
  }

  render() {
    const {
      form: {
        getFieldValue,
        getFieldDecorator,
      },
    } = this.props;
    getFieldDecorator('keys', { initialValue: [] });
    const keys = getFieldValue('keys');
    return (<div className="device-range-input">
      {keys.map((key) => { return this.renderRangeItem(key); })}
      {keys.length < 10 && <div className="add-btn"><a onClick={this.handleAddRange}>+新增设备起止区间</a></div>}
      {!!this.getTotalCount() && <div className="total-num">共 {this.getTotalCount()} 个设备</div>}
    </div>);
  }
}

RangeInput.propTypes = {
  form: PropTypes.object.isRequired,
  title: PropTypes.string,
};

RangeInput.defaultProps = {
  title: null,
};

const Container = Form.create()(RangeInput);
export { Container as RangeInput };
