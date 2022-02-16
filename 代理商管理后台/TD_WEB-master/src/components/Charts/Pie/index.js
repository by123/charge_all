import React from 'react';
import { Chart, Coord, Label, Tooltip, Geom } from 'bizcharts';

const COLORS = ['#1890ff', '#f04864', '#55eeaa', '#22aadd', '#9933dd'];

const data = [
  {
    city: '深圳',
    sold: 0.25,
  },
  {
    city: '广州',
    sold: 0.3,
  },
  {
    city: '杭州',
    sold: 0.15,
  },
  {
    city: '上海',
    sold: 0.1,
  },
  {
    city: '北京',
    sold: 0.2,
  },
];

export class Pie extends React.Component {
  render() {
    return (<Chart height={300} data={data} padding={[0, 80, 0, 80]} forceFit>
      <Coord type="theta" radius={1} />
      <Tooltip showTitle={false} />
      <Geom type="intervalStack" position="sold" color={['city', COLORS]} shape="radiusPie" >
        <Label content="sold"
          custom
          formatter={(val, item) => {
            return `${item.point.city}: ${val}`;
          }}
        />
      </Geom>
    </Chart>);
  }
}

