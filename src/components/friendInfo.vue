<template>
	<div class="userInfo" v-loading2="isLoading">
		<div class="title">
			<span class="iconfont icon-left" @click="back"></span>
			{{chatType=='group'?'成员信息':'好友信息'}}
<!-- 			<span class="iconfont icon-edit" @click="isEdit=true" v-if="!isEdit"></span>
			<span class="pub" @click="reset();isEdit=false;" v-else>取消</span> -->
		</div>
		<div class="info-wrap">
			<div class="info-inner clearfix">
				<div class="start-upload" :style="'background-image:url('+(headResult||obj.headPath||'static/img/user-head.png')+')'">
					<div class="mask" v-if="isEdit"></div>
				</div>
				<template v-if="chatType=='friend' && isMyFriend">
					<p class="nickname ellipsis" :title="obj.nickName" v-if="!isEdit">
						{{obj.nickName}}
						<span class="iconfont icon-edit" @click="isEdit=true" v-if="!isEdit"></span>
					</p>
					<p class="nickname" :title="obj.nickName" v-else>
						<input type="text" class="name" v-model="obj.nickName">
					</p>
				</template>
				<template v-if="chatType=='group'">
					<p class="nickname ellipsis" :title="obj.carte">群名片:{{obj.carte}}</p>
				</template>
				<div class="input-row">
					<label for="">账号</label>
					<p class="value ellipsis" :title="obj.user_account">{{'('+obj.user_name+')'+obj.user_account}}</p>
				</div>

				<div class="input-row">
					<label for="">邮箱</label>
					<p class="value ellipsis" :title="obj.email">{{obj.email}}</p>
				</div>

				<div class="input-row">
					<label for="">年龄</label>
					<p class="value ellipsis">{{obj.age}}岁</p>
				</div>

				<div class="input-row">
					<label for="">地区</label>
					<p class="value ellipsis" :title="obj.area">{{obj.area||'无'}}</p>
				</div>

				<div class="input-row">
					<label for="">电话</label>
					<p class="value ellipsis" :title="obj.phone">{{obj.phone||'无'}}</p>
				</div>

				<div class="input-row">
					<label for="nickame">性别</label>
					<p class="value ellipsis">{{obj.sexName}}</p>
				</div>

				<div class="input-row sign">
					<label for="">签名</label>
					<p class="value" :title="obj.sign">{{obj.sign||'无'}}</p>
				</div>
			</div>
			<div class="info-buts" v-if="!isEdit">
				<button @click="applyAddFriend" class="save" v-if="!isMyFriend">加为好友</button>
				<button class="save" v-if="isMyFriend" @click="setShowBody('chat')">发消息</button>
				<button @click="deleteFriend" class="reset" v-if="isMyFriend">删除</button>
			</div>
			<div class="info-buts" v-else>
				<button @click="save" class="save">保存</button>
				<button @click="reset" class="reset">取消</button>
			</div>
		</div>
	</div>
</template>

<script>
import {mapState,mapActions} from 'vuex'
export default{
	data(){
		return{
			obj: {},
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
			returnView:state=>state.view.returnView,
			typeKeys:state=>state.data.typeKeys,
			stateUser:state=>state.data.user,
			loginKey:state=>state.data.loginKey,
			friend:state=>state.data.friend,
			chatType:state=>state.data.chatType,
			friendList:state=>state.data.friendList,
			recordList:state=>state.data.recordList,
		}),
		isMyFriend(){//检测是否是我的好友
			if(!this.stateUser.friend_ids){return false;}
			var list = this.stateUser.friend_ids.split(',');
			for(var i = 0;i<list.length;i++){
				if(this.friend.user_id == list[i]){
					return true;
				}
			}
			return false;
		}
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody',
			addTypeKeys: 'data/addTypeKeys',
			setUser: 'data/setUser',
			send: 'data/send',
			setFriend: 'data/setFriend',
			setReturnView: 'view/setReturnView',
			setFriendList: 'data/setFriendList',
			setUser: 'data/setUser',
			setRecordList: 'data/setRecordList',
		}),
		deleteFriend(){
			this.$Tip.showTip('确定删除该好友吗？',{
				sure:()=>{
					this.send({data: {
						type: 'deleteFriend',
						loginKey: this.loginKey,
						friend_id: this.obj.user_id
					},callback: (data)=>{
						//重新获得群列表
						if(this.friendList.length>0){
							let list1 = this.friendList[0].list.filter((item)=>{return item.user_id != this.obj.user_id});
							let list2 = this.friendList[1].list.filter((item)=>{return item.user_id != this.obj.user_id});
							this.setFriendList([list1,list2]);
						}
						//重新获得个人信息
						let tempUser = Object.assign({},this.stateUser);
						tempUser.friend_ids = tempUser.friend_ids.split(',').filter((item)=>{
							return item != this.obj.user_id
						}).join(',');
						this.setUser(tempUser);
						this.setFriend({});
						this.setShowBody(false);
					}})
				}
			});
		},
		applyAddFriend(){
			this.$prompt('请输入验证信息(可为空)', '提示', {
	          	confirmButtonText: '确定',cancelButtonText: '取消'
	        }).then(({ value }) => {
	          	this.send({data: {
					type: 'applyAddFriend',
					loginKey: this.loginKey,
					target_id: this.obj.user_id,
					write_date: Date.parse(new Date)/1000,
					apply_content: value
				},callback: (data)=>{

				}})
				this.$message({type: 'success',message: '成功发送申请，请等待对方审核'});
	        });
		},
		save(){
			this.isLoading = true;
			this.send({data: {
				type: 'setNickName',
				loginKey: this.loginKey,
				friend_id: this.obj.user_id,
				nickName: this.obj.nickName
			},callback: (data)=>{
				this.isLoading = false;
				this.setFriend(this.obj);
				this.isEdit = false;
				this.send({data: {type: 'getRecordList',loginKey: this.loginKey}})
				this.send({data: {type: 'getFriendList',loginKey: this.loginKey}})
			}})
		},
		reset(){
			this.obj = Object.assign({},this.other);
			this.isEdit = false;
		},
		back(){
			if(this.returnView !== ''){
				this.setShowBody(this.returnView);
			}else{
				this.setShowBody('chat');
			}
		}
	},
	activated(){
		this.obj = Object.assign({},this.friend);
		this.other = Object.assign({},this.obj);
	},
	deactivated(){
		this.reset();
		this.isEdit = false;
		this.setReturnView(false);
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
	height: 40px;
	overflow: hidden;
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
.iconfont.icon-edit{
	cursor: pointer;
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