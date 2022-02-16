import React from 'react';
import PropTypes from 'prop-types';
import { Upload, Icon, Form, message, Modal } from 'antd';
import { FILE_TYPE_FILE, FILE_TYPE_IMAGE } from '@/utils/constants';

import './style.less';

const Dragger = Upload.Dragger;

class UploadFile extends React.PureComponent {
  state = {
    fileList: [],
    uploading: false,
    previewImage: '',
    previewVisible: false,
  };

  getFileList = () => {
    return this.state.fileList;
  }

  getFileAcceptType = () => {
    const { fileType, acceptType } = this.props;
    const typeObj = {
      [FILE_TYPE_FILE]: ['csv', 'txt'],
      [FILE_TYPE_IMAGE]: ['png', 'jpeg', 'gif', 'jpg'],
    };
    return acceptType || typeObj[fileType];
  }

  generateFileType = (typeArr) => {
    if (!(typeArr instanceof Array)) {
      throw new TypeError('typeArr must bu array');
    }
    return typeArr.map(val => `.${val}`).join(',');
  }

  getBase64 = (file) => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => resolve(reader.result);
      reader.onerror = error => reject(error);
    });
  }

  validateFile = (file) => {
    const { fileType, fileSize = {}, validateFn } = this.props;
    const nameList = file.name.split('.');
    const acceptType = this.getFileAcceptType();
    const fileTypeText = fileType === FILE_TYPE_IMAGE ? '图片' : '文件';
    let errMsg = '';
    let rules = [
      {
        rule: !(acceptType.indexOf(nameList[nameList.length - 1]) === -1),
        errMsg: `不支持的${fileTypeText}格式`,
      },
      {
        rule: !(fileType === FILE_TYPE_FILE && file.size > (fileSize.size || 10) * 1024 * 1024),
        errMsg: `上传的文件不能大于${fileSize.size || 10}MB`,
      },
      {
        rule: !(fileType === FILE_TYPE_IMAGE && file.size > (fileSize.size || 2) * 1024 * 1024),
        errMsg: `上传的图片不能大于${fileSize.size || 2}MB`,
      },
    ];

    validateFn && (rules = rules.concat(validateFn(file, acceptType)));
    rules.forEach(item => {
      if (!item.rule) {
        errMsg = item.errMsg;
        return false;
      }
    });

    if (errMsg) {
      message.error(errMsg);
      setTimeout(() => this.handleRemove(file), 1000);
    }
    return !errMsg;
  }

  calcImgWidth = (src) => {
    return new Promise((resolve) => {
      const image = new Image();
      image.onload = () => {
        const { width, height } = image;
        resolve({ width, height });
      };
      image.src = src;
    });
  }

  beforeUpload = file => {
    const { fileType, fileSize = {} } = this.props;

    if (!this.validateFile(file)) return false;

    if (fileType === FILE_TYPE_IMAGE && file) {
      this.getBase64(file).then(async data => {
        file.thumbUrl = data;
        if (fileSize) {
          const { width, height } = fileSize;
          let imgSize = await this.calcImgWidth(data);
          if (imgSize.width !== width || imgSize.height !== height) {
            message.error(`图片尺寸限制为${width}*${height}`);
            setTimeout(() => this.handleRemove(file), 1000);
            return false;
          }
        }

        this.setState(() => ({
          fileList: [file],
          previewImage: data,
        }));
        return false;
      });
    }

    this.setState(() => ({
      fileList: [file],
    }));
    return false;
  }

  handleRemove = (file) => {
    this.setState(state => {
      const index = state.fileList.indexOf(file);
      const newFileList = state.fileList.slice();
      newFileList.splice(index, 1);
      return {
        fileList: newFileList,
      };
    });
  }

  handlePreview = () => {
    this.setState({
      previewVisible: true,
    });
  }

  handleCancel = () => {
    this.setState({ previewVisible: false });
  }

  handleChange = ({ fileList }) => {
    const file = fileList[fileList.length - 1];
    this.setState({ fileList: file ? [file] : [] }, this.props.onChooseFile);
  }

  render() {
    const { fileType, ...otherProps } = this.props;
    const { fileList, previewVisible, previewImage } = this.state;
    const acceptType = this.getFileAcceptType();
    const fileTypeText = fileType === FILE_TYPE_IMAGE ? '图片' : '文件';
    const uploadProps = {
      name: 'file',
      multiple: false,
      accept: this.generateFileType(acceptType),
      fileList,
      beforeUpload: this.beforeUpload,
      onRemove: this.handleRemove,
      onPreview: this.handlePreview,
      onChange: this.handleChange,
      ...otherProps,
    };
    return (<div>
      <Dragger {...uploadProps}>
        <p className="ant-upload-drag-icon">
          <Icon type="inbox" />
        </p>
        <p className="ant-upload-text">{`点击或将${fileTypeText}拖拽到这里上传`}</p>
        <p className="ant-upload-hint">{`支持的${fileTypeText}类型：`}{acceptType.join('，')}</p>
      </Dragger>
      {fileType === FILE_TYPE_IMAGE && <Modal visible={previewVisible} footer={null} onCancel={this.handleCancel}>
        <img alt="example" style={{ width: '100%' }} src={previewImage} />
      </Modal>}
    </div>);
  }
}

const container = Form.create()(UploadFile);

export { container as UploadFile };

UploadFile.propTypes = {
  fileType: PropTypes.string,
  onChooseFile: PropTypes.func,
  validateFn: PropTypes.func,
  onRemove: PropTypes.func,
  acceptType: PropTypes.array,
  fileSize: PropTypes.object,
};

UploadFile.defaultProps = {
  fileType: FILE_TYPE_FILE,
  onChooseFile: null,
  onRemove: null,
  validateFn: null,
  acceptType: null,
  fileSize: {},
};

