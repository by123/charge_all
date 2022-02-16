import React from 'react';
import PropTypes from 'prop-types';
import { Form, Row, Col, message } from 'antd';
import moment from 'moment';
import { parse } from 'query-string';
import isBoolean from 'lodash/isBoolean';
import debounce from 'lodash/debounce';
import { connect } from 'react-redux';
import { push } from '../../store/router-helper';
import { Search } from '../../components/InputSearch';
import { Select, DatePicker } from '../../components/pop/index';
import FilterItem from '../../components/FilterItem';
import { processDateRangeToFields, createFilterField, initialDateRange } from '../../utils';

const { Option } = Select;
const { RangePicker, MonthPicker } = DatePicker;

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
class DateFilter extends React.Component {
  processSpecialFields = (fields) => {
    this.props.columns.forEach(column => {
      if (column.type === 'dateArea') {
        processDateRangeToFields(fields, column.dataIndex, column.startKey, column.endKey, column.isTime);
      }
      if (column.type === 'month') {
        fields[column.dataIndex] = fields[column.dataIndex] && fields[column.dataIndex].format('YYYY-MM');
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
      searchAll,
      form: {
        getFieldsValue,
      },
    } = this.props;
    let fields = getFieldsValue();
    this.processSpecialFields(fields);
    if (!searchAll && this.isEmpty(fields)) {
      message.warning('请先输入查询条件');
      return null;
    }
    this.onFilterChange(fields);
  }, 1000, { leading: true, trailing: false });

  onFilterChange = (fields = {}) => {
    const { location, dispatch, onChange } = this.props;
    if (onChange) {
      onChange(fields);
    } else {
      dispatch(push({ ...location, query: fields }));
    }
  };

  handleSelectChange = (column, value) => {
    // onChange中getFieldsValue获取当前组件的value还是改变之前的
    // 所以需要用回调参数中value替换成最新的
    let fields = this.props.form.getFieldsValue();
    fields[column.dataIndex] = value;
    this.processSpecialFields(fields);
    this.onFilterChange(fields);
  };

  handleReset = () => {
    if (this.props.onFilterReset) {
      this.props.onFilterReset();
    } else {
      this.filterReset();
    }
  }
  filterReset = debounce(() => {
    this.onFilterChange();
  }, 1000, { leading: true, trailing: false });
  mapArrayToOptions = (array, key = 'value', label = 'label', hasAll) => {
    const Options = array.map((item) => {
      return <Option key={item[key]}>{item[label]}</Option>;
    });
    if (isBoolean(key)) { // 简化参数
      hasAll = key;
    }
    if (hasAll) {
      return [<Option key="" value="">全部</Option>].concat(Options);
    }
    return Options;
  };
  renderFilterComponent = (column) => {
    switch (column.type) {
      case 'dateArea': {
        return (
          <RangePicker style={{ width: '100%' }} onChange={this.handleSelectChange.bind(this, column)} />
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
          <Select style={{ width: '100%' }} onChange={this.handleSelectChange.bind(this, column)}>{this.mapArrayToOptions(column.list, alias.value, alias.label, true)}</Select>
        );
      }
      default: { // search
        return (
          <Search placeholder={column.placeholder || '请输入'} onSearch={this.handleSubmit} />
        );
      }
    }
  };
  render() {
    const {
      columns,
      colProps,
      form: {
        getFieldDecorator,
      },
    } = this.props;
    return (<div>
      <Row gutter={24}>
        {columns.map(column => (
          <Col {...colProps} key={column.dataIndex}>
            <FilterItem>
              {getFieldDecorator(column.dataIndex)(this.renderFilterComponent(column))}
            </FilterItem>
          </Col>
        ))}
      </Row>
    </div>);
  }
}

DateFilter.defaultProps = {
  colProps: {
    xs: 24,
    sm: 24,
    md: 24,
    lg: 24,
    xxl: 24,
    style: {
      marginBottom: 16,
    },
  },
  searchAll: true,
  search: '',
  onFilterReset: undefined,
};

DateFilter.propTypes = {
  colProps: PropTypes.object,
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.object,
  onChange: PropTypes.func,
  form: PropTypes.object.isRequired,
  columns: PropTypes.array.isRequired,
  search: PropTypes.string,
  searchAll: PropTypes.bool,
  onFilterReset: PropTypes.func,
};

DateFilter.defaultProps = {
  location: {},
  onChange: null,
};

const FilterForm = Form.create({
  mapPropsToFields({ search, columns }) {
    const query = parse(search);
    columns.forEach(column => {
      if (column.type === 'dateArea') {
        query[column.dataIndex] = initialDateRange(query, column.startKey, column.endKey);
      } else if (column.type === 'month') {
        query[column.dataIndex] = query[column.dataIndex] ? moment(query[column.dataIndex], 'YYYY-MM') : null;
      } else {
        query[column.dataIndex] = query[column.dataIndex] || '';
      }
    });

    return createFilterField(query);
  },
})(connect()(DateFilter));

export {
  FilterForm as DateFilter,
};

