/* eslint-disable */
import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import { Modal, Divider, Button, Input } from 'antd';

class Portal extends React.Component {
  constructor(props) {
    super(props);
    this.el = document.createElement('div');
  }

  componentDidMount() {
    document.body.appendChild(this.el);
  }

  componentWillUnmount() {
    document.body.removeChild(this.el);
  }

  render() {
    return ReactDOM.createPortal(
      this.props.children,
      this.el,
    );
  }
}


/**
 * 对于PureComponent在shouldComponentUpdate中，会使用shallowEqual（浅比较）去比较判断是否要render
 * 当state或props是有某个属性是object类型时，当这个值重新被赋值，且这个值本身没有变化，赋了一样的值
 * shallowEqual还是会判断这个对象发生改变了，然后去re-render
 * 其实这样也ok了，正常用不会出现值改变了又没有re-render
 *
 * 除非直接去修改state里的对象
 * 例如： this.state.obj.property = 'xxx'，然后在setState({obj: this.state.obj}})
 * 这样老的state在render前的shouldComponentUpdate比较中就会返回false不进行render
 *
 */
export class LifeCycle extends React.Component {
  // static getDerivedStateFromProps (props, state) {
  //   /**
  //    * props或state发生改变时都会触发
  //    */
  //   console.log('>>>>>>>>derived state', props.visible, 'prev', state.prevVisible);
  //   if (props.visible !== state.prevVisible) {
  //     console.log('modal change....');
  //     return {
  //       index: props.visible ? props.index : state.index, // 打开才重新赋值，这个判断很重要
  //       prevVisible: props.visible,
  //     };
  //   }
  //   return null;
  // }
  constructor(props) {
    super(props);
    this.baseHeight = 200;
    this.state = {
      text: 'cac',
      index: this.props.index,
      // prevVisible: this.props.visible,
      height: 200,
      obj: {
        a1: 'a1',
        a2: 'a2',
      }
    }
    console.log('>>>>constructor invoked');
  }
  componentDidMount() {
    console.log('>>>>>>>>>>>>child did mount');
    // 如果组件在调用时，key发生改变，那么组件会重新加载
  }

  // shouldComponentUpdate(nextProps, nextState) {
  //   console.log(this.state, nextState);
  //   /**
  //    *  这是Component组件的默认的行为，直接返回true
  //    * 对于PureComponent，则会对state和props进行浅比较，如果不同才返回true
  //    */
  //   return true;
  // }

  componentWillUnmount() {
    console.log('>>>>>>>>>>>>child will unmount');

  }
  closeModal = () => {
    this.setState({
      visible: false,
    });
  }
  previous = () => {
    let index = this.state.index - 1;
    index = index < 0 ? 0 : index;
    this.setState({ index });
  }

  next = () => {
    let index = this.state.index + 1;
    index = index >= this.props.content.length ? this.state.index : index;
    console.log('next index', index);
    this.setState({ index });
  }
  scale = () => {
    this.zoom++;
    this.setState({
      height: this.baseHeight * this.zoom,
    });
  }
  resetObjState = () => {
    this.state.obj.a1 = '';
    this.state.obj.a2 = '';
    this.setState({ obj: { ...this.state.obj }});
  }
  render() {
    const { content, index } = this.props;
    console.log('child render... state index', this.state.index, ', props index', index, ', zoom', this.zoom);
    const src = content[this.state.index];
    const imgStyle = {
      height: `${this.state.height}px`,
    };
    return (<Modal visible={this.props.visible} onCancel={this.props.onClose}>
      <h1>Lift Cycle Test Component</h1>
      <Button onClick={() => { this.setState({ text: '' }); }}>重置文本框</Button>
      <Input value={this.state.text} onChange={(e) => { this.setState({ text: e.target.value })}} />
      <Divider />
      <Button onClick={this.resetObjState}>重置state</Button>
      <Input value={this.state.obj.a1} onChange={(e)=> { this.setState({ obj: { ...this.state.obj, a1: e.target.value }})}} />
      <Input value={this.state.obj.a2} onChange={(e)=> { this.setState({ obj: { ...this.state.obj, a2: e.target.value }})}} />
      <Divider />

      <Button onClick={this.previous}>上一张</Button>
      <Divider type="vertical" />
      <Button onClick={this.next}>下一张</Button>
      <Divider type="vertical" />
      <Button onClick={this.scale}>放大</Button>
      <div style={{ margin: 20 }}>
        <img style={imgStyle} ref={dom => { this.pRef = dom; }} src={src} alt="img" />
      </div>
    </Modal>);
  }
  resetImage = () => {

  }
  componentDidUpdate(prevProps, prevState) {
    console.log('prevProps', prevProps, ', this.props', this.props)
    if (prevProps.visible !== this.props.visible && this.props.visible) {
      console.log('model show');
      this.zoom = 1;
      const img = new Image();
      img.src = this.props.content[this.props.index];
      const height = img.height < this.baseHeight ? img.height : this.baseHeight;
      // if (this.state.index !== this.props.index) {
      //   console.log('>>>>>>>>>>>>>>>>child did update update update');
      //
      // }
      this.setState({
        index: this.props.index,
        height,
      });
      // show
      // setTimeout(() => {
      //   console.log('setTimeout', this.pRef);
      //   const style = this.pRef.style;
      //   style.width = '300px';
      //   style.height = '400px';
      // });
      //
      // console.log('直接获取：', this.pRef);
    }
  }
}

LifeCycle.propTypes = {
  index: PropTypes.number,
  visible: PropTypes.bool.isRequired,
  content: PropTypes.array.isRequired,
  onClose: PropTypes.func.isRequired,
};

