import { combineReducers } from 'redux';
import { reducer as global } from './global';
import { reducer as dashboard } from '../pages/Dashboard/store';
import { reducer as order } from '../pages/Order/store';
import { reducer as device } from '../pages/Device/store';
import { reducer as money } from '../pages/Money/store';
import { reducer as personnel } from '../pages/Personnel/store';
import { reducer as agent } from '../pages/Agent/store';
import { reducer as account } from '../pages/Account/store';
import { reducer as active } from '../pages/Initialize/store';
import { reducer as reportCenter } from '../pages/ReportCenter/store';
import { reducer as financeCenter } from '../pages/FinanceCenter/store';
import { reducer as serviceCenter } from '../pages/ServiceCenter/store';
import { reducer as operationCenter } from '../pages/OperationCenter/store';
import { reducer as taxiGroup } from '../pages/Taxi/Group/store';
import { reducer as taxiDevice } from '../pages/Taxi/Device/store';
import { reducer as taxiOrder } from '../pages/Taxi/Order/store';
import { reducer as taxiAfterSales } from '../pages/Taxi/AfterSales/store';
import { reducer as download } from '../pages/DownloadModal/store';

const rootReducer = combineReducers({
  global,
  dashboard,
  account,
  order,
  agent,
  device,
  money,
  personnel,
  active,
  reportCenter,
  financeCenter,
  serviceCenter,
  operationCenter,
  taxiGroup,
  taxiDevice,
  taxiOrder,
  taxiAfterSales,
  download,
});

export default rootReducer;
