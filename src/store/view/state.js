export default{
	isShowBody: false,
	bodyIs: '',
	isShowEditor: false,
	isShowAudio: true,
	isShowAlert: typeof Notification == 'function' && Notification.permission == 'granted',
	sidebarLoading: false,//右侧的loadingzz
	returnView: '',//返回的组件
	isGlobalLoading: false
}