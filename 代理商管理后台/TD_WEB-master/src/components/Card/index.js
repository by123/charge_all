import React from 'react';
import PropTypes from 'prop-types';

import './style.less';

export const Card = ({ title, children, isCenter, className }) => {
  const wrapperStyle = `card-wrapper ${className} ${isCenter ? 'card-center' : ''}`;
  return (<div className={wrapperStyle} >
    {title && <h4>{title}</h4>}
    {children}
  </div>);
};

Card.propTypes = {
  children: PropTypes.object.isRequired,
  title: PropTypes.any,
  className: PropTypes.string,
  isCenter: PropTypes.bool,
};

Card.defaultProps = {
  title: null,
  className: '',
  isCenter: true,
};
