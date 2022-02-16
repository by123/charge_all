import React from 'react';
import PropTypes from 'prop-types';
import { Row, Col, Form } from 'antd';

const FormItem = Form.Item;

export const DetailList = ({ colSpan, itemCol, columns, dataSource }) => {
  const getLists = columns.map((list, index) => {
    const { key, label, render } = list;
    dataSource = dataSource || {};
    const value = (render && render instanceof Function) ? render(dataSource[key], dataSource, index) : dataSource[key];
    const itemProps = {
      label,
      ...itemCol,
    };

    return (
      <Col {...colSpan} {...list.colSpan} key={index} >
        <FormItem style={{ marginBottom: 0 }} {...itemProps} {...list.itemProps} >{value}</FormItem>
      </Col>
    );
  });

  return <Row gutter={24} type="flex" >{getLists}</Row>;
};

DetailList.propTypes = {
  colSpan: PropTypes.object,
  itemCol: PropTypes.object,
  columns: PropTypes.array.isRequired,
  dataSource: PropTypes.object,
  // formItemLayout: PropTypes.object,
};
DetailList.defaultProps = {
  colSpan: {
    xs: 24,
    sm: 12,
    // md: 12,
    // lg: 12,
    xl: 8,
    // xxl: 6,
  },
  // itemCol: {
  //   labelCol: { span: 10 },
  //   wrapperCol: { span: 14 },
  // },
  title: null,
  dataSource: {},
  itemCol: {
    wrapperCol: {
      xs: {
        span: 12,
      },
      sm: {
        span: 12,
      },
      xl: {
        span: 12,
      },
    },
    labelCol: {
      xs: {
        span: 10,
      },
      sm: {
        span: 10,
      },
      xl: {
        span: 10,
      },
    },
  },
};
