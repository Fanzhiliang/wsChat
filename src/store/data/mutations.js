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
	addTypeKeys(state,data){
		// Vue.set(state,'typeKeys',data);
		Object.assign(state.typeKeys,data);
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
	setDynamicLike(state,{index,likes,isLike}){
		Vue.set(state.dynamicList[index],'likes',likes);
		Vue.set(state.dynamicList[index],'hasMylike',!state.dynamicList[index].hasMylike);
	},
	setDynamicIndex(state,data){
		Vue.set(state,'dynamicIndex',data);
	},
	setChatType(state,data){
		Vue.set(state,'chatType',data);
	},
	setFriend(state,data){
		state.recordList.forEach((item,i)=>{//修改用户昵称同时修改消息记录
			if(item.id == data.user_id){
				Vue.set(state.recordList[i],'nickName',data.nickName);
			}
		})
		Vue.set(state,'friend',data);
	},
	setGroup(state,data){
		Vue.set(state,'group',data);
	}
}