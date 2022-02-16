/* eslint-disable no-unused-vars */
import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import { Button, Input, message, Form, List } from 'antd';

import { get, post } from '@/utils/request';
import { api } from '@/store/api';

import { LifeCycle } from './LifeCycle';

const FormItem = Form.Item;
const demoList = [
  {
    title: '定时器页面',
    url: '/timer',
    desc: '手动触发定时器',
  }, {
    title: 'Form Demo组件',
    url: '/form',
    desc: '包含基本的表单使用，文件上传表单，动态生成表单',
  }, {
    title: '图片上传组件',
    url: '/upload',
    desc: '将图片上传至七牛',
  }, {
    title: '批量图片上传',
    url: '/multiUpload',
    desc: '将图片批量上传至七牛，生成对应目录结构，未完待续',
  }, {
    title: 'Modal弹窗组件',
    url: '/modal',
    desc: '弹窗的基本使用',
  }, {
    title: '拖拽移动组件',
    url: '/sort',
    desc: '在弹窗中表格的使用',
  }, {
    title: '表格组件',
    url: '/table',
    desc: '在弹窗中表格的使用',
  }, {
    title: '树型组件',
    url: '/tree',
    desc: '树型组件的简单使用',
  }];
const imgList = [
  'http://oyu1zoloe.bkt.clouddn.com/FtbrOmv0dpt_UMV48-pOk5efqy2A',
  'http://oyu1zoloe.bkt.clouddn.com/FgZqao5S66axFGIoNaM1NhwcDGfD',
  'http://oyu1zoloe.bkt.clouddn.com/Fi3-thoWQ0g-prO5azF_gEF2m5y-',
];
class Playground extends React.Component {
  state = {
    imageURL: '',
    imageUUID: '',
    visible: false,
    index: 0,
    fileList: [],
    val: '',
  };

  componentDidMount() {
    console.log('playground did mount');
    setTimeout(() => {
      this.setState({
        fileList: ['aaaaa'],
      });
    }, 1000);
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevState.val !== this.state.val) {
      console.log('recordCursorPosition', this.input.selectionStart, this.inputPos);
      this.input.setSelectionRange(this.inputPos, this.inputPos);
    }
  }
  componentWillUnmount() {
    this.request && this.request.cancel();
  }


  getImageUrl = () => {
    if (!this.state.imageUUID || this.state.imageUUID.trim() === '') {
      message.warning('请输入图片uuid');
      return false;
    }
    this.request = get(api.getImageUrl, { fileName: this.state.imageUUID, isPublic: 0 });
    this.request.then(data => {
      this.setState({ imageURL: data });
    });
  }
  toggleVisible = (index) => {
    this.setState({
      index,
      visible: !this.state.visible,
    });
  }
  onFileChange = (fileList) => {
    this.setState({ fileList });
  }
  onChange = (e) => {
    const newValue = e.target.value;
    this.inputPos = this.input.selectionStart; // 记录光标位置
    this.setState({
      val: newValue.toUpperCase(),
    });
  }
  render() {
    const lifeProps = {
      // key: Date.now(),
      index: this.state.index,
      content: imgList,
      visible: this.state.visible,
      onClose: () => { this.setState({ visible: false }); },
    };

    const derivedStateProps = {
      fileList: this.state.fileList,
      onFileChange: this.onFileChange,
    };
    return (<div className="main-wrapper" style={{ padding: '10px' }}>
      {/* <DerivedState {...derivedStateProps} /> */}
      <input placeholder="控制光标位置" ref={dom => { this.input = dom; }} type="text" onChange={this.onChange} value={this.state.val} />
      <h1>Demo列表</h1>
      <List
        itemLayout="horizontal"
        dataSource={demoList}
        renderItem={item => (
          <List.Item>
            <List.Item.Meta
              title={<Link to={item.url}>{item.title}</Link>}
              description={item.desc}
            />
          </List.Item>
        )}
      />
      <FormItem label="获取私有空间图片完整地址">
        <Input value={this.state.imageUUID} onChange={(e) => this.setState({ imageUUID: e.target.value })} />
      </FormItem>
      <Button onClick={this.getImageUrl}>获取图片URL</Button>
      <pre>{this.state.imageURL}</pre>
      <br />
      {imgList.map((img, index) => (<img key={index} src={img} alt="img" width={100} onClick={this.toggleVisible.bind(null, index)} />))}
      <LifeCycle {...lifeProps} />
    </div>);
  }
}


export default Playground;
