import React, { createElement } from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import { Button } from 'antd';
import config from './type-config';
import './index.less';

const Exception = ({ className, linkElement, type, ...rest }) => {
  const pageType = type in config ? type : '404';
  const clsString = classNames('exception', className);
  return (
    <div className={clsString} {...rest}>
      <div className="img-block">
        <div
          className="img-ele"
          style={{ backgroundImage: `url(${config[pageType].img})` }}
        />
      </div>
      <div className="content">
        <h1>{config[pageType].title}</h1>
        <div className="desc">{config[pageType].desc}</div>
        <div className="actions">
          {
            createElement(linkElement, {
              to: '/',
              href: '/',
            }, <Button type="primary">返回首页</Button>)
          }
        </div>
      </div>
    </div>
  );
};

Exception.propTypes = {
  className: PropTypes.string,
  linkElement: PropTypes.string,
  type: PropTypes.string.isRequired,
};

Exception.defaultProps = {
  className: null,
  linkElement: 'a',
};

export default Exception;
