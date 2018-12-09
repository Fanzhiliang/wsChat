import Vue from 'vue'
import {setCookie,getCookie,delCookie} from '../../assets/js/utils.js'

export default{
	setUser(state,data){
		Vue.set(state,'user',data);
	},
	updateLoginKey(state){
		Vue.set(state,'loginKey',state.user.loginKey);
		setCookie('loginKey',state.user.loginKey,1);
	},
	exitLogin(state){
		Vue.set(state,'user',false);
		delCookie('loginKey');
	},
	setWs(state,data){
		Vue.set(state,'ws',data);
	},
	send(state,data){
		if(typeof state.ws.send == 'function'){
			state.ws.send(JSON.stringify(data));
		}
	},
	setRecordList(state,data){
		Vue.set(state,'recordList',data);
	},
	setFriendList(state,data){
		Vue.set(state,'friendList',data);
	},
	setGroupList(state,data){
		Vue.set(state,'groupList',data);
	}
}