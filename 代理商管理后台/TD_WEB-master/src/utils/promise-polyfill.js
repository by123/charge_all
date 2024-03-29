const then = Promise.prototype.then;


Promise.prototype._getPrevPromise = function () {
  return this._prev || null;
};

Promise.prototype._getRootPromise = function () {
  return this._root || this;
};

Promise.prototype.then = function (onFulfilled, onRejected) {
  const rootPromise = this._getRootPromise();
  const currentPromise = this;
  let fulfilledWrapper = null;
  let rejectedWrapper = null;

  if (onFulfilled) {
    fulfilledWrapper = function (data) {
      if (rootPromise.isCancelled()) return;
      return onFulfilled(data);
    };
  }

  if (onRejected) {
    rejectedWrapper = function (data) {
      if (rootPromise.isCancelled()) return;
      return onRejected(data);
    };
  }

  const returnPromise = then.apply(this, [fulfilledWrapper, rejectedWrapper]);
  returnPromise._root = rootPromise;
  returnPromise._prev = currentPromise;
  return returnPromise;
};

Promise.prototype.cancel = function () {
  this._getRootPromise()._isCancelled = true;
  return true;
};

Promise.prototype.isCancelled = function () {
  return this._getRootPromise()._isCancelled;
};

Promise.prototype.done = function (onFulfilled, onRejected) {
  this.then(onFulfilled, onRejected)
    .catch((reason) => {
      // 抛出一个全局错误
      setTimeout(() => { throw reason; }, 0);
    });
};

Promise.prototype.finally = function (callback) {
  let P = this.constructor;
  return this.then(
    value => P.resolve(callback()).then(() => value),
    reason => P.resolve(callback()).then(() => { throw reason; })
  );
};
