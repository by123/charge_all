import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Button, Icon, Form, Input, message, Modal } from 'antd';
import copy from 'copy-to-clipboard';
import { PageFilter } from '../../containers/PageFilter';
import { PageList } from '../../containers/PageList';
import { action as personnelActions } from './store';
import { AgentDeleteModal } from '../../containers/AgentDeleteModal';
import { OperationLink } from '../../components/OperationLink';
import { datetimeFormat } from '../../utils';
import { pattern, SUCCESS, ADD, ACTION_WIDTH, EDIT } from '../../utils/constants';

import './style.less';

const FormItem = Form.Item;

class PersonnelPage extends React.Component {
  state = {
    disabled: true,
    deleteModalVisible: false,
  }

  fetchList = () => {
    const { dispatch, location: { search } } = this.props;
    dispatch(personnelActions.fetchPersonnelList(search));
  }

  componentDidMount() {
    this.fetchList();
  }

  componentDidUpdate({ location }) {
    if (!Object.is(this.props.location, location)) {
      this.fetchList();
    }
  }

  handleCancel = () => {
    this.toggleAddModal(false);
    this.props.form.resetFields();
  }

  toggleAddModal = (visible, editType) => {
    this.props.dispatch(personnelActions.toggleAddModal(visible, editType));
  }

  onSubmit = () => {
    const { dispatch, editType, selectedRowData } = this.props;
    this.props.form.validateFieldsAndScroll((err, values) => {
      if (!err) {
        if (editType === ADD) {
          dispatch(personnelActions.addPersonnel(values));
        } else {
          const params = {
            ...values,
            userId: selectedRowData.userId,
          };
          dispatch(personnelActions.editPersonnel(params));
        }
      }
    });
  }

  handleAddSuccessClose = () => {
    const { dispatch } = this.props;
    this.props.form.resetFields();
    dispatch(personnelActions.closeSuccessModal());
  }

  copyAccount = () => {
    const { accountInfo: { result: { userId, password } } } = this.props;
    let text = `登陆账号：${userId}，初始密码：${password}`;
    if (copy(text)) {
      this.setState({
        disabled: false,
      });
      message.success('复制成功！');
    }
  }

  saveSelectedRowData = (data) => {
    this.props.dispatch(personnelActions.saveSelectedRowData(data));
  }

  toggleDeleteModal = (visible) => {
    this.props.dispatch(personnelActions.toggleDeleteModal(visible));
  }

  handleDelete = () => {
    const { selectedRowData, dispatch } = this.props;
    dispatch(personnelActions.deletePersonnel({ userId: selectedRowData.userId }, () => {
      this.fetchList();
      message.success('业务员删除成功');
      this.toggleDeleteModal(false);
    }));
  }

  render() {
    const {
      location: { search },
      personnelData: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource = [],
      },
      addModalShow = false,
      editType,
      accountInfo: {
        result,
        loading: addLoading,
        status,
      },
      addModalSuccessShow,
      selectedRowData,
      deleteResult,
    } = this.props;
    const { disabled } = this.state;
    const accountInfo = result || {};
    const filterProps = {
      search,
      columns: [
        { dataIndex: 'userId', title: '业务员账号' },
        { dataIndex: 'name', title: '业务员姓名' },
        { dataIndex: 'mobile', title: '业务员手机号' },
      ],
    };
    const listProps = {
      loading,
      rowKey: 'userId',
      pagination: {
        current,
        total,
        pageSize,
      },
      columns: [
        { dataIndex: 'userId', title: '业务员账号' },
        { dataIndex: 'name', title: '业务员姓名' },
        { dataIndex: 'mobile', title: '业务员手机号' },
        { dataIndex: 'deviceCount', title: '设备总数' },
        { dataIndex: 'activeCount', title: '激活设备数' },
        { dataIndex: 'agencyCount', title: '拓展代理商总数' },
        { dataIndex: 'merchantCount', title: '拓展商户总数' },
        { dataIndex: 'createTime', title: '账号创建时间', render: text => datetimeFormat(text) },
        {
          dataIndex: 'x',
          title: '操作',
          fixed: 'right',
          width: ACTION_WIDTH,
          render: (_, record) => {
            const options = [
              {
                text: '编辑',
                action: () => {
                  this.saveSelectedRowData(record);
                  this.toggleAddModal(true, EDIT);
                },
              },
              {
                text: '删除',
                action: () => {
                  this.saveSelectedRowData(record);
                  this.toggleDeleteModal(true);
                },
              },
            ];
            return <OperationLink options={options} />;
          },
        },
      ],
      dataSource,
    };
    const { getFieldDecorator } = this.props.form;
    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 16 },
    };
    const closable = false;
    const confirmColumns = [
      { name: '业务员姓名', value: selectedRowData.name },
      { name: '业务员手机号', value: selectedRowData.mobile },
      { name: '业务员账号', value: selectedRowData.userId },
    ];
    const deleteLoading = deleteResult.result ? deleteResult.result.loading : false;

    return (<div className="page-personnel">
      <div className="content-header">
        <h2>业务员管理</h2>
        <Button className="g-btn-black" type="primary" onClick={() => this.toggleAddModal(true, ADD)}>
          <Icon type="plus" theme="outlined" />添加业务员
        </Button>
      </div>
      <PageFilter {...filterProps} />
      <div className="list-count">共搜索到 {total} 条数据</div>
      <PageList {...listProps} />

      <Modal
        title={`${editType === ADD ? '添加业务员' : '编辑业务员资料'}`}
        visible={addModalShow}
        centered
        maskClosable={closable}
        wrapClassName="add-personnel"
        onOk={this.onSubmit}
        onCancel={this.handleCancel}
        okText={editType === ADD ? '创建' : '保存'}
        okButtonProps={{ loading: addLoading }}
      >
        <Form>
          <FormItem label="业务员姓名" {...formItemLayout}>
            {getFieldDecorator('name', {
              initialValue: selectedRowData.name,
              rules: [
                {
                  required: true,
                  message: '请填写业务员姓名',
                },
                {
                  max: 20,
                  message: '名称长度不能超过20个字符',
                },
              ],
            })(<Input placeholder="请输入姓名" />)}
          </FormItem>

          <FormItem label="业务员电话" {...formItemLayout}>
            {getFieldDecorator('mobile', {
              initialValue: selectedRowData.mobile,
              rules: [
                {
                  required: true,
                  message: '请填写业务员电话',
                },
                {
                  pattern: pattern.mobile,
                  message: '请输入正确的手机号码',
                  trigger: 'onblur',
                },
              ],
              validateTrigger: 'onBlur',
            })(<Input type="number" placeholder="请输入电话" />)}
          </FormItem>
          {editType === ADD && <div className="add-personnel-tip">手机号用于登陆系统，创建后生成初始密码</div>}
        </Form>
      </Modal>

      <Modal
        title="创建成功"
        visible={addModalSuccessShow && status === SUCCESS}
        centered
        wrapClassName="add-personnel"
        onOk={this.handleAddSuccessClose}
        onCancel={this.handleAddSuccessClose}
        okText="确定"
        maskClosable={closable}
        closable={closable}
        cancelButtonProps={{ disabled }}
        okButtonProps={{ disabled }}
      >
        {
          accountInfo &&
          <div className="add-personnel-account">
            <span>登陆账号：{accountInfo.userId}</span>
            <span>初始密码：{accountInfo.password}</span>
            <span className="add-personnel-copy" onClick={this.copyAccount}>请点击复制账号密码</span>
          </div>
        }
      </Modal>

      <AgentDeleteModal onOk={this.handleDelete} loading={deleteLoading} confirmColumns={confirmColumns} />
    </div>);
  }
}

PersonnelPage.propTypes = {
  personnelData: PropTypes.object,
  addModalShow: PropTypes.bool,
  addModalSuccessShow: PropTypes.bool,
  accountInfo: PropTypes.object,
  editType: PropTypes.string,
  selectedRowData: PropTypes.object,
  deleteResult: PropTypes.object,
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.object.isRequired,
  form: PropTypes.object.isRequired,
};

PersonnelPage.defaultProps = {
  personnelData: {},
  addModalShow: false,
  addModalSuccessShow: false,
  accountInfo: {},
  editType: ADD,
  selectedRowData: {},
  deleteResult: {},
};

const mapStateToProps = ({ personnel: {
  personnelData,
  addModalShow,
  accountInfo,
  addModalSuccessShow,
  selectedRowData,
  deleteResult,
  editType,
} }) => ({
  personnelData,
  addModalShow,
  accountInfo,
  addModalSuccessShow,
  editType,
  selectedRowData,
  deleteResult,
});
export default Form.create()(connect(mapStateToProps)(PersonnelPage));
