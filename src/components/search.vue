<template>
	<div class="search">
		<div class="title">
			<span class="iconfont icon-left" @click="exit"></span>
			<span class="title-main">搜索</span>
		</div>
		<div class="input-row">
			<div class="input-inner">
				<span class="iconfont icon-search1"></span>
				<input type="text" @input="input" v-model="keyword">
			</div>
		</div>
		<div :class="['list-wrap',$isMobile?'mobile':'']">
			<div class="list-inner">
				<div class="list">
					<div class="list-tile" v-if="searchFriends.length>0">搜索用户</div>
					<div class="rows" v-if="searchFriends.length>0">
						<div class="item-row" v-for="item in searchFriends" @click="clickItem(item,'friend')">
							<img :src="item.headPath" alt="">
							<p class="name ellipsis">{{item.user_name}}</p>
							<p class="account ellipsis">{{item.user_account}}</p>
						</div>
					</div>

					<div class="list-tile" v-if="searchGroups.length>0">搜索群聊</div>
					<div class="rows" v-if="searchGroups.length>0">
						<div class="item-row" v-for="item in searchGroups" @click="clickItem(item,'group')">
							<img :src="item.headPath" alt="">
							<p class="name ellipsis">{{item.group_name}}</p>
							<p class="account ellipsis">{{item.group_account}}</p>
						</div>
					</div>

					<div class="list-tile" v-if="myFriends.length>0">我的好友</div>
					<div class="rows" v-if="myFriends.length>0">
						<div class="item-row" v-for="item in myFriends" @click="clickItem(item,'friend')">
							<img :src="item.headPath" alt="">
							<p class="name ellipsis">{{item.nickName}}({{item.user_name}})</p>
							<p class="account ellipsis">{{item.user_account}}</p>
						</div>
					</div>

					<div class="list-tile" v-if="myGroups.length>0">我的群聊</div>
					<div class="rows" v-if="myGroups.length>0">
						<div class="item-row" v-for="item in myGroups" @click="clickItem(item,'group')">
							<img :src="item.headPath" alt="">
							<p class="name ellipsis">{{item.group_name}}</p>
							<p class="account ellipsis">{{item.group_account}}</p>
						</div>
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
			keyword: '',
			myFriends: [],
			myGroups: [],
			searchFriends: [],
			searchGroups:[],
			timeObj: null
		}
	},
	computed:{
		...mapState({
			loginKey:state=>state.data.loginKey,
			friendList:state=>state.data.friendList,
			groupList:state=>state.data.groupList,
			tempKeyword:state=>state.data.keyword,
			searchList:state=>state.data.searchList,
			friend:state=>state.data.friend,
			group:state=>state.data.group,
			user:state=>state.data.user,
			chatType:state=>state.data.chatType,
		})
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody',
			send: 'data/send',
			setChatType: 'data/setChatType',
			setFriend: 'data/setFriend',
			setGroup: 'data/setGroup',
			setReturnView: 'view/setReturnView',
			setKeyword: 'data/setKeyword',
			setSearchList: 'data/setSearchList',
		}),
		search(){
			if(this.keyword){
				// 前端搜索
				if(this.friendList.length>0){
					let list = this.friendList[0].list.filter((item)=>{//我的好友
						return item.user_account.includes(this.keyword) || item.user_name.includes(this.keyword) || item.nickName.includes(this.keyword);
					})
					this.myFriends = list;
				}
				if(this.groupList.length>0){
					let list = this.groupList.filter((item)=>{//我的群聊
						return item.group_account.includes(this.keyword) || item.group_name.includes(this.keyword);
					})
					this.myGroups = list;
				}
				// 后端搜索
				this.send({data: {
					type: 'search',
					keyword: this.keyword
				},callback: (data)=>{
					this.searchFriends = data.list[0].filter((item)=>{
						return this.myFriends.filter((it)=>{return it.user_id==item.user_id})<=0&&item.user_id!=this.user.user_id;
					})
					this.searchGroups = data.list[1].filter((item)=>{
						return this.myGroups.filter((it)=>{return it.group_id==item.group_id})<=0&&item.user_id!=this.user.user_id;
					})
					this.setSearchList(this.$data);
				}})
			}else{
				this.reset();
			}
		},
		input(){
			this.setKeyword(this.keyword);
			clearTimeout(this.timeObj);
			this.timeObj = setTimeout(()=>{
				this.search();
			},500)
		},
		clickItem(item,type){
			if(type == 'friend' && (this.friend['user_id'] != item.user_id || this.chatType=='group')){//防止重复获取
				this.send({data: {
					type: 'getUserInfoById',loginKey: this.loginKey,user_id: item.user_id
				},callback: (data)=>{
					if(data.list.length==2){
						this.setFriend(Object.assign(data.list[0],{chatList: data.list[1]}));
					}
					this.setChatType('friend');
					this.setGroup({});//清空群信息
					this.setReturnView('search');
					this.setShowBody('friendInfo');
				}})
			}else if(type == 'group' && this.group['group_id'] != item.group_id){//防止重复获取
				this.send({data: {
					type: 'getGroupInfoById',loginKey: this.loginKey,group_id: item.group_id
				},callback: (data)=>{
					if(data.list.length==2){
						this.setGroup(Object.assign(data.list[0],{chatList: data.list[1]}));
					}
					this.setChatType('group');
					this.setFriend({});//清空好友信息
					this.setReturnView('search');
					this.setShowBody('groupInfo');
				}})
			}
		},
		reset(){
			this.myFriends = [];
			this.myGroups = [];
			this.searchFriends = [];
			this.searchGroups = [];
			this.setSearchList({});
		},
		exit(){
			this.reset();
			this.setKeyword('');
			this.setShowBody(false);
		}
	},
	activated(){
		this.keyword = this.tempKeyword;
		this.myFriends = this.searchList.myFriends?this.searchList.myFriends:[];
		this.myGroups = this.searchList.myGroups?this.searchList.myGroups:[];
		this.searchFriends = this.searchList.searchFriends?this.searchList.searchFriends:[];
		this.searchGroups = this.searchList.searchGroups?this.searchList.searchGroups:[];
	}
}
</script>

<style scoped>
.search{
	width: 100%;
	height: 100%;
	padding-top: 80px;
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
	top: 0;
	left: 10px;
	height: 100%;
	font-size: 18px;
	cursor: pointer;
}
.input-row{
	width: 100%;
	height: 40px;
	line-height: 40px;
	padding: 4px 8px;
	box-sizing: border-box;
	position: absolute;
	left: 0;
	top: 40px;
}
.input-row .input-inner{
	height: 34px;
	line-height: 34px;
	background-color: #fff;
	border-radius: 3px;
	padding-left: 25px;
}
.input-row .iconfont{
	position: absolute;
	left: 14px;
	top: 4px;
}
.input-row input{
	display: inline-block;
	width: 100%;
	height: 32px;
	border: 0;
	box-sizing: border-box;
	padding-right: 10px;
	padding-left: 5px;
	vertical-align: top;
	font-size: 15px;
}
.list-wrap{
	width: 100%;
	height: 100%;
	overflow-x: hidden;
	overflow-y: scroll;
	position: relative;
	padding-right: 17px;
}
.list-wrap.mobile{
	padding-right: 0;
}
.list-inner{
	position: absolute;
	width: 100%;
	left: 0;
	top: 0;
	padding: 0 8px;
	box-sizing: border-box;
	padding-bottom: 10px;
}
.list{
	background-color: #fff;
}
.list-tile{
	color: #666;
	font-size: 15px;
	border-bottom: 1px solid #dddddd;
	padding: 12px 0;
	margin: 8px;
}
.item-row{
	height: 60px;
	line-height: 60px;
	cursor: pointer;
}
.item-row:hover{
	background-color: #EDFAFF;
}
.item-row img{
	width: 50px;
	height: 50px;
	float: left;
	border-radius: 50%;
	margin: 5px 8px;
}
.item-row .name{
	padding-right: 8px;
	line-height: 35px;
	color: #333;
}
.item-row .account{
	padding-right: 8px;
	line-height: 16px;
	color: #7e7e7e;
}
.rows{
	padding: 5px 0;
	border-bottom: 2px solid #ECF1F7;
}
</style>