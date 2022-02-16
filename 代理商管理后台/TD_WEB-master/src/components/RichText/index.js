import React from 'react';
import PropTypes from 'prop-types';
import ReactQuill from 'react-quill';
import debounce from 'lodash/debounce';
import 'react-quill/dist/quill.snow.css';
import './editor.less';

class RichText extends React.Component {

  handleChange = debounce(this.props.onChange, 500);

  render() {
    const richTextProps = {
      theme: 'snow',
      modules: {
        toolbar: [
          [{ size: [] }],
          ['bold', 'italic', 'underline', 'strike'],
          [{ list: 'ordered' }, { list: 'bullet' }],
          [{ color: [] }, { background: [] }],
          [{ header: 1 }, { header: 2 }],
          ['clean'],
        ],
      },
      ...this.props,
      value: this.props.value || '',
      onChange: this.handleChange,
    };
    return <ReactQuill {...richTextProps} />;
  }
}

RichText.defaultProps = {
  onChange() {},
};
RichText.propTypes = {
  onChange: PropTypes.func,
  /* eslint-disable react/require-default-props */
  value: PropTypes.string,
};

export { RichText };
