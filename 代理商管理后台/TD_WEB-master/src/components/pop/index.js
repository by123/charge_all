import React from 'react';
import forEach from 'lodash/forEach';
import {
  Tooltip,
  Select,
  Popconfirm,
  Popover,
  AutoComplete,
  TimePicker,
  Cascader,
  Dropdown,
  TreeSelect,
  DatePicker,
} from 'antd';
import { getPopupContainer } from '../../utils/index';

const { MonthPicker, RangePicker } = DatePicker;

// DatePicker、MonthPicker、RangePicker 使用 getCalendarContainer来控制浮层
const wrapDatePicker = PopContainer => class extends React.PureComponent {
  render() {
    const nextProps = {
      getCalendarContainer: getPopupContainer,
      ...this.props,
    };
    return <PopContainer {...nextProps} />;
  }
};

const NewDatePicker = wrapDatePicker(DatePicker);
NewDatePicker.MonthPicker = wrapDatePicker(MonthPicker);
NewDatePicker.RangePicker = wrapDatePicker(RangePicker);

/**
 * 该高阶组件不能使用函数式纯组件的方式包装
 * 原因：getFieldDecorator 不能用于装饰纯函数组件。
 * @param PopContainer
 */
/* eslint-disable react/no-multi-comp */
const wrapComponent = PopContainer => class extends React.PureComponent {
  render() {
    const nextProps = {
      getPopupContainer,
      ...this.props,
    };
    return <PopContainer {...nextProps} />;
  }
};

const extendsProperty = (Target, Source) => {
  forEach(Source, (value, key) => {
    Target[key] = value;
  });
};

const wrap = (component) => {
  const NewComponent = wrapComponent(component);
  extendsProperty(NewComponent, component);
  return NewComponent;
};

const NewPopconfirm = wrap(Popconfirm);
const NewPopover = wrap(Popover);
const NewTooltip = wrap(Tooltip);
const NewSelect = wrap(Select);
const NewAutoComplete = wrap(AutoComplete);
const NewTimePicker = wrap(TimePicker);
const NewCascader = wrap(Cascader);
const NewDropdown = wrap(Dropdown);
const NewTreeSelect = wrap(TreeSelect);

// NewSelect.Option = Select.Option;
// NewSelect.OptGroup = Select.OptGroup;


export {
  NewPopconfirm as Popconfirm,
  NewSelect as Select,
  NewPopover as Popover,
  NewTooltip as Tooltip,
  NewAutoComplete as AutoComplete,
  NewTimePicker as TimePicker,
  NewCascader as Cascader,
  NewDropdown as Dropdown,
  NewTreeSelect as TreeSelect,
  NewDatePicker as DatePicker,
};

