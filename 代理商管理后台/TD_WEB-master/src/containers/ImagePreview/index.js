import React from 'react';
import PropTypes from 'prop-types';
import { Modal, Icon, Spin, message } from 'antd';

import './style.less';

/**
 * 计算图片初始化高度
 * @param imageList
 * @param index
 * @returns {number}
 */
const getInitialImageHeight = (imageList, index) => {
  if (!imageList) return 0;
  const img = new Image();
  img.src = imageList[index].url;
  let initHeight = window.innerHeight - 120;
  if (imageList.length > 1) {
    initHeight = window.innerHeight - 220;
  }
  if (img.height < img.width) { // 宽大于高，按最大高度的值作为宽度显示
    if (img.width < initHeight) {
      initHeight = img.height;
    } else {
      initHeight = initHeight * img.height / img.width;
    }
  } else { // 高度大于宽度，按最大高度显示，否则显示原图
    initHeight = img.height < initHeight ? img.height : initHeight;
  }
  return initHeight;
};

const getThumbsListOffset = (imageList, index) => {
  if (!imageList) return 0;
  const thumbWidth = 140;
  const boxWidth = window.innerWidth;
  const listWidth = imageList.length * thumbWidth;
  // let visibleLeft = 0;
  // let visibleRight = boxWidth;
  const thumbPos = (index + 1) * thumbWidth;
  const tailWidth = listWidth - thumbPos;
  const defaultOffset = boxWidth / 2 - thumbWidth / 2; // 默认是窗口宽度的一半
  if (thumbPos > boxWidth) {
    const offset = defaultOffset < tailWidth ? defaultOffset : tailWidth;
    return 0 - (thumbPos - boxWidth + offset);
  }
  return 0;
};

export class ImagePreview extends React.PureComponent {

  constructor(props) {
    super(props);
    this.offsetStep = 200;
    this.state = {
      angle: 0, // 旋转角度
      zoom: 1, // 放大倍数
      height: 0,
      zoomOut: false,
      zoomIn: true,
      loading: false,
      prevVisible: this.props.visible,
      index: 0,
      baseHeight: 0,
      offset: 0,
    };
  }

  static getDerivedStateFromProps(props, state) {
    let nextState = null;
    if (props.visible !== state.prevVisible) {
      nextState = {
        prevVisible: props.visible,
      };
      if (props.visible) {
        // 打开预览窗口时
        const baseHeight = getInitialImageHeight(props.imageList, props.index);
        nextState = {
          ...nextState,
          index: props.index,
          baseHeight,
          height: baseHeight,
          offset: getThumbsListOffset(props.imageList, props.index),
        };
      }
    }
    return nextState;
  }


  resetImageSize = (height) => {
    this.setState({
      angle: 0,
      zoom: 1,
      zoomIn: true,
      height,
      baseHeight: height,
    });
  }

  closeModal = () => {
    this.resetImageSize();
    this.props.onClose();
  }

  showMessage = (msg) => {
    if (!this.isInfoShow) {
      this.isInfoShow = true;
      message.info(msg, () => {
        this.isInfoShow = false;
      });
    }
  }
  handleTurnLeft = () => {
    this.setState({ angle: this.state.angle - 90 });
  }

  handleTurnRight = () => {
    this.setState({ angle: this.state.angle + 90 });
  }

  // 缩小
  handleZoomOut = () => {
    if (this.state.zoom <= 1) {
      this.showMessage('已是最小分辨率');
      this.setState({ zoomOut: false });
      return;
    }
    const zoom = this.state.zoom - 1;

    this.setState({ zoomIn: true, zoom, height: this.state.baseHeight * zoom });
  }

  // 放大
  handleZoomIn = () => {
    const zoom = this.state.zoom + 1;
    let height = this.state.baseHeight * zoom;
    this.setState({ zoom, zoomOut: true, height });
  }

  setImage = (index) => {
    const { imageList } = this.props;
    this.resetImageSize(getInitialImageHeight(imageList, index));
    const offset = getThumbsListOffset(imageList, index);
    let loading = false;
    if (imageList[index].url !== imageList[this.state.index].url) {
      loading = true;
    }
    this.setState({
      loading,
      index,
      offset,
    });
  }

  previousImage = () => {
    let index = this.state.index - 1;
    if (index < 0) {
      index = this.props.imageList.length - 1; // 跳至最后一张
    }
    this.setImage(index);
  }
  nextImage = () => {
    let index = this.state.index + 1;
    if (index >= this.props.imageList.length) {
      index = 0; // 跳至最后一张
    }
    this.setImage(index);
  }

  handlePreviewByIndex = (index) => {
    if (index === this.state.index) return false;
    this.setImage(index);
  }
  onImgLoad = () => {
    this.setState({
      loading: false,
    });
  };

  renderImage = (currentImage) => {
    if (!currentImage.url) return null;
    const imageStyle = {
      transform: `rotate(${this.state.angle}deg)`,
      height: this.state.height,
    };
    return (<img
      style={imageStyle}
      ref={dom => { this.imgDom = dom; }}
      onLoad={this.onImgLoad}
      onDoubleClick={this.handleZoomIn}
      src={currentImage.url}
      alt=""
    />);
  }
  render() {
    const { visible, imageList } = this.props;
    const currentImage = imageList[this.state.index] || {};
    document.body.style.overflow = visible ? 'hidden' : null;
    const modalProps = {
      visible,
      wrapClassName: `image-modal-wrapper ${imageList.length > 1 ? 'thumbs-list-modal' : ''}`,
      width: '100%',
      footer: null,
      onCancel: this.closeModal,
    };
    return (<div className="image-preview">
      <Modal {...modalProps}>
        <div className="img-wrapper">
          <Spin spinning={this.state.loading} wrapperClassName={`${this.state.height > window.innerHeight ? '' : 'center'}`} >
            {this.renderImage(currentImage)}
          </Spin>
        </div>
        <div className="title">{currentImage.title}</div>
        { imageList.length > 1 &&
        <div className="thumbs-wrapper">
          <ul className="preview-list" style={{ left: this.state.offset }}>
            {imageList.map((item, i) => (<li key={i} onClick={this.handlePreviewByIndex.bind(null, i)} className={`${this.state.index === i ? 'active' : ''}`}>
              <img src={item.url} alt="" />
            </li>))}
          </ul>
        </div>}
        <div className="operation-bar">
          <div className="bottom-wrapper">
            <a title="向左旋转" onClick={this.handleTurnLeft}><Icon type="rollback" /></a>
            <a title="缩小" onClick={this.handleZoomOut}><Icon type="minus-circle-o" /></a>
            <a title="放大" onClick={this.handleZoomIn}><Icon type="plus-circle-o" /></a>
            <a title="向右旋转" onClick={this.handleTurnRight}><Icon type="enter" /></a>
          </div>
          { imageList.length > 1 &&
            <div>
              <div className="left-btn">
                <a title="上一张" onClick={this.previousImage} ><Icon type="left" /></a>
              </div>
              <div className="right-btn">
                <a title="下一张" onClick={this.nextImage} ><Icon type="right" /></a>
              </div>
            </div>
          }
        </div>
      </Modal>
    </div>);
  }
}


ImagePreview.propTypes = {
  visible: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  index: PropTypes.number,
  imageList: PropTypes.array.isRequired,
};

ImagePreview.defaultProps = {
  current: '',
  index: 0,
  // imageList: [
  //   {
  //     title: '小姐姐1',
  //     thumbs: 'http://oyu1zoloe.bkt.clouddn.com/FkkNCZU6GS4W7fIusTTjTFoxexvo',
  //     url: 'http://oyu1zoloe.bkt.clouddn.com/FkkNCZU6GS4W7fIusTTjTFoxexvo',
  //   },
  //   {
  //     title: '小姐姐2',
  //     thumbs: 'http://oyu1zoloe.bkt.clouddn.com/FtbrOmv0dpt_UMV48-pOk5efqy2A',
  //     url: 'http://oyu1zoloe.bkt.clouddn.com/FtbrOmv0dpt_UMV48-pOk5efqy2A',
  //   },
  //   {
  //     title: '小姐姐3',
  //     thumbs: 'http://oyu1zoloe.bkt.clouddn.com/FgZqao5S66axFGIoNaM1NhwcDGfD',
  //     url: 'http://oyu1zoloe.bkt.clouddn.com/FgZqao5S66axFGIoNaM1NhwcDGfD',
  //   },
  // ],
};
