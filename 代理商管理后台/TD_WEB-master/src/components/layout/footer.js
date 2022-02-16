import React from 'react';
import PropTypes from 'prop-types';
import { Layout } from 'antd';
import './layout.less';
import { COMPANY_NAME } from '../../utils/constants';

const { Footer } = Layout;

export default class CommonFooter extends React.Component {
  static propTypes = {
    className: PropTypes.string,
    buildYear: PropTypes.number,
  };
  static defaultProps = {
    className: '',
    buildYear: 2021,
  };

  render() {
    const now = new Date().getFullYear();
    const { buildYear } = this.props;

    const year = now === buildYear ? now : `${buildYear} - ${now}`;
    const webPage = (
      <a
        href="https://beian.miit.gov.cn"
        target="_blank"
        className="web-link"
      >粤ICP备2021080251号</a>);
    return (
      <Footer className={`layout-footer ${this.props.className}`}>
        {COMPANY_NAME} 版权所有 © {year} {webPage}
      </Footer>
    );
  }
}
