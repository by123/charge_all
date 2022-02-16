import React from 'react';
import { Button } from 'antd';
import isEqual from 'lodash/isEqual';
import PropTypes from 'prop-types';

export class DerivedState extends React.Component {
  state = {
    prevFileList: this.props.fileList,
    fileList: null,
  }
  static getDerivedStateFromProps(props, state) {
    let newState = null;
    if (props.fileList !== state.prevFileList) {
      newState = {
        prevFileList: props.fileList,
      };
      const fileList = props.fileList.map(file => ({ uuid: file }));
      if (!isEqual(fileList, state.fileList)) {
        newState = {
          ...newState,
          fileList,
        };
      }
    }
    return newState;
  }
  addFile = () => {

    const fileList = this.state.fileList.concat({ uuid: `file-${Math.floor(Math.random() * 1000)}` });
    this.setState({ fileList });
    setTimeout(() => {
      this.props.onFileChange(fileList.map(file => file.uuid));
    }, 2000);
  }
  render() {
    return (<div>
      <h1>派生state</h1>
      <Button onClick={this.addFile}>添加一个</Button>
      <pre>
        {JSON.stringify(this.state.fileList)}
      </pre>
      <pre>
        {JSON.stringify(this.props.fileList)}
      </pre>
    </div>);
  }
}

DerivedState.propTypes = {
  onFileChange: PropTypes.func.isRequired,
  fileList: PropTypes.array.isRequired,
};
