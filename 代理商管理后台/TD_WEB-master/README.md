# 炭电商户管理后台

> 支持hmr热更新，支持code split异步加载组件，整合react router和ant design组件库，支持redux进行数据流管理，使用redux-thunk和redux-promise进行异步数据流管理，使用mockjs模拟api请求，

## 框架构成

- Webpack v3
- React v16
- ReactRouter v4
- Redux v3(redux-thunk + redux-promise)
- AntDesign v3


## 开始使用

> **注意**：由于项目中ESLint配置了换行符统一为LR的方式，所以在使用Git 检出项目之前要确保autocrlf的配置时`input`或`false`
> 若没有设置请执行该命令：`git config --global core.autocrlf input`

### 安装依赖

	```
	yarn i
	```

### 启动服务

	```
	yarn start
	```

## 目录结构说明

- components 受控组件（傻瓜组件，无状态组件）
- containers 智能组件（有状态的组件）
- pages 页面，包括页面组件和页面model
- store 数据流相关文件
