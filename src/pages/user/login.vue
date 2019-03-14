<template>
	<div class="panel-wrap">
		<div class="panel-inner">
			<h1 class="big-title">wsChat</h1>
			<div class="panel">
				<h3 class="small-title">账号密码登录</h3>
				<p class="tip">
					前往<router-link to="register">注册</router-link>
					<router-link to="reset" class="reset">忘记密码</router-link>
				</p>
				<div class="panel-main">
					<div class="input-row">
						<input type="text" id="key" name="key" placeholder="账号或邮箱" v-model="obj.key">
						<span class="iconfont icon-offline" v-if="obj.key!=''" @click="obj.key=''"></span>
					</div>
					<div class="input-row">
						<input type="password" id="password" name="password" placeholder="密码" v-model="obj.password">
						<span class="iconfont icon-offline" v-if="obj.password!=''" @click="obj.password=''"></span>
					</div>
					<div class="but-row">
						<button class="big" @click="submit">登录</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
import {mapState,mapActions} from 'vuex'
export default{
	data(){
		return{
			obj: {
				key: '',
				password: ''
			}
		}
	},
	computed:{
		...mapState({
			
		})
	},
	methods:{
		...mapActions({
			send: 'data/send',
			setUser: 'data/setUser',
			setFriend: 'data/setFriend',
			setGroup: 'data/setGroup'
		}),
		submit(){
			this.$set(this.obj,'user_account',this.obj.key);
			this.$set(this.obj,'email',this.obj.key);

			this.send({data: {
				type: 'login',
				user: this.obj
			},callback: (data)=>{
				this.setUser(data.list[0]);
				//清空好友和群信息防止，用户登录别的账号数据依然保持
				this.setFriend({});
				this.setGroup({});
				this.$router.push('/');
			}})
		}
	}
}
</script>

<style scoped>
@import '../../assets/css/user.css';
</style>