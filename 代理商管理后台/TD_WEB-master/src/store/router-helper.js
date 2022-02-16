/**
 * 由于react-router v4把location中的query属性去掉了
 * 路由参数的变化只能由router.location.search来控制
 * 而search是一个query-string，在拼装多个参数时不能使用（...）对象展开来处理就非常的麻烦
 * 需要在各种地方把query-string转成object，然后才能使用对象展开处理参数
 *
 * 所以这个helper提供了对query属性支持，把search的值和query同步起来
 * 这样使用时就像react-router v3一样，不用管search了，直接处理query就好
 *
 * 主要两件事:
 * 1. router变化时，通过subscribe，监听变化，把location.search 转换给 location.query
 * 2. 包装push和replace，将query转换成search，因为本质上只能改变search
 *
 */
import { push as originPush, replace as originReplace } from 'connected-react-router';
import { parse, stringify } from 'query-string';
import isEmpty from 'lodash/isEmpty';

/**
 * 将query转换成search
 * @param location
 * @returns {*}
 */
function mapQueryString(location) {
  if (typeof location === 'string') return location;
  if (isEmpty(location.query)) {
    location.search = null;
  } else {
    const defaultQuery = parse(location.search);
    if (defaultQuery.pageId) {
      defaultQuery.pageId = 1;
    }
    const query = {
      ...defaultQuery,
      ...location.query,
    };
    location.search = stringify(query);
  }
  return location;
}

export function push(location) {
  return originPush(mapQueryString(location));
}

export function replace(location) {
  return originReplace(mapQueryString(location));
}


/**
 *
 * 这里利用redux的subscribe特性，监听location变化，search的值转换并同步到query
 * @param store
 */
export const syncRouterQuery = (store) => {
  let location = null;
  return store.subscribe(() => {
    let nextLocation = store.getState().router.location;
    if (nextLocation !== location) {
      location = nextLocation;
      nextLocation.query = parse(nextLocation.search);
    }
  });
};
