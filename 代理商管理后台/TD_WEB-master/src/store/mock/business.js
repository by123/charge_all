import Mock from 'mockjs';
import { parse } from 'query-string';

// 去掉对象中value值为空字符串的属性
function trim(obj) {
  const newObj = {};
  Object.keys(obj).forEach(key => {
    obj[key] === '' || (newObj[key] = obj[key]);
  });
  return newObj;
}

export const intentionList = ({ url }) => {
  const query = trim(parse(url.split('?')[1]));
  const {
    mobile = /1[3-8]\d{9}/,
    name = '@cname',
    submitStartTime,
    submitEndTime,
    pageIndex = 1,
    pageSize = 20,
  } = query;
  const submitTime = submitStartTime && submitEndTime && `@integer(${submitStartTime}, ${submitEndTime})` || '@datetime("T")';
  return Mock.mock({
    code: 0,
    msg: 'ok',
    data: {
      [`items|${pageSize}`]: [{
        'id|+1': 0,
        mobile,
        name,
        borrowReason: '@cword(5, 10)',
        submitTime,
      }],
      pageIndex,
      pageSize,
      pagesCount: 1,
      totalRowsCount: `@integer(${pageIndex * pageSize}, 100000)`,
    },
  });
};

export const orderList = ({ url }) => {
  const query = trim(parse(url.split('?')[1]));
  const {
    requisitionNumber = /\d{9}/,
    channelName = '@cword(5, 10)',
    customerName = '@cname',
    productType = /(policy_loans)|(car_instalments)/,
    submitStartTime,
    submitEndTime,
    requisitionStatus = /(submitted)|(auditing)|(failpayment)|(rejected)|(canceled)|(waitpayment)|(waitloan)|(loaned)/,
    pageIndex = 1,
    pageSize = 20,
  } = query;
  const submitTime = submitStartTime && submitEndTime && `@integer(${submitStartTime}, ${submitEndTime})` || '@datetime("T")';
  return Mock.mock({
    code: 0,
    msg: 'ok',
    data: {
      [`items|${pageSize}`]: [{
        'id|+1': 0,
        requisitionNumber,
        channelCode: '@string',
        channelName,
        productType,
        customerName,
        submitTime,
        borrowAmount: '@float(0, 100000000, 0, 2)',
        requisitionStatus,
        manualFlag: '@boolean',
      }],
      pageIndex,
      pageSize,
      pagesCount: 1,
      totalRowsCount: `@integer(${pageIndex * pageSize}, 100000)`,
    },
  });
};

export const orderDetail = {
  code: 0,
  msg: 'ok',
  data: {
    requisitionVO: {
      'id|+1': 0,
      requisitionNumber: '@string',
      channelCode: '@string',
      channelName: '@string',
      productType: /(policy_loans)|(car_instalments)/,
      productName: '@string',
      requisitionStatus: /(submitted)|(auditing)|(rejected)|(canceled)|(waitpayment)|(failpayment)|(waitloan)|(loaned)/,
      borrowAmount: '@float(0, 100000000, 0, 2)',
      serviceFeeRate: '@float(0, 10, 0, 2)',
      serviceFee: '@float(0, 100000000, 0, 2)',
      interestRate: '@float(0, 10, 0, 2)',
      borrowStartTime: '@datetime("T")',
      borrowEndTime: '@datetime("T")',
      submitTime: '@datetime("T")',
    },
    customerVO: {
      companyName: '@string',
      businessLicence: '@string',
      licencePicture: '@dataImage',
      insuranceCompany: '@string',
      insuranceBranch: '@string',
      idNum: /\d{15,17}[\dX]/,
      phone: /1[3-8]\d{9}/,
      bankCard: /\d{15,17}[\dX]/,
      bankName: '@string',
      bankBranch: '@string',
      bankCardPicture: '@dataImage',
      idFront: '@dataImage',
      idBack: '@dataImage',
    },
    'durationVOList|0-10': [{
      'id|+1': 0,
      'contractId|+1': 0,
      duration: /\d/,
      carNum: /\d/,
      insuranceNum: /\d/,
      borrowAmount: '@float(0, 100000000, 0, 2)',
      borrowStartTime: '@datetime("T")',
      borrowEndTime: '@datetime("T")',
      repayDayType: /(initial_payment)|(final_payment)/,
      repayType: /(principal_interest)/,
      percentage: '@float(0, 10, 0, 2)',
    }],
  },
};

export const orderOperationRecord = {
  code: 0,
  msg: 'ok',
  'data|0-10': [{
    'id|+1': 0,
    createAt: '@datetime("T")',
    name: '@cname',
    roles: ['财务员', '审核员'],
    mobile: /1[3-9]\d{9}/,
    operationType: /(cancel)|(confirmPaid)|(withhold)|(audit)/,
    operationRemark: '@string',
    attachments: '@string',
  }],
};

export const vehicleDetail = {
  code: 0,
  msg: 'ok',
  'data|0-10': [{
    'id|+1': 0,
    drivingLicense: /\d{9}/,
  }],
};

export const insuranceDetail = {
  code: 0,
  msg: 'ok',
  data: {
    borrowAmount: '@float(0, 100000000, 0, 2)',
    commercialInsuranceAmount: '@float(0, 100000000, 0, 2)',
    commercialInsuranceNumber: /\d{9}/,
    commercialInsuranceStart: '@datetime("T")',
    commercialInsuranceEnd: '@datetime("T")',
    compulsoryInsuranceAmount: '@float(0, 100000000, 0, 2)',
    compulsoryInsuranceNumber: /\d{9}/,
    compulsoryInsuranceStart: '@datetime("T")',
    compulsoryInsuranceEnd: '@datetime("T")',
    taxAmount: '@float(0, 100000000, 0, 2)',
    drivingLicenseMain: '@dataImage',
    drivingLicenseAttach: '@dataImage',
    'resource|0-20': [
      {
        'id|+1': 0,
        resourceType: /(busi_insurance)|(drive_insurance)|(tax_insurance)/,
        resourcePicture: '@dataImage',
      },
    ],
  },
};

export const loanList = ({ url }) => {
  const query = trim(parse(url.split('?')[1]));
  const {
    requisitionNumber = /\d{9}/,
    channelName = '@cword(5, 10)',
    customerName = '@cname',
    productType = /(policy_loans)|(car_instalments)/,
    requisitionStatus = /(waitloan)|(loaned)/,
    pageIndex = 1,
    pageSize = 20,
  } = query;
  return Mock.mock({
    code: 0,
    msg: 'ok',
    data: {
      [`items|${pageSize}`]: [{
        'id|+1': 0,
        requisitionNumber,
        channelCode: '@string',
        channelName,
        productType,
        customerName,
        loanAmount: '@float(0, 100000000, 0, 2)',
        serviceFee: '@float(0, 100000000, 0, 2)',
        requisitionStatus,
        recordVO: {
          code: '@string',
          'imgKey|1-5': ['@dataImage'],
          remark: '@cword(5, 10)',
          overdueDays: '@integer(0, 100)',
        },
      }],
      pageIndex,
      pageSize,
      pagesCount: 1,
      totalRowsCount: `@integer(${pageIndex * pageSize}, 100000)`,
    },
  });
};

export const refundList = ({ url }) => {
  const query = trim(parse(url.split('?')[1]));
  const {
    requisitionNumber = /\d{9}/,
    contractCode = /\d{9}/,
    customerName = '@cname',
    refundStatus = /(waiting_refund)|(has_refund)|(fail_refund)|(overdue)|(waiting_withdraw)|(has_withdraw)/,
    refundBeginDate,
    refundEndDate,
    pageIndex = 1,
    pageSize = 20,
  } = query;
  const refundDate = refundBeginDate && refundEndDate && `@integer(${refundBeginDate}, ${refundEndDate})` || '@datetime("T")';
  return Mock.mock({
    code: 0,
    msg: 'ok',
    data: {
      [`items|${pageSize}`]: [{
        'id|+1': 0,
        contractCode,
        requisitionNumber,
        customerName,
        productType: /(policy_loans)|(car_instalments)/,
        refundPhase: /[3-9]/,
        refundAmount: '@float(0, 100000000, 0, 2)',
        overdueFines: '@float(0, 100000000, 0, 2)',
        refundDate,
        lastRefundDate: '@datetime("T")',
        refundTime: '@datetime("T")',
        refundStatus,
        manualFlag: '@boolean',
      }],
      pageIndex,
      pageSize,
      pagesCount: 1,
      totalRowsCount: `@integer(${pageIndex * pageSize}, 100000)`,
    },
  });
};

export const contractList = ({ url }) => {
  const query = trim(parse(url.split('?')[1]));
  const {
    contractCode = /\d{9}/,
    channelName = '@cword(5, 10)',
    customerName = '@cname',
    contractStatus = /(init)|(refunding)|(refunded)|(insreturning)|(insreturned)/,
    loanBeginDate,
    loanEndDate,
    pageIndex = 1,
    pageSize = 20,
  } = query;
  const loanDate = loanBeginDate && loanEndDate && `@integer(${loanBeginDate}, ${loanEndDate})` || '@datetime("T")';
  return Mock.mock({
    code: 0,
    msg: 'ok',
    data: {
      [`items|${pageSize}`]: [{
        'id|+1': 0,
        contractCode,
        requisitionNumber: /\d{9}/,
        channelName,
        productType: /(policy_loans)|(car_instalments)/,
        customerName,
        loanDate,
        lendAmount: '@float(0, 100000000, 0, 2)',
        totalPhase: /[3-9]/,
        refundPhase: /[1-2]/,
        contractStatus,
      }],
      pageIndex,
      pageSize,
      pagesCount: 1,
      totalRowsCount: `@integer(${pageIndex * pageSize}, 100000)`,
    },
  });
};

export const contractDetail = {
  code: 0,
  msg: 'ok',
  data: {
    contractBaseDetailVO: {
      contractId: '@string',
      contractCode: '@string',
      carCount: '@integer(1, 100)',
      insuranceCount: '@integer(1, 100)',
      requisitionNumber: '@string',
      channelNo: '@string',
      channelName: '@string',
      lendAmount: '@float(0, 100000000, 0, 2)',
      totalPhase: /[1-9]/,
      lendBeginDate: '@datetime("T")',
      lendEndDate: '@datetime("T")',
      rate: '@float(0, 100000000, 0, 2)',
    },
    productVO: {
      productType: /(policy_loans)|(car_instalments)/,
      productName: '@string',
      repayDayType: '等本等息 期末还款',
      serviceFeeRate: '@float(0, 10000, 0, 2)',
      interestRate: '@float(0, 10000, 0, 2)',
      otherFeeRate: '@float(0, 10000, 0, 2)',
      prepaymentPenaltyRate: '@float(0, 10000, 0, 2)',
      prepaymentDays: '@integer(1, 100)',
      maxOverdueDays: '@integer(1, 100)',
      overdueFineRate: '@float(0, 10000, 0, 2)',
      overdueFineRate1: '@float(0, 10000, 0, 2)',
    },
    'refundVO|0-10': [{
      'id|+1': 0,
      'refundPhase|+1': 0,
      refundAmount: '@float(0, 100000000, 0, 2)',
      overdueFines: '@float(0, 100000000, 0, 2)',
      refundDate: '@datetime("T")',
      lastRefundDate: '@datetime("T")',
      refundTime: '@datetime("T")',
      refundStatus: /(waiting_refund)|(has_refund)|(fail_refund)|(overdue)|(waiting_withdraw)|(has_withdraw)/,
    }],
  },
};
