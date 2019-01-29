import Vue from 'vue'

let isWindowMin = false;
window.addEventListener('blur', function(){isWindowMin = true});//当前页面失去焦点
window.addEventListener('focus', function(){isWindowMin = false});//当前页面获得焦点

export default{
	setShowBody(state,value){
		Vue.set(state,'isShowBody',value);
	},
	setShowEditor(state,value){
		Vue.set(state,'isShowEditor',value);
	},
	setBodyIs(state,value){
		Vue.set(state,'bodyIs',value);
	},
	setShowAudio(state,value){
		Vue.set(state,'isShowAudio',value);
	},
	setShowAlert(state,value){
		if(value && typeof Notification == 'function'){
			if(Notification.permission == 'granted'){
				Vue.set(state,'isShowAlert',value);
			}else{
				Notification.requestPermission((result)=>{
					Vue.set(state,'isShowAlert',result == 'granted');
				})
			}
		}else{
			Vue.set(state,'isShowAlert',false);
		}
	},
	setCtrlEnter(state,value){
		Vue.set(state,'isCtrlEnter',value);
	},
	setRidebarLoading(state,value){
		Vue.set(state,'sidebarLoading',value);
	},
	showAlert(state,{title,body,icon,callback}){
		if(!state.isShowAlert || !isWindowMin){return;}
		var notification = new Notification(title, {body,icon});
		notification.onclick = function(){
			if(typeof callback == 'function'){
				callback();
			}
			window.focus();
		}
	}
}