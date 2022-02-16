import React from 'react';
import PropTypes from 'prop-types';
import { replace, push } from '@/store/router-helper';
import { Icon, Button, Divider } from 'antd';
import { connect } from 'react-redux';
import { routes } from '../../menu';

class Header extends React.Component {
  static propTypes = {
    onSwitchSider: PropTypes.func.isRequired,
    siderFold: PropTypes.bool,
    location: PropTypes.object.isRequired,
    dispatch: PropTypes.func.isRequired,
  };

  static defaultProps = {
    siderFold: '',
  }

  handleBack = () => {
    this.props.dispatch(push('/'));
  }

  toggleDoc(path) {
    this.props.dispatch(push(path));
  }

  getDocType = () => {
    const { location: { pathname } } = this.props;
    let docType = /\/doc\/(biz|app)/.exec(pathname);
    docType = docType ? docType[1] : 'pc';
    return docType;
  }

  render() {
    const docType = this.getDocType();
    return (
      <div className="layout-header">
        {/* <div className="button" onClick={onSwitchSider.bind(this, siderFold)}>
          <Icon type={siderFold ? 'menu-fold' : 'menu-unfold'} />
        </div> */}
        <div className="nav">
          <Button
            onClick={() => this.toggleDoc(routes.pc.introduce)}
            type={docType === 'pc' ? 'primary' : 'default'}
          >PC端代理商操作手册</Button>
          <Button
            onClick={() => this.toggleDoc(routes.app.download)}
            type={docType === 'app' ? 'primary' : 'default'}
          >代理商APP操作手册</Button>
          <Button
            onClick={() => this.toggleDoc(routes.biz.introduce)} 
            type={docType === 'biz' ? 'primary' : 'default'}
          >商户操作手册</Button>
        </div>
        <Button style={{ marginRight: 20 }} onClick={this.handleBack}>返回炭电代理商后台</Button>
      </div>
    );
  }
}

export default connect()(Header);
