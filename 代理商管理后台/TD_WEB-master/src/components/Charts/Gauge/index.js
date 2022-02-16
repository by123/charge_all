import React from 'react';
import { Chart, Coord, Guide, Geom } from 'bizcharts';

const {
  Html,
  Arc,
  Line,
  Text,
} = Guide;

const data = [{
  value: 80,
}];
const cols = {
  value: {
    min: 0,
    max: 100,
  },
};

export class Gauge extends React.Component {
  renderText = () => {
    return `<div style="width: 300px;text-align: center;font-size: 12px!important;">
      <p style="font-size: 3em;color: rgba(0,0,0,0.85);margin: 0;">${data[0].value}<span style="font-size: 20px">%</span></p>
    </div>`;
  };
  render() {
    return (<Chart height={300} width={300} data={data} scale={cols} padding={[0, 0, 50, 0]} forceFit>
      <Coord type="polar" startAngle={-5 / 4 * Math.PI} endAngle={1 / 4 * Math.PI} radius={0.75} />
      <Guide>
        <Line
          start={[30, 1.3]}
          end={[30, 0.6]}
          lineStyle={{
            stroke: '#1890FF',
            lineDash: [15, 40],
            lineWidth: 4,
          }}
        />
        <Arc zIndex={0}
          start={[0, 1]}
          end={[100, 1]}
          style={{
            // 底灰色
            stroke: '#000',
            lineWidth: 18,
            opacity: 0.09,
          }}
        />
        <Arc zIndex={1}
          start={[0, 1]}
          end={[data[0].value, 1]}
          style={{
            // 数值颜色
            stroke: '#1890FF',
            lineWidth: 18,
          }}
        />
        <Html position={['50%', '60%']} html={this.renderText()} />
        <Text top content="比平均值偏高 40%" />
      </Guide>
      <Geom type="point"
        position="value*1"
        shape="pointer"
        color="#1890FF"
        active={false}
        style={{
          stroke: '#fff',
          lineWidth: 1,
        }}
      />
    </Chart>);
  }

}
