import React from 'react';
import PropTypes from 'prop-types';
import { Form } from 'antd';

import Upload from '../../containers/Upload'; // 具有拖拽功能的上传组件
import { UPLOADING } from '../../utils/constants';

/**
 * 文件上传表单组件
 *
 */

const PICTURE_CARD = 'picture-card';

const FormItem = Form.Item;

export class FileInput extends React.PureComponent {
  render() {
    const {
      form: {
        getFieldDecorator,
      },
      name,
      initialValue,
      rules,
      formItemProps,
      type,
      ...uploaderProps
    } = this.props;

    const initial = this.upload && this.upload.getWrappedInstance().initValue(initialValue);
    return (<FormItem {...formItemProps} >
      {getFieldDecorator(name, {
        initialValue: initial,
        // validateTrigger: [''], // 仅在提交的时候做校验, 这个方法不行，因为图片上传完后无法触发这个校验，在图片上传完成后还是显示图片上传中，
        rules: [
          {
            validator(rule, value, callback) {
              if (value && value.some(v => v.status === UPLOADING)) {
                callback('上传中，请稍候...');
              } else if (value && value.some(v => v.status === 'error')) {
                callback('有上传失败的图片，请移除或重新上传');
              } else {
                callback();
              }
            },
          },
          ...rules,
        ],
      })(<Upload {...uploaderProps} ref={instance => { this.upload = instance; }} listType={type} />)}
    </FormItem>);
  }
}

FileInput.propTypes = {
  form: PropTypes.object.isRequired,
  name: PropTypes.string.isRequired,
  type: PropTypes.string,
  formItemProps: PropTypes.object,
  initialValue: PropTypes.oneOfType([PropTypes.string, PropTypes.array]),
  rules: PropTypes.array,
};

FileInput.defaultProps = {
  initialValue: null,
  rules: [],
  formItemProps: {},
  type: PICTURE_CARD,
};
