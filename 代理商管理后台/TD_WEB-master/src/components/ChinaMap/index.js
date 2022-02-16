import React, { Component } from 'react';
// import PropTypes from 'prop-types';
import echarts from 'echarts';
import { COMPANY_NAME } from '../../utils/constants';
// import china from 'echarts/map/js/china';

// const values = [{
//   name: '海门',
//   value: 9,
// },
// {
//   name: '鄂尔多斯',
//   value: 12,
// },
// {
//   name: '招远',
//   value: 12,
// },
// {
//   name: '舟山',
//   value: 12,
// },
// {
//   name: '齐齐哈尔',
//   value: 14,
// },
// {
//   name: '盐城',
//   value: 15,
// },
// {
//   name: '赤峰',
//   value: 16,
// },
// {
//   name: '青岛',
//   value: 18,
// },
// {
//   name: '乳山',
//   value: 18,
// },
// {
//   name: '金昌',
//   value: 19,
// },
// {
//   name: '泉州',
//   value: 21,
// },
// {
//   name: '莱西',
//   value: 21,
// },
// {
//   name: '日照',
//   value: 21,
// },
// {
//   name: '胶南',
//   value: 22,
// },
// {
//   name: '南通',
//   value: 23,
// },
// {
//   name: '拉萨',
//   value: 24,
// },
// {
//   name: '云浮',
//   value: 24,
// },
// {
//   name: '梅州',
//   value: 25,
// },
// {
//   name: '文登',
//   value: 25,
// },
// {
//   name: '上海',
//   value: 25,
// },
// {
//   name: '攀枝花',
//   value: 25,
// },
// {
//   name: '威海',
//   value: 25,
// },
// {
//   name: '承德',
//   value: 25,
// },
// {
//   name: '厦门',
//   value: 26,
// },
// {
//   name: '汕尾',
//   value: 26,
// },
// {
//   name: '潮州',
//   value: 26,
// },
// {
//   name: '丹东',
//   value: 27,
// },
// {
//   name: '太仓',
//   value: 27,
// },
// {
//   name: '曲靖',
//   value: 27,
// },
// {
//   name: '烟台',
//   value: 28,
// },
// {
//   name: '福州',
//   value: 29,
// },
// {
//   name: '瓦房店',
//   value: 30,
// },
// {
//   name: '即墨',
//   value: 30,
// },
// {
//   name: '抚顺',
//   value: 31,
// },
// {
//   name: '玉溪',
//   value: 31,
// },
// {
//   name: '张家口',
//   value: 31,
// },
// {
//   name: '阳泉',
//   value: 31,
// },
// {
//   name: '莱州',
//   value: 32,
// },
// {
//   name: '湖州',
//   value: 32,
// },
// {
//   name: '汕头',
//   value: 32,
// },
// {
//   name: '昆山',
//   value: 33,
// },
// {
//   name: '宁波',
//   value: 33,
// },
// {
//   name: '湛江',
//   value: 33,
// },
// {
//   name: '揭阳',
//   value: 34,
// },
// {
//   name: '荣成',
//   value: 34,
// },
// {
//   name: '连云港',
//   value: 35,
// },
// {
//   name: '葫芦岛',
//   value: 35,
// },
// {
//   name: '常熟',
//   value: 36,
// },
// {
//   name: '东莞',
//   value: 36,
// },
// {
//   name: '河源',
//   value: 36,
// },
// {
//   name: '淮安',
//   value: 36,
// },
// {
//   name: '泰州',
//   value: 36,
// },
// {
//   name: '南宁',
//   value: 37,
// },
// {
//   name: '营口',
//   value: 37,
// },
// {
//   name: '惠州',
//   value: 37,
// },
// {
//   name: '江阴',
//   value: 37,
// },
// {
//   name: '蓬莱',
//   value: 37,
// },
// {
//   name: '韶关',
//   value: 38,
// },
// {
//   name: '嘉峪关',
//   value: 38,
// },
// {
//   name: '广州',
//   value: 228,
// },
// {
//   name: '延安',
//   value: 38,
// },
// {
//   name: '太原',
//   value: 39,
// },
// {
//   name: '清远',
//   value: 39,
// },
// {
//   name: '中山',
//   value: 39,
// },
// {
//   name: '昆明',
//   value: 39,
// },
// {
//   name: '寿光',
//   value: 40,
// },
// {
//   name: '盘锦',
//   value: 40,
// },
// {
//   name: '长治',
//   value: 41,
// },
// {
//   name: '深圳',
//   value: 41,
// },
// {
//   name: '珠海',
//   value: 273,
// },
// {
//   name: '宿迁',
//   value: 43,
// },
// {
//   name: '咸阳',
//   value: 43,
// },
// {
//   name: '铜川',
//   value: 44,
// },
// {
//   name: '平度',
//   value: 44,
// },
// {
//   name: '佛山',
//   value: 44,
// },
// {
//   name: '海口',
//   value: 44,
// },
// {
//   name: '江门',
//   value: 45,
// },
// {
//   name: '章丘',
//   value: 45,
// },
// {
//   name: '肇庆',
//   value: 46,
// },
// {
//   name: '大连',
//   value: 47,
// },
// {
//   name: '临汾',
//   value: 47,
// },
// {
//   name: '吴江',
//   value: 47,
// },
// {
//   name: '石嘴山',
//   value: 49,
// },
// {
//   name: '沈阳',
//   value: 50,
// },
// {
//   name: '苏州',
//   value: 50,
// },
// {
//   name: '茂名',
//   value: 50,
// },
// {
//   name: '嘉兴',
//   value: 51,
// },
// {
//   name: '长春',
//   value: 51,
// },
// {
//   name: '胶州',
//   value: 52,
// },
// {
//   name: '银川',
//   value: 52,
// },
// {
//   name: '张家港',
//   value: 52,
// },
// {
//   name: '三门峡',
//   value: 53,
// },
// {
//   name: '锦州',
//   value: 54,
// },
// {
//   name: '南昌',
//   value: 54,
// },
// {
//   name: '柳州',
//   value: 54,
// },
// {
//   name: '三亚',
//   value: 54,
// },
// ];
// const geoCoordMap = {
//   海门: [121.15, 31.89],
//   鄂尔多斯: [109.781327, 39.608266],
//   招远: [120.38, 37.35],
//   舟山: [122.207216, 29.985295],
//   齐齐哈尔: [123.97, 47.33],
//   盐城: [120.13, 33.38],
//   赤峰: [118.87, 42.28],
//   青岛: [120.33, 36.07],
//   乳山: [121.52, 36.89],
//   金昌: [102.188043, 38.520089],
//   泉州: [118.58, 24.93],
//   莱西: [120.53, 36.86],
//   日照: [119.46, 35.42],
//   胶南: [119.97, 35.88],
//   南通: [121.05, 32.08],
//   拉萨: [91.11, 29.97],
//   云浮: [112.02, 22.93],
//   梅州: [116.1, 24.55],
//   文登: [122.05, 37.2],
//   上海: [121.48, 31.22],
//   攀枝花: [101.718637, 26.582347],
//   威海: [122.1, 37.5],
//   承德: [117.93, 40.97],
//   厦门: [118.1, 24.46],
//   汕尾: [115.375279, 22.786211],
//   潮州: [116.63, 23.68],
//   丹东: [124.37, 40.13],
//   太仓: [121.1, 31.45],
//   曲靖: [103.79, 25.51],
//   烟台: [121.39, 37.52],
//   福州: [119.3, 26.08],
//   瓦房店: [121.979603, 39.627114],
//   即墨: [120.45, 36.38],
//   抚顺: [123.97, 41.97],
//   玉溪: [102.52, 24.35],
//   张家口: [114.87, 40.82],
//   阳泉: [113.57, 37.85],
//   莱州: [119.942327, 37.177017],
//   湖州: [120.1, 30.86],
//   汕头: [116.69, 23.39],
//   昆山: [120.95, 31.39],
//   宁波: [121.56, 29.86],
//   湛江: [110.359377, 21.270708],
//   揭阳: [116.35, 23.55],
//   荣成: [122.41, 37.16],
//   连云港: [119.16, 34.59],
//   葫芦岛: [120.836932, 40.711052],
//   常熟: [120.74, 31.64],
//   东莞: [113.75, 23.04],
//   河源: [114.68, 23.73],
//   淮安: [119.15, 33.5],
//   泰州: [119.9, 32.49],
//   南宁: [108.33, 22.84],
//   营口: [122.18, 40.65],
//   惠州: [114.4, 23.09],
//   江阴: [120.26, 31.91],
//   蓬莱: [120.75, 37.8],
//   韶关: [113.62, 24.84],
//   嘉峪关: [98.289152, 39.77313],
//   广州: [113.23, 23.16],
//   延安: [109.47, 36.6],
//   太原: [112.53, 37.87],
//   清远: [113.01, 23.7],
//   中山: [113.38, 22.52],
//   昆明: [102.73, 25.04],
//   寿光: [118.73, 36.86],
//   盘锦: [122.070714, 41.119997],
//   长治: [113.08, 36.18],
//   深圳: [114.07, 22.62],
//   珠海: [113.52, 22.3],
//   宿迁: [118.3, 33.96],
//   咸阳: [108.72, 34.36],
//   铜川: [109.11, 35.09],
//   平度: [119.97, 36.77],
//   佛山: [113.11, 23.05],
//   海口: [110.35, 20.02],
//   江门: [113.06, 22.61],
//   章丘: [117.53, 36.72],
//   肇庆: [112.44, 23.05],
//   大连: [121.62, 38.92],
//   临汾: [111.5, 36.08],
//   吴江: [120.63, 31.16],
//   石嘴山: [106.39, 39.04],
//   沈阳: [123.38, 41.8],
//   苏州: [120.62, 31.32],
//   茂名: [110.88, 21.68],
//   嘉兴: [120.76, 30.77],
//   长春: [125.35, 43.88],
//   胶州: [120.03336, 36.264622],
//   银川: [106.27, 38.47],
//   张家港: [120.555821, 31.875428],
//   三门峡: [111.19, 34.76],
//   锦州: [121.15, 41.13],
//   南昌: [115.89, 28.68],
//   柳州: [109.4, 24.33],
//   三亚: [109.511909, 18.252847],
// };

// const convertData = (data) => {
//   let res = [];
//   for (let i = 0; i < data.length; i++) {
//     let geoCoord = geoCoordMap[data[i].name];
//     if (geoCoord) {
//       res.push({
//         name: data[i].name,
//         value: geoCoord.concat(data[i].value),
//       });
//     }
//   }
//   return res;
// };


// const option = {
//   legend: {
//     left: 'left',
//     data: ['强', '中', '弱'],
//     textStyle: {
//       color: '#ccc',
//     },
//   },
//   geo: {
//     map: 'china',
//     show: true,
//     roam: true,
//     label: {
//       emphasis: {
//         show: false,
//       },
//     },
//     itemStyle: {
//       normal: {
//         areaColor: '#323C48',
//         borderColor: '#252C32',
//         shadowColor: '#e0dd85',
//         shadowBlur: 20,
//       },
//     },
//   },
//   series: [
//     {
//       name: '城市',
//       type: 'scatter',
//       coordinateSystem: 'geo',
//       data: convertData(values),
//       symbolSize: (val) => {
//         return (val[2] / 20);
//       },
//       label: {
//         normal: {
//           formatter: '{b}',
//           position: 'right',
//           show: false,
//         },
//         emphasis: {
//           show: true,
//         },
//       },
//       itemStyle: {
//         normal: {
//           color: '#ddb926',
//         },
//       },
//     },
//     {
//       name: '前5',
//       type: 'effectScatter',
//       coordinateSystem: 'geo',
//       data: convertData(values.sort((a, b) => {
//         return b.value - a.value;
//       }).slice(0, 9)),
//       symbolSize: (val) => {
//         return (val[2] / 20);
//       },
//       showEffectOn: 'render',
//       rippleEffect: {
//         brushType: 'stroke',
//       },
//       hoverAnimation: true,
//       label: {
//         normal: {
//           formatter: '{b}',
//           position: 'right',
//           show: true,
//         },
//       },
//       itemStyle: {
//         normal: {
//           color: '#f4e925',
//           shadowBlur: 10,
//           shadowColor: '#333',
//         },
//       },
//       zlevel: 1,
//     },
//   ],
// };

const config = {
  title: {
    text: `${COMPANY_NAME}设备分布图`,
    // subtext: '纯属虚构',
    left: 'center',
  },
  tooltip: {
    trigger: 'item',
  },
  legend: {
    orient: 'vertical',
    left: 'left',
    data: ['充电线'],
  },
  visualMap: {
    min: 0,
    max: 2500,
    left: 'left',
    top: 'bottom',
    text: ['高', '低'],
    calculable: true,
  },
  toolbox: {
    show: true,
    orient: 'vertical',
    left: 'right',
    top: 'center',
    feature: {
      mark: { show: true },
      dataView: { show: true, readOnly: false },
      restore: { show: true },
      saveAsImage: { show: true },
    },
  },
  backgroundColor: {
    type: 'linear',
    x: 0,
    y: 0,
    x2: 1,
    y2: 1,
    colorStops: [{
      offset: 0, color: '#0f2c70', // 0% 处的颜色
    }, {
      offset: 1, color: '#091732', // 100% 处的颜色
    }],
    globalCoord: false, // 缺省为 false
  },
  geo: {
    map: 'china',
    show: true,
    roam: true,
    label: {
      emphasis: {
        show: false,
      },
    },
    itemStyle: {
      normal: {
        areaColor: '#091632',
        borderColor: '#1773c3',
        shadowColor: '#1773c3',
        shadowBlur: 20,
      },
    },
  },
  series: [
    {
      name: '充电线',
      type: 'map',
      mapType: 'china',
      roam: false,
      label: {
        normal: {
          show: false,
        },
        emphasis: {
          show: true,
        },
      },
      data: [
        { name: '北京', value: Math.round(Math.random() * 1000) },
        { name: '天津', value: Math.round(Math.random() * 1000) },
        { name: '上海', value: Math.round(Math.random() * 1000) },
        { name: '重庆', value: Math.round(Math.random() * 1000) },
        { name: '河北', value: Math.round(Math.random() * 1000) },
        { name: '河南', value: Math.round(Math.random() * 1000) },
        { name: '云南', value: Math.round(Math.random() * 1000) },
        { name: '辽宁', value: Math.round(Math.random() * 1000) },
        { name: '黑龙江', value: Math.round(Math.random() * 1000) },
        { name: '湖南', value: Math.round(Math.random() * 1000) },
        { name: '安徽', value: Math.round(Math.random() * 1000) },
        { name: '山东', value: Math.round(Math.random() * 1000) },
        { name: '新疆', value: Math.round(Math.random() * 1000) },
        { name: '江苏', value: Math.round(Math.random() * 1000) },
        { name: '浙江', value: Math.round(Math.random() * 1000) },
        { name: '江西', value: Math.round(Math.random() * 1000) },
        { name: '湖北', value: Math.round(Math.random() * 1000) },
        { name: '广西', value: Math.round(Math.random() * 1000) },
        { name: '甘肃', value: Math.round(Math.random() * 1000) },
        { name: '山西', value: Math.round(Math.random() * 1000) },
        { name: '内蒙古', value: Math.round(Math.random() * 1000) },
        { name: '陕西', value: Math.round(Math.random() * 1000) },
        { name: '吉林', value: Math.round(Math.random() * 1000) },
        { name: '福建', value: Math.round(Math.random() * 1000) },
        { name: '贵州', value: Math.round(Math.random() * 1000) },
        { name: '广东', value: Math.round(Math.random() * 1000) },
        { name: '青海', value: Math.round(Math.random() * 1000) },
        { name: '西藏', value: Math.round(Math.random() * 1000) },
        { name: '四川', value: Math.round(Math.random() * 1000) },
        { name: '宁夏', value: Math.round(Math.random() * 1000) },
        { name: '海南', value: Math.round(Math.random() * 1000) },
        { name: '台湾', value: Math.round(Math.random() * 1000) },
        { name: '香港', value: Math.round(Math.random() * 1000) },
        { name: '澳门', value: Math.round(Math.random() * 1000) },
      ],
    },
  ],
};

export default class ChinaMap extends Component {
  componentDidMount = () => {
    const myChart = echarts.init(this.mapNode);
    myChart.setOption(config, true);
  }
  render() {
    return (
      <div className="china-map">
        <div style={{ width: '500px', height: '400px' }} ref={(mapNode) => { this.mapNode = mapNode; }} />
      </div>
    );
  }
}
