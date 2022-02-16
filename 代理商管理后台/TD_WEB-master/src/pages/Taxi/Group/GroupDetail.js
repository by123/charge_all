import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Collapse, Spin } from 'antd';
import { DetailList } from '@/components/DetailList';
import { concatLabel, renderGroupPrice } from '@/utils';

const { Panel } = Collapse;

class GroupDetail extends React.Component {
  render() {
    const {
      detailData: {
        loading,
        result,
      },
    } = this.props;

    const groupDetail = result || {};

    let agentColumns = [
      { key: 'groupName', label: '分组名称' },
      { key: 'salesName', label: '关联业务员' },
      { key: 'profitPercentTaxi', label: '分润比例', render: (text) => concatLabel(text, '%') },
      { key: 'service', label: '默认计费规则', render: renderGroupPrice },
      { key: 'depositStr', label: '设备冻结款', render: text => `${text}元` },
    ];
    const deviceColumns = [
      { key: 'deviceTotal', label: '设备总数' },
      { key: 'deviceTotalActive', label: '设备激活数' },
      { key: 'orderTotalnum', label: '订单总数' },
      { key: 'orderTotalmoneyStr', label: '订单总金额' },
    ];
    const beforeSaleColumns = [
      { key: 'presaleContactName', label: '联系人' },
      { key: 'presaleContactTel', label: '手机号' },
      { key: 'presaleDetailAddr',
        label: '售前地址',
        render: (text, record) => {
          const area = record.presaleArea ? `${record.presaleProvince} ${record.presaleCity} ${record.presaleArea} ` : '';
          return text ? area + text : area;
        },
      },
    ];
    const afterSaleColumns = [
      { key: 'aftersaleContactName', label: '联系人' },
      { key: 'aftersaleContactTel', label: '手机号' },
      { key: 'aftersaleDetailAddr',
        label: '售后地址',
        render: (text, record) => {
          const area = record.aftersaleArea ? `${record.aftersaleProvince} ${record.aftersaleCity} ${record.aftersaleArea} ` : '';
          return text ? area + text : area;
        },
      },
    ];
    const driverColumns = [
      { key: 'taxiNum', label: '司机数量' },
    ];
    return (<div>
      <Collapse bordered={false} onChange={this.handleCollapseChange} defaultActiveKey={['a', 'b', 'c', 'd', 'e']}>
        <Panel header={<h3>分组信息</h3>} key="a">
          <Spin spinning={loading}>
            <DetailList columns={agentColumns} dataSource={groupDetail} />
          </Spin>
        </Panel>
        <Panel header={<h3>售前信息</h3>} key="b">
          <Spin spinning={loading}>
            <DetailList columns={beforeSaleColumns} dataSource={groupDetail} />
          </Spin>
        </Panel>
        <Panel header={<h3>售后信息</h3>} key="c">
          <Spin spinning={loading}>
            <DetailList columns={afterSaleColumns} dataSource={groupDetail} />
          </Spin>
        </Panel>
        <Panel header={<h3>设备信息</h3>} key="d">
          <Spin spinning={loading}>
            <DetailList columns={deviceColumns} dataSource={groupDetail} />
          </Spin>
        </Panel>
        <Panel header={<h3>司机</h3>} key="e">
          <Spin spinning={loading}>
            <DetailList columns={driverColumns} dataSource={groupDetail} />
          </Spin>
        </Panel>
      </Collapse>
    </div>);
  }
}
GroupDetail.propTypes = {
  detailData: PropTypes.object.isRequired,
};

const Container = connect(({ taxiGroup: { detailData } }) => ({
  detailData,
}))(GroupDetail);

export { Container as GroupDetail };
