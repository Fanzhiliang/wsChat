<template>
	<div class="userInfo" v-loading2="isLoading">
		<div class="title">
			<span class="iconfont icon-left" @click="setShowBody(false)"></span>
			用户信息
			<span class="iconfont icon-edit" @click="isEdit=true" v-if="!isEdit"></span>
			<span class="pub" @click="reset();isEdit=false;" v-else>取消</span>
		</div>
		<div class="info-wrap">
			<div class="info-inner clearfix">
				<div class="start-upload" :style="'background-image:url('+(headResult||user.headPath||'static/img/user-head.png')+')'">
					<img src="@/assets/img/upload.png" alt="" v-if="isEdit">
					<input type="file" accept="image/*" class="hide" ref="head" @change="fileChange($event)">
					<div class="mask" v-if="isEdit" @click="startUpload"></div>
				</div>
				<p class="nickname ellipsis" :title="user.user_name" v-if="!isEdit">{{user.user_name}}</p>
				<p class="nickname" :title="user.user_name" v-else>
					<input type="text" class="name" v-model="user.user_name">
				</p>

				<div class="input-row">
					<label for="">账号</label>
					<p class="value ellipsis" :title="user.user_account">{{user.user_account}}</p>
				</div>

				<div class="input-row">
					<label for="">邮箱</label>
					<p class="value ellipsis" :title="user.email">{{user.email}}</p>
				</div>

				<div class="input-row">
					<label for="">年龄</label>
					<p class="value ellipsis" v-if="!isEdit">{{user.age}}岁</p>
					<p class="value ellipsis" v-else>
						<input type="text" class="age" v-model="user.age">岁
					</p>
				</div>

				<div class="input-row">
					<label for="">地区</label>
					<p class="value ellipsis" :title="user.area">
						{{user.area||'无'}}<span class="iconfont icon-edit" @click="isShowArea=true" v-if="isEdit"></span>
					</p>
				</div>

				<div class="input-row">
					<label for="">电话</label>
					<p class="value ellipsis" :title="user.phone" v-if="!isEdit">{{user.phone}}</p>
					<p class="value ellipsis" v-else>
						<input type="text" class="normal" v-model="user.phone">
					</p>
				</div>

				<div class="input-row">
					<label for="nickame">性别</label>
					<p class="value ellipsis">
						{{user.sexName}}<span class="iconfont icon-edit" @click="isShowSex=true" v-if="isEdit"></span>
					</p>
				</div>

				<div class="input-row sign">
					<label for="">签名</label>
					<p class="value" :title="user.sign" v-if="!isEdit">{{user.sign}}</p>
					<p class="value ellipsis" v-else>
						<input type="text" class="sign" v-model="user.sign">
					</p>
				</div>
			</div>
			<div class="info-buts" v-if="isEdit">
				<button @click="save" class="save">保存</button>
				<button @click="reset" class="reset">重置</button>
			</div>
		</div>
		<areaSelecter :isShow.sync="isShowArea" :areaString.sync="user.area" :areaArray.sync="user.areaArray"/>
		<sexSelecter :isShow.sync="isShowSex" :sexName.sync="user.sexName" :sexId.sync="user.sex"/>
		<headSelecter :isShow.sync="isShowHead" :src.sync="headSrc" :head="$refs.head" :result.sync="headResult"/>
	</div>
</template>

<script>
import {mapState,mapActions} from 'vuex'
import areaSelecter from '@/components/area-selecter';
import sexSelecter from '@/components/sex-selecter';
import headSelecter from '@/components/head-selecter';
export default{
	data(){
		return{
			user: {},
			other: {},
			isEdit: false,
			isShowSex: false,
			isShowArea: false,
			isShowHead: false,
			headSrc: '',
			headResult: '',
			isLoading: false
		}
	},
	computed:{
		...mapState({
			stateUser:state=>state.data.user,
			loginKey:state=>state.data.loginKey
		})
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody',
			setUser: 'data/setUser',
			send: 'data/send'
		}),
		startUpload(){
			this.$refs.head.click();
		},
		fileChange(e){
        	let file = e.target.files[0];
	        let reader = new FileReader();
          	let handler = (e)=>{
            	this.headSrc = e.target.result;
            	this.isShowHead = true;
            	reader.removeEventListener('load',handler);
          	};
          	reader.addEventListener('load',handler);
          	reader.readAsDataURL(file);
      	},
		reset(){
			this.headSrc = '';
			this.headResult = '';
			this.$refs.head.value = '';
			this.user = Object.assign({},this.other);
			this.isShowSex=false;
			this.isShowArea=false;
			this.isShowHead=false;
		},
		save(){
			if(this.headResult){//有更换头像
				this.user.headPath = this.headResult;
			}

			this.isLoading = true;
			
			this.send({data: {
				type: 'updateUser',
				loginKey: this.loginKey,
				info: Object.assign(this.user,{areaArray: JSON.stringify(this.user.areaArray)})
			},callback: (data)=>{
				this.setUser(data.list[0]);
				this.user = Object.assign({},data.list[0]);
				this.$set(this.user,'areaArray',JSON.parse(this.user.areaArray));
				this.other = Object.assign({},this.user);
				this.isLoading = false;
				this.isEdit = false;
			}})
		}
	},
	activated(){
		this.user = Object.assign({},this.stateUser);
		this.$set(this.user,'areaArray',JSON.parse(this.stateUser.areaArray));
		this.other = Object.assign({},this.user);
	},
	deactivated(){
		this.reset();
		this.isEdit = false;
	},
	components:{
		areaSelecter,
		sexSelecter,
		headSelecter
	}
}
</script>

<style scoped>
.userInfo{
	width: 100%;
	height: 100%;
	padding-top: 40px;
	background-color: #ECF1F7;
	box-sizing: border-box;
	position: relative;
}
.title{
	width: 100%;
	height: 40px;
	line-height: 40px;
	position: absolute;
	left: 0;
	top: 0;
	text-align: center;
	color: #fff;
	background-color: #9BB7F1;
	font-size: 20px;
}
.title .icon-left{
	position: absolute;
	left: 10px;
	height: 100%;
	font-size: 18px;
	cursor: pointer;
}
.title .icon-edit{
	position: absolute;
	right: 10px;
	height: 100%;
	font-size: 18px;
	cursor: pointer;
}
.title .pub{
	position: absolute;
	right: 10px;
	height: 100%;
	font-size: 16px;
	cursor: pointer;
}
.info-wrap{
	width: 100%;
	min-height: 100%;
	padding-right: 17px;
	overflow-x: hidden;
	overflow-y: scroll;
}
.info-inner{
	padding: 22% 2% 4% 4%;
	position: relative;
}
.start-upload{
	background-size: 100% 100%;
	background-repeat: no-repeat;
	background-position: 0 0;
	position: absolute;
	top: 0;
	left: 50%;
	transform: translateX(-50%);
	width: 14%;
	padding-top: 14%;
	margin-top: 2%;
	border: 1px solid #d3d3d3;
	box-shadow: 1px 1px 10px rgba(136, 136, 136, 0.8);
	cursor: pointer;
}
.start-upload img{
	width: 30%;
	position: absolute;
	right: 3px;
	bottom: 3px;
	background-color: rgb(255,255,255,0.5);
	border-radius: 5px;
}
.start-upload .mask{
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	cursor: pointer;
	z-index: 9;
}
.nickname{
	width: 30%;
	position: absolute;
	left: 50%;
	top: 0;
	margin-top: 18.5%;
	text-align: center;
	transform: translateX(-50%);
}
.input-row{
	height: 20px;
	line-height: 20px;
	margin-top: 4.5%;
	float: left;
	width: 50%;
	box-sizing: border-box;
	padding-left: 15%;
	position: relative;
}
.input-row.sign{
	width: 100%;
}
.input-row label{
	width: 30%;
	min-width: 65px;
	position: absolute;
	left: 0;
	top: 0;
	vertical-align: top;
	color: #717171;
	font-size: 18px;
}
.input-row .value{
	width: 100%;
	display: inline-block;
	vertical-align: top;
}
.input-row .value .icon-edit{
	margin-left: 10px;
	cursor: pointer;
}
input{
	border: 1px solid #999999;
	border-radius: 3px;
	padding: 0 5px;
}
input.name{
	width: 100%;
	box-sizing: border-box;
	text-align: center;
}
input.age{
	width: 20px;
}
input.sign{
	width: 100%;
	box-sizing: border-box;
}
input.normal{
	width: 180px;
}
.info-buts{
	border-top: 1px solid #E1E6EB;
	text-align: center;
	padding: 3% 0;
	margin: 0 3%;
}
.info-buts button{
	border: 0;
	font-size: 16px;
	color: #fff;
	padding: 4px 20px;
	border-radius: 5px;
	cursor: pointer;
	margin: 0 5%;
}
.info-buts button.save{
	background-color: #12B7F5;
}
.info-buts button.reset{
	background-color: #d9534f;
}
@media screen and (max-width: 555px) {
	.input-row{
		width: 100%;
	}
	.input-row label{
		width: 15%;
	}
}
@media screen and (max-width: 680px) {
	.nickname{
		font-size: 13px;
	}
	.input-row label{
		font-size: 14px;
	}
	.input-row .value{
		font-size: 13px;
	}
}
</style>