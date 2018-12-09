<template>
	<div class="panel-wrap">
		<div class="panel-inner">
			<h1 class="big-title">wsChat</h1>
			<div class="panel">
				<h3 class="small-title">账号密码登录</h3>
				<p class="tip">登录需账号，还没<router-link to="register">注册</router-link>，请注册。</p>
				<div class="panel-main">
					<div class="input-row">
						<input type="text" placeholder="账号或邮箱" v-model="obj.key">
						<span class="iconfont icon-offline" v-if="obj.key!=''" @click="obj.key=''"></span>
					</div>
					<div class="input-row">
						<input type="password" placeholder="密码" v-model="obj.password">
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
import {mapActions} from 'vuex'
export default{
	data(){
		return{
			obj: {
				key: '',
				password: ''
			}
		}
	},
	methods:{
		...mapActions({
			send: 'data/send'
		}),
		submit(){
			this.$set(this.obj,'user_account',this.obj.key);
			this.$set(this.obj,'email',this.obj.key);
			this.send({
				type: 'login',
				user: this.obj
			});
		}
	}
}
</script>

<style scoped>
@import '../../assets/css/user.css';
</style>