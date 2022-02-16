/**
 * 页面列表组件，修改了antd的默认分页样式，
 * API与Table组件保持一致
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Table, Pagination } from 'antd';
import { connect } from 'react-redux';
import { EditableFormTable } from '../EditableFormTable';
import { push } from '../../store/router-helper';

const style = {
  display: 'flex',
  justifyContent: 'flex-end',
  padding: '16px 0',
};

const PageList = ({
  dispatch,
  location,
  rowKey,
  pagination = {},
  showPagination = true,
  queryDate,
  editable,
  ...otherProps
}) => {
  // if (queryDate) {
  //   const query = { pageId: 1, pageSize: 15, queryDate };
  //   dispatch(push({ ...location, query }));
  // }
  const { onChange } = pagination;
  const handlePageListChange = (pageId, pageSize) => {
    if (onChange) {
      onChange(pageId, pageSize);
    } else {
      // 组件默认的处理方式，把分页信息更新到URL中去
      let query = {};
      if (queryDate) {
        query = { pageId, pageSize, queryDate };
      } else {
        query = { pageId, pageSize };
      }
      dispatch(push({ ...location, query }));
    }
  };
  const props = {
    bordered: true,
    size: 'middle',
    ...otherProps,
    rowKey,
    pagination: false,
  };

  const paginationProps = {
    defaultPageSize: 15,
    defaultCurrent: 1,
    showSizeChanger: true,
    showQuickJumper: true,
    pageSizeOptions: ['10', '15', '20', '50', '100'],
    // showTotal: (total) => {
    //   return <div>共 {total} 条数据</div>;
    // },
    onChange: handlePageListChange,
    ...pagination,
    onShowSizeChange: handlePageListChange,
  };

  return (
    <div>
      {!editable ? <Table {...props} /> : <EditableFormTable tableProps={props} />}
      {showPagination && <div style={style}>
        <Pagination {...paginationProps} />
      </div>}
    </div>
  );
};

PageList.propTypes = {
  rowKey: PropTypes.string,
  pagination: PropTypes.shape({
    current: PropTypes.number.isRequired,
    pageSize: PropTypes.number.isRequired,
    total: PropTypes.number.isRequired,
    onChange: PropTypes.func,
  }),
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.object.isRequired,
  showPagination: PropTypes.bool,
  queryDate: PropTypes.string,
};

PageList.defaultProps = {
  rowKey: 'id',
  pagination: {
    current: 1,
    pageSize: 15,
    total: 0,
    onChange: null,
  },
  showPagination: true,
  queryDate: '',
};

const Container = connect(({ router: { location } }) => ({
  location,
}))(PageList);
export { Container as PageList };
