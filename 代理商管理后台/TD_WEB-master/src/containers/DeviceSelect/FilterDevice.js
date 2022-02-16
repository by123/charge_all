import React from 'react';
import PropTypes from 'prop-types';
import { mapObjectToRadios } from '../../utils/index';
import { deviceStatus, agentAccountColProps } from '../../utils/enum';
import { PageFilter } from '../PageFilter/index';
import { action as deviceActions } from '../../pages/Device/store';


export class FilterDevice extends React.PureComponent {
  //
  handleReset = () => {
    this.props.dispatch(deviceActions.filterDevice());
  }

  handleFilterChange = (query) => {
    this.props.dispatch(deviceActions.queryDevice(query));
  }
  render() {
    const { isAdmin, userList, agentList } = this.props;
    let filterColumns = [
      { dataIndex: 'sn', title: '设备编码', placeholder: '输入设备编号' },
      { dataIndex: 'state', title: '投放状态', type: 'select', list: mapObjectToRadios(deviceStatus) },
      { dataIndex: 'contactUser', title: '代理人姓名' },
      { dataIndex: 'mchName', title: '代理商名称' },
      {
        dataIndex: 'mchUserId',
        title: '代理商账号',
        colProps: agentAccountColProps,
        type: 'select',
        list: agentList,
        itemAlias: { value: 'superUser', label: 'mchName' },
      },
    ];
    if (isAdmin) {
      filterColumns = filterColumns.concat({
        dataIndex: 'userId',
        title: '关联业务员',
        type: 'select',
        list: userList,
        itemAlias: { value: 'userId', label: 'name' },
      });
    }
    filterColumns = filterColumns.concat([
      { dataIndex: 'date', title: '激活时间', type: 'dateArea', startKey: 'startTime', endKey: 'endTime' },
    ]);
    const filterProps = {
      columns: filterColumns,
      onChange: this.handleFilterChange,
      onFilterReset: this.handleReset,
      ...this.props,
    };
    return (<div style={{ margin: 20 }}>
      <PageFilter {...filterProps} />
    </div>);
  }
}

FilterDevice.propTypes = {
  dispatch: PropTypes.func.isRequired,
  isAdmin: PropTypes.bool.isRequired,
  userList: PropTypes.array.isRequired,
  agentList: PropTypes.array.isRequired,
};
