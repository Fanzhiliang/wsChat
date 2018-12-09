import Vue from 'vue'

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
	}
}