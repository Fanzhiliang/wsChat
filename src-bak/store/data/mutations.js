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
		Vue.set(state,'loginKey','');
		delCookie('loginKey');
	},
	setWs(state,data){
		Vue.set(state,'ws',data);
	},
	setTypeKeys(state,data){
		Vue.set(state,'typeKeys',data);
	},
	send(state,data){
		if(typeof state.ws.send == 'function'){
			state.ws.send(JSON.stringify(data));
		}
	},
	setRecordList(state,data){//对数据进行排序
		Vue.set(state,'recordList',data);
	},
	setFriendList(state,data){
		Vue.set(state,'friendList',data);
	},
	setGroupList(state,data){
		Vue.set(state,'groupList',data);
	},
	setDynamicToggle(state,{index,data}){
		Vue.set(state.dynamicList[index],'isToggle',data);
	},
	clearDynamicList(state,data){
		Vue.set(state,'dynamicList',[]);
	},
	setDynamicList(state,data){
		Vue.set(state,'dynamicList',state.dynamicList.concat(data));
	},
	setDynamicIndex(state,data){
		Vue.set(state,'dynamicIndex',data);
	}
}