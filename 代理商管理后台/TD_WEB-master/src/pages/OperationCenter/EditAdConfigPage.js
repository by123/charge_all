import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Form, Input, Radio, Icon, Tag, message } from 'antd';
// import Swiper from 'swiper';
import { UploadFile } from '@/containers/DeviceSelect/UploadFile';
import CityPicker from '@/components/CityPicker';
import AgentFilter from '@/containers/AgentFilter';
import { ADD, EDIT, FILE_TYPE_IMAGE, pattern } from '@/utils/constants';
import { SaveBtn } from '@/components/SaveBtn';
import { DatePicker } from '@/components/pop';
import { TextImageInput } from '@/components/TextImageInput';
import { PreviewAdContent } from '@/components/PreviewAdContent';
import moment from 'moment';
import {
  checkIsSuperAdmin,
  mapObjectToRadios,
  momentToFormatDate,
  formatDateToMoment,
} from '@/utils';
import { genderObj, adChannelList, AdPlaceList, AdMatchTypeObj, adImgRate } from '@/utils/enum';
import { push } from '@/store/router-helper';
import 'swiper/dist/css/swiper.min.css';
import { action } from './store';
import { FormItemWrapper } from './FormItemWrapper';
import Img_active from '../../images/i_active.png';
import './style.less';

const Swiper = require('swiper/dist/js/swiper.min.js');

const { RangePicker } = DatePicker;

const SaveTypes = {
  tmp: '0',
  release: '1',
};

class EditAdConfigPage extends React.Component {
  constructor(props) {
    super(props);
    const { editType, id } = props.match.params;

    this.state = {
      editType,
      id,
      cityList: [],
      fileList: [],
      cityListVisible: false,
      fileChanged: false,
      content: [],
      adPlaceList: [],
      bizList: [],
      isAreaChanged: false,
      previewVisible: false,
    };
  }

  componentDidMount() {
    this.initialEditValue();

    setTimeout(() => {
      let adPlaceList = this.getAdShowPageList();
      this.setState({
        adPlaceList,
      });
      const width = window.innerWidth - 400;
      this.swiper = new Swiper('.swiper-container', {
        width,
        slidesPerView: width > 1100 ? 5.5 : 4.5,
        spaceBetween: 30,
        freeMode: true,
      });
    });
  }

  deepCopy = (arr) => {
    return arr.map(item => {
      return { ...item };
    });
  }

  getAdShowPageList = () => {
    const { getAdAuthListResult: { result: adAuthList }, profile = {} } = this.props;
    let adShowPageList = this.deepCopy(AdPlaceList);
    if (profile.mchType !== 2) {
      const authShowPage = adAuthList[profile.mchId] || [];
      adShowPageList = adShowPageList.filter(item => {
        return authShowPage.indexOf(item.value) > -1;
      });
    }
    return adShowPageList;
  }

  // 初始化广告位置
  initialAdPlace = (adDetail) => {
    const { lstShowPage } = adDetail || {};
    if (!lstShowPage || !lstShowPage[0]) return;
    const { adPlaceList } = this.state;
    let showPage;
    adPlaceList.forEach(item => {
      let isShow = item.value === lstShowPage[0].showPage;
      if (isShow) {
        showPage = item.value;
      }
      item.active = isShow;
    });
    this.props.form.setFieldsValue({ lstShowPage: [showPage] });
    this.setState({
      adPlaceList,
    });
  }

  initCityPickerValue = (lstLocation) => {
    if (!lstLocation) return;
    let result = [];
    lstLocation.map(loc => {
      let { addrCode, area, province, city } = loc;
      if (province === '' && area === '' && city === '') {
        province = '选择全部';
      } else if (city === '' && area === '') {
        city = '选择全部';
      } else if (area === '') {
        area = '选择全部';
      }
      result.push([addrCode, province, city, area]);
      return null;
    });
    this.cityPicker.setValue(result);
  }

  initialEditValue = () => {
    if (this.state.editType === EDIT) {
      this.props.dispatch(action.fetchAdDetail(this.state.id, (_, getState) => {
        const { fetchAdDetailResult } = getState().operationCenter;
        const adDetail = fetchAdDetailResult.result || {};

        const { lstLocation, lstMchConfig, matchType } = adDetail;
        let matchTypeStr = this.numberToString(matchType);
        this.props.form.setFieldsValue({ matchType: matchTypeStr });
        this.initialAdPlace(adDetail);
        this.setState({
          content: JSON.parse(adDetail.adJumpcontent || '[]'),
        });

        if (matchTypeStr === AdMatchTypeObj.loc) {
          this.initCityPickerValue(lstLocation);
        } else if (matchTypeStr === AdMatchTypeObj.biz) {
          this.initBizValue(lstMchConfig);
        }
      }));
    }
  }

  initBizValue = (mchList) => {
    if (!mchList) return;
    let list = mchList.map(item => {
      return {
        label: `${item.mchName} ${item.mchId}`,
        value: item.mchId,
      };
    });
    this.setState({
      bizList: list,
    });
  }

  closeCityPicker = () => {
    this.cityPicker.closePicker();
  }

  onSubmit = (saveType) => {
    const { dispatch } = this.props;
    const { fileList, editType, id, fileChanged, content } = this.state;
    this.props.form.validateFieldsAndScroll((err, values) => {
      if (!err) {
        if (!this.validateValues(values)) return;

        this.addAdShowType(values);
        let timeArr = momentToFormatDate(values.time, true, 'YYYY-MM-DD HH:mm:ss');
        values.startTime = timeArr[0];
        values.endTime = timeArr[1];
        delete values.time;

        values.adJumpcontent = JSON.stringify(this.filterContent(content));
        values.adState = saveType;
        if (editType === ADD) {
          let fileData = new FormData();
          fileData.append('file', fileList[0].originFileObj);
          dispatch(action.addAdConfig(fileData, values, () => {
            message.success('新增广告成功');
            this.handleBack();
          }));
        } else {
          if (fileChanged) {
            let fileData = new FormData();
            fileData.append('file', fileList[0].originFileObj);
            dispatch(action.modADConfigPic(id, fileData));
          }
          dispatch(action.modADConfig({ ...values, adId: id }, () => {
            message.success('编辑广告成功');
            setTimeout(() => {
              window.history.back();
            }, 300);
          }));
        }
      }
    });
  }

  validateValues = (values) => {
    let msg = '';
    const { cityList, fileList, editType, bizList, fileChanged } = this.state;
    const { lstShowPage, matchType } = values;
    if (!lstShowPage) {
      msg = '请选择展示页面';
    } else if (matchType === AdMatchTypeObj.biz && !bizList.length) {
      msg = '请选择投放商户';
    } else if (matchType === AdMatchTypeObj.loc && (!cityList || !cityList.length)) {
      msg = '请选择投放区域';
    } else if (((editType === EDIT && fileChanged) || editType === ADD) && (!fileList || !fileList.length)) {
      msg = '请上传广告图片';
    }
    if (msg) {
      message.error(msg);
    }
    return !msg;
  }

  // 根据广告投放类型格式化对应的值
  addAdShowType = (values) => {
    const { matchType } = values;
    const { bizList, cityList } = this.state;
    if (matchType === AdMatchTypeObj.biz) {
      values.lstMchId = bizList.map(item => {
        let mchId = item.value;
        if (mchId.indexOf('$') > -1) {
          mchId = mchId.substr(1);
        }
        return mchId;
      });
    } else if (matchType === AdMatchTypeObj.loc) {
      values.lstLocation = this.formatCityList(cityList);
    }
  }

  filterContent = (content) => {
    if (!content || !Array.isArray(content)) return [];
    return content.filter(item => {
      return !!item.content;
    });
  }

  formatCityList = (cityList) => {
    return cityList.map(cityItem => {
      let [cityCode, province, city, area] = cityItem;
      province = province === '选择全部' || !province ? '' : province;
      city = city === '选择全部' || !city ? '' : city;
      area = area === '选择全部' || !area ? '' : area;
      return `${cityCode}|${province}|${city}|${area}`;
    });
  }

  onChooseFile = () => {
    const fileList = this.uploadFile.getFileList();
    this.setState({
      fileList,
      fileChanged: !!fileList.length,
    });
  }

  handleChangeCity = (cityList) => {
    this.setState({
      cityList,
    });
  }

  toggleCityList = () => {
    this.setState({
      cityListVisible: !this.state.cityListVisible,
    });
  }

  getCityList = (matchType) => {
    let { cityList, cityListVisible, bizList } = this.state;
    let list = matchType === AdMatchTypeObj.biz ? bizList : cityList;
    let result = list.concat();
    if (!cityListVisible) {
      result = result.splice(0, 4);
    }
    return result;
  }

  handleDeleteCity = (cityItem) => {
    this.cityPicker.handleDeleteCity(cityItem);
  }

  handleDeleteBiz = (bizItem) => {
    let { bizList } = this.state;
    bizList = bizList.filter(item => {
      return item.value !== bizItem.value;
    });
    this.setState({
      bizList,
    });
  }

  handleBack = () => this.props.dispatch(push('/operationCenter/adManage'));

  getPosLabel = (posList, pos) => {
    let label = '';
    posList.forEach((element) => {
      if (element.value === pos) {
        label = String(pos);
        return false;
      }
    });
    return label;
  }

  onChangeContent = (content) => {
    this.setState({
      content,
    });
  }

  getAreaTypeList = () => {
    const { isSuperAdmin } = this.props;
    const adAreaTypeList = [
      { label: '按商户投放', value: AdMatchTypeObj.biz },
    ];
    if (isSuperAdmin) {
      adAreaTypeList.push({
        label: '按客人地理位置投放', value: AdMatchTypeObj.loc,
      });
    }
    return adAreaTypeList;
  }

  onChangeBiz = (_, record) => {
    if (!_ || !record) return;
    record = Array.isArray(record) ? record[record.length - 1] : record;
    const label = record.label || record.mchName;
    const value = record.value || record.mchId;
    let { bizList } = this.state;
    // 先去重
    bizList = bizList.filter(item => {
      return item.value !== value;
    });
    bizList.push({
      label: `${label} ${value.indexOf('$') > -1 ? value.substr(1) : value}`,
      value,
    });
    this.setState({
      bizList,
    });
  }

  getBizList = (bizList) => {
    return bizList.map(item => {
      return item.value;
    });
  }

  onChooseImg = (activeIndex) => {
    const { adPlaceList } = this.state;
    adPlaceList.forEach((item, index) => {
      item.active = activeIndex === index;
    });
    this.props.form.setFieldsValue({
      lstShowPage: [adPlaceList[activeIndex].value],
    });
    this.setState({
      adPlaceList,
      fileList: [],
      fileChanged: true,
    });
  }

  numberToString = (value) => {
    return typeof value === 'number' ? String(value) : value;
  }

  onChangeAreaType = () => {
    this.setState({
      isAreaChanged: true,
    });
  }

  // 预览
  togglePreview = (visible) => {
    this.setState({
      previewVisible: visible,
    });
  }

  disabledDate = (current) => {
    return current < moment().subtract(1, 'days');
  }

  getVisibleList = (list) => {
    const { cityListVisible } = this.state;
    let newList = [...list];
    if (!cityListVisible) {
      newList.splice(0, 6);
    }
    return newList;
  }

  getImgSize = () => {
    const { form: { getFieldValue } } = this.props;
    const { adPlaceList } = this.state;
    let showPage = getFieldValue('lstShowPage');
    showPage = showPage ? showPage[0] : showPage;
    let showPageItem = null;
    adPlaceList.forEach(item => {
      if (item.value === showPage) {
        showPageItem = item;
        return false;
      }
    });
    return showPageItem;
  }

  render() {
    const {
      editAdConfigResult: {
        loading,
      },
      form: {
        getFieldDecorator,
        getFieldValue,
      },
    } = this.props;
    const { cityListVisible, editType, fileChanged, isAreaChanged } = this.state;

    const adDetail = editType === EDIT ? this.props.fetchAdDetailResult.result || {} : {};

    let initialShowChannel = '';
    let initialShowPage = '';
    let matchType = AdMatchTypeObj.biz;
    if (editType === EDIT && adDetail) {
      adDetail.time = formatDateToMoment([adDetail.startTime, adDetail.endTime], true);
      matchType = this.numberToString(adDetail.matchType);
      if (adDetail.lstShowPage) {
        initialShowChannel = this.numberToString(adDetail.lstShowPage[0].showChannel);
        initialShowPage = adDetail.lstShowPage[0].showPage;
      }
    }
    // let bizList = this.getVisibleList(this.state.bizList);
    // const formatedList = this.getVisibleList(cityList);
    const saveProps = {
      onOk: () => this.onSubmit(SaveTypes.release),
      onCancel: () => this.onSubmit(SaveTypes.tmp),
      okText: editType === ADD ? '提交审核' : '提交审核',
      cancelText: '存为草稿',
      confirmLoading: loading,
      cancelLoading: loading,
    };

    const renderTitle = (title) => (<h3 style={{ paddingLeft: 40, marginBottom: 20 }}>{title}</h3>);

    // 获取已选择的广告位置尺寸
    const imgSize = this.getImgSize();
    let imgSizeText = '';
    let imgWidth = 0;
    let imgHeight = 0;
    if (imgSize) {
      imgWidth = imgSize.width * adImgRate;
      imgHeight = imgSize.height * adImgRate;
      imgSizeText = `${imgWidth}*${imgHeight}`;
    }
    // 初始值有时候还未设置
    if (isAreaChanged) {
      matchType = getFieldValue('matchType');
    }

    let cityList = this.getCityList(matchType);
    getFieldDecorator('lstShowPage', { initialValue: initialShowPage });

    const agentOptions = {
      dataIndex: 'newParentId',
      title: '请选择商户',
      type: 'agentFilter',
      changeOnSelect: false,
      childUseable: true,
      width: 240,
      listFilter: null,
      showAll: true,
    };

    return (
      <div className="edit-ad-config-container">
        <div className="content-header">
          <h2>{`${editType === ADD ? '新建广告' : '编辑广告'}`}</h2>
        </div>
        <Form>
          <div className="edit-ad-config-section">
            {renderTitle('第一步，选择广告位')}
            <div className="img-list-wrap swiper-container">
              <div className="img-list-content swiper-wrapper">
                {this.state.adPlaceList.map((item, index) => (<div
                  key={item.value}
                  className="img-item swiper-slide"
                  onClick={() => this.onChooseImg(index)}
                >
                  {item.active && <div className="item-mask"><img src={Img_active} alt="" /></div>}
                  <div className="item-name">{item.name}</div>
                  <img src={item.src()} alt={item.name} />
                </div>))}
              </div>
            </div>
          </div>
          <div className="edit-ad-config-section">
            {renderTitle('第二步，设置投放对象和时间')}
            <FormItemWrapper label="投放渠道">
              {getFieldDecorator('showChannel', {
                initialValue: initialShowChannel,
                rules: [
                  {
                    required: true,
                    message: '请选择投放渠道',
                  },
                ],
              })(<Radio.Group>
                {mapObjectToRadios(adChannelList).map(group => {
                  return <Radio value={group.value} key={group.value}>{group.label}</Radio>;
                })}
              </Radio.Group>)}
            </FormItemWrapper>

            <FormItemWrapper label="投放类型">
              {getFieldDecorator('matchType', {
                initialValue: this.numberToString(adDetail.matchType) || AdMatchTypeObj.biz,
                rules: [
                  {
                    required: true,
                    message: '请选择投放类型',
                  },
                ],
              })(<Radio.Group onChange={this.onChangeAreaType}>
                {this.getAreaTypeList().map(group => {
                  return <Radio value={group.value} key={group.value}>{group.label}</Radio>;
                })}
              </Radio.Group>)}
            </FormItemWrapper>

            {matchType === AdMatchTypeObj.biz && <FormItemWrapper label="请选择商户">
              <AgentFilter column={agentOptions} onChange={this.onChangeBiz} />
              <div className="city-list-wrap">
                {cityList.map(item => {
                  const { label, value } = item;
                  return (<Tag
                    closable
                    onClose={() => this.handleDeleteBiz(item)}
                    key={value}
                  >
                    {label}
                  </Tag>);
                })}
                {!!cityList.length && <div style={{ textAlign: 'right' }}>
                  <a onClick={this.toggleCityList}>{cityListVisible ? '收起更多' : '查看更多'}
                    <Icon type={cityListVisible ? 'up' : 'down'} />
                  </a>
                </div>}
              </div>
            </FormItemWrapper>}

            {matchType === AdMatchTypeObj.loc && <FormItemWrapper label="投放区域">
              <div>
                <CityPicker
                  onChange={this.handleChangeCity}
                  dataIndex="asd"
                  wrappedComponentRef={inst => { this.cityPicker = inst; }}
                />
                <div className="city-list-wrap">
                  {cityList.map(cityItem => {
                    const [cityCode, province, city, area] = cityItem;
                    return (<Tag
                      closable
                      onClose={() => this.handleDeleteCity(cityItem)}
                      key={`${cityCode}${province}${city}`}
                    >
                      {province || ''}{city ? ` / ${city}` : ''}{area ? ` / ${area}` : ''}
                    </Tag>);
                  })}
                  {!!cityList.length && <div style={{ textAlign: 'right' }}>
                    <a onClick={this.toggleCityList}>{cityListVisible ? '收起更多' : '查看更多'}
                      <Icon type={cityListVisible ? 'up' : 'down'} />
                    </a>
                  </div>}
                </div>
              </div>
            </FormItemWrapper>}

            <FormItemWrapper label="投放性别" key="form-item-4">
              {getFieldDecorator('gender', {
                initialValue: this.numberToString(adDetail.gender),
                rules: [
                  {
                    required: true,
                    message: '请选择投放性别',
                  },
                ],
              })(<Radio.Group>
                {mapObjectToRadios(genderObj).map(group => {
                  return <Radio value={group.value} key={group.value}>{group.label}</Radio>;
                })}
              </Radio.Group>)}
            </FormItemWrapper>

            <FormItemWrapper
              label="投放时间"
              extraText="请至少预留1天的审核时间；如果广告位投放排期有冲突，审核人员会提前与您沟通；"
            >
              {getFieldDecorator('time', {
                initialValue: adDetail.time,
                rules: [
                  {
                    required: true,
                    message: '请填写投放时间',
                  },
                ],
              })(<RangePicker
                showTime
                format="YYYY-MM-DD HH:mm:ss"
                onChange={this.onDateChange}
                disabledDate={this.disabledDate}
              />)}
            </FormItemWrapper>

          </div>
          <div className="edit-ad-config-section">
            {renderTitle('第三步，编辑广告内容')}

            <FormItemWrapper label="广告标题" extraText="40个字符以内，1个汉字计算为2个字符；">
              {getFieldDecorator('adName', {
                initialValue: adDetail.adName,
                rules: [
                  {
                    required: true,
                    message: '请填写广告标题',
                  },
                ],
              })(<Input maxLength={40} placeholder="请填写广告标题" autoComplete="false" />)}
            </FormItemWrapper>

            {!!getFieldValue('lstShowPage') && <FormItemWrapper label="广告图片" extraText={`支持PNG/JPEG/JPG格式，1M以内，${imgSizeText}`}>
              <UploadFile
                fileType={FILE_TYPE_IMAGE}
                listType="picture-card"
                onChooseFile={this.onChooseFile}
                wrappedComponentRef={inst => { this.uploadFile = inst; }}
                fileSize={{ width: imgWidth, height: imgHeight, size: 1 }}
                acceptType={['png', 'jepg', 'jpg']}
              />
              {editType === EDIT && !fileChanged && (<div>
                <img
                  src={adDetail.adPicUrl}
                  alt=""
                  style={{ width: '100%', height: 100, marginTop: 10 }}
                />
              </div>)}
            </FormItemWrapper>}

            <FormItemWrapper label="广告落地页" required={false}>
              <TextImageInput
                list={this.state.content}
                onChange={this.onChangeContent}
                showPreview={!!true}
                onPreview={() => this.togglePreview(true)}
              />
            </FormItemWrapper>

          </div>
          <div className="edit-ad-config-section">
            {renderTitle('第四步，设置广告投放业务联系人')}

            <FormItemWrapper label="姓名">
              {getFieldDecorator('contactsName', {
                initialValue: adDetail.contactsName,
                rules: [
                  {
                    required: true,
                    message: '请填写姓名',
                  },
                ],
              })(<Input placeholder="请输入" />)}
            </FormItemWrapper>

            <FormItemWrapper label="手机号" extraText="审核结果将发送短信到此手机号码">
              {getFieldDecorator('mobile', {
                initialValue: adDetail.mobile,
                validateFirst: true,
                rules: [
                  {
                    required: true,
                    message: '请填写手机号',
                  },
                  {
                    pattern: pattern.mobile,
                    message: '请输入正确的手机号码',
                  },
                ],
              })(<Input placeholder="请输入" />)}
            </FormItemWrapper>

          </div>
        </Form>

        <SaveBtn {...saveProps} />
        <PreviewAdContent
          visible={this.state.previewVisible}
          content={this.state.content}
          onClose={() => this.togglePreview(false)}
        />
      </div>);
  }
}

EditAdConfigPage.propTypes = {
  visible: PropTypes.bool.isRequired,
  dispatch: PropTypes.func.isRequired,
  form: PropTypes.object.isRequired,
  editAdConfigResult: PropTypes.object.isRequired,
  fetchAdDetailResult: PropTypes.object,
  profile: PropTypes.object,
};

EditAdConfigPage.defaultProps = {
  fetchAdDetailResult: {},
  profile: {},
};

const mapStateToProps = ({
  operationCenter: {
    editAdModalVisible,
    editAdConfigResult,
    fetchAdDetailResult,
  },
  global: {
    profile,
    getAdAuthListResult,
  },
}) => ({
  visible: editAdModalVisible,
  editAdConfigResult,
  fetchAdDetailResult,
  getAdAuthListResult,
  profile,
  isSuperAdmin: checkIsSuperAdmin(profile),
});

const EditAdConfigModalForm = Form.create()(connect(mapStateToProps)(EditAdConfigPage));

export default EditAdConfigModalForm;
