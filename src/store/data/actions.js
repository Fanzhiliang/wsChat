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
	addTypeKeys({commit},data){
		commit('addTypeKeys',data);
	},
	send({commit},data){
		commit('send',data);
	},
	setRecordList({commit},data){
		data.sort(function(a,b){
			return a.sort == b.sort ? b.write_date - a.write_date : b.sort - a.sort;
		});
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
	setDynamicList({commit},{list,user_id}){
		list.forEach((item)=>{
			item.img_srcs = JSON.parse(item.img_srcs);
			item.hasMylike = item.likes.filter((item)=>{return item.user_id == user_id}).length>0;//我是否有点赞
		})
		commit('setDynamicList',list);
		Vue.nextTick(function(){
			Array.prototype.forEach.call(document.querySelectorAll(".dynamic-list .text"),function(item,i){
				if(item.clientHeight > 108){
					item.style.maxHeight = '108px';
					document.querySelectorAll(".dynamic-list .toggle")[i].style.visibility = 'initial';
					commit('setDynamicToggle',{index: i,data: false});
				}
			})
		})
	},
	setDynamicLike({commit},data){
		commit('setDynamicLike',data);
	},
	setDynamicIndex({commit},data){
		commit('setDynamicIndex',data);
	}
}