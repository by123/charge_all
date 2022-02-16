/**
 * 添加编辑代理商/商户
 */
import React from 'react';
import PropTypes from 'prop-types';
import copy from 'copy-to-clipboard';
import { Modal, message, Button, Spin, Row, Col, Collapse, Divider } from 'antd';
import { connect } from 'react-redux';
import { action as agentActions } from '../../pages/Agent/store';
import { editText } from '../../utils/enum';
import { DetailList } from '../../components/DetailList';
import { AgentForm } from './AgentForm';
import { ADD, AGENT, BIZ, EDIT, CHAIN, STORE, COMPANY_NAME } from '../../utils/constants';
import { momentToFormatDate, processBillingRules, processBillingRulesWithPre, checkIsTypeChain } from '../../utils';

const { Panel } = Collapse;
const itemProps = {
  wrapperCol: { xs: { span: 21 }, sm: { span: 21 }, xl: { span: 21 } },
  labelCol: { xs: { span: 3 }, sm: { span: 3 }, xl: { span: 3 } },
};
const colSpan = { xs: 24, sm: 24, md: 24, lg: 24, xl: 24 };

class EditAgentModal extends React.PureComponent {
  state = {
    disabled: true,
    hasStores: false,
    selectedChainId: '', // 添加门店分店时保存父级mchId
    isNextAndCreateStore: false,
    parentAgentData: {}, //
    chainAccountData: {}, // 连锁门店账户信息
    isContinue: false, // 点击继续创建门店
    isIndustryChanged: false,
  }

  // keepData = true 为继续创建分店
  handleOk = (isContinue) => {
    const { form } = this.agentForm.props;
    const { isNextAndCreateStore } = this.state;
    isContinue && this.setState({
      isContinue,
    });
    form.validateFieldsAndScroll((errors, fields) => {
      if (errors) {
        return;
      }
      const { agentType, editType, dispatch, detailData } = this.props;
      const isAddBiz = (agentType === BIZ || agentType === STORE) && editType === ADD;
      // 继续创建分店时重置表单
      const nextAction = isContinue ? () => {
        form.resetFields();
        form.setFieldsValue({ pledge: undefined });
        form.setFieldsValue({ keys: [{
          key: 0,
          initialPrice: undefined,
          initialTime: undefined,
        }] });
        this.setState({
          isIndustryChanged: false,
        });
      } : null;
      let rule;
      if (isAddBiz) {
        fields.service = (fields.serviceType === 1 ? processBillingRules(fields.service) : processBillingRulesWithPre(fields.service));
        fields.pledge = 0;
        fields.superUser = fields.contactPhone;
      }
      if ((agentType === BIZ || agentType === STORE) && editType === EDIT) {
        rule = {
          deviceType: detailData.result.deviceType,
          service: fields.serviceType === 1 ? processBillingRules(fields.service) : processBillingRulesWithPre(fields.service),
          serviceType: fields.serviceType,
          pledgeYuan: fields.pledge,
          tenantId: detailData.result.mchId,
        };
        // dispatch(agentActions.editBizRule(rule));
      }
      // 连锁门店
      if (agentType === STORE && editType === ADD) {
        // let newParentAgentData = isNextAndCreateStore ? this.state.parentAgentData : (parentAgentData || {});
        // let newParentAgentData = this.getParentData();
        const { mchId, salesId } = this.getParentData();
        fields.mchParentChainAgentId = mchId;
        fields.salesId = salesId;
        delete fields.keys;
      }
      if (fields.address && fields.address.length > 0) {
        fields.province = fields.address[0];
        fields.city = fields.address[1];
        fields.area = fields.address[2];
      } else {
        fields.province = '';
        fields.city = '';
        fields.area = '';
      }
      delete fields.address;

      if (fields.blockedAmount) {
        fields.blockedAmount *= 100;
      }

      fields.contractTime = momentToFormatDate(fields.contractTime, false, 'x');
      fields.salesId = fields.salesId || '';

      dispatch(agentActions.saveAgentInfo(fields, rule, isNextAndCreateStore, nextAction));
    });
  };

  handleCancel = () => {
    this.props.dispatch(agentActions.toggleEditAgentModal(false));
    this.setState({
      disabled: true,
      selectedChainId: '',
      isNextAndCreateStore: false,
      chainAccountData: {},
      isContinue: false,
    });
  }

  generatorTitle = () => {
    const { editType, agentType } = this.props;
    const nameList = {
      [AGENT]: editType === EDIT ? '代理商' : '子代理',
      [CHAIN]: '连锁门店',
      [BIZ]: '商户',
      [STORE]: '分店',
    };
    const suffix = editType === EDIT ? '资料' : '';

    return editText[editType] + nameList[agentType] + suffix;
  }

  copyAccount = () => {
    if (copy(this.generatorAccountInfo())) {
      this.setState({
        disabled: false,
      });
      message.success('复制成功！');
    }
  }

  generatorAccountInfo = () => {
    let { agentType, addAgent: { result } } = this.props;
    const { isNextAndCreateStore, chainAccountData } = this.state;
    result = result || {};
    if (agentType === STORE && isNextAndCreateStore) {
      result = chainAccountData;
    }
    const { SuperUser, password } = result;
    return `登陆账号：${SuperUser}，初始密码：${password}`;
  }

  // 创建完连锁门店后 点击 继续创建分店
  createStore = () => {
    const { dispatch, addAgent: { result = {}, loading }, location = {} } = this.props;
    if (loading) return;
    // dispatch(agentActions.toggleEditAgentModal(false));
    dispatch(agentActions.toggleAccountInfoModal(false));
    const { form } = this.agentForm.props;
    const { industry, profitSubAgent, salesId } = form.getFieldsValue();
    form.resetFields();
    let parentAgentData = { industry, salesId, totalPercent: profitSubAgent, mchId: result.mchId };
    this.setState({
      isNextAndCreateStore: true,
      parentAgentData,
      chainAccountData: result,
      isIndustryChanged: false,
    });
    dispatch(agentActions.toggleEditAgentModal(true, STORE, ADD));
    dispatch(agentActions.fetchAgentList(location.search));
  }

  onTypeChange = (agentType) => {
    this.props.dispatch(agentActions.toggleEditAgentModal(true, agentType, this.props.editType));
  }

  onChainChange = (mchId) => {
    this.setState({
      selectedChainId: mchId,
    });
    this.props.dispatch(agentActions.queryParentProfit(mchId));
  }

  closeModal = () => {
    this.props.dispatch(agentActions.closeModalAndRefresh());
    this.setState({
      disabled: true,
      selectedChainId: '',
      isNextAndCreateStore: false,
      chainAccountData: {},
      isContinue: false,
    });
  }

  getParentData = () => {
    const { isNextAndCreateStore } = this.state;
    const { selfInfo, parentAgentData, agentType, editType } = this.props;
    let result = {};
    // 连锁门店账户创建分店不需要选父级
    if (editType === ADD) {
      if (agentType !== STORE || checkIsTypeChain(selfInfo)) {
        result = selfInfo;
      } else {
        result = isNextAndCreateStore ? this.state.parentAgentData : (parentAgentData || {});
      }
    } else {
      result = parentAgentData || {};
    }
    return result;
  }

  onChangeIndustry = () => {
    this.setState({
      isIndustryChanged: true,
      service: {},
    });
  }

  render() {
    const {
      visible,
      accountVisible,
      agentType,
      editType,
      detailData,
      addAgent,
      updateAgent,
      selfInfo,
      allUsers,
      profile,
      editBizRuleResult,
      addedStoresList = [],
      queryAgent,
      industryList,
    } = this.props;
    const { disabled, isNextAndCreateStore, isContinue, isIndustryChanged } = this.state;
    const industyPrice = industryList.result || [];
    let newParentAgentData = this.getParentData();
    let loading = false;
    if (detailData.result) {
      loading = detailData.loading;
    }
    const footer = (<div style={{ textAlign: 'center', position: 'relative' }}>
      <Button loading={addAgent.loading} onClick={this.handleCancel}>取消</Button>
      <Button loading={addAgent.loading} type="primary" onClick={() => this.handleOk()}>创建门店</Button>
      <a
        disabled={addAgent.loading}
        onClick={() => this.handleOk(true)}
        style={{ position: 'absolute', left: '62%', bottom: 3 }}
      >提交并创建下一个分店</a>
    </div>);
    const modalOpts = {
      title: this.generatorTitle(),
      visible,
      width: 800,
      style: {
        top: 20,
      },
      onOk: () => this.handleOk(),
      onCancel: this.handleCancel,
      destroyOnClose: true,
      confirmLoading: addAgent.loading || updateAgent.loading || editBizRuleResult.loading,
      cancelButtonProps: {
        disabled: addAgent.loading || updateAgent.loading || editBizRuleResult.loading,
      },
      maskClosable: false,
    };
    if (agentType === STORE && editType === ADD && isNextAndCreateStore) {
      modalOpts.footer = footer;
    }
    const bizModalVisible = accountVisible && (agentType === BIZ || (agentType === STORE && !isNextAndCreateStore));
    const chainModalVisible = accountVisible && (agentType === CHAIN || (agentType === STORE && isNextAndCreateStore));
    const accountModalOpts = {
      title: `${agentType === BIZ ? '商户' : '连锁门店分店'}创建成功`,
      visible: bizModalVisible,
      maskClosable: false,
      // footer: null,
      closable: false,
      onCancel: this.closeModal,
      onOk: this.closeModal,
    };
    const addAgentModalOpts = {
      title: '添加成功',
      visible: accountVisible && agentType === AGENT,
      loading: addAgent.loading,
      maskClosable: false,
      footer: null,
      closable: false,
      width: 540,
    };
    const addChainModalOpts = {
      title: '连锁门店创建成功',
      visible: chainModalVisible,
      // visible: true,
      loading: addAgent.loading,
      maskClosable: false,
      footer: null,
      closable: false,
      width: 540,
    };
    const storeColumns = [
      { key: 'mchName', label: '分店名称' },
      { key: 'contactPhone', label: '联系人姓名' },
      { key: 'contactUser', label: '联系人电话' },
      { key: 'totalPercent', label: '分店分润比例', render: text => `${text}%` },
      { key: 'area', label: '区域位置', render: (text, record) => `${record.province} ${record.city} ${text}` },
      { key: 'pledgeYuan', label: '押金', render: (text, record) => `${record.mchPriceRule[0].pledgeYuan}元` },
      { key: 'service',
        label: '计费规则',
        itemProps,
        colSpan,
        render: (rule, record) => {
          if (!record.mchPriceRule) return;
          let { service } = record.mchPriceRule[0];
          service = JSON.parse(service);
          const serviceType = rule.serviceType;
          return (serviceType === '1' || serviceType === 1) ? service.map(s => `/${s.price / 100}元${s.time / 60}小时`).join(' ') : `前${service.minMinutes / 60}小时扣费${service.minMoney / 100}元，超过${service.minMinutes / 60}小时，每${service.stepMinutes / 60}小时收费${service.price / 100}元/预付金${service.prepaid / 100}元/封顶${service.maxMoney / 100}元`;
        } },
    ];
    let userList = allUsers.result || [];
    const { mchType, roleType } = profile;
    if (roleType > 1) { // 非管理员,管理业务员只能选自己
      userList = [{
        userId: profile.userId,
        roleType,
        name: profile.name,
      }];
    }
    const isPlatform = mchType === 2 && roleType < 2;
    const subProfit = newParentAgentData.totalPercent || selfInfo.totalPercent;
    const defaultActiveKey = addedStoresList.length ? [String(addedStoresList.length - 1)] : [];
    return (
      <div>
        <Modal {...modalOpts}>
          <Spin spinning={loading}>
            {isContinue && !!addedStoresList.length && <Collapse
              style={{ marginBottom: 20 }}
              bordered={false}
              defaultActiveKey={defaultActiveKey}
            >
              {addedStoresList.map((val, ind) => {
                return (<Panel header={<h3>分店{ind + 1}创建成功</h3>} key={String(ind)}>
                  <DetailList columns={storeColumns} dataSource={val} />
                </Panel>);
              })}
            </Collapse>}
            <AgentForm
              agent={detailData.result}
              totalProfit={subProfit}
              editType={editType}
              agentType={agentType}
              userList={userList}
              level={selfInfo.level}
              parentChainData={newParentAgentData}
              isPlatform={isPlatform}
              onTypeChange={this.onTypeChange}
              onChainChange={this.onChainChange}
              queryAgent={queryAgent}
              insdustyPrice={industyPrice}
              isNextAndCreateStore={isNextAndCreateStore}
              wrappedComponentRef={inst => { this.agentForm = inst; }}
              isIndustryChanged={isIndustryChanged}
              onChangeIndustry={this.onChangeIndustry}
            />
          </Spin>
        </Modal>
        <Modal {...accountModalOpts}>
          {/* <div style={{ marginTop: 10 }}>
          {this.generatorAccountInfo()}&nbsp;&nbsp;&nbsp;&nbsp;<a onClick={this.copyAccount}>点击复制</a></div>
          <div style={{ textAlign: 'center', paddingTop: 20 }}>
            <Button onClick={() => dispatch(agentActions.closeModalAndRefresh())}>知道了</Button>
          </div> */}
          {agentType === STORE && (<div>
            <div>注意：</div>
            <div>1，连锁门店上级代理商可越级管理分店，及分店设备</div>
            <div>{`2，微信关注公众号“${COMPANY_NAME}商家版”，获得二维码并绑定分店，可查看各分店详情`}</div>
          </div>)}
          {agentType === BIZ && (<div>
            <div>注意：</div>
            <div>{`1，请通知商户关注公众号“${COMPANY_NAME}商家版”，获得二维码`}</div>
            <div>{`2，登录${COMPANY_NAME}-代理商版APP，扫码商户二维码，进行绑定`}</div>
          </div>)}
        </Modal>
        <Modal {...addAgentModalOpts}>
          <div style={{ marginTop: 10, textAlign: 'center' }}>
            {this.generatorAccountInfo()}&nbsp;&nbsp;&nbsp;&nbsp;
            <a onClick={this.copyAccount}>请点击复制账号密码</a>
          </div>
          <div style={{ textAlign: 'center', paddingTop: 20 }}>
            <Button disabled={disabled} onClick={this.closeModal}>知道了</Button>
          </div>
        </Modal>
        {/* 添加连锁门店弹窗 */}
        <Modal {...addChainModalOpts}>
          <div style={{ marginTop: 10, textAlign: 'center' }}>
            {this.generatorAccountInfo()}&nbsp;&nbsp;&nbsp;&nbsp;
            <a onClick={this.copyAccount}>请点击复制账号密码</a>
          </div>
          {!isNextAndCreateStore && <div style={{ textAlign: 'center', paddingTop: 20 }}>
            <Button disabled={disabled} style={{ marginRight: 20 }} onClick={this.closeModal}>暂不创建分店</Button>
            <Button disabled={disabled} type="primary" onClick={this.createStore}>创建分店</Button>
          </div>}
          {isNextAndCreateStore && <div>
            <Divider />
            {addedStoresList.map((val, ind) => {
              return (<Row key={val.mchId}>
                <Col span={4} offset={2}><span>分店{ind + 1}：</span></Col>
                <Col span={10}><span>{val.mchName}</span></Col>
              </Row>);
            })}
          </div>}
          <div style={{ marginTop: 20, padding: '0 10px' }}>
            <div>注意：</div>
            <div>{`1，连锁门店可登陆${COMPANY_NAME}-代理商版APP `}</div>
            <div>{`2，微信关注公众号“${COMPANY_NAME}商家版”，获得二维码并绑定成功，可查看各分店详情`}</div>
          </div>
          {isNextAndCreateStore && <div style={{ textAlign: 'center', paddingTop: 20 }}>
            <Button disabled={disabled} type="primary" onClick={this.closeModal}>知道了</Button>
          </div>}
        </Modal>
      </div>
    );
  }
}

EditAgentModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.object,
  visible: PropTypes.bool.isRequired,
  accountVisible: PropTypes.bool.isRequired,
  addAgent: PropTypes.object.isRequired,
  updateAgent: PropTypes.object.isRequired,
  agentType: PropTypes.string,
  editType: PropTypes.string,
  detailData: PropTypes.object.isRequired,
  editBizRuleResult: PropTypes.object.isRequired,
  addChainStoresResult: PropTypes.object,
  addedStoresList: PropTypes.array,
  parentAgentData: PropTypes.object,
  queryAgent: PropTypes.object,
  industryList: PropTypes.object,
  insdustyPrice: PropTypes.object.isRequired,
  selfInfo: PropTypes.object.isRequired,
  allUsers: PropTypes.object.isRequired,
  profile: PropTypes.object.isRequired,
};

EditAgentModal.defaultProps = {
  agentType: AGENT,
  editType: ADD,
  // detailData: undefined,
  addChainStoresResult: {},
  addedStoresList: [],
  parentAgentData: null,
  queryAgent: {},
  industryList: {},
  location: {},
  insdustyPrice: {},

};

const Container = connect(({
  agent: {
    editModalVisible,
    accountVisible,
    addAgent,
    updateAgent,
    agentType,
    editType,
    detailData,
    selfInfo,
    editBizRuleResult,
    addChainStoresResult,
    addedStoresList,
    parentAgentData,
  },
  personnel: {
    allUsers,
  },
  global: {
    profile,
  },
  device: { queryAgent, industryList },
}) => ({
  visible: editModalVisible,
  accountVisible,
  updateAgent,
  addAgent,
  agentType,
  editType,
  detailData,
  selfInfo,
  allUsers,
  profile,
  editBizRuleResult,
  addChainStoresResult,
  addedStoresList,
  parentAgentData,
  queryAgent,
  industryList,
}))(EditAgentModal);

export { Container as EditAgentModal };
