import { parse } from 'query-string';

export default function queryStringMiddleware() {
  return next => action => {
    if (action.type === '@@router/LOCATION_CHANGE') {
      const query = parse(action.payload.location.search);
      const payload = {
        ...action.payload,
        location: {
          ...action.payload.location,
          query,
        },
      };
      const newAction = {
        ...action,
        payload,
      };
      return next(newAction);
    }
    return next(action);
  };
}
