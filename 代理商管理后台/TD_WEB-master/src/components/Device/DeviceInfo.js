import React from 'react';
import PropTypes from 'prop-types';
import { Spin } from 'antd';

import { DetailList } from '../DetailList/index';
import { deviceStatus, wireTypes } from '../../utils/enum';
import { datetimeFormat } from '../../utils/index';

export const DeviceInfo = ({ loading, ...otherProps }) => {
  const deviceColumns = [
    { key: 'wireType', label: '设备名称', render: text => wireTypes[text] },
    { key: 'deviceSn', label: '设备编码' },
    { key: 'deviceVersion', label: '设备型号' },
    { key: 'deviceBatch', label: '设备批次' },
    { key: 'deviceState', label: '设备状态', render: text => deviceStatus[text] },
    { key: 'activeTime', label: '激活时间', render: text => datetimeFormat(text) },
    { key: 'firstuseTime', label: '首次使用日期', render: text => datetimeFormat(text) },
    { key: 'lastUseTime', label: '最近使用日期', render: text => datetimeFormat(text) },
    { key: 'count', label: '使用次数' },
    { key: 'location', label: '最近使用位置' },
  ];
  return (<Spin spinning={loading}>
    <DetailList columns={deviceColumns} {...otherProps} />
  </Spin>);
};

DeviceInfo.propTypes = {
  loading: PropTypes.bool.isRequired,
};
