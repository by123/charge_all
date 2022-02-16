import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Form, Input, Radio, message, Row, Col } from 'antd';
import { ADD, EDIT, DETAIL } from '@/utils/constants';
import { SaveBtn } from '@/components/SaveBtn';
import { DatePicker } from '@/components/pop';
import { TextImageInput } from '@/components/TextImageInput';
import { mapObjectToRadios, formatDateToMoment } from '@/utils';
import { agentTypes } from '@/utils/enum';
import { push } from '@/store/router-helper';
import moment from 'moment';
import { action } from './store';

const FormItem = Form.Item;
const { TextArea } = Input;

const styles = {
  tip: {
    lineHeight: '39px',
    color: '#999',
    fontSize: '12px',
  },
};

class NoticeEditPage extends React.Component {
  constructor(props) {
    super(props);
    const { editType, id } = props.match.params;
    this.state = {
      editType,
      id,
      content: [],
      noticeTime: '',
    };
  }

  componentDidMount() {
    const { editType, id } = this.state;
    if (editType !== ADD && id) {
      this.props.dispatch(action.queryNoticeDetail({ id }, (_, getState) => {
        const { queryNoticeDetailResult: { result } } = getState().operationCenter;
        this.setState({
          content: JSON.parse(result.content || '[]'),
          noticeTime: '2',
        });
      }));
    }
  }

  closeCityPicker = () => {
    this.cityPicker.closePicker();
  }

  validateContent = (content) => {
    let msg = '';
    content = this.filterContent(content);
    if (!content || !content.length) {
      msg = '请编辑通知内容';
    }
    msg && message.error(msg);
    return !msg;
  }

  filterContent = (content) => {
    if (!content || !Array.isArray(content)) return [];
    return content.filter(item => {
      return !!item.content;
    });
  }

  onSubmit = () => {
    const { dispatch } = this.props;
    const { editType, id, content } = this.state;
    this.props.form.validateFieldsAndScroll((err, values) => {
      if (!err) {
        if (!this.validateContent(content)) return;
        let formatedContent = this.filterContent(content);
        values.content = JSON.stringify(formatedContent);
        values.publishTime = (values.timeType === '1' ? moment() : values.publishTime).format('YYYY-MM-DD HH:mm:ss');
        delete values.timeType;

        if (editType === ADD) {
          dispatch(action.addNotice(values, () => {
            message.success('新增消息成功');
            this.handleBack();
          }));
        } else {

          dispatch(action.modNotice({ ...values, adId: id }, () => {
            message.success('编辑消息成功');
            setTimeout(() => {
              window.history.back();
            }, 300);
          }));
        }
      }
    });
  }

  onChooseFile = () => {
    const fileList = this.uploadFile.getFileList();
    this.setState({
      fileList,
      fileChanged: !!fileList.length,
    });
  }

  handleBack = () => this.props.dispatch(push('/operationCenter/notice'));

  generateLabelText = () => {
    const { editType } = this.state;
    let title = '新建消息';
    let editText = '确认发布';
    if (editType === EDIT) {
      title = '编辑消息';
      editText = '保存';
    } else if (editType === DETAIL) {
      title = '消息详情';
      editText = '编辑';
    }

    return {
      title,
      editText,
    };
  }

  changeNoticeTime = (e) => {
    this.setState({
      noticeTime: e.target.value,
    });
  }

  getNoticeUserObj = () => {
    let result = [{
      label: '全部',
      value: '-1',
    }];
    for (let agent in agentTypes) {
      if (Object.prototype.hasOwnProperty.call(agentTypes, agent)) {
        if (agent === '2') break;
        result.push({
          label: agentTypes[agent],
          value: agent,
        });
      }
    }
    return result;
  }

  onChangeContent = (content) => {
    this.setState({
      content,
    });
  }

  goEdit = () => {
    const { id } = this.state;
    this.props.dispatch(push(`/operationCenter/notice/edit/${id}`));
  }

  handleEdit = () => {
    const { content, id } = this.state;
    if (!this.validateContent(content)) return;
    let formatedContent = JSON.stringify(this.filterContent(content));
    this.props.dispatch(action.modNotice({
      content: formatedContent,
      id,
    }, () => {
      message.success('通知编辑成功');
      this.handleBack();
    }));
  }

  onOk = () => {
    const { editType } = this.state;
    switch (editType) {
      case ADD:
        this.onSubmit();
        break;
      case EDIT:
        this.handleEdit();
        break;
      case DETAIL:
        this.goEdit();
        break;
      default:
        break;
    }
  }

  disabledDate = (current) => {
    let dayBefore = new Date().getTime();
    return current < moment(dayBefore);
  }

  render() {
    const {
      editNoticeResult: {
        loading,
      },
      queryNoticeDetailResult,
    } = this.props;
    const { editType } = this.state;
    const noticeDetail = editType !== ADD ? queryNoticeDetailResult.result || {} : {};
    const { getFieldDecorator } = this.props.form;
    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 16 },
    };

    const labelText = this.generateLabelText();
    const saveProps = {
      onOk: this.onOk,
      onCancel: this.handleBack,
      okText: labelText.editText,
      cancelText: '返回',
      confirmLoading: loading,
    };

    const noticeTimeObj = {
      1: '提交后立即推送',
      2: '定时推送',
    };

    const noticeUserObj = this.getNoticeUserObj();
    const disabled = editType !== ADD;
    let intialMchType;

    if (editType !== ADD) {
      noticeDetail.publishTime = formatDateToMoment(noticeDetail.publishTime);
      intialMchType = (noticeDetail && noticeDetail.mchType !== undefined) ? String(noticeDetail.mchType) : undefined;
    }

    return (
      <div style={{ minWidth: 1200 }}>
        <div className="content-header">
          <h2>{labelText.title}</h2>
        </div>
        <Form>
          <Row>
            <Col span={14}>
              <FormItem label="消息标题" {...formItemLayout}>
                {getFieldDecorator('title', {
                  initialValue: noticeDetail.title,
                  rules: [
                    {
                      required: true,
                      message: '请填写消息标题',
                    },
                  ],
                })(<Input disabled={disabled} maxLength={20} placeholder="请填写消息标题" autoComplete="false" />)}
              </FormItem>
            </Col>
            <Col span={8}><span style={styles.tip}>20个字以内</span></Col>
          </Row>
          <Row>
            <Col span={14}>
              <FormItem label="消息简介" {...formItemLayout}>
                {getFieldDecorator('brief', {
                  initialValue: noticeDetail.brief,
                  rules: [
                    {
                      required: true,
                      message: '请填写消息简介',
                    },
                  ],
                })(<TextArea
                  disabled={disabled}
                  maxLength={60}
                  placeholder="请填写消息简介"
                  autosize={{ minRows: 2, maxRows: 6 }}
                />)}
              </FormItem>
            </Col>
            <Col span={8}><span style={styles.tip}>60个字以内</span></Col>
          </Row>
          <Row>
            <Col span={14}>
              <FormItem label="详细内容" required {...formItemLayout}>
                <TextImageInput
                  disabled={disabled && editType === DETAIL}
                  list={this.state.content}
                  onChange={this.onChangeContent}
                />
              </FormItem>
            </Col>
            <Col span={8}><span style={styles.tip}>图片大小500KB以内，宽度345px或690px；PNG/JPG/JPEG格式</span></Col>
          </Row>
          <Row>
            <Col span={14}>
              <FormItem label="推送对象" required {...formItemLayout}>
                {getFieldDecorator('mchType', {
                  initialValue: intialMchType,
                  rules: [
                    {
                      required: true,
                      message: '请选择推送对象',
                    },
                  ],
                })(<Radio.Group disabled={disabled}>
                  {noticeUserObj.map(group => {
                    return <Radio value={group.value} key={group.value}>{group.label}</Radio>;
                  })}
                </Radio.Group>)}
              </FormItem>
            </Col>
            <Col span={8}><span style={styles.tip}>代理商推送到炭电App，商户推送到商户小程序</span></Col>
          </Row>
          <Row>
            <Col span={14}>
              <FormItem label="推送时间" required {...formItemLayout}>
                {getFieldDecorator('timeType', {
                  initialValue: this.state.noticeTime,
                  rules: [
                    {
                      required: true,
                      message: '请选择推送时间',
                    },
                  ],
                })(<Radio.Group disabled={disabled} onChange={this.changeNoticeTime}>
                  {mapObjectToRadios(noticeTimeObj).map(group => {
                    return <Radio value={group.value} key={group.value}>{group.label}</Radio>;
                  })}
                </Radio.Group>)}
              </FormItem>
            </Col>
          </Row>

          {this.state.noticeTime === '2' && <Row>
            <Col span={14}>
              <FormItem label="请选择推送时间" {...formItemLayout}>
                {getFieldDecorator('publishTime', {
                  initialValue: noticeDetail.publishTime,
                  rules: [
                    {
                      required: true,
                      message: '请选择推送时间',
                    },
                  ],
                })(<DatePicker
                  disabled={disabled}
                  showTime
                  format="YYYY-MM-DD HH:mm:ss"
                  onChange={this.onDateChange}
                  disabledDate={this.disabledDate}
                />)}
              </FormItem>
            </Col>
          </Row>}

        </Form>

        <SaveBtn {...saveProps} />
      </div>);
  }
}

NoticeEditPage.propTypes = {
  visible: PropTypes.bool.isRequired,
  dispatch: PropTypes.func.isRequired,
  form: PropTypes.object.isRequired,
  editNoticeResult: PropTypes.object.isRequired,
  queryNoticeDetailResult: PropTypes.object,
  getPositionListResult: PropTypes.object.isRequired,
};

NoticeEditPage.defaultProps = {
  queryNoticeDetailResult: {},
};

const mapStateToProps = ({ operationCenter: {
  editAdModalVisible,
  editNoticeResult,
  getPositionListResult,
  queryNoticeDetailResult,
} }) => ({
  visible: editAdModalVisible,
  editNoticeResult,
  queryNoticeDetailResult,
  getPositionListResult,
});

const NoticeEditPage1 = (props) => <NoticeEditPage {...props} key={props.location.pathname} />;
const EditAdConfigModalForm = Form.create()(connect(mapStateToProps)(NoticeEditPage1));

export default EditAdConfigModalForm;
