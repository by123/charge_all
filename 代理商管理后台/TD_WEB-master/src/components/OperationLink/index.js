import React from 'react';
import PropTypes from 'prop-types';
import { Divider } from 'antd';
/**
 *
 * @param options
 *
 * {
 *    key: 1,
 *    text: '编辑',
 *    action: 'eventHandle',
 * }
 *
 * @returns {*}
 * @constructor
 */
export const OperationLink = ({ options }) => {
  const [, ...children] = options.reduce((pre, next, index) => {
    const { key = index, text, action } = next;
    return [
      ...pre,
      <Divider key={`${key}-span`} type="vertical" />,
      <a key={`${key}-a`} onClick={action}>{text}</a>,
    ];
  }, []);

  return <span>{children.length === 0 ? '--' : children}</span>;
};
OperationLink.defaultProps = {
  options: [],
};
OperationLink.propTypes = {
  options: PropTypes.array,
};

