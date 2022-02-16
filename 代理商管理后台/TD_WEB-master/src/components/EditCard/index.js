import React from 'react';
import { Card, Spin } from 'antd';
import PropTypes from 'prop-types';
import './editor-card.less';

export const EditCard = (props) => {
  const { children, title, subTitle, editable, onEditClick, loading, operationText } = props;
  const titleHead = <h3>{title}<small>{subTitle}</small></h3>;
  const editorText = editable && <a onClick={onEditClick}>{operationText}</a>;
  return (
    <Spin spinning={loading}>
      <Card className="card-head" title={titleHead} bordered={false} extra={editorText}>
        {children}
      </Card>
    </Spin>
  );
};
EditCard.propTypes = {
  children: PropTypes.oneOfType([
    PropTypes.object,
    PropTypes.array,
  ]).isRequired,
  title: PropTypes.string,
  subTitle: PropTypes.string,
  editable: PropTypes.bool,
  onEditClick: PropTypes.func,
  loading: PropTypes.bool,
  operationText: PropTypes.string,
};
EditCard.defaultProps = {
  subTitle: null,
  editable: false, // 是否可编辑，处于编辑态或没有编辑权限时不可编辑
  title: null,
  onEditClick: null,
  loading: false,
  operationText: '编辑',
};
