/* eslint-disable */
import React from 'react';
import { Form, Icon } from 'antd';

import Upload from '../../../containers/Upload';

const FormItem = Form.Item;


class UploadPage extends React.Component {
  state = {
    publicUrls: '',
    privateUrls: '',
    fileList: [],
  }
  componentDidMount() {
    // const file = this.upload.getWrappedInstance().initValue('FvbgadqGXJu_cxfv0p5kJbn7UuoJ');
    // setTimeout(() => {
    //   this.setState({
    //     fileList: file,
    //   });
    // }, 1000);
  }
  handleFileUpload = (type, fileList) => {
    const urls = JSON.stringify(fileList.map(file => file.url), null, 2);
    this.setState({
      [type]: urls,
    });
  }

  renderUploadButton = () => {
    return (
      <div>
        <Icon type="plus" />
        <div className="ant-upload-text">点击上传</div>
      </div>
    );
  }
  onComplete1 = (fileList) => {
    this.handleFileUpload('privateUrls', fileList);
  }

  onComplete2 = (fileList) => {
    this.handleFileUpload('publicUrls', fileList);
  }
  onChange = (fileList) => {
    this.setState({ fileList });
  }

  render() {
    return (
      <div style={{ padding: 20 }}>
        <h1>七牛图片上传</h1>
        <FormItem label="图片上传测试（公有空间）" style={{ marginBottom: '10px' }}>
          <Upload ref={instance => { this.upload = instance; }} value={this.state.fileList} onChange={(fileList) => this.setState({ fileList })} maxSize={4096} maxLength={10} onComplete={this.handleFileUpload.bind(null, 'publicUrls')} />
        </FormItem>
        <pre>
          {this.state.publicUrls}
        </pre>
        <FormItem label="图片上传测试（私有空间）" style={{ marginBottom: '10px' }}>
          <Upload private maxLength={10} onComplete={this.handleFileUpload.bind(null, 'privateUrls')} />
        </FormItem>
        <pre>
          {this.state.privateUrls}
        </pre>
      </div>
    );
  }
}

export default Form.create()(UploadPage);
