import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

import { Filter } from '../../components/Filter';
import { push } from '../../store/router-helper';

class PageFilter extends React.PureComponent {
  handleFilterChange = (fields = {}) => {
    const { location, dispatch, onChange, onChangeSuccess } = this.props;
    if (onChange) {
      onChange(fields);
    } else {
      dispatch(push({ ...location, query: fields }));
    }
    // 某些情况下需要额外做一些事情
    onChangeSuccess && onChangeSuccess();
  };
  render() {
    return <Filter onFilterChange={this.handleFilterChange} {...this.props} />;
  }
}

PageFilter.propTypes = {
  location: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  onChange: PropTypes.func,
  onChangeSuccess: PropTypes.func,
};

PageFilter.defaultProps = {
  onChangeSuccess: () => {},
  onChange: null,
};

const Container = connect(({ router: { location } }) => ({
  location,
}))(PageFilter);

export { Container as PageFilter };
