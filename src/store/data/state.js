import {setCookie,getCookie,delCookie} from '../../assets/js/utils.js'

let data = {
	loginKey: getCookie('loginKey')?getCookie('loginKey'):false,
	user: false,//用户信息
	ws: false,//WebSocket对象
	typeKeys: {},//type返回对象
	recordList: [],//消息列表
	friendList: [],//好友列表
	groupList: [],//群聊列表
	dynamicList: [],//动态列表
	dynamicIndex: false,//要操作的动态index
	chatType: '',//聊天类型 friend group
	friend: {},//选择的好友
	group: {},//选择的群聊
	keyword: '',//搜索关键字
	searchList: {},//搜索列表
	isSaveRecord: (function(){//是否保存登录记录
		var result = localStorage.getItem('isSaveRecord')?localStorage.getItem('isSaveRecord'):false;
		if(!result){
			delCookie('loginKey');
		}
	})(),
}

export default data;