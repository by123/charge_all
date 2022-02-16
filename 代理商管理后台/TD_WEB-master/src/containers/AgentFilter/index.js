/**
 * 支持选下级代理商的筛选项，嵌入PageFilter组件中，
 * 使用方式参考财务中心的代理商筛选项-- /FinanceCenter/WithdrawalManage
 */
import React from 'react';
import { Input, List } from 'antd';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { api } from '@/store/api';
import { get } from '@/utils/request';
import { Cascader } from '@/components/pop';
import { formatAgentSelect, getPopupContainer } from '../../utils';
import { action as deviceActions } from '../../pages/Device/store';
import { action as agentActions } from '../../pages/Agent/store';
import './style.less';

const Search = Input.Search;

let uuid = 0;

class AgentFilter extends React.Component {
  constructor(props) {
    super(props);
    this.isClickSet = false;
  }

  state = {
    allMchAccount: [],
    popupVisible: false,
    selctedLabel: undefined,
    searchInput: '',
    isInit: false,
    cascaderValue: undefined,
    searchVisible: false,
    uuid: ++uuid,
  };

  componentDidMount() {
    this.queryAgent();
    this.initEvent();
  }

  initEvent = () => {
    setTimeout(() => {
      try {
        this.toggleEvent(false);
        this.toggleEvent(true);
      } catch (e) {
        setTimeout(() => {
          this.toggleEvent(false);
          this.toggleEvent(true);
        }, 200);
      }
    }, 200);
  }

  onClickSearch = () => {
    const { searchInput } = this.state;
    if (!searchInput) return;
    this.searchValue(searchInput);
  }

  componentWillUnmount() {
    this.toggleEvent(false);
  }

  toggleEvent = (isAdd) => {
    const warpperEle = this.getWarpperContent();
    this.wrapEventFn(warpperEle, isAdd, this.onBodyClick);

    const inputEle = document.querySelector(`.js-stop-event-${this.state.uuid}`);
    this.wrapEventFn(inputEle, isAdd, this.onInputClick);

    // 搜索框的搜索按钮点击
    const searchEle = document.querySelector(`.js-stop-event-${this.state.uuid} .ant-input-suffix`);
    this.wrapEventFn(searchEle, isAdd, this.onClickSearch);

    const cascaderEle = document.querySelector(`.js-cascader-${this.state.uuid}`);
    this.wrapEventFn(cascaderEle, isAdd, this.onCascaderClick);
  }

  wrapEventFn = (ele, isAdd, callback) => {
    const fn = isAdd ? 'addEventListener' : 'removeEventListener';
    if (!ele && !isAdd) return;
    if (isAdd) ele.removeEventListener('click', callback, false);
    ele[fn]('click', callback, false);
  }

  getWarpperContent = () => {
    let containerEle = null;
    const isInModal = document.querySelector(`.ant-modal-wrap .js-cascader-${this.state.uuid}`);
    if (isInModal) {
      let allModal = document.querySelectorAll('.ant-modal-wrap');
      allModal.forEach(element => {
        if (element.querySelector(`.js-cascader-${this.state.uuid}`)) {
          containerEle = element;
          return false;
        }
      });
    } else {
      containerEle = getPopupContainer().childNodes[0];
    }
    return containerEle;
  }

  // Todo：一个页面有两个组件时会绑定两次事件，
  onBodyClick = (e) => {
    if (e.target.tagName.toLowerCase() === 'input' && e.target.type === 'radio') return;
    if (this.state.searchVisible) {
      this.toggleSearch(false);
    }
    if (this.state.popupVisible) {
      this.toggleCascader(false);
    }
  }

  onInputClick = (e) => {
    e.stopPropagation();
  }

  queryAgent = () => {
    const { profile: { mchId }, dispatch } = this.props;
    dispatch(deviceActions.queryAgent({ mchId }, () => {
      this.setState({
        allMchAccount: this.formatWithFilter(this.props.queryAgent.result || []),
      });
    }));
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
    const { column: { showAll = false } } = this.props;

    targetOption.loading = true;
    // targetOption.useable = true;
    return get(api.queryAgent, { mchId: targetOption.value }).then(res => {
      targetOption.loading = false;
      let children = this.formatWithFilter(res);
      showAll && children.unshift({
        value: `$${targetOption.value}`,
        label: `${targetOption.label.split(' ')[1]} 全部`,
        isLeaf: true,
      });
      if (children.length) {
        targetOption.children = children;
      }
      this.setState({
        allMchAccount: [...this.state.allMchAccount],
        searchVisible: true,
      });
      return Promise.resolve(targetOption);
    });
  }

  loadAllChildData = async (mchList, callback) => {
    // 最后一个不用查下级
    mchList = mchList.concat();
    mchList.pop();
    let i = 0;
    while (i < mchList.length) {
      let targetOption = this.getTargetOption(mchList[i]);
      await this.loadData([targetOption]);
      i++;
    }
    callback && callback();
  }

  getTargetOption = (mchId) => {
    const { allMchAccount } = this.state;
    let result = {};

    function _getTargetOption(list, id) {
      list.forEach(val => {
        if (val.value === id) {
          result = val;
          return false;
        }
        if (val.children) {
          _getTargetOption(val.children, id);
        }
      });
    }

    _getTargetOption(allMchAccount, mchId);
    return result;
  }

  displayRender = (labels, selectedOptions) => {
    const option = selectedOptions[selectedOptions.length - 1] || '';
    const { column: { showMchId = false } } = this.props;
    const label = `${labels[labels.length - 1]} ${showMchId ? option.value : ''}`;
    return option ? <span key={option.value}>{label}</span> : '';
  };

  renderSelected = (selectedOptions) => {
    if (!selectedOptions) {
      this.setState({
        selctedLabel: '',
      });
      return;
    }
    const option = selectedOptions[selectedOptions.length - 1];
    let selctedLabel = '';
    if (!option) {
      selctedLabel = '';
    } else {
      const { column: { showMchId = false } } = this.props;
      selctedLabel = `${option.label} ${showMchId ? option.value : ''}`;
    }
    this.setState({
      selctedLabel,
    });
  }

  searchValue = (value) => {
    const { searchMchByInfoResult: { loading }, column: { mchType = -1 } } = this.props;
    if (loading) return;
    this.setState({
      isInit: false,
      popupVisible: false,
    });
    this.props.dispatch(agentActions.searchMchByInfo({ qryInfo: value, mchType }, () => {
      this.setState({
        isInit: true,
      });
    }));
  }

  onChange = (value, selectedOptions) => {
    const { column: { changeOnSelect } = {} } = this.props;
    this.renderSelected(selectedOptions);
    this.setState({
      cascaderValue: value,
      popupVisible: value && !!value.length && changeOnSelect,
      searchVisible: value && !!value.length && changeOnSelect,
      searchInput: '',
      isInit: false,
    });
    this.props.onChange && this.props.onChange(value, selectedOptions);
  }

  clearData = () => {
    this.onChange(undefined, undefined);
    this.setState({
      popupVisible: false,
    });
  }

  renderItem = (item) => {
    return (<List.Item onClick={(e) => this.handleClickItem(item, e)}>
      {item.mchName} {item.contactUser}
    </List.Item>);
  }

  handleClickItem = (item) => {
    const { mchId } = item;
    const { form, onChange } = this.props;
    this.props.dispatch(agentActions.queryParentsByMchId({ mchId }, (_, getState) => {
      const { queryParentsByMchIdResult: { result } } = getState().agent;
      const cascaderValue = result.map(val => {
        return val.mchId;
      });

      this.loadAllChildData(cascaderValue, () => {
        this.setState({
          isInit: false,
          searchInput: undefined,
          searchVisible: false,
          // popupVisible: true, 直接展开值不能即时更新，原因未知
        });
      });

      if (!form) {
        this.setState({
          cascaderValue,
        });
      }
      onChange && onChange(cascaderValue, item);
    }));
  }

  onSearchChange = (value) => {
    if (!value) {
      this.setState({
        isInit: false,
      });
    }
  }

  onSearchInput = (e) => {
    this.setState({
      searchInput: e.currentTarget.value,
    });
  }

  toggleSearch = (visible) => {
    this.setState({
      searchVisible: visible,
    }, () => {
      if (!visible) {
        this.setState({
          isInit: false,
          searchInput: '',
        });
      }
    });
  }

  toggleCascader = (visible) => {
    this.setState({
      popupVisible: visible,
    });
  }

  checkIsClickClose = (target) => {
    const closeEle = document.querySelector(`.js-cascader-${this.state.uuid} .ant-cascader-picker-clear`);
    return closeEle && closeEle.innerHTML.indexOf(target.parentNode.innerHTML) > -1;
  }

  onCascaderClick = (e) => {
    e.stopPropagation();
    if (this.checkIsClickClose(e.target)) {
      this.clearData();
      return;
    }
    const visible = !this.state.popupVisible;
    this.toggleCascader(visible);
    this.toggleSearch(visible);
  }

  render() {
    const {
      column,
      form,
      searchMchByInfoResult: {
        result: mchList = [],
        loading,
      },
    } = this.props;

    const { changeOnSelect = false, width, placeholder = '全部', disabled = false } = column;
    const { allMchAccount, isInit, searchVisible, cascaderValue, popupVisible, uuid: uid } = this.state;
    const options = {
      popupClassName: `js-agent-filter-item-${uid}`,
      className: `js-cascader-${uid}`,
      style: { width: width || '100%' },
      placeholder,
      options: allMchAccount,
      loadData: this.loadData,
      disabled,
      notFoundContent: '暂无数据',
      onChange: this.onChange,
      changeOnSelect,
      popupVisible,
      displayRender: this.displayRender,
      ref: refs => { this.cascader = refs; },
    };
    if (!form) options.value = cascaderValue;
    const cascader = (<Cascader {...options} />);
    const searchEle = (<Search
      placeholder="请输入账号/名称/联系人"
      onSearch={this.searchValue}
      value={this.state.searchInput}
      className={`js-stop-event-${uid}`}
      onInput={this.onSearchInput}
      onChange={this.onSearchChange}
    />);
    return (<div className="agent-filter-container">
      {form ? form.getFieldDecorator(column.dataIndex)(cascader) : cascader}
      <div
        className="search-container"
        hidden={!searchVisible}
      >
        {searchEle}
        <List
          dataSource={mchList || []}
          bordered
          className="search-list"
          size="small"
          split={!false}
          hidden={!isInit}
          loading={loading}
          renderItem={this.renderItem}
        />
      </div>
    </div>);
  }
}

AgentFilter.propTypes = {
  queryAgent: PropTypes.object,
  column: PropTypes.object.isRequired,
  onChange: PropTypes.func,
  profile: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  dataIndex: PropTypes.string,
  form: PropTypes.object,
  searchMchByInfoResult: PropTypes.object,
  queryParentsByMchIdResult: PropTypes.object,
};

AgentFilter.defaultProps = {
  queryAgent: {},
  onChange: null,
  dataIndex: 'mchId',
  form: null,
  searchMchByInfoResult: {},
  queryParentsByMchIdResult: {},
};

export default connect(({
  device: { queryAgent },
  global: { profile },
  agent: { searchMchByInfoResult, queryParentsByMchIdResult },
}) => ({
  queryAgent,
  profile,
  searchMchByInfoResult,
  queryParentsByMchIdResult,
}))(AgentFilter);
