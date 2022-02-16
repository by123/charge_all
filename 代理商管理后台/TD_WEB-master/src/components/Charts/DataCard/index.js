import React from 'react';
import PropTypes from 'prop-types';
import { Icon } from 'antd';
import tinycolor from 'tinycolor2';

import './style.less';

export class DataCard extends React.PureComponent {
  render() {
    const { background, icon, value, label, children } = this.props;
    let iconBg = '#2DB6F4';
    if (background) {
      iconBg = tinycolor(background).darken().toString();
    }
    return (<div className={`data-card ${background ? '' : 'default-card'} ${children ? 'has-child' : ''}`} style={{ background }}>
      <div className="icon-wrapper" style={{ background: iconBg }}><Icon {...icon} /></div>
      <div>
        <div className="card-content">
          <p className="label">{label}</p>
          <p className="value">{value}</p>
        </div>
        {children && (
          <div className="card-content">
            <p className="label">{children.label}</p>
            <p className="value">{children.value}</p>
          </div>
        )}
      </div>
    </div>);
  }
}

DataCard.propTypes = {
  icon: PropTypes.object.isRequired,
  background: PropTypes.string.isRequired,
  value: PropTypes.oneOfType([
    PropTypes.number,
    PropTypes.string,
  ]).isRequired,
  label: PropTypes.string.isRequired,
  children: PropTypes.array,
};

DataCard.defaultProps = {
  children: [],
  background: '',
  // label: '今日收入（元）',
  // value: 0,
  // icon: {
  //   type: 'money-collect',
  // },
  // background: '#fff',
};
