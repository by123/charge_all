import React from 'react';
import marked from 'marked';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Divider, Icon, Button } from 'antd';
import { getDocType } from '@/utils';
import '../styles/markdown.less';

class AppDoc extends React.Component {
  static propTypes = {
    content: PropTypes.string,
    location: PropTypes.object.isRequired,
  }

  static defaultProps  = {
    content: '',
  }

  state = {
    content: '',
  }

  componentWillMount() {
    marked.setOptions({
      renderer: new marked.Renderer(),
			gfm: true,
			tables: true,
			breaks: true,
			pedantic: true,
			sanitize: true,
			smartLists: true,
			smartypants: true,
		});
  }

  shouldComponentUpdate(nextProps) {
    if (nextProps.location.hash !== this.props.location.hash) {
      return false;
    }
    return true;
  }

  handleDownload = () => {
    const baseUrl = 'https://xhdianpub.oss-cn-shenzhen.aliyuncs.com/doc';
    const linkObj = {
      biz: `${baseUrl}/biz/${encodeURIComponent('炭电商户操作指南.pdf')}`,
      app: `${baseUrl}/app/${encodeURIComponent('炭电代理商APP操作手册.pdf')}`,
      pc: `${baseUrl}/pc/${encodeURIComponent('炭电代理商PC端操作手册.pdf')}`,
    };
    const docType = getDocType(this.props.location.pathname);
    window.open(linkObj[docType], '_blank');
  }

  render() {
    return (<div>
      <div style={{ display: 'flex', paddingTop: '10px' }}>
        <span style={{ fontSize: 18, fontWeight: 600, flex: 1 }}>PC端代理商操作指南</span>
        <Button
          style={{ fontSize: 16, marginRight: 60, border: 'none' }}
          onClick={this.handleDownload}
        >
          <Icon type="download" />下载文档
        </Button>
      </div>
      <Divider />
      <div
        className="markdown-warpper"
        dangerouslySetInnerHTML={{
		      __html: marked(this.props.content),
			  }}
      ></div>
    </div>);
  }
}

export default connect()(AppDoc);
