export default{
	isShowBody: false,
	bodyIs: '',
	isShowEditor: false,
	isShowAudio: true,
	isShowAlert: typeof Notification == 'function' && Notification.permission == 'granted',
	isCtrlEnter: false,
	sidebarLoading: false,//右侧的loading
}