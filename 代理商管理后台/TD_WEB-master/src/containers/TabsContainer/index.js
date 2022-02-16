import React from 'react';
import PropTypes from 'prop-types';
import { Tabs } from 'antd';
import { connect } from 'react-redux';
import { push } from '../../store/router-helper';

const TabsContainer = ({ location, dispatch, onChange, children, ...otherProps }) => {
  const handleTabChange = (key) => {
    if (onChange) {
      onChange(key);
    } else {
      // 组件默认的处理方式，把分页信息更新到URL中去
      dispatch(push({ ...location, query: { tab: key } }));
    }
  };
  const { tab: activeKey } = location.query;
  let props = {
    onChange: handleTabChange,
    ...otherProps,
  };
  activeKey && (props.activeKey = activeKey);
  return (
    <Tabs {...props}>
      {children}
    </Tabs>
  );
};

TabsContainer.propTypes = {
  location: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  onChange: PropTypes.func,
  children: PropTypes.array.isRequired,
};

TabsContainer.defaultProps = {
  onChange: null,
};

const Container = connect(({ router: { location } }) => ({
  location,
}))(TabsContainer);
export { Container as TabsContainer };
