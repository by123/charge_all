import React from 'react';
import PropTypes from 'prop-types';
import { Drawer, message } from 'antd';
import { connect } from 'react-redux';
import { dateFormat } from '@/utils';
import { action as downloadAction } from './store';

import './style.less';

const statusObj = {
  0: '正在为您生成，请稍等',
  2: '生成成功',
};

class DownloadModal extends React.PureComponent {
  onClose = () => {
    this.props.dispatch(downloadAction.toggleDownloadModal(false));
  }

  downloadFile = (item) => {
    window.open(item.resourceUrl, '_blank');
  }

  deleteFile = (item) => {
    const { dispatch, taskType } = this.props;
    dispatch(downloadAction.deleteDownloadItem({ taskId: item.id }, () => {
      message.success('删除成功');
      dispatch(downloadAction.fetchDownloadList(taskType));
    }));
  }

  formatList = (data) => {
    let result = {};
    data.forEach(val => {
      let time = dateFormat(val.createTime);
      if (!result[time]) {
        result[time] = [];
      }
      result[time].push(val);
    });
    return result;
  }

  render() {
    const {
      downloadList,
      visible,
      title,
    } = this.props;
    const downloadListData = this.formatList(downloadList.dataSource || []);
    return (
      <Drawer
        title={title}
        placement="right"
        closable={false}
        width="70%"
        onClose={this.onClose}
        visible={visible}
        className="download-drawer"
      >
        {!!downloadListData && <div className="download-drawer-body">
          {Object.keys(downloadListData).map(key => {
            const list = downloadListData[key];
            return (<div className="drawer-section" key={key}>
              <div className="drawer-section-head">{key}</div>
              <div className="drawer-section-content">
                <div className="drawer-list">
                  {list.map(item => (<div className="drawer-list-item" key={item.id}>
                    <div className="item-content">
                      <div className="item-content-name">{item.fileName}</div>
                      <div className="item-content-status">{statusObj[item.taskStatus]}</div>
                    </div>
                    {item.taskStatus === 2 && <div className="item-operation">
                      <a href="#" onClick={() => this.downloadFile(item)}>保存</a>
                      <a href="#" onClick={() => this.deleteFile(item)}>删除</a>
                    </div>}
                  </div>))}
                </div>
              </div>
            </div>);
          })}
        </div>}
      </Drawer>
    );
  }
}

DownloadModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  downloadList: PropTypes.object,
  visible: PropTypes.bool.isRequired,
  taskType: PropTypes.string.isRequired,
  title: PropTypes.string,
};

DownloadModal.defaultProps = {
  downloadList: {},
  title: '下载管理',
};

const Container = connect(({ download: { downloadModalVisible, downloadList } }) => ({
  downloadList,
  visible: downloadModalVisible,
}))(DownloadModal);

export { Container as DownloadModal };
