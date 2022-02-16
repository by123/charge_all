import React from 'react';
import PropTypes from 'prop-types';
import { Chart, Legend, Axis, Tooltip, Geom, Label } from 'bizcharts';
import DataSet from '@antv/data-set';
import moment from 'moment';

// 数据源
// const data = [
//   // {
//   //   type: '充电宝',
//   //   '12-1': 2300,
//   //   '12-2': 667,
//   //   '12-3': 982,
//   //   '12-4': 5271,
//   //   '12-5': 3710,
//   // },
//   {
//     type: '充电线',
//     '12-1': 2100,
//     '12-2': 867,
//     '12-3': 902,
//     '12-4': 3271,
//     '12-5': 3110,
//   },
// ];

export class GroupedColumn extends React.PureComponent {
  render() {
    const { dataSource } = this.props;
    const line = {
      type: '充电线',
    };
    const fields = [];
    dataSource.forEach(item => {
      const key = moment(item.profitDate, 'x').format('MM-DD');
      fields.push(key);
      line[key] = item.profit;
    });
    const data = [line];
    const ds = new DataSet();
    const dv = ds.createView().source(data);
    dv.transform({
      type: 'fold',
      fields,
      // 展开字段集
      key: '日期',
      // key字段
      value: '收入', // value字段
    });
    return (<Chart height={342} data={dv} padding={[50, 50, 30, 80]} forceFit>
      <Axis name="日期" />
      <Axis name="收入" line={{ stroke: '#dddddd' }} grid={null} />
      <Legend position="top-right" marker="circle" />
      <Tooltip crosshairs={{
        type: 'y',
      }}
      />
      <Geom
        type="interval"
        position="日期*收入"
        color={'type'}
        adjust={[{ type: 'dodge' }]}
      >
        <Label content="收入" />
      </Geom>
    </Chart>);
  }
}

GroupedColumn.propTypes = {
  dataSource: PropTypes.array,
};

GroupedColumn.defaultProps = {
  dataSource: [
    // {
    //   direction: 1,
    //   profit: 1230,
    //   profitDate: 1541174400000,
    // }, {
    //   direction: 1,
    //   profit: 1830,
    //   profitDate: 1541260800000,
    // },
    // {
    //   direction: 1,
    //   profit: 1830,
    //   profitDate: 1541360800000,
    // },
    // {
    //   direction: 1,
    //   profit: 830,
    //   profitDate: 1541460800000,
    // },
    // {
    //   direction: 1,
    //   profit: 530,
    //   profitDate: 1541560800000,
    // },
    // {
    //   direction: 1,
    //   profit: 990,
    //   profitDate: 1541660800000,
    // },
    // {
    //   direction: 1,
    //   profit: 2830,
    //   profitDate: 1541760800000,
    // },
  ],
};
