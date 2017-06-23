// import App from './App'
const ignoreAuth = {authorization: false}
export default [
  {
    path: '/',
    name: 'index',
    component: r => require(['src/views/index.vue'], r),
    children: [
      {
        path: 'activity',
        name: 'activity',
        component: r => require(['src/views/activity/list.vue'], r)
      }
    ]
  }
]
