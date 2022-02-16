import React from 'react';
import PropTypes from 'prop-types';
import { Modal, Form, Row, Col, Radio, Icon, Spin } from 'antd';
import { connect } from 'react-redux';
import { api } from '@/store/api';
import { get } from '@/utils/request';
import { FormInput } from '../../components/FormInput';
import { mapBankList, transformCity, formatBankCode, getCityIndex } from '../../utils';
import { DetailList } from '../../components/DetailList';
import { action as accountActions } from '../../pages/Account/store';
import { action as applyActions } from '../../pages/FinanceCenter/store';

import './style.less';
import { ADD, EDIT } from '../../utils/constants';
import { accountState } from '../../utils/enum';

const RadioGroup = Radio.Group;
const FormItem = Form.Item;

class AddBankModal extends React.PureComponent {
  state = {
    confirmDirty: false,
    tmpBankData: null,
    isPublic: 0,
    options: [],
    bankData: null,
    isChecking: false,
    isBankCodeOk: true,
  }

  componentDidMount() {
    const { dispatch } = this.props;
    dispatch(accountActions.fetchBankCodeList());
    dispatch(accountActions.fetchCityCodeList());
  }

  componentWillUpdate(prevState) {
    if (prevState.initData && prevState.initData.isPublic !== undefined
      && (!this.props.initData || this.props.initData.isPublic === undefined)) {
      setTimeout(() => {
        this.setState({
          isPublic: prevState.initData.isPublic || 0,
        });
      }, 20);
    }
  }

  changeAccountType = (e) => {
    this.setState({
      isPublic: e.target.value,
      tmpBankData: null,
      bankData: null,
      isChecking: false,
      isBankCodeOk: true,
    });
    // 账户状态不能重置
    this.props.form.resetFields(['bankId', 'accountName', 'bankIndex', 'bankBranch', 'cityCode']);
  }

  handleAddCancel = () => {
    const { dispatch } = this.props;
    if (!this.state.confirmDirty) {
      this.setState({
        tmpBankData: null,
        bankData: null,
      });
      dispatch(accountActions.toggleAddBankModal(false));
    } else {
      this.setState({
        confirmDirty: false,
      });
    }
  }

  handleAddOk = () => {
    const { confirmDirty, isPublic, isBankCodeOk, isChecking } = this.state;
    const { form,
      editType,
      bankCodeList: {
        result: {
          data: bankList = [],
        } = {},
      },
      initData,
      dispatch,
    } = this.props;
    let fields = form.getFieldsValue();
    if (!isBankCodeOk || isChecking) return;
    if (!confirmDirty) {
      form.validateFieldsAndScroll((errors) => {
        if (errors) return;
        this.setState({
          confirmDirty: true,
          tmpBankData: {
            ...fields,
            isPublic,
          },
        });
      });
    } else {
      const { tmpBankData } = this.state;
      let bankData = { ...tmpBankData };
      if (isPublic === 0 || isPublic === 1) {
        const bank = bankList[tmpBankData.bankIndex].node;
        bankData = {
          ...bankData,
          bankName: bank.bank_name,
          bankCode: bank.bank_code.trim(),
        };
        delete bankData.bankIndex;
      }
      const { cityCode } = tmpBankData;
      if (cityCode) {
        bankData.cityCode = cityCode[cityCode.length - 1].split('&')[0];
        bankData.cityName = this.codeToCity(cityCode);
      }
      if (editType === EDIT) {
        bankData.mchId = initData.mchId;
        bankData.oldBankId = initData.bankId;
        dispatch(accountActions.editBankCard(Object.assign({}, bankData), () => {
          dispatch(accountActions.addBankSuccess(EDIT));
          dispatch(applyActions.refreshList());
        }));
      } else {
        dispatch(accountActions.addBankCard(Object.assign({}, bankData)));
      }
      setTimeout(() => {
        this.setState({
          tmpBankData: null,
          confirmDirty: false,
          bankData: null,
        });
      }, 200);
    }
  }

  codeToCity = (text) => {
    return text.reduce((pre, cur) => {
      return pre + cur.split('&')[1];
    }, '');
  }

  queryBank = (e) => {
    const value = e.currentTarget.value;
    if (!value || this.state.isPublic === 1) return;
    this.setState({
      isChecking: true,
    });
    const { form: { setFieldsValue, setFields, getFieldValue } } = this.props;
    get(api.queryBankByCode, { cardNo: value }).then((res) => {
      const { bank_code } = res;
      setFieldsValue({ bankIndex: this.getBankIndex(bank_code) });
      this.setState({
        isChecking: false,
        isBankCodeOk: true,
      });
    }).catch(err => {
      this.setState({
        isChecking: false,
        isBankCodeOk: false,
      });
      setFields({
        bankId: {
          value: getFieldValue('bankId'),
          errors: [new Error(err.msg || '卡号校验不通过')],
        },
      });
    });
  }

  getBankIndex = (bankCode) => {
    const { bankCodeList: { result: { data: bankList = [] } = {} } } = this.props;
    let bankIndex;
    for (let i = 0, len = bankList.length; i < len; i++) {
      if (bankList[i].node.bank_code === bankCode) {
        bankIndex = i;
        break;
      }
    }
    bankIndex = bankIndex !== undefined ? String(bankIndex) : undefined;
    return bankIndex;
  }

  render() {
    const {
      addBankShow,
      addBankInfo,
      form,
      editType = ADD,
      bankCodeList: {
        result: {
          data: bankList = [],
        } = {},
      },
      cityCodeList: {
        result: {
          data: cityList = [],
        } = {},
      },
    } = this.props;
    const { confirmDirty, tmpBankData, isPublic } = this.state;
    let loading = false;
    if (addBankInfo.result) {
      loading = addBankInfo.loading;
    }
    let initData = this.props.initData;
    let formData = tmpBankData || initData || { isPublic };
    // 为了使上一条语句走向最后，初始化在这里
    initData = initData || {};
    initData.bankIndex = this.getBankIndex(initData.bankCode || 0);
    initData.cityIndex = getCityIndex(cityList, initData.cityCode, initData.cityName);
    const transformedCityList = cityList ? transformCity(cityList) : [];
    let title = '';
    if (editType === EDIT) {
      title = confirmDirty ? '确认编辑信息' : '编辑代理商/商户提现信息';
    } else {
      title = '添加银行卡';
    }
    let confirmText = editType === EDIT ? '请再次确认账户状态与银行账户信息' : '为保障资金安全，请您再次确认银行账户信息';
    const addModalOpts = {
      title,
      visible: addBankShow,
      loading,
      centered: true,
      maskClosable: false,
      closable: false,
      destroyOnClose: true,
      onCancel: this.handleAddCancel,
      onOk: this.handleAddOk,
    };

    const bankColSpan = {
      xs: 24,
      sm: 24,
      xl: 24,
    };
    const bankItemCol = {
      labelCol: { span: 11 },
      wrapperCol: { span: 13 },
    };
    const typeLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 18 },
    };

    const getBankColumns = () => {
      let columns = [];
      if (isPublic === 0) {
        columns = [
          { key: 'isPublic', label: '账户类型', render: () => '对私银行账户' },
          { key: 'accountName', label: '开卡人姓名' },
          { key: 'bankId', label: '银行卡号', render: text => formatBankCode(text) },
          { key: 'bankIndex', label: '开户银行', render: text => bankList[Number(text)].node.bank_name },
        ];
      } else if (isPublic === 1) {
        columns = [
          { key: 'isPublic', label: '账户类型', render: () => '对公银行账户' },
          { key: 'accountName', label: '账户名称' },
          { key: 'bankId', label: '银行对公账号', render: text => formatBankCode(text) },
          { key: 'bankIndex', label: '开户银行', render: text => bankList[Number(text)].node.bank_name },
          { key: 'bankBranch', label: '支行名称' },
          { key: 'cityCode', label: '开户行所在地', render: text => this.codeToCity(text) },
        ];
      } else if (isPublic === 2) {
        columns = [
          { key: 'isPublic', label: '账户类型', render: () => '微信零钱' },
        ];
      }
      editType === EDIT && columns.unshift({
        key: 'accountState', label: '账户提现状态', render: text => accountState[text],
      });
      return columns;
    };
    const codeRule = [{ pattern: /^[0-9]+$/, message: '请输入正确的银行卡号' }];
    const antIcon = <Icon type="loading" style={{ fontSize: 16 }} spin />;
    const checkText = <span style={{ position: 'absolute', right: 5, top: 8, lineHeight: 1.5, height: 32 }}><Spin indicator={antIcon} /> 校验中</span>;
    const editTitle = <h4 style={{ fontWeight: 600 }}>编辑银行卡信息</h4>;
    const isEditWechat = editType === EDIT && isPublic === 2;
    return (
      <div>
        <Modal {...addModalOpts}>
          {/* <AddBankForm addBankInfo={addBankData} confirmDirty={confirmDirty} wrappedComponentRef={inst => { this.addBankForm = inst; }} /> */}

          <Form layout="horizontal" autoComplete="off">
            {!confirmDirty && <div>
              <Row>
                {editType === EDIT && <FormItem label="账户提现状态" {...typeLayout}>
                  {form.getFieldDecorator('accountState', {
                    initialValue: formData.accountState,
                  })(
                    <RadioGroup>
                      <Radio value={0}>正常</Radio>
                      <Radio value={1}>冻结</Radio>
                    </RadioGroup>
                  )}
                </FormItem>}
                {editType === EDIT && !isEditWechat && <Col><FormItem extra={editTitle} /></Col>}
                {!isEditWechat && <FormItem label="账户类型" {...typeLayout}>
                  <RadioGroup name="isPublic" defaultValue={formData.isPublic} onChange={this.changeAccountType}>
                    <Radio value={0}>对私银行账户</Radio>
                    <Radio value={1}>对公银行账户</Radio>
                  </RadioGroup>
                </FormItem>}
                {isPublic === 0 && <Col style={{ position: 'relative' }}>
                  <FormInput form={form} label="银行卡卡号" rules={codeRule} name="bankId" onBlur={this.queryBank} defaultValue={formData.bankId} />
                  {this.state.isChecking && checkText}
                </Col>}
                {isPublic === 0 && <Col>
                  <FormInput form={form} label="开卡人姓名" name="accountName" defaultValue={formData.accountName} />
                </Col>}
                {isPublic === 0 && <Col>
                  {/* filterOption="true" showSearch="false" optionFilterProp="node" */}
                  <FormInput form={form} label="开户银行" type="select" options={mapBankList(bankList)} name="bankIndex" defaultValue={formData.bankIndex} />
                </Col>}
                {/* 对公账户 */}
                {isPublic === 1 && <Col style={{ position: 'relative' }}>
                  <FormInput form={form} label="银行对公账号" rules={codeRule} name="bankId" onBlur={this.queryBank} defaultValue={formData.bankId} />
                  {this.state.isChecking && checkText}
                </Col>}
                {isPublic === 1 && <Col>
                  <FormInput form={form} label="账户名称" name="accountName" defaultValue={formData.accountName} />
                </Col>}
                {isPublic === 1 && <Col>
                  {/* filterOption="true" showSearch="false" optionFilterProp="node" */}
                  <FormInput form={form} label="开户银行" type="select" options={mapBankList(bankList)} name="bankIndex" defaultValue={formData.bankIndex} />
                </Col>}
                {isPublic === 1 && <Col>
                  <FormInput form={form} label="支行名称" name="bankBranch" defaultValue={formData.bankBranch} />
                </Col>}
                {isPublic === 1 && <Col>
                  <FormInput type="cascader"
                    form={form}
                    label="开户行所在地"
                    name="cityCode"
                    options={transformedCityList}
                    defaultValue={formData.cityIndex || []}
                  />
                </Col>}
              </Row>
            </div>
            }
            {confirmDirty && <Row>
              <div style={{ textAlign: 'center', marginBottom: 20 }}>{confirmText}</div>
              <DetailList
                colSpan={bankColSpan}
                itemCol={bankItemCol}
                columns={getBankColumns()}
                dataSource={tmpBankData}
              />
            </Row>
            }
          </Form>
        </Modal>
      </div>
    );
  }
}

AddBankModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  addBankShow: PropTypes.bool.isRequired,
  addBankInfo: PropTypes.object.isRequired,
  editType: PropTypes.string,
  form: PropTypes.object.isRequired,
  bankCodeList: PropTypes.object.isRequired,
  cityCodeList: PropTypes.object.isRequired,
  initData: PropTypes.object,
};

AddBankModal.defaultProps = {
  editType: undefined,
  initData: null,
};

const Container = Form.create()(connect(({ account: { addBankShow, addBankInfo, editType, bankCodeList, cityCodeList, initData } }) => ({
  addBankShow,
  addBankInfo,
  editType,
  bankCodeList,
  cityCodeList,
  initData,
}))(AddBankModal));

export { Container as AddBankModal };
