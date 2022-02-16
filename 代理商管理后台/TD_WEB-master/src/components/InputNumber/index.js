import React from 'react';
import PropTypes from 'prop-types';
import { InputNumber as Input } from 'antd';

/**
 * 让数字输入框带上后缀
 * @param suffix
 * @param otherProps
 * @returns {*}
 * @constructor
 */
export const InputNumber = ({ suffix, ...otherProps }) => {
  return <Input {...otherProps} formatter={value => value && `${value}${suffix}`} parser={value => value.replace(suffix, '')} />;
};

InputNumber.propTypes = {
  suffix: PropTypes.string,
};

InputNumber.defaultProps = {
  suffix: '',
};
