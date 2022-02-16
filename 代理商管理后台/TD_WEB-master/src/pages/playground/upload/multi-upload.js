import React from 'react';
import PropTypes from 'prop-types';
import { Table, Button } from 'antd';
import { connect } from 'react-redux';
import RcUpload from 'rc-upload';
import { UPLOAD_URL, IMG_HOST } from '@/utils/constants';

import { action as commonActions } from '@/store/global';

class MultiUploadPage extends React.Component {
  state = {
    fileList: [
      { key: '101', name: '客户信息表', images: [{ name: '文件名', uuid: 'key 七牛文件key值' }] },
      { key: '102', name: '客户面签、实地调查照片', images: [] },
      { key: '103', name: '客户身份证', images: [] },
    ],
    formValue: [],
  }
  componentDidMount() {
    this.props.dispatch(commonActions.getImageToken());
  }

  updateFileList(file, groupCode) {
    const fileList = [...this.state.fileList];
    const groupItem = fileList.find(item => item.key === groupCode);
    groupItem.images.push(file);
    this.setState({
      fileList,
    });
  }

  handleBeforeUpload = (file) => {
    const groupCode = file.name.slice(0, 3);
    const groupItem = this.state.fileList.find(item => item.key === groupCode);
    if (!groupItem || groupItem.images.findIndex(item => file.name === item.name) !== -1) {

      // 同一个组中的同名文件不再重新上传
      return false;
    }
  }

  // 批量图片上传成功回调
  handleMultiSuccess = (response, file) => {
    const groupCode = file.name.slice(0, 3);
    this.handleUploadInGroup(response, file, groupCode);
  };

  // 分组内图片上传成功回调
  handleUploadInGroup = (response, file, groupCode) => {
    try {
      if (typeof response === 'string') {
        response = JSON.parse(response);
      }
    } catch (e) { /* do nothing */
    }
    this.updateFileList({ name: file.name, uuid: response.key }, groupCode);
  };

  render() {
    const token = this.props.uploadToken.result;
    const maxLength = 10;

    const columns = [
      { title: '分组id', dataIndex: 'key', key: 'key' },
      { title: '文件分类', dataIndex: 'name', key: 'name' },
      { title: '数量', key: 'count', render: (text, record) => <div>{record.images.length}</div> },
      { title: '操作',
        dataIndex: '',
        key: 'x',
        render: (text, record) => (<RcUpload action={UPLOAD_URL}
          data={token}
          multiple={false}
          onSuccess={(response, file) => this.handleUploadInGroup(response, file, record.key)}
        >
          <a href="#">上传</a>
        </RcUpload>) },
    ];


    const renderDetail = record => {
      if (record.images.length > 0) {
        return (
          <div>
            {record.images.map((img, index) => (
              <div key={index} style={{ padding: 5 }}>
                <span style={{ display: 'inline-block', whiteSpace: 'nowrap', width: '200px', padding: '0 20px' }}>{img.name}</span>
                <img src={`${IMG_HOST}${img.uuid}`} style={{ verticalAlign: 'middle' }} width={30} height={30} alt={img.name} />
              </div>
            ))}
          </div>
        );
      }
    };

    return (
      <div>
        <RcUpload
          action={UPLOAD_URL}
          data={token}
          multiple={maxLength > 1}
          beforeUpload={this.handleBeforeUpload}
          onSuccess={this.handleMultiSuccess}
        >
          <Button>批量上传</Button>
        </RcUpload>
        <Table
          columns={columns}
          expandedRowRender={renderDetail}
          dataSource={this.state.fileList}
          pagination={false}
        />
      </div>
    );
  }
}
MultiUploadPage.propTypes = {
  uploadToken: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
};

export default connect(({ global: { uploadToken } }) => ({ uploadToken }))(MultiUploadPage);
