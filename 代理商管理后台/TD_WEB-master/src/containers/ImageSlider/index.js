import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import Slider from 'react-slick';

import './style.less';


class ImageSlider extends React.PureComponent {
  constructor(props) {
    super(props);
    const { currentIndex, dataSource } = props;
    this.state = {
      currentIndex: dataSource.length === 0 ? 0 : currentIndex % dataSource.length,
    };
  }

  handlePrev = () => this.slider.slickPrev();
  handleNext = () => this.slider.slickNext();
  handleChange = index => this.setState({ currentIndex: index });

  render() {
    const { dataSource, pagingMode, background } = this.props;
    const customPaging = index => <a><img alt={dataSource[index]} src={dataSource[index]} /></a>;
    const carouselProps = {
      dots: !!pagingMode,
      dotsClass: pagingMode === 'thumb' ? 'slick-dots slick-thumb' : undefined,
      customPaging: pagingMode === 'thumb' ? customPaging : undefined,
      infinite: true,
      speed: 500,
      slidesToShow: 1,
      slidesToScroll: 1,
      useTransform: false,
      beforeChange: (_, next) => this.handleChange(next),
    };
    return (
      <div style={{ background }} className={classNames({ 'image-slider': true, 'height-full': !(pagingMode === 'thumb'), 'dots-inner': pagingMode === 'dot' })}>
        <Slider ref={c => { this.slider = c; }} {...carouselProps}>
          {dataSource.map((item, index) => <div key={index} className="image-wrap"><img alt={item} src={item} /></div>)}
        </Slider>
      </div>
    );
  }
}

ImageSlider.defaultProps = {
  dataSource: [],
  currentIndex: 0,
  pagingMode: null, // 'dot'  'thumb'
  background: 'transparent',
};

ImageSlider.propTypes = {
  dataSource: PropTypes.array,
  currentIndex: PropTypes.number,
  pagingMode: PropTypes.string,
  background: PropTypes.string,
};

export default ImageSlider;
