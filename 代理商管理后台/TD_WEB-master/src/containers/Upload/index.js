import React from 'react';
import { connect } from 'react-redux';
import { message, Modal, Icon, Button } from 'antd';
import RcUpload from 'rc-upload';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import { arrayMove } from 'react-sortable-hoc';

import { action as commonActions } from '@/store/global';

import { UPLOADING, UPLOAD_URL, IMG_HOST } from '../../utils/constants';
import UploadList from './upload-list';

/**
 * 文件上传组件
 * 上传预览类型
 * {
 *  listType: [
 *  'text',         文字链接
 *  'table',        表格展示
 *  'picture'       名称+图片卡片展示
 *  'picture-card'  正方形图片展示
 *  'picture-desc'  图片+文字描述展示
 *  ]
 * }
 */

const PICTURE_CARD = 'picture-card';

const defaultLocale = {
  uploading: '文件上传中',
  removeFile: '删除文件',
  uploadError: '上传失败，请重试',
  previewFile: '预览文件',
};

const footerTextStyle = {
  position: 'absolute',
  left: 120,
  top: 10,
  width: 200,
  lineHeight: 1.8,
};
const fileToObject = file => ({
  lastModified: file.lastModified,
  lastModifiedDate: file.lastModifiedDate,
  name: file.filename || file.name,
  size: file.size,
  type: file.type,
  uid: file.uid,
  response: file.response,
  error: file.error,
  percent: 0,
  status: null,
  desc: null,
  time: null,
  uuid: null,
});
const getFileItem = (file, fileList) => {
  const matchKey = file.uid !== undefined ? 'uid' : 'name';
  return fileList.find(item => item[matchKey] === file[matchKey]);
};
const removeFileItem = (file, fileList) => {
  const matchKey = file.uid !== undefined ? 'uid' : 'name';
  const removed = fileList.filter(item => item[matchKey] !== file[matchKey]);
  if (removed.length === fileList.length) {
    return null;
  }
  return removed;
};

// 这个组件不要改成PureComponent，如果不得不改，
// 需要修改子组件对于fileList的修改方式，每次回调都返回新的fileList
// 否则将无法触发子组件render
class Upload extends React.PureComponent {
  state = {
    fileList: [],
    previewUrl: '',
    previewName: '',
    previewVisible: false,
  };
  /** 生命周期 */
  componentDidMount() {
    this.props.dispatch(commonActions.getImageToken(this.props.private));
  }
  initValue = (initialValue) => {
    if (typeof initialValue === 'string') {
      initialValue = initialValue.split(',').map(value => ({
        uuid: value,
      }));
    }
    return initialValue && initialValue.map((val, index) => ({
      ...val,
      uid: `uploaded_${index}`,
      status: 'done',
      url: IMG_HOST + val.uuid,
      name: val.name || `未命名文件: ${val.uuid}`,
    }));
  }
  isInnerState = () => { // 由于即使被Form包裹value是可能是为undefined的，所以不能直接判断value
    return !this.props.onChange;
  }

  /**
   * 获得上传文件列表
   * @param isOrigin 师傅返回原数组
   * @returns 返回新的数组
   */
  getFileList = (isOrigin) => {
    const fileList = this.isInnerState() ? this.state.fileList : this.props.value;
    if (isOrigin) return fileList || [];
    return fileList ? fileList.concat() : [];
  }


  /** 事件处理 */
  onBeforeUpload = (file, newFileList) => {
    const fileList = this.getFileList();
    const uploadedLength = fileList.length;
    if (newFileList.length + uploadedLength > this.props.maxLength) {
      if (file.uid === newFileList[0].uid) { // 只提示一次
        message.error(`文件上传数量不得超过${this.props.maxLength}个`);
      }
      return false;
    }

    if (file.size > (this.props.maxSize * 1024)) {
      message.error(`文件${file.name}上传失败，原因：大小超过了限制，请上传小于${this.props.maxSize}Kb的文件`, 5);
      return false;
    }
    if (this.isPictureType()) { // 上传类型为图片时判断类型
      const accept = ['jpeg', 'png', 'gif'];
      const fileType = file.type.split('/')[1];
      if (accept.indexOf(fileType) === -1) {
        message.error(`文件${file.name}上传失败，原因：格式不支持，支持的图片格式有: jpg,jpeg,png,gif `, 5);
        return false;
      }
    }
  };

  onStart = (file) => {
    let targetItem;
    const fileList = this.getFileList();
    if (file.length > 0) {
      targetItem = file.map(f => {
        const fileObject = fileToObject(f);
        fileObject.status = UPLOADING;
        return fileObject;
      });
    } else {
      targetItem = fileToObject(file);
      targetItem.status = UPLOADING;
    }
    this.onChange({
      file: targetItem,
      fileList: fileList.concat(targetItem),
    });
  };
  onProgress = (e, file) => {
    const fileList = this.getFileList();
    let targetItem = getFileItem(file, fileList);

    // removed
    if (!targetItem) {
      return;
    }
    targetItem.percent = e.percent;
    this.onChange({
      event: e,
      file: { ...targetItem },
      fileList,
    });
  };
  onSuccess = (response, file) => {
    try {
      if (typeof response === 'string') {
        response = JSON.parse(response);
      }
    } catch (e) { /* do nothing */
    }
    const fileList = this.getFileList();
    let targetItem = getFileItem(file, fileList);

    // removed
    if (!targetItem) {
      return;
    }
    targetItem.status = 'done';
    targetItem.response = response;
    targetItem.uuid = response.key;
    targetItem.url = IMG_HOST + response.key;
    targetItem.time = new Date().getTime(); // 记录上传成功时间
    this.onChange({
      file: { ...targetItem },
      fileList,
    });
    if (fileList.every(item => item.percent === 100)) {
      // 全部上传成功
      this.props.onComplete(fileList);
    }
  };
  onError = (error, response, file) => {
    const fileList = this.getFileList();
    let targetItem = getFileItem(file, fileList);

    // removed
    if (!targetItem) {
      return;
    }
    targetItem.error = error;
    targetItem.response = response;
    targetItem.status = 'error';
    this.onChange({
      file: { ...targetItem },
      fileList,
    });
  };
  onChange = ({ file, fileList }) => {
    if (file.status === 'error') {
      if (file.error) {
        let msg;
        if (file.response && typeof file.response === 'string') {
          msg = file.response;
        } else {
          msg = (file.error && file.error.statusText) || '上传失败';
        }
        switch (file.error.status) {
          case 400:
            message.error('上传token未设置');
            break;
          case 401:
            message.error('上传token已失效');

            // 重新获取token
            this.props.dispatch(commonActions.fetchImageToken(true));
            break;
          default:
            message.error(msg);
        }
      }
    }
    // let value = fileList.filter(item => item.status !== 'error');
    if (this.isInnerState()) {
      this.setState({ fileList });
    } else {
      this.props.onChange(fileList);
    }
  };

  onSortEnd = ({ oldIndex, newIndex }) => {
    const fileList = this.getFileList();
    const nextFileList = arrayMove(fileList, oldIndex, newIndex);
    const file = { status: 'sorted' };
    this.onChange({
      file,
      fileList: nextFileList,
    });
  };

  onDescChange = (value, file) => {
    file.desc = value;
    const fileList = this.getFileList();
    const index = fileList.findIndex(item => item.uid === file.uid);
    fileList[index] = file;
    this.onChange({
      file,
      fileList,
    });
  };

  handleManualRemove = file => {
    this.upload.abort(file);
    file.status = 'removed'; // eslint-disable-line
    const fileList = this.getFileList();
    const removedFileList = removeFileItem(file, fileList);
    if (removedFileList) {
      this.onChange({
        file,
        fileList: removedFileList,
      });
    }
  };
  handlePreview = file => {
    this.setState({
      previewUrl: file.url || file.thumbUrl,
      previewName: file.name,
      previewVisible: true,
    });
  };
  handlePreviewCancel = () => {
    this.setState({ previewVisible: false });
  };

  isPictureType() {
    return this.props.listType.indexOf('picture') !== -1;
  }
  openWindowPreview = () => {
    window.open(this.state.previewUrl);
  }

  render() {
    // upload button
    const {
      prefixCls,
      disabled,
      listType,
      showUploadList,
      descMaxLength,
      descPlaceholder,
      maxLength,
      footerText,
      uploadToken,
      privateUploadToken,
    } = this.props;
    const uploadButtonCls = classNames(prefixCls, {
      [`${prefixCls}-select`]: true,
      [`${prefixCls}-select-${listType}`]: true,
      [`${prefixCls}-disabled`]: disabled,
    });
    const fileList = this.getFileList(true);
    const tokenData = this.props.private ? privateUploadToken : uploadToken;
    const rcUploadProps = {
      action: UPLOAD_URL,
      data: { token: tokenData.result.token },
      multiple: maxLength > 1,
      beforeUpload: this.onBeforeUpload,
      onStart: this.onStart,
      onError: this.onError,
      onSuccess: this.onSuccess,
      listType,
      ...this.props,
    };
    delete rcUploadProps.className;
    const renderUploadButton = () => {
      return (
        <div>
          {listType === PICTURE_CARD ?
            <div>
              <Icon type="plus" />
              <div className="ant-upload-text">点击上传</div>
            </div>
            :
            <Button disabled={disabled}>
              <Icon type="upload" /> 点击上传
            </Button>
          }
        </div>
      );
    };
    const hideUploadButton = () => {
      return fileList && fileList.length >= maxLength;
    };

    const uploadButton = (
      <div className={uploadButtonCls} style={{ display: hideUploadButton() ? 'none' : '' }} key="button" >
        <RcUpload {...rcUploadProps} onProgress={this.onProgress} ref={rcUpload => { this.upload = rcUpload; }} >
          {hideUploadButton() ? null : renderUploadButton()}
        </RcUpload>
      </div>
    );

    // upload list
    const uploadList = showUploadList ? (
      <UploadList
        disabled={disabled}
        descMaxLength={descMaxLength}
        listType={listType}
        descPlaceholder={descPlaceholder}
        items={fileList}
        onPreview={this.handlePreview}
        onDescChange={this.onDescChange}
        onRemove={this.handleManualRemove}
        onSortEnd={this.onSortEnd}
        locale={this.props.locale}
      />
    ) : null;


    return (
      <div>
        {listType === 'picture-card' ?
          <div>
            {uploadList}
            {uploadButton}
          </div>
          :
          <div>
            {uploadButton}
            {uploadList}
          </div>
        }
        <Modal title="图片预览" visible={this.state.previewVisible} footer={null} onCancel={this.handlePreviewCancel}>
          <a title="双击图片即可打开新窗口预览">
            <img alt="preview" style={{ width: '100%' }} onDoubleClick={this.openWindowPreview} src={this.state.previewUrl} />
          </a>
        </Modal>
        <div style={maxLength === 1 ? footerTextStyle : null}>{ footerText }</div>
      </div>
    );
  }
}

Upload.defaultProps = {
  prefixCls: 'ant-upload',
  disabled: false,
  showUploadList: true,
  locale: defaultLocale,
  onChange: null,
  onComplete: () => {},
  descPlaceholder: '',
  onPreview: () => {},
  maxLength: 1,
  footerText: '',
  maxSize: 2048,
  descMaxLength: 1000,
  listType: 'picture-card',
  private: false,
  privateUploadToken: null,
  uploadToken: null,
};
Upload.propTypes = {
  dispatch: PropTypes.func.isRequired,
  uploadToken: PropTypes.object,
  privateUploadToken: PropTypes.object,
  /* eslint-disable react/require-default-props */
  value: PropTypes.array, // 这里设置了必填ant-design会有警告，所以不设置必填，但是设置默认值也有警告，所以这里也不设置默认值
  onChange: PropTypes.func,
  onComplete: PropTypes.func,
  prefixCls: PropTypes.string,
  disabled: PropTypes.bool,
  private: PropTypes.bool,
  showUploadList: PropTypes.oneOfType([
    PropTypes.bool,
    PropTypes.object,
  ]),
  descPlaceholder: PropTypes.string,
  descMaxLength: PropTypes.number,
  listType: PropTypes.string,
  locale: PropTypes.object,
  onPreview: PropTypes.func,
  maxLength: PropTypes.number,
  footerText: PropTypes.string,
  maxSize: PropTypes.number,
};

const mapStateToProps = ({ global: { uploadToken, privateUploadToken } }) => {
  return {
    uploadToken,
    privateUploadToken,
  };
};

export default connect(mapStateToProps, null, null, { withRef: true })(Upload);
