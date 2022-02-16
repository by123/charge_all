import React from 'react';
import { Modal, Alert } from 'antd';
import axios from 'axios';

export class CheckVersion extends React.Component {
  state = {
    visible: false,
    version: null,
  };

  componentDidMount() {
    // this.checkVersion();
    this.intervalId = setInterval(() => {
      this.checkVersion();
    }, 60000);
  }

  componentWillUnmount() {
    clearInterval(this.intervalId);
    this.intervalId = null;
  }

  checkVersion() {
    axios.get('/version.json').then(res => {
      const version = res.data.version;
      if (version
        && version !== process.env.VERSION
        && this.compareVersion(process.env.VERSION, version)
      ) {
        // this.setState({ visible: true, version });
        this.handleRefresh();
      }
    });
  }

  compareVersion = (version, newVersion) => {
    const versionArr = version.split('.');
    const newVersionArr = newVersion.split('.');
    let result = false;
    newVersionArr.forEach((value, index) => {
      let oldItem = versionArr[index] || 0;
      oldItem = Number(oldItem);
      value = Number(value);
      if (value > oldItem) {
        result = true;
        return false;
      }
    });
    return result;
  }

  handleRefresh = () => {
    if (!window.location.hash) {
      window.location.href = window.location.href;
    } else {
      window.location.reload(true);
    }
    // window.location.reload(true);
  };

  handleCancel = () => {
    this.setState({ visible: false });
  };

  render() {
    const modalProps = {
      visible: this.state.visible,
      title: '检测到新版本',
      okText: '立即刷新',
      cancelText: '待会我自行刷新',
      onOk: this.handleRefresh,
      onCancel: this.handleCancel,
    };
    return (
      <Modal {...modalProps}>
        <p>当前版本: v{process.env.VERSION}</p>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;新版本: v{this.state.version}</p>
        <Alert message="需要刷新页面才可以访问到最新版本" type="info" showIcon />
      </Modal>
    );
  }
}
