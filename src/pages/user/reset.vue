<template>
	<div class="panel-wrap" v-loading="isLoading">
		<div class="panel-inner">
			<h1 class="big-title">wsChat</h1>
			<div class="panel">
				<h3 class="small-title">修改密码</h3>
				<p class="tip center">想起密码了，可以<router-link to="login">登录</router-link>。</p>
				<div class="panel-main">
					<div class="input-row">
						<input type="text" placeholder="绑定的邮箱" autocomplete="off" v-model="obj.email">
						<span class="iconfont icon-offline" v-if="obj.email!=''" @click="obj.email=''"></span>
					</div>

					<div class="input-row but-row">
						<input type="text" placeholder="验证码" autocomplete="off" class="small" v-model="obj.code">
						<button class="small" @click="getCode">{{text}}</button>
					</div>
					<div class="input-row">
						<input type="password" placeholder="新的密码" autocomplete="off" v-model="obj.password">
						<span class="iconfont icon-offline" v-if="obj.password!=''" @click="obj.password=''"></span>
					</div>
					<div class="input-row">
						<input type="password" placeholder="确认密码" autocomplete="off" v-model="obj.password2">
						<span class="iconfont icon-offline" v-if="obj.password2!=''" @click="obj.password2=''"></span>
					</div>
					<div class="but-row">
						<button class="big" @click="submit">修改</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
import {mapState,mapActions} from 'vuex'
import {getCode} from '@/api/api.js'
export default{
	data(){
		return{
			obj: {
				email:'',
				password:'',
				password2:'',
				code: ''
			},
			time: 60,
			isGetCode: false,
			cycleObj: false,
			isLoading: false
		}
	},
	computed:{
		...mapState({
			typeKeys:state=>state.data.typeKeys
		}),
		text(){
			return this.isGetCode?this.time+'s':'获取验证码';
		}
	},
	methods:{
		...mapActions({
			send: 'data/send',
			addTypeKeys: 'data/addTypeKeys',
			setUser: 'data/setUser',
			setShowBody: 'view/setShowBody'
		}),
		checkEmail(){
			if(!this.obj.email){
				this.$Tip.showTip('邮箱不能为空',{time:2});
				return false;
			}
			if(!(/^[A-Za-z\d]+([-_.][A-Za-z\d]+)*@([A-Za-z\d]+[-.])+[A-Za-z\d]{2,4}$/.test(this.obj.email))){
	        	this.$Tip.showTip('邮箱格式有误',{time:2});
	        	return false;
	        }
	        return true;
		},
		async getCode(){
			if(this.isGetCode || !this.checkEmail()){
				return;
			}
	        this.isLoading = true;
			let err_msg = await getCode({
				email: this.obj.email,
				type: 'reset'
			});
			this.isLoading = false;
			if(err_msg){//有错误信息
				this.$Tip.showTip(err_msg,{time:2});
			}else{
				this.isGetCode = true;
		        this.cycleObj = setInterval(()=>{
		        	--this.time;
		        	if(this.time == 0){
		        		this.isGetCode = false;
		        		this.time = 60;
		        		clearInterval(this.cycleObj);
		        	}
		        },1000);
			}
		},
		submit(){
			if(!this.checkEmail()){
				return;
			}
			if(!this.obj.password || !this.obj.password2){
				this.$Tip.showTip('密码不能为空',{time:2});
				return;
			}
			if(this.obj.password != this.obj.password2){
				this.$Tip.showTip('密码不相同',{time:2});
				return;
			}
			if(!this.obj.code){
				this.$Tip.showTip('验证码不能为空',{time:2});
				return;
			}
			if(typeof this.typeKeys['reset_success'] != 'function'){
				this.addTypeKeys({
					'reset_success': (data)=>{
						this.setUser(data.list[0]);
						this.$router.push('/');
						this.setShowBody('userInfo');
					}
				})
			}
			this.send({
				type: 'reset',
				user: this.obj
			});
		}
	}
}
</script>

<style scoped>
@import '../../assets/css/user.css';
</style>