import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Spin, Card, Tabs, message, Form, Icon, Collapse } from 'antd';
import { action as accountActions } from './store';
import { dateFormat, datetimeFormat, formatBankCode, formatAgentType } from '../../utils';
import { roleTypes } from '../../utils/enum';
import { TabsContainer } from '../../containers/TabsContainer';
import { DetailList } from '../../components/DetailList';
import { AddBankModal } from '../../containers/AccountAddBank/AddBankModal';

import './style.less';

const TabPane = Tabs.TabPane;
const Panel = Collapse.Panel;

class AccountPage extends React.Component {
  componentDidMount() {
    this.fetchAccountDetail();
    this.fetBankInfo();
  }

  fetchAccountDetail = () => {
    const { dispatch } = this.props;
    dispatch(accountActions.fetchAccountDetail());
  }

  fetBankInfo = () => {
    const { dispatch } = this.props;
    dispatch(accountActions.fetchBankInfo());
  }

  handleSubmit = () => {
    const { dispatch } = this.props;
    this.props.form.validateFieldsAndScroll((errors, values) => {
      if (errors) {
        return;
      }
      const { newPassword, repeatPassword } = values;
      if (newPassword !== repeatPassword) {
        message.destroy();
        message.error('两次输入的密码不一致！');
        return;
      }
      dispatch(accountActions.resetPassword(values));
    });
  }

  showAddBank = () => {
    const { dispatch } = this.props;
    dispatch(accountActions.toggleAddBankModal(true));
  }

  render() {
    const {
      accountDetail: {
        loading,
        result,
      },
      bankInfo,
      roleType,
    } = this.props;
    let accountDetail = result || {};
    let bankList = bankInfo.result || {};
    bankList = bankList.banks ? bankList.banks : [];
    const { area, city, province, level, detailAddr } = accountDetail;
    let accountColumns = [];
    let deviceColumns = [];
    if (roleType !== 2) {
      accountDetail.address = `${province || ''}${city || ''}${area || ''}${detailAddr || ''}`;
      accountColumns = [
        { key: 'mchType', label: '代理商类型', render: (text) => formatAgentType(text, level) },
        { key: 'mchId', label: '代理商编号' },
        { key: 'superUser', label: '代理商账号' },
        { key: 'mchName', label: '代理商名称' }, // 商户名称
        { key: 'contactUser', label: '代理人姓名' }, // 商户姓名
        { key: 'contactPhone', label: '代理人电话' }, // 商户电话
        { key: 'contractTime', label: '合同结束期', render: text => datetimeFormat(text) },
        { key: 'salesName', label: '关联业务员' },
        { key: 'createTime', label: '账号创建日期', render: text => datetimeFormat(text) },
        { key: 'address', label: '位置地域' },
        { key: 'settementPeriod', label: '结算周期', render: text => `T+${text}` },
      ];
      deviceColumns = [
        { key: 'deviceTotal', label: '设备总数' },
        { key: 'deviceActiveTotal', label: '设备激活数' },
        { key: 'transTotal', label: '订单总数' },
        { key: 'moneyTotalYun', label: '订单总金额' },
      ];

      if (String(accountDetail.mchType) === 1) {
        accountColumns.push({ key: 'industry', label: '商户行业', render: text => dateFormat(text) });
      }
    } else {
      accountDetail = {
        ...accountDetail,
        ...accountDetail.user,
      };
      accountColumns = [
        { key: 'roleType', label: '账户类型', render: text => roleTypes[text] },
        { key: 'name', label: '业务员姓名' },
        { key: 'mobile', label: '业务员电话' }, // 商户名称
        // { key: 'contactUser', label: '所属代理商名称' }, // 商户姓名
        { key: 'createTime', label: '账号创建日期', render: text => datetimeFormat(text) },
      ];
      deviceColumns = [
        { key: 'deviceCount', label: '设备总数' },
        { key: 'activeCount', label: '设备激活数' },
      ];
    }
    const agentColumns = [
      { key: 'agentLevel2Total', label: '二级代理商总数' },
      { key: 'agentLevel3Total', label: '三级代理商总数' },
      { key: 'tenantTotal', label: '终端商户总数' },
    ];
    const getBankColumns = (bank) => {
      let bankColumns = [];
      if (bank.isPublic === 1) {
        bankColumns = [
          { key: 'isPublic', label: '账户类型', render: () => '对公银行账户' },
          { key: 'bankName', label: '开户银行' },
          { key: 'accountName', label: '账户名称' },
          { key: 'bankId', label: '银行对公账号', render: text => formatBankCode(text) },
          { key: 'bankBranch', label: '支行名称' },
          { key: 'cityName', label: '开户行所在地', render: text => text || '' },
        ];
      } else if (bank.isPublic === 0) {
        bankColumns = [
          { key: 'isPublic', label: '账户类型', render: () => '对私银行账户' },
          { key: 'accountName', label: '账户名称' },
          { key: 'bankId', label: '银行卡号', render: text => formatBankCode(text) },
          { key: 'bankName', label: '开户银行' },
        ];
      } else if (bank.isPublic === 2) {
        bankColumns = [
          { key: 'isPublic', label: '账户类型', render: () => '微信零钱' },
          { key: 'accountName', label: '账户名称' },
        ];
      }
      return bankColumns;
    };
    const bankColSpan = {
      xs: 24,
      sm: 24,
      xl: 24,
    };
    const bankItemCol = {
      labelCol: { span: 8 },
      wrapperCol: { span: 16 },
    };
    return (
      <div className="account-wrap">
        <TabsContainer defaultActiveKey="account">
          <TabPane tab="账户详情" key="account">
            <Collapse bordered={false} defaultActiveKey={['a', 'b', 'c']}>
              <Panel header={<h3>账户详情</h3>} bordered={false} key="a">
                <Spin spinning={loading}>
                  <DetailList columns={accountColumns} dataSource={accountDetail} />
                </Spin>
              </Panel>
              <Panel header={<h3>设备信息</h3>} bordered={false} key="b">
                <Spin spinning={loading}>
                  <DetailList columns={deviceColumns} dataSource={accountDetail} />
                </Spin>
              </Panel>
              {roleType !== 2 && accountDetail.mchType === 0 &&
                <Panel header={<h3>子级代理商信息</h3>} bordered={false} key="c">
                  <Spin spinning={loading}>
                    <DetailList columns={agentColumns} dataSource={accountDetail} />
                  </Spin>
                </Panel>
              }
            </Collapse>
          </TabPane>

          {roleType !== 2 && <TabPane tab="银行卡信息" key="bankInfo">
            {
              !!bankList.length && (<div>
                {
                  bankList.map(bank => (<Card
                    key={bank.bankId}
                    title="我的银行卡信息"
                    className="bank-card"
                  >
                    <DetailList
                      colSpan={bankColSpan}
                      itemCol={bankItemCol}
                      columns={getBankColumns(bank)}
                      dataSource={bank}
                    />
                    <div className="bank-card-status">使用中</div>
                  </Card>))
                }
              </div>)
            }
            {
              !bankList.length && <Card
                className="bank-card add-card"
                onClick={this.showAddBank}
              >
                <Icon type="plus" theme="outlined" />
                <div>添加银行卡</div>
              </Card>
            }
          </TabPane>
          }
        </TabsContainer>
        <AddBankModal />
      </div>
    );
  }
}

AccountPage.propTypes = {
  accountDetail: PropTypes.object,
  bankInfo: PropTypes.object,
  dispatch: PropTypes.func.isRequired,
  form: PropTypes.object.isRequired,
  roleType: PropTypes.number.isRequired,
};

AccountPage.defaultProps = {
  accountDetail: {},
  bankInfo: {},
  form: {},
};

export default Form.create()(connect(({ account: { accountDetail, bankInfo, roleType } }) => ({
  accountDetail, bankInfo, roleType,
}))(AccountPage));
