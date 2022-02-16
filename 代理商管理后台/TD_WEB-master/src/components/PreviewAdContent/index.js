import React from 'react';
import PropTypes from 'prop-types';
import './style.less';
import phoneBg from '../../images/phone_bg.png';

class PreviewAdContent extends React.Component {

  onClose = () => {
    this.props.onClose && this.props.onClose();
  }

  stopEvent = (e) => {
    e.stopPropagation();
  }

  render() {
    const {
      visible,
      content,
    } = this.props;

    return visible ? (
      <div className="ad-preview-container" onClick={this.onClose}>
        <div className="preview-main" onClickCapture={this.stopEvent}>
          <div className="preview-bg">
            <img alt="" src={phoneBg} />
          </div>
          <div className="preview-content">
            {/* <div className="content-title">啊是大23</div> */}
            <div className="content-list">
              {content.map(item => {
                if (item.type === 'img') {
                  return (<div key={item.key} className="content-item content-item-img">
                    <img src={item.content} alt="" />
                  </div>);
                } else if (item.type === 'text') {
                  return <div key={item.key} className="content-item content-item-text">{item.content}</div>;
                }
                return null;
              })}
            </div>
          </div>
        </div>
      </div>
    ) : null;
  }
}

PreviewAdContent.propTypes = {
  visible: PropTypes.bool.isRequired,
  content: PropTypes.array.isRequired,
  onClose: PropTypes.func.isRequired,
};

export { PreviewAdContent };
