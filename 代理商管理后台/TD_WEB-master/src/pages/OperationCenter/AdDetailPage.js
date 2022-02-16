
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import classNames from 'classnames';
import { Spin, Icon, Divider, Row, Col, Form, message, Radio, Select, Input, Tag } from 'antd';
import { SaveBtn } from '@/components/SaveBtn';
import { replace, push } from '@/store/router-helper';
import { PageList } from '@/containers/PageList';
import { DetailList } from '@/components/DetailList';
import { PreviewAdContent } from '@/components/PreviewAdContent';
import { EDIT, AD_TYPE_TOP_BANNER, AD_TYPE_BOTTOM_BANNER, AD_TYPE_PAGE_BG } from '@/utils/constants';
import { goBack } from 'connected-react-router';
import {
  genderObj,
  adStateList,
  AdPlaceList,
  adChannelList,
  adExamineFailReason,
  adExamineStateList,
  AdMatchTypeObj,
} from '@/utils/enum';
import {
  renderAdLocation,
  datetimeFormat,
  dateFormat,
  addDateZero,
  addEndTime,
  checkIsSuperAdmin,
  mapObjectToOptions,
} from '@/utils';
import { action } from './store';
import './style.less';

const FormItem = Form.Item;
const TextArea = Input.TextArea;
const formItemLayout = {
  labelCol: {
    span: 6,
  },
  wrapperCol: {
    span: 14,
  },
};

class AdDetailPage extends Component {
  constructor(props) {
    super(props);
    const { id } = props.match.params;
    this.state = {
      id,
      previewVisible: false,
    };
  }

  fetchList = () => {
    const { startDay, endDay, id } = this.state;
    const { location: { query } } = this.props;
    this.props.dispatch(action.getAdStatistic({ ...query, startDay, endDay, adID: id }));
  }

  fetchDetail = (nextAction) => {
    this.props.dispatch(action.fetchAdDetail(this.state.id, nextAction));
  }

  componentDidMount = () => {
    this.props.dispatch(action.getPostionList());
    this.fetchDetail((_, getState) => {
      const { operationCenter: { fetchAdDetailResult: { result } } } = getState();
      this.pathAddTime(result);
      if (result.adState > 3) {
        this.fetchList();
      }
    });
  }

  pathAddTime = (adDetail) => {
    let { startTime, endTime } = adDetail || {};
    startTime = addDateZero(dateFormat(startTime), true);
    endTime = addEndTime(dateFormat(endTime), true);
    this.setState({
      startDay: startTime,
      endDay: endTime,
    });
  }

  handleBack = () => {
    this.props.dispatch(replace('/operationCenter/adManage'));
  }

  getAdBg = (adDetail) => {
    const { lstShowPage } = adDetail || {};
    let result = {};
    if (!lstShowPage || !lstShowPage.length) return '';
    AdPlaceList.forEach(item => {
      if (item.value === lstShowPage[0].showPage) {
        result = item;
        return false;
      }
    });
    return result;
  }

  // 预览
  togglePreview = (visible) => {
    this.setState({
      previewVisible: visible,
    });
  }

  renderMchList = (mchList) => {
    if (!mchList) return '';
    const eleList = mchList.map(item => (<Tag key={item.mchId}>
      {item.mchName} {item.mchId}
    </Tag>));
    return (<div>
      <div>按代理商投放</div>
      <div>{eleList}</div>
    </div>);
  }

  numberToString = (value) => {
    return typeof value === 'number' ? String(value) : value;
  }

  renderAdShowTarget = (matchType, adDetail) => {
    matchType = this.numberToString(matchType);
    if (matchType === AdMatchTypeObj.biz) {
      return this.renderMchList(adDetail.lstMchConfig);
    } else if (matchType === AdMatchTypeObj.loc) {
      return this.renderLocList(adDetail.lstLocation);
    }
  }

  renderLocList = (lstLocation) => {
    return (<div>
      <div>按地理位置投放</div>
      <div>{renderAdLocation(lstLocation)}</div>
    </div>);
  }

  // 草稿
  getStateProps0 = () => {
    const { id } = this.state;
    const { dispatch, editAdConfigResult = {} } = this.props;
    const onCancel = () => {
      this.goEdit(id);
    };
    const onOk = () => {
      dispatch(action.modADConfig({ adId: id, adState: 1 }, () => {
        dispatch(action.fetchAdDetail(id));
      }));
    };
    return {
      onOk,
      onCancel,
      okText: '提交审核',
      cancelText: '编辑',
      confirmLoading: editAdConfigResult.loading,
    };
  }

  goEdit = (id) => {
    this.props.dispatch(push(`/operationCenter/adManage/${EDIT}/${id}`));
  }

  onBack = () => {
    this.props.dispatch(goBack());
  }

  // 等待审核
  getStateProps1 = () => {
    const { dispatch, profile, form: { validateFields } } = this.props;
    const { id } = this.state;
    const onCancel = this.onBack;
    const onOk = () => {
      validateFields((err, values) => {
        if (err) return;
        dispatch(action.examineAdConfig({
          adID: id,
          ...values,
        }, () => {
          message.success('广告审核成功');
          dispatch(goBack());
          dispatch(action.refreshAdList());
        }));
      });
    };
    let props = {
      onOk: onCancel,
      okText: '返回',
      cancelText: null,
      confirmLoading: false,
    };
    if (checkIsSuperAdmin(profile)) {
      props = {
        ...props,
        cancelText: '取消',
        okText: '确定',
        onCancel,
        onOk,
      };
    }
    return props;
  }

  // 审核失败
  getStateProps2 = () => {
    const { id } = this.state;
    const onOk = () => {
      this.goEdit(id);
    };
    return {
      cancelText: '返回',
      okText: '编辑',
      onOk,
      onCancel: this.onBack,
    };
  }

  // 等待投放
  getStateProps3 = () => {
    const onCancel = this.endAdShow;
    return {
      cancelText: '提前下架',
      onCancel,
      okText: '返回',
      onOk: this.onBack,
    };
  }

  // 投放中
  getStateProps4 = () => {
    const onCancel = this.endAdShow;
    return {
      cancelText: '提前下架',
      onCancel,
      okText: '返回',
      onOk: this.onBack,
    };
  }

  // 已下架
  getStateProps5 = () => {
    return {
      cancelText: null,
      okText: '返回',
      onOk: this.onBack,
    };
  }

  // 生成底部按钮
  getSaveProps = () => {
    const { fetchAdDetailResult: { result: adDetail = {} } = {} } = this.props;
    const { adState } = adDetail;
    return adState !== undefined ? this[`getStateProps${adState}`]() : null;
  }

  // 提起下架广告
  endAdShow = () => {
    const { id } = this.state;
    const { dispatch } = this.props;
    dispatch(action.modADConfig({
      adState: 5,
      adId: id,
    }, () => {
      message.success('提前下架广告成功');
      dispatch(action.fetchAdDetail(id));
      this.fetchList();
    }));
  }

  renderShowAdBtn = (text) => {
    let btn = '';
    text = JSON.parse(text || '[]');
    if (!text || !text.length) {
      btn = '未配置广告详情';
    } else {
      btn = <a onClick={() => this.togglePreview(true)}>点击查看</a>;
    }
    return btn;
  }

  render() {
    //filter
    const {
      getAdStatisticResult: {
        loading = false,
        current = 1,
        total = 0,
        pageSize = 15,
        dataSource,
      } = {},
      fetchAdDetailResult: {
        result: adDetail = {},
        loading: detailLoading,
      },
      form: {
        getFieldDecorator,
        getFieldValue,
      },
      profile,
    } = this.props;
    const adState = adDetail.adState;
    const columns = [
      { dataIndex: 'statsDate', title: '日期', render: text => dateFormat(text) },
      { dataIndex: 'showCount', title: '曝光量' },
      { dataIndex: 'clickCount', title: '点击量' },
      { dataIndex: 'userCount', title: '点击人数' },
      { dataIndex: 'clickRatio', title: '点击率' },
    ];

    const listProps = {
      loading,
      rowKey: 'statsDate',
      pagination: {
        current,
        total,
        pageSize,
      },
      columns,
      dataSource,
    };

    const detailSettingColumns = [
      { key: 'lstShowPage', label: '投放渠道', render: text => (text ? adChannelList[text[0].showChannel] : '') },
      { key: 'matchType', label: '投放区域', render: (text, record) => this.renderAdShowTarget(text, record) },
      { key: 'gender', label: '客人性别', render: text => genderObj[text] },
      {
        key: 'startTime',
        label: '投放时间',
        render: (text, record) => `${datetimeFormat(text)} - ${datetimeFormat(record.endTime)}`,
      },
    ];

    let detailContentColumns = [
      { key: 'adName', label: '广告标题' },
      { key: 'adImg', label: '广告图片', render: () => '如左图所示' },
      { key: 'adJumpcontent', label: '广告落地页', render: text => this.renderShowAdBtn(text) },
    ];

    if (checkIsSuperAdmin(profile)) {
      detailContentColumns.push(
        { key: 'mchName', label: '广告主', render: (text, record) => `${text} ${record.mchId}` }
      );
    }

    const detailContactColumns = [
      { key: 'contactsName', label: '姓名' },
      { key: 'mobile', label: '手机号' },
    ];

    const statsColumns = [
      { key: 'totalShowCount', label: '总曝光量' },
      { key: 'totalClickCount', label: '总点击量' },
      { key: 'totalUserclickCount', label: '总点击人数' },
      { key: 'clickRatio', label: '总点击率' },
    ];

    const listColProps = {
      xs: 24,
      sm: 24,
      md: 24,
      lg: 24,
      xl: 24,
    };

    const itemCols = {
      labelCol: {
        xs: { span: 6 },
        sm: { span: 6 },
        xl: { span: 6 },
      },
    };

    const saveProps = this.getSaveProps();
    const bgItem = this.getAdBg(adDetail);
    const adPicClass = classNames(
      'banner-img-wrap',
      {
        'ad-pos-top': bgItem.type === AD_TYPE_TOP_BANNER,
        'ad-pos-bom': bgItem.type === AD_TYPE_BOTTOM_BANNER,
        'ad-pos-page-bg': bgItem.type === AD_TYPE_PAGE_BG,
      },
    );

    const content = JSON.parse(adDetail.adJumpcontent || '[]');

    return (
      <div className="page-ad-detail-container">
        {/* <div className="content-header">
          <h2>广告详情</h2>
        </div> */}
        <div style={{ marginBottom: 20, fontSize: 16 }}>
          <Icon type="left" style={{ fontSize: '16px' }} />
          <a onClick={this.handleBack} style={{ marginLeft: 5 }}>广告列表</a>
          <span> / </span>
          <span>{adDetail.adId}</span>
        </div>
        <Divider />
        <Spin spinning={!!detailLoading}>
          <div className="ad-state">
            <p>广告状态：{adStateList[adDetail.adState]}</p>
            {adState === 2 && <p>失败原因：{adExamineFailReason[adDetail.reasonType]}</p>}
            {adState === 2 && <p>补充说明：{adDetail.reason}</p>}
          </div>
          <Divider />
          <Row>
            <Col span={10} offset={2}>
              <div className="banner-wrap">
                <img className="banner-bg" alt="广告背景图" src={bgItem ? bgItem.src() : ''} />
                <div className={adPicClass}>
                  <img className="banner-img" alt="广告图片" src={adDetail.adPicUrl} />
                </div>
              </div>
            </Col>
            <Col span={10} offset={2}>
              <div className="ad-detail-list-section">
                <div className="section-title">广告投放设置：</div>
                <DetailList
                  columns={detailSettingColumns}
                  dataSource={adDetail}
                  colSpan={listColProps}
                  itemCol={itemCols}
                />
              </div>

              <div className="ad-detail-list-section">
                <div className="section-title">广告内容：</div>
                <DetailList
                  columns={detailContentColumns}
                  dataSource={adDetail}
                  colSpan={listColProps}
                  itemCol={itemCols}
                />
              </div>

              <div className="ad-detail-list-section">
                <div className="section-title">业务联系人：</div>
                <DetailList
                  columns={detailContactColumns}
                  dataSource={adDetail}
                  colSpan={listColProps}
                  itemCol={itemCols}
                />
              </div>
            </Col>
          </Row>
        </Spin>
        <Divider />

        {/* 广告效果统计 */}
        {adState > 3 && <div className="content-wrapper">
          <h3>广告效果统计</h3>
          <DetailList
            columns={statsColumns}
            dataSource={adDetail}
          />
          <PageList {...listProps} />
        </div>}

        {adState === 1 && checkIsSuperAdmin(profile) && <div>
          <Form>
            <FormItem label="审核结果" required {...formItemLayout}>
              {getFieldDecorator('bResult', {
                rules: [
                  {
                    required: true,
                    message: '请选择审核结果',
                  },
                ],
              })(<Radio.Group>
                {adExamineStateList.map(group => {
                  return <Radio value={group.value} key={group.value}>{group.label}</Radio>;
                })}
              </Radio.Group>)}
            </FormItem>
            {getFieldValue('bResult') === false && <FormItem label="审核失败原因" required {...formItemLayout}>
              {getFieldDecorator('reasonType', {
                rules: [
                  {
                    required: true,
                    message: '请选择失败原因',
                  },
                ],
              })(<Select>
                {mapObjectToOptions(adExamineFailReason)}
              </Select>)}
            </FormItem>}
            {getFieldValue('bResult') === false && <FormItem label="补充说明" {...formItemLayout}>
              {getFieldDecorator('reason')(<TextArea />)}
            </FormItem>}
          </Form>
        </div>}

        {saveProps && <SaveBtn {...saveProps} />}
        <PreviewAdContent
          visible={this.state.previewVisible}
          content={content}
          onClose={() => this.togglePreview(false)}
        />
      </div>
    );
  }
}

AdDetailPage.propTypes = {
  dispatch: PropTypes.func.isRequired,
  getAdStatisticResult: PropTypes.object.isRequired,
  fetchAdDetailResult: PropTypes.object.isRequired,
  getPositionListResult: PropTypes.object.isRequired,
};

AdDetailPage.defaultProps = {

};

const mapStateToProps = ({
  operationCenter: {
    getAdStatisticResult,
    fetchAdDetailResult,
    getPositionListResult,
  },
  global: {
    profile,
  },
}) => ({
  getAdStatisticResult,
  getPositionListResult,
  fetchAdDetailResult,
  profile,
});

const AdDetailPageForm = Form.create()(connect(mapStateToProps)(AdDetailPage));

export default AdDetailPageForm;
