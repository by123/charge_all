import React from 'react';
import PropTypes from 'prop-types';
import { Form } from 'antd';
import './filter-item.less';

const FilterItem = ({
  label = '',
  children,
  validateProps,
}) => {
  const labelArray = label.split('');
  return (
    <div className="filter-container">
      {labelArray.length > 0
        ? <div className="label">
          {labelArray.map((item, index) => <span className="labelText" key={index}>{item}</span>)}
        </div>
        : ''}
      <div className="item">
        {validateProps ? <Form.Item>{children}</Form.Item> : <div className="item-content">{children}</div>}
      </div>
    </div>
  );
};

FilterItem.propTypes = {
  label: PropTypes.string,
  children: PropTypes.element.isRequired,
  validateProps: PropTypes.object,
};

FilterItem.defaultProps = {
  label: '',
  validateProps: null,
};

export default FilterItem;
