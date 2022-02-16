import React from 'react';
import { Input } from 'antd';

const AntdSearch = Input.Search;

export class Search extends React.PureComponent {
  render() {
    const props = {
      maxLength: 100, // 限制输入长度最大为100，通常用于列表条件过滤
      ...this.props,
    };
    return <AntdSearch {...props} />;
  }
}
