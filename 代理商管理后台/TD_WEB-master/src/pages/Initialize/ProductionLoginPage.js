import {
  Button, Form, Input, Row, Col,
} from 'antd';
import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { action } from './store';
import { replace } from '../../store/router-helper';
import { STATISTIC_KEY } from '../../utils/constants';
import './style.less';

const styles = {
  content: { height: 'calc(100vh - 200px)' },
};

class ProductionLoginPage extends React.Component {
  componentDidMount() {
    if (localStorage.getItem(STATISTIC_KEY)) {
      this.props.dispatch(replace('/initialize/productionStatistic'));
    }
  }

  submit = () => {
    const { dispatch, form, profile } = this.props;
    form.validateFieldsAndScroll((error, values) => {
      if (error) return;
      const params = {
        ...values,
      };
      if (profile.mchType === 2 && profile.roleType === 7) {
        params.factoryId = profile.userId;
      }
      dispatch(action.productionAuth(params));
    });
  }

  render() {
    const { form } = this.props;
    return (
      <div className="production-login" style={styles.content}>
        <div className="main">
          <Row>
            <Col span={14}>
              {form.getFieldDecorator('password')(
                <Input placeholder="请输入查看密码" onPressEnter={this.submit} />
              )}
            </Col>
            <Col span={6} offset={1}>
              <Button type="primary" className="search-button" onClick={this.submit}>提交</Button>
            </Col>
          </Row>
        </div>
      </div>
    );
  }
}

ProductionLoginPage.propTypes = {
  form: PropTypes.object.isRequired,
  dispatch: PropTypes.func.isRequired,
  location: PropTypes.object.isRequired,
  profile: PropTypes.object.isRequired,
};

const Container = Form.create()(ProductionLoginPage);

export default connect(({ active: {
  statisticsData,
}, global: { profile } }) => ({
  statisticsData,
  profile,
}))(Container);
