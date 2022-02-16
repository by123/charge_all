import React from 'react';
import { Input, Icon, Upload, message } from 'antd';
import { api } from '@/store/api';
import { post } from '@/utils/request';
import './style.less';

const { TextArea } = Input;

class TextImageInput extends React.Component {

  generateTextItem = () => {
    return {
      type: 'text',
      content: '',
      key: new Date().getTime(),
    };
  }

  generateImgItem = (url) => {
    return {
      type: 'img',
      content: url,
      key: new Date().getTime(),
    };
  }

  onCloseItem = (e) => {
    const { index } = e.currentTarget.dataset;
    const { list } = this.props;
    list.splice(index, 1);
    this.changeListData(list);
  }

  changeListData = (list) => {
    if (!Array.isArray(list)) return;
    const { onChange } = this.props;
    onChange && onChange(list);
  }

  onOrderUp = (e) => {
    let { index } = e.currentTarget.dataset;
    const { list } = this.props;
    index = Number(index);
    if (index - 1 < 0) return;

    let delItem = list[index - 1];
    list[index - 1] = list[index];
    list[index] = delItem;
    this.changeListData(list);
  }

  onOrderDown = (e) => {
    let { index } = e.currentTarget.dataset;
    const { list } = this.props;
    index = Number(index);
    if (index + 1 > list.length - 1) return;

    let delItem = list[index + 1];
    list[index + 1] = list[index];
    list[index] = delItem;
    this.changeListData(list);
  }

  onAddText = () => {
    const { list } = this.props;
    list.push(this.generateTextItem());
    console.log('add Text', list);
    this.changeListData(list);
  }

  onPreview = () => {}

  renderSectionItem = () => {
    let { list, disabled } = this.props;

    const getActionSection = (index) => (<div className="section-action">
      <div className="action-item" data-index={index} onClick={this.onCloseItem}><Icon type="close" /></div>
      <div className="action-item" data-index={index} onClick={this.onOrderUp}><Icon type="arrow-up" /></div>
      <div className="action-item" data-index={index} onClick={this.onOrderDown}><Icon type="arrow-down" /></div>
    </div>);

    const getImageSection = (item, index) => (<div className="section img-section" key={item.key}>
      <div className="section-content img-content"><img src={item.content} alt="" /></div>
      {getActionSection(index)}
    </div>);

    const getTextSection = (item, index) => (<div className="section text-section" key={item.key}>
      <div className="section-content">
        <TextArea
          onInput={this.handleInputText}
          data-index={index}
          value={item.content}
          autosize={disabled}
        />
      </div>
      {getActionSection(index)}
    </div>);

    if (!list || !list.length) return;

    return list.map((item, index) => {
      let result = null;
      if (item.type === 'img') {
        result = getImageSection(item, index);
      } else if (item.type === 'text') {
        result = getTextSection(item, index);
      }
      return result;
    });
  }

  handleInputText = (e) => {
    const { index } = e.currentTarget.dataset;
    const { list } = this.props;
    list[index].content = e.target.value;
    this.changeListData(list);
  }

  handleUpload = (file) => {
    let fileData = new FormData();
    fileData.append('file', file);
    const { list } = this.props;
    post(api.uploadPublicFile, fileData).then(res => {
      const { url } = res;
      list.push(this.generateImgItem(url));
      this.changeListData(list);
    }, () => {
      message.error('图片上传失败');
    });
  }

  vaildateFile = (file) => {
    let result = true;
    let msg = '';
    const typeArray = ['image/jpeg', 'image/jpg', 'image/png'];

    if (file.size > 500 * 1024) {
      msg = '文件不能大于500KB';
    } else if (typeArray.indexOf(file.type) === -1) {
      msg = '文件类型不正确';
    }

    if (msg) {
      message.error(msg);
      result = false;
    }
    return result;
  }

  onPreview = () => {
    const { onPreview } = this.props;
    onPreview && onPreview();
  }

  render() {
    const { disabled, showPreview } = this.props;
    const props = {
      name: 'file',
      accept: '.jpg, .jpeg, .png',
      beforeUpload: file => {
        if (this.vaildateFile(file)) {
          this.handleUpload(file);
        }
        return false;
      },
      showUploadList: false,
    };

    return (<div className="text-image-input-container">
      {disabled && <div className="mask" />}
      {this.renderSectionItem()}
      <div className="btn-list">
        <div className="btn-item">
          <Upload {...props}>
            <span>+添加图片</span>
          </Upload>
        </div>
        <div className="btn-item text-item"><span onClick={this.onAddText}>+添加文本</span></div>
        {showPreview && <div className="btn-item" onClick={this.onPreview}><span>预览</span></div>}
      </div>
    </div>);
  }
}

export { TextImageInput };
