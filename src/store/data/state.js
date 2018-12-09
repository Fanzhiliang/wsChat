import {getCookie} from '../../assets/js/utils.js'

export default{
	loginKey: getCookie('loginKey')?getCookie('loginKey'):false,
	user: false,//用户信息
	ws: false,//WebSocket对象
	recordList: [],//消息列表
	friendList: [],//好友列表
	groupList: [],//群聊列表
}