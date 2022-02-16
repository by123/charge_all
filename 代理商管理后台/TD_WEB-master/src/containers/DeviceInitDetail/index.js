import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Modal, Spin, Progress } from 'antd';
import { DetailList } from '../../components/DetailList';
import { datetimeFormat, parseString } from '../../utils';
import './style.less';

class DeviceInitDetail extends React.Component {
  render() {
    // const { detailData, title } = this.props;
    // if(datailData.result) {
    //   loading = detailData.loading;
    // }
    const {
      detailData: {
        loading,
        result,
      },
      onCancel,
      visible,
      onOk,
    } = this.props;

    const { adddeviceFailedlists = [], task = {} } = result || {};
    // if (task && task.taskContent && task.taskContent instanceof String) {
    //   task.taskContent = JSON.parse(task.taskContent);
    // }
    const modalOpts = {
      visible,
      title: '新增设备出厂详情',
      onCancel,
      onOk,
    };
    let deviceInitColumns = [
      { key: 'progressPercent', label: '当前进度', render: text => <Progress percent={text} /> },
      {
        key: 'taskContent',
        label: '设备区间',
        render: text => {
          return (
            parseString(text) && parseString(text).snList.map((item, index) => {
              return (
                <div>
                  <p key={index}>{`${item[0]}-${item[1]}`}</p>
                </div>
              );
            })
          );
        },
      },
      { key: 'completeNum', label: '设备数量', render: text => `${text}个` },
      { key: 'taskContent', label: '绑定代理商', render: text => parseString(text) && parseString(text).mchName },
      { key: 'extendInfo1', label: '快递信息' },
      { key: 'extendInfo2', label: '其他备注' },
      { key: 'createTime', label: '提交时间', render: text => datetimeFormat(text) },
    ];
    // const failTaskStyle = {
    //   height: 80,
    //   overflow: 'hidden',
    //   textOverflow: 'ellipsis',
    //   '-webkit-box-orient': 'vertical',
    //   '-webkit-line-clamp': 2,
    //   display: '-webkit-box',
    // };
    if (task && adddeviceFailedlists.length > 0) {
      task.adddeviceFailedlists = adddeviceFailedlists;
      task.failDeviceNum = adddeviceFailedlists.length;
      deviceInitColumns.splice(1, 0, {
        key: 'failDeviceNum',
        label: '失败数量',
        render: text => text,
      }, {
        key: 'adddeviceFailedlists',
        label: '失败设备',
        render: text => {
          return (
            <div className="fail-wrapper" style={text.length > 3 ? { height: 80 } : { height: 40 }}>
              <div>
                {
                  text && text.length <= 3 ? text.map((item) => {
                    return `${item.deviceSn},`;
                  }) : `${text[0].deviceSn},${text[1].deviceSn},${text[2].deviceSn}...............................${text[text.length - 2].deviceSn},${text[text.length - 1].deviceSn}`
                }
              </div>
            </div>
          );
        },
      });
    }
    const colSpan = {
      xs: 24,
      sm: 24,
      xl: 24,
    };

    const formItemLayout = {
      wrapperCol: {
        xs: {
          span: 20,
        },
        sm: {
          span: 20,
        },
        xl: {
          span: 20,
        },
      },
      labelCol: {
        xs: {
          span: 4,
        },
        sm: {
          span: 4,
        },
        xl: {
          span: 4,
        },
      },
    };

    const detailListOpts = {
      columns: deviceInitColumns,
      colSpan,
      itemCol: formItemLayout,
    };
    return (
      <Modal {...modalOpts}>
        {
          adddeviceFailedlists && adddeviceFailedlists.length > 0 ? <div className="line" style={adddeviceFailedlists.length > 3 ? { top: 245 } : { top: 206 }} /> : null
        }
        <Spin spinning={loading}>
          <DetailList {...detailListOpts} dataSource={task} />
        </Spin>
      </Modal>
    );
  }
}

DeviceInitDetail.propTypes = {
  onCancel: PropTypes.func.isRequired,
  dispatch: PropTypes.func.isRequired,
  onChange: PropTypes.func,
  onOk: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  detailData: PropTypes.object.isRequired,
};

DeviceInitDetail.defaultProps = {
  onChange: null,
};

const Container = connect(({ active: { deviceInitDetail } }) => ({
  detailData: deviceInitDetail,
}))(DeviceInitDetail);

export { Container as DeviceInitDetail };

