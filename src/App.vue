<template>
	<div id="app" v-show="isWs">
		<template v-if="isConnect">
			<router-view/>
			<div v-loading2="isGlobalLoading" v-if="isGlobalLoading" class="global-mask"></div>
		</template>
		<h1 class="connecting" v-loading2="true" v-else>正在连接服务器...</h1>
		<audio src="/static/data/tip.mp3" style="display: none;"></audio>
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
			loginKey:state=>state.data.loginKey,
			groupList:state=>state.data.groupList,
			isGlobalLoading:state=>state.view.isGlobalLoading,
		})
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody',
			setRidebarLoading: 'view/setRidebarLoading',
			addTypeKeys: 'data/addTypeKeys',
			setUser: 'data/setUser',
			setWs: 'data/setWs',
			send: 'data/send',
			showAlert: 'view/showAlert',
			setGroupList: 'data/setGroupList',
			setFriendList: 'data/setFriendList',
			play: 'view/play'
		}),
		getUserByLoginKey(){
			this.send({data: {
				type: 'getUserByLoginKey',
				loginKey: this.loginKey
			},callback: (data)=>{
				this.setUser(data.list[0]);
				this.setRidebarLoading(false);
			}})
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
			// let ws = new WebSocket('ws://120.78.128.4:443');
			ws.onmessage = (e)=>{
				let data = JSON.parse(e.data);
				console.log(JSON.parse(JSON.stringify(data)));
				this.setRidebarLoading(false);//避免后端出错，loading一直出现的问题
				if(data.err_code == 0){
					//默认执行
					switch (data.type) {
						case 'friend_sendMsg'://好友发送消息给我
						case 'sendFriendMsg_success'://我发送消息给好友
						case 'group_sendMsg'://群有人发了消息
						//case 'sendGroupMsg_success'://我向群发送消息//后台会通过广播通知全部成员，所以发送成功后不用在获得
						case 'pass_join_group':
						case 'pass_add_friend':
							this.send({data: {type: 'getRecordList',loginKey: this.loginKey}})//重新获得消息记录
							this.play();
							break;
						case 'readed_success':
							this.send({data: {type: 'getRecordList',loginKey: this.loginKey}})
							break;
						case 'group_delete_me':
							this.send({data: {type: 'getRecordList',loginKey: this.loginKey}})
							this.showAlert({
								title: '提示',
								body: (data['from_group'].group_name+'群主' || '有人') + '把你踢出了群',
								icon: data['from_group'].headPath||'./static/img/user-head.png',
								callback: ()=>{}
							})
							break;
						case 'apply_join_group':
							this.send({data: {type: 'getRecordList',loginKey: this.loginKey}})
							this.showAlert({
								title: (data['from_user'].user_name || '有人') + '申请加入' + data['apply_group'].group_name,
								body: data.content || '进群申请',
								icon: data['from_user'].headPath||'./static/img/user-head.png',
								callback: ()=>{}
							})
							break;
						case 'apply_add_friend':
							this.send({data: {type: 'getRecordList',loginKey: this.loginKey}})
							this.showAlert({
								title: (data['from_user'].user_name || '有人') + '想加你为好友',
								body: data.content || '好友申请',
								icon: data['from_user'].headPath||'./static/img/user-head.png',
								callback: ()=>{}
							})
							break;
						case 'apply_user_join_group':
							this.send({data: {type: 'getRecordList',loginKey: this.loginKey}})
							this.showAlert({
								title: (data['from_user'].user_name || '有人') + '邀请你进'+data['from_group'].group_name,
								body: '进群邀请',
								icon: data['from_group'].headPath||'./static/img/user-head.png',
								callback: ()=>{}
							})
							break;
						case 'insertGroup_success':
							this.getUserByLoginKey();
							break;
					}
					//自定义执行
					if(typeof this.typeKeys[data.type] == 'function'){
						this.typeKeys[data.type](data);
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
				setInterval(()=>{
					this.send({data:{type:'ping'}});
				},120000)
				this.addTypeKeys({
					'pass_join_group': (data)=>{//申请加入成功
						if(data.user){
							this.setUser(data.user);
						}
						this.setGroupList(data.groupList);
					},
					'pass_add_friend': (data)=>{//申请好友成功
						if(data.user){
							this.setUser(data.user);
						}
						this.setFriendList(data.friendList);
					},
					'friend_delete_me': (data)=>{//被好友删除
						if(data.user){
							this.setUser(data.user);
						}
					}
				})
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
.global-mask{
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	z-index: 999999999999;
}
</style>
