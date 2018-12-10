import Vue from 'vue'

export default{
	setUser({commit},data){
		commit('setUser',data);
		commit('updateLoginKey');
	},
	exitLogin({commit}){
		commit('exitLogin');
	},
	setWs({commit},data){
		commit('setWs',data);
	},
	send({commit},data){
		commit('send',data);
	},
	setRecordList({commit},data){
		commit('setRecordList',data);
		Vue.nextTick(function(){
			let text = null;
			Array.prototype.forEach.call(document.querySelectorAll(".item p img"),function(oldNode){
				if(oldNode.getAttribute('alt') != 'face'){
					text = document.createTextNode('[ 图片 ]');
					oldNode.parentNode.replaceChild(text, oldNode);
				}
			})
		})
	},
	setFriendList({commit},data){
		commit('setFriendList',data);
	},
	setGroupList({commit},data){
		commit('setGroupList',data);
	},
	setDynamicToggle({commit},obj){
		commit('setDynamicToggle',obj);
	},
	clearDynamicList({commit}){
		commit('clearDynamicList');
	},
	setDynamicList({commit},data){
		commit('setDynamicList',data);
		Vue.nextTick(function(){
			Array.prototype.forEach.call(document.querySelectorAll(".dynamic-list .text"),function(item,i){
				if(item.clientHeight >= 108){
					document.querySelectorAll(".dynamic-list .toggle")[i].style.display = 'inline';
					commit('setDynamicToggle',{index: i,data: false});
				}
			})
		})
	}
}