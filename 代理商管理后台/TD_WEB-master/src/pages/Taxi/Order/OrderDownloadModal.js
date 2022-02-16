import React from 'react';
import PropTypes from 'prop-types';
import { Modal, Spin, Button } from 'antd';
import { connect } from 'react-redux';
import { getDownloadFileName } from '@/utils';
import { action as orderActions } from './store';

import './style.less';

class OrderDownloadModal extends React.PureComponent {
  toggleDownloadReport = (visible) => {
    if (!visible) {
      this.props.dispatch(orderActions.cleanDownloadLink());
    }
    this.props.dispatch(orderActions.toggleDownloadReport(false));
  }

  handleDownload = (link) => {
    window.open(link);
    this.props.dispatch(orderActions.toggleDownloadReport(false));
  }

  render() {
    const {
      visible,
      downloadLink: {
        loading = false,
        result = {},
      } = {},
    } = this.props;
    const modalOpts = {
      title: '订单数据下载',
      visible,
      width: 600,
      footer: null,
      onCancel: () => this.toggleDownloadReport(false),
      maskClosable: false,
      destroyOnClose: true,
    };
    const downloadUrl = result || {};
    const { resourceUrl } = downloadUrl;
    return (
      <div>
        <Modal {...modalOpts} className="download-modal">
          <Spin spinning={loading}>
            {!resourceUrl && <p className="text">正在生成报表...</p>}
            {resourceUrl && <div className="download-wrap clearfix">
              <span>{getDownloadFileName(resourceUrl)}</span>
              <Button style={{ float: 'right' }} type="primary" onClick={() => this.handleDownload(resourceUrl)}>下载报表</Button>
            </div>}
          </Spin>
        </Modal>
      </div>
    );
  }
}

OrderDownloadModal.propTypes = {
  dispatch: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  downloadLink: PropTypes.object.isRequired,
};

const Container = connect(({ order: { downloadVisible, downloadLink } }) => ({
  visible: downloadVisible,
  downloadLink,
}))(OrderDownloadModal);

export { Container as OrderDownloadModal };
