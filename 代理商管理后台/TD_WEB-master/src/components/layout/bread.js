import React from 'react';
import PropTypes from 'prop-types';
import { Breadcrumb, Icon } from 'antd';
import pathToRegexp from 'path-to-regexp';
import { Link } from 'react-router-dom';
import './layout.less';
import { queryArray } from '../../utils';


const Bread = ({ menu, location }) => {
  const normalizePath = (str) => {
    return str.startsWith('/') ? str : `/${str}`;
  };

  // 匹配当前路由
  let pathArray = [];
  let path = normalizePath(location.pathname);

  let current = menu.find(item => {
    return item.router && pathToRegexp(item.router).exec(path);
  });
  const getPathArray = (item) => {
    pathArray.unshift(item);
    if (item.bpid) {
      getPathArray(queryArray(menu, item.bpid, 'id'));
    }
  };

  if (!current) {
    pathArray.push({
      id: 404,
      name: 'Not Found',
    });
  } else {
    getPathArray(current);
  }

  // 递归查找父级
  const breads = pathArray.map((item, key) => {
    const content = (
      <span>{item.icon
        ? <Icon type={item.icon} style={{ marginRight: 4 }} />
        : ''}{item.name}</span>
    );
    return (
      <Breadcrumb.Item key={key}>
        {(pathArray.length - 1) !== key && item.router
          ? <Link to={item.router}>
            {content}
          </Link>
          : content}
      </Breadcrumb.Item>
    );
  });

  return (
    <div className="layout-bread">
      <Breadcrumb separator=">">
        {breads}
      </Breadcrumb>
    </div>
  );
};

Bread.propTypes = {
  menu: PropTypes.array.isRequired,
  location: PropTypes.object.isRequired,
};

export default Bread;
