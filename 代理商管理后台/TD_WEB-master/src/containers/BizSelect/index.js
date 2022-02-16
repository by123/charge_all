
import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bizFilter } from '../../utils';
import AgentFilter from '../AgentFilter';

class BizSelect extends React.Component {

  render() {
    const {
      onChange,
      childUseable,
      dataIndex,
      listFilter,
      containerEle,
      ...otherOptions
    } = this.props;

    const checkUseable = (item) => {
      const { mchType, level } = item;
      return !(mchType === 0 && level === 4);
    };
    const filter = listFilter !== undefined ? listFilter : (item) => {
      return bizFilter(item, childUseable);
    };
    const bizSelectColumns = {
      placeholder: '请选择商户',
      changeOnSelect: false,
      dataIndex,
      childUseable,
      listFilter: filter,
      showMchId: true,
      checkUseable,
      width: 320,
      mchType: 1, // 只搜索商户
    };
    return (<AgentFilter
      onChange={onChange}
      column={bizSelectColumns}
      {...otherOptions}
    />);
  }
}

BizSelect.propTypes = {
  onChange: PropTypes.func,
  childUseable: PropTypes.bool,
  dispatch: PropTypes.func.isRequired,
  dataIndex: PropTypes.string,
};

BizSelect.defaultProps = {
  onChange: null,
  childUseable: false,
  dataIndex: 'mchId',
};

export default connect(({ global: { authCode } }) => ({
  childUseable: authCode[2] === '1',
}))(BizSelect);
