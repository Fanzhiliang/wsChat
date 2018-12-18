<template>
	<div id="app" v-show="isWs">
		<router-view v-if="isConnect"/>
		<h1 class="connecting" v-loading="true" v-else>正在连接服务器...</h1>
	</div>
</template>

<script>
import {mapState,mapActions} from 'vuex'
export default {
	name: 'App',
	data(){
		return{
			isWs: true,//是否支持WebSocket
			isConnect: false,//是否连接上WebSocket
		}
	},
	computed:{
		...mapState({
			typeKeys:state=>state.data.typeKeys,
			user:state=>state.data.user,
			loginKey:state=>state.data.loginKey
		})
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody',
			setRidebarLoading: 'view/setRidebarLoading',
			addTypeKeys: 'data/addTypeKeys',
			setUser: 'data/setUser',
			setWs: 'data/setWs',
			send: 'data/send'
		}),
		getUserByLoginKey(){
			if(typeof this.typeKeys['getUserByLoginKey_success'] != 'function'){
				this.addTypeKeys({
					'getUserByLoginKey_success': (data)=>{
						this.setUser(data.list[0]);
						this.setRidebarLoading(false);
					}
				})
			}
			this.send({
				type: 'getUserByLoginKey',
				loginKey: this.loginKey
			})
		},
		checkLogin(){
	  		if(this.$route.path == '/'){//已经在登录或者注册页面时不用检查
	  			if(this.loginKey && this.user){
	  				
	  			}else if(this.loginKey && !this.user){//有loginKey但没用户信息时才去获取用户信息
	  				this.getUserByLoginKey();
	  			}else{//其它情况跳转到登录
	  				this.$router.push('/login');
	  			}
	  		}
	  	}
	},
	watch:{
  		$route(){
  			this.checkLogin();
  			this.setShowBody(false);
  		}
  	},
	created(){
		if('WebSocket' in window){
			let ws = new WebSocket('ws://127.0.0.1:8086');
			//let ws = new WebSocket('ws://120.78.128.4:443');
			ws.onmessage = (e)=>{
				let data = JSON.parse(e.data);
				console.log(data);
				if(data.err_code == 0){
					for(let key in this.typeKeys){
						if(data.type == key && typeof this.typeKeys[key] == 'function'){
							this.typeKeys[key](data);
						}
					}
					//this.setRidebarLoading(false);
				}else{
					this.$Tip.showTip(data.err_msg,{time:2});
					if(data.err_code == 1){//错误代码为1都是没登录时发生的
						if(this.$route.path == '/'){//已经在登录或者注册页面时不用检查
							this.$router.push('/login');
						}
					}
				}
			}
			ws.onopen = ()=>{
				this.checkLogin();
				this.isConnect = true;
				console.log('WebSocket连接成功!');
			}
			ws.onerror = ()=>{
				console.log('WebSocket出错!');
			};
			this.setWs(ws);
		}else{
			this.isWs = false;
			this.$Tip.showTip('浏览器不支持WebSocket，请升级浏览器!',{
				sure(){
					window.location.href = 'http://www.firefox.com.cn/';
				}
			});
		}
	}
}
</script>

<style>
@import 'assets/css/reset.css';
@import 'assets/css/common.css';
@import 'assets/css/editor.css';
@import 'assets/icon/iconfont.css';
#app {
	font-family: 'Avenir', Helvetica, Arial, sans-serif;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	position: relative;
}
h1.connecting{
	font-family: '微软雅黑','Helvetica Neue',Helvetica,Arial,sans-serif;
	text-align: center;
	font-size: 20px;
	position: fixed;
	width: 100%;
	top: 50%;
	left: 0;
	transform: translateY(-550%);
}
h1.connecting .v-loading-mask{
	top: -50px;
}
</style>
