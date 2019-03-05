import Vue from 'vue'

export default{
	setShowBody({commit},value){
		if(value===false || value===''){
			commit('setShowBody',false);
			commit('setBodyIs','');
		}else{
			commit('setShowBody',true);
			commit('setBodyIs',value);
		}
	},
	setShowEditor({commit},value){
		commit('setShowEditor',value);
	},
	setShowAudio({commit},value){
		commit('setShowAudio',value);
	},
	setShowAlert({commit},value){
		commit('setShowAlert',value);
	},
	setRidebarLoading({commit},value){
		commit('setRidebarLoading',value);
	},
	showAlert({commit},data){
		commit('showAlert',data);
	},
	setReturnView({commit},value){
		commit('setReturnView',value);
	},
	play({commit}){
		commit('play');
	},
	setGlobalLoading({commit},value){
		commit('setGlobalLoading',value);
	}
}