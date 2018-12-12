import {getCookie} from '../../assets/js/utils.js'

export default{
	loginKey: getCookie('loginKey')?getCookie('loginKey'):false,
	user: false,//用户信息
	ws: false,//WebSocket对象
	typeKeys: {},//type返回对象
	recordList: [],//消息列表
	friendList: [],//好友列表
	groupList: [],//群聊列表
	dynamicList: [],//动态列表
	dynamicIndex: 0,//要操作的动态index
}