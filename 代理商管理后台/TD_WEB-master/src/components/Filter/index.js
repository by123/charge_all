import React from 'react';
import PropTypes from 'prop-types';
import { Form, Button, Row, Col, message } from 'antd';
import moment from 'moment';
import { parse } from 'query-string';
import debounce from 'lodash/debounce';
import { Search } from '../../components/InputSearch';
import { Select, DatePicker, Cascader } from '../../components/pop/index';
import FilterItem from '../../components/FilterItem';
import AgentFilter from '../../containers/AgentFilter';
import { processDateRangeToFields, createFilterField, initialDateRange, mapArrayToOptions } from '../../utils';

import './index.less';

const { RangePicker, MonthPicker } = DatePicker;
const fullCol = {
  xs: 24,
  sm: 24,
  md: 24,
  lg: 24,
  xxl: 24,
};
const startValue = moment().subtract(1, 'days');

/**
 * 通用列表过滤条件
 * props说明：
 * search：url上的query string，用于填充到搜索框中
 * columns：过滤字段数组
 * （对象属性说明）
 * {
 *  title: 搜索框文字说明, 例：'申请单号'
 *  type: 搜索框类型, 可选值: 'search', 'select', 'dateArea', 'month', 默认search
 *  dataIndex: 字段名称，即接口查询参数的key值，在数组中必须唯一
 *  placeholder: 搜索框内文字提示
 *  list: 当type值为select时，必须指定下拉列表的值
 *  itemAlias: 当list是对象数组时，指定label值和value值，例：{ value: 'id', label: 'userName' }
 *  startKey: 当type为dateArea时，指定开始日期字段的key
 *  endKey: 当type为dateArea时，指定结束日期字段的key
 * }
 *
 *
 */
class Filter extends React.Component {
  processSpecialFields = (fields) => {
    this.props.columns.forEach(column => {
      if (column.type === 'dateArea') {
        processDateRangeToFields(fields, column.dataIndex, column.startKey, column.endKey, column.isTime, column.toZero);
      }
      if (column.type === 'month') {
        fields[column.dataIndex] = fields[column.dataIndex] && fields[column.dataIndex].format('YYYY-MM');
      }
      if (column.type === 'datePicker') {
        if (fields[column.dataIndex] !== null) {
          let format = column.format || 'YYYY-MM-DD';
          fields[column.dataIndex] = fields[column.dataIndex] && fields[column.dataIndex].format(format);
          return;
        }
        // fields[column.dataIndex] = startValue.format('YYYY-MM-DD');
      }
      if (!column.type) {
        fields[column.dataIndex] = fields[column.dataIndex].trim();
      }
    });
  };
  isEmpty = (obj) => {
    return Object.keys(obj).every(key => {
      return !obj[key] || obj[key] === '';
    });
  };
  handleSubmit = debounce(() => {
    const {
      onFilterChange,
      searchAll,
      form: {
        validateFields,
      },
    } = this.props;
    validateFields((err, fields) => {
      if (err) return;
      this.processSpecialFields(fields);
      if (!searchAll && this.isEmpty(fields)) {
        message.warning('请先输入查询条件');
        return null;
      }
      onFilterChange(fields);
    });
  }, 1000, { leading: true, trailing: false });

  handleSelectChange = (column, value) => {
    // onChange中getFieldsValue获取当前组件的value还是改变之前的
    // 所以需要用回调参数中value替换成最新的
    let fields = this.props.form.getFieldsValue();
    fields[column.dataIndex] = value;
    if (column.type === 'lazyCascader' || column.type === 'agentFilter') {
      if (value && value.length === 1) {
        value.push('');
        fields[column.dataIndex] = value;
      }
    }
    this.processSpecialFields(fields);
    this.props.onFilterChange(fields);
  };

  handleReset = () => {
    if (this.props.onFilterReset) {
      this.props.onFilterReset();
    } else {
      this.filterReset();
    }
  };

  filterReset = debounce(() => {
    this.props.onFilterChange();
  }, 1000, { leading: true, trailing: false });

  // mapArrayToOptions = (array, key = 'value', label = 'label', hasAll) => {
  //   const Options = array.map((item) => {
  //     return <Option key={item[key]}>{item[label]}</Option>;
  //   });
  //   if (isBoolean(key)) { // 简化参数
  //     hasAll = key;
  //   }
  //   if (hasAll) {
  //     return [<Option key="" value="">全部</Option>].concat(Options);
  //   }
  //   return Options;
  // };
  disabledDate = (current, column) => {
    const notToday = !!column.notToday;
    return current && current > (notToday ? moment().subtract(1, 'days') : moment().endOf('day'));
  };

  displayRender = (labels, selectedOptions) => {
    const option = selectedOptions[selectedOptions.length - 1] || '';
    return <span key={option.value}>{labels[labels.length - 1]}</span>;
  }

  renderFilterComponent = (column) => {
    switch (column.type) {
      case 'datePicker': {
        return (
          <DatePicker
            style={{ width: '100%' }}
            onChange={this.handleSelectChange.bind(this, column)}
            format={column.showTime ? 'YYYY-MM-DD HH:mm:ss' : 'YYYY-MM-DD'}
            allowClear={false}
            showTime={!!column.showTime}
            disabledDate={(current) => this.disabledDate(current, column)}
          />
        );
      }
      case 'dateArea': {
        return (
          <RangePicker
            style={{ width: '100%' }}
            format={column.showTime ? 'YYYY-MM-DD HH:mm:ss' : 'YYYY-MM-DD'}
            showTime={!!column.showTime}
            onChange={this.handleSelectChange.bind(this, column)}
          />
        );
      }
      case 'month': {
        return (
          <MonthPicker style={{ width: '100%' }} onChange={this.handleSelectChange.bind(this, column)} />
        );
      }
      case 'select': {
        const alias = column.itemAlias || {};
        return (
          <Select
            style={{ width: column.width || '100%' }}
            onChange={this.handleSelectChange.bind(this, column)}
          >
            {mapArrayToOptions(column.list, alias.value, alias.label, true)}
          </Select>
        );
      }
      case 'lazyCascader': {
        const { options, changeOnSelect = false, loadData } = column;
        return (
          <Cascader
            popupClassName="agent-filter-item"
            style={{ width: column.width || '100%' }}
            placeholder="全部"
            options={options}
            loadData={loadData}
            notFoundContent="暂无数据"
            onChange={this.handleSelectChange.bind(this, column)}
            changeOnSelect={changeOnSelect}
            displayRender={this.displayRender}
          />
        );
      }
      case 'agentFilter': {
        return (<AgentFilter
          form={this.props.form}
          column={column}
          onChange={this.handleSelectChange.bind(this, column)}
        />);
      }
      default: { // search
        return (
          <Search placeholder={column.placeholder || `请输入${column.title || ''}`} onSearch={this.handleSubmit} />
        );
      }
    }
  };
  render() {
    const {
      columns,
      colProps,
      searchAll,
      form: {
        getFieldDecorator,
      },
    } = this.props;
    const getInitValue = (column) => {
      let value = '';
      if (column.type === 'datePicker') {
        value = startValue;
      } else if (column.type === 'agentFilter') {
        value = [];
      }
      return value;
    };
    return (<div className="filter">
      <Row gutter={24}>
        {columns.map(column => (
          <Col
            {...Object.assign({}, colProps, column.colProps, column.isFull ? fullCol : {})}
            key={column.dataIndex}
            style={{ marginBottom: 0 }}
          >
            <FilterItem label={column.title} validateProps={column.validateProps}>
              {column.type !== 'agentFilter'
                ? getFieldDecorator(
                  column.dataIndex,
                  {
                    initialValue: getInitValue(column),
                    ...column.validateProps,
                  }
                )(this.renderFilterComponent(column))
                : this.renderFilterComponent(column)
              }
            </FilterItem>
          </Col>
        ))}
        {columns.length < 3 &&
          <Col {...colProps}>
            <div style={{ display: 'flex' }}>
              <div style={{ width: 86, marginRight: 12, textAlign: 'right' }}>
                <Button type="primary" onClick={this.handleSubmit}>搜索</Button>
              </div>
              {searchAll ? <Button onClick={this.handleReset}>清除</Button> : null}
            </div>
          </Col>
        }
      </Row>
      {columns.length >= 3 &&
        <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
          <div style={{ width: 86, marginRight: 12, textAlign: 'right' }}>
            <Button type="primary" onClick={this.handleSubmit}>搜索</Button>
          </div>
          {searchAll ? <Button onClick={this.handleReset}>清除</Button> : null}
        </div>
      }
    </div>);
  }
}

Filter.defaultProps = {
  colProps: {
    xs: 24,
    sm: 24,
    md: 12,
    lg: 8,
    xxl: 6,
    style: {
      marginBottom: 16,
    },
  },
  searchAll: true,
  search: '',
  onFilterReset: undefined,
};

Filter.propTypes = {
  colProps: PropTypes.object,
  form: PropTypes.object.isRequired,
  columns: PropTypes.array.isRequired,
  search: PropTypes.string,
  searchAll: PropTypes.bool,
  onFilterChange: PropTypes.func.isRequired,
  onFilterReset: PropTypes.func,
};

const FilterForm = Form.create({
  mapPropsToFields({ search, columns }) {
    const query = parse(search);
    columns.forEach(column => {
      if (column.type === 'datePicker') {
        let format = column.format || 'YYYY-MM-DD';
        query[column.dataIndex] = query[column.dataIndex] ? moment(query[column.dataIndex], format) : null;
      } else if (column.type === 'dateArea') {
        query[column.dataIndex] = initialDateRange(query, column.startKey, column.endKey, column.isTime);
      } else if (column.type === 'month') {
        query[column.dataIndex] = query[column.dataIndex] ? moment(query[column.dataIndex], 'YYYY-MM') : null;
      } else if (column.type === 'agentFilter') {
        query[column.dataIndex] = query[column.dataIndex] || null;
        // query[column.dataIndex] = query[column.dataIndex] ? moment(query[column.dataIndex], 'YYYY-MM') : null;
      } else {
        query[column.dataIndex] = query[column.dataIndex] || '';
      }
    });
    return createFilterField(query);
  },
})(Filter);

export {
  FilterForm as Filter,
};
