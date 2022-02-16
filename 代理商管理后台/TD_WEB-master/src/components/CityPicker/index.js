
import React from 'react';
import { Form } from 'antd';
import PropTypes from 'prop-types';
import { formatAgentSelect } from '@/utils';
import address from '@/store/address/address';
import { Cascader } from '@/components/pop';
import './style.less';

const AddressData = [].concat(address);

function _getChildData(cityList, parentId, result) {
  let isBreak = false;
  for (let i = cityList.length - 1; i >= 0; i--) {
    let val = cityList[i];
    if (val.value === parentId) {
      result[0] = [];
      !!val.children && val.children.forEach(element => {
        const { children, ...other } = element;
        result[0].push({ ...other, isLeaf: !children });
      });
      isBreak = true;
      break;
    }
    if (val.children) {
      isBreak = _getChildData(val.children, parentId, result);
      if (isBreak) break;
    }
  }
  return isBreak;
}

const getChildData = (list, parentId) => {
  list = [].concat(list);
  let result = [];
  let childData = [];
  let allItem = {
    value: `all${parentId || ''}`,
    label: '选择全部',
    isLeaf: true,
    parentId,
  };
  if (parentId) {
    _getChildData(list, parentId, childData);
    childData = childData[0];
  } else {
    childData = list.concat().map(element => {
      const { children, ...other } = element;
      return {
        ...other,
        isLeaf: false,
      };
    });
  }
  result = result.concat(childData);
  result.unshift(allItem);
  return result;
};

class CityPicker extends React.Component {
  state = {
    dataSource: getChildData(AddressData),
    selectedValue: [],
  };

  componentDidMount() {
    // this.queryAgent();
  }

  setValue = (value) => {
    this.changeValue(value);
  }

  // column中接受一个filter
  formatWithFilter = (list) => {
    const { listFilter, childUseable } = this.props.column;
    if (listFilter) {
      list = list.filter(listFilter);
    }
    let mchList = formatAgentSelect(list, childUseable);
    return mchList;
  }

  loadData = (selectedOptions) => {
    const targetOption = selectedOptions[selectedOptions.length - 1];
    let children = null;
    if (targetOption.loading) return;
    targetOption.loading = true;
    // 点击单个选项
    children = getChildData(address, targetOption.value);
    targetOption.children = children;
    this.setState({
      dataSource: [...this.state.dataSource],
    });
    targetOption.loading = false;
  }

  displayRender = (labels, selectedOptions) => {
    const option = selectedOptions[selectedOptions.length - 1] || '';
    return option ? option.value : '';
  };

  toggleVisible = (e) => {
    e.stopPropagation();
    this.setState({
      popupVisible: !this.state.popupVisible,
    });
  }

  closePicker = () => {
    this.getCityValue();
    this.setState({
      popupVisible: false,
    });
  }

  onChange = (value, selectedOptions) => {
    let { selectedValue } = this.state;

    selectedValue = this.addNewCity(selectedValue, selectedOptions);
    selectedValue = this.filterSelectedValue(selectedValue);
    this.changeValue(selectedValue);
  }

  addNewCity = (selectedValue, newCity) => {
    const [province, city, area] = newCity;
    let cityCode = (area || city || province).value;
    let deleteArray = [];
    let result = [
      cityCode,
      province ? province.label : null,
      city ? city.label : null,
      area ? area.label : null,
    ];

    const allIndex = result.indexOf('选择全部');
    if (allIndex > -1) {
      selectedValue.forEach((val, index) => {
        let matchIndex = allIndex;
        let isMatch = true;
        while (matchIndex > 1) {
          --matchIndex;
          if (result[matchIndex] !== val[matchIndex]) {
            isMatch = false;
            break;
          }
        }
        if (isMatch) {
          deleteArray.push(index);
        }
      });
    }
    selectedValue = selectedValue.filter((val, index) => {
      return deleteArray.indexOf(index) === -1;
    });
    selectedValue.push(result);
    return selectedValue;
  }

  filterSelectedValue = (selectedValue) => {
    const cityList = selectedValue.concat();
    let hash = {};
    let result = [];

    // 去重
    cityList.forEach((city) => {
      if (!hash[city[0]]) {
        result.push(city);
        hash[city[0]] = true;
      }
    });
    return result;
  }

  handleDeleteCity = (cityItem) => {
    let { selectedValue } = this.state;
    selectedValue = selectedValue.filter(val => {
      return val !== cityItem;
    });
    this.changeValue(selectedValue);
  }

  changeValue = (selectedValue) => {
    this.setState({
      selectedValue,
    });
    this.props.onChange && this.props.onChange(selectedValue);
  }

  render() {
    const {
      form,
      dataIndex,
    } = this.props;

    const { dataSource } = this.state;
    const cascader = (<Cascader
      popupClassName="city-picker-wrap"
      style={{ width: '100%' }}
      placeholder="请选择城市"
      options={dataSource}
      loadData={this.loadData}
      notFoundContent="暂无数据"
      onChange={this.onChange}
      changeOnSelect={false}
      // displayRender={this.displayRender}
    />);
    return form.getFieldDecorator(dataIndex)(cascader);
  }
}

CityPicker.propTypes = {
  onChange: PropTypes.func,
  form: PropTypes.object.isRequired,
  column: PropTypes.object,
  dataIndex: PropTypes.string.isRequired,
};

CityPicker.defaultProps = {
  onChange: null,
  column: {},
};

const EditAdConfigModalForm = Form.create()(CityPicker);

export default EditAdConfigModalForm;

