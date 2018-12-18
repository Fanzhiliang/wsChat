<template>
	<div class="setting" @click="isShowSelect=false">
		<div class="wrap">
			<div class="user-info clearfix">
				<img :src="user.headPath" alt="" class="head" @click="setShowBody('userInfo')">
				<p class="user-name ellipsis" @click="setShowBody('userInfo')">{{user.user_name}}</p>
				<p class="user-number">{{user.user_account}}</p>
				<div class="status-toggle" @click.stop="isShowSelect=true">
					<span class="iconfont icon-online" v-if="user.status==1"></span>
					<span class="iconfont icon-stealth" v-else-if="user.status==2"></span>
					<span class="iconfont icon-offline" v-else></span>
					<div class="inner-list" v-show="isShowSelect">
						<p @click.stop="toggleStatus(1)"><span class="iconfont icon-online"></span>在线</p>
						<p @click.stop="toggleStatus(2)"><span class="iconfont icon-stealth"></span>隐身</p>
						<!-- <p @click.stop="toggleStatus(0)"><span class="iconfont icon-offline"></span>离线</p> -->
					</div>
				</div>
			</div>
			<div class="set-but" @click="setShowBody('setMessage')">
				消息相关设置<span class="iconfont icon-right"></span>
			</div>
			<div class="exit" @click="exit">退出当前账号</div>
		</div>
	</div>
</template>

<script>
import {mapState,mapActions} from 'vuex'
export default{
	data(){
		return{
			isShowSelect: false
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
			send: 'data/send',
			exitLogin: 'data/exitLogin'
		}),
		toggleStatus(status){
			if(typeof this.typeKeys['setStatus_success'] != 'function'){
				this.addTypeKeys({
					'setStatus_success': (data)=>{
						this.send({
							type: 'getUserByLoginKey',
							loginKey: this.loginKey
						})
					}
				})
			}
			this.setRidebarLoading(true);
			this.send({
				type: 'setStatus',
				loginKey: this.loginKey,
				status: status
			})
			this.isShowSelect = false;
		},
		exit(){
			this.$Tip.showTip('确定要退出吗？',{
				sure:()=>{
					this.exitLogin();
					this.$router.push('/login');
				}
			});	
		}
	}
}
</script>

<style>
.setting{
	
}
.wrap{
	position: absolute;
	width: 92%;
	padding: 15px 4%;
}
.user-info{
	height: 50px;
	padding: 20px;
	border: 1px solid #AFC8E2;
	border-radius: 5px;
	margin-bottom: 20px;
	position: relative;
}
.user-info .head{
	width: 45px;
	height: 45px;
	float: left;
	margin-right: 15px;
	cursor: pointer;
}
.user-info .user-name{
	font-size: 22px;
	cursor: pointer;
}
.user-info .user-number{
	color: #999999;
	font-size: 16px;
	padding-top: 10px;
}
.set-but{
	height: 40px;
	line-height: 40px;
	padding: 0 10px;
	border: 1px solid #AFC8E2;
	border-radius: 5px;
	font-size: 18px;
	cursor: pointer;
	margin-bottom: 20px;
}
.set-but .iconfont{
	color: #999999;
	float: right;
}
.exit{
	height: 40px;
	line-height: 40px;
	padding: 0 10px;
	color: #fff;
	text-align: center;
	background-color: #E13523;
	border-radius: 5px;
	cursor: pointer;
}
.icon-online{
	color: #09F175;
}
.icon-offline{
	color: #ADADAD;
}
.icon-stealth{
	color: #FFAA31;
}
.status-toggle{
	width: 40px;
	height: 17px;
	position: absolute;
	bottom: 20px;
	left: 200px;
	cursor: pointer;
}
.status-toggle::after{
	content: '';
	width: 0;
	height: 0;
	border: 5px solid transparent;
	border-top-color: #000;
	position: absolute;
	right: 10px;
	bottom: 0;
}
.inner-list{
	width: 80px;
	background-color: #fff;
	margin-left: -30px;
	margin-top: 10px;
	padding: 5px 0;
	border-radius: 3px;
	text-align: center;
	box-shadow: 1px 1px 5px #888888;
	overflow: hidden;
}
.inner-list p{
	padding: 5px;
	font-size: 14px;
}
.inner-list p:hover{
	background-color: #EDFAFF;
}
.inner-list p .iconfont{
	margin-right: 3px;
}
</style>