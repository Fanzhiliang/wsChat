import Vue from 'vue'
import "babel-polyfill"
import Vuex from 'vuex'

Vue.use(Vuex)

import view from './view'
import data from './data'

export default new Vuex.Store({
	modules:{
		view,
		data
	}
})