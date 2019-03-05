<template>
	<div class="contact-list" ref="wrap" @click="isShowCtrl=false;isShowGroupCtrl=false;">
		<div class="list-inner" ref="friendInner" v-show="groupIndex==0">
			<template v-for="(f,index) in friendList">
				<div class="group" @click="toggleRows(index)">
					<span class="iconfont icon-right" ref="icons"></span>
					<span class="groupName">{{f.groupName}}</span>
				</div>
				<div class="rows" ref="rows">
					<div class="info-row" v-for="friend,i in f.list" @click="clickItem(friend,'friend')" :ref="'ctrl'+i">
						<img :src="friend.headPath" alt="" class="head">
						<p class="name" :title="friend.nickName||friend.user_name">{{friend.nickName||friend.user_name}}</p>
						<p class="signature" :title="friend.sign">{{friend.status==1?'[在线]':'[离线]'}} {{friend.sign}}</p>
						<div class="toggle-ctrl" v-show="isShowToggle" @click.stop="showCtrl(friend,i,index)">
							<span class="iconfont icon-left"></span>
						</div>
					</div>
				</div>
			</template>
		</div>
		<div class="scrollBar" ref="friendScrollBar" v-show="groupIndex==0"></div>

		<div class="list-inner" ref="groupInner" v-show="groupIndex==1">
			<div class="info-row" v-for="group in groupList" @click="clickItem(group,'group')">
				<img :src="group.headPath" alt="" class="head">
				<p class="name" :title="group.group_name" :style="{'line-height':!group.last_date?'30px':''}">
					{{group.group_name}}
				</p>
				<p class="signature">{{group.last_date?'最近活跃：'+group.last_date:''}}</p>
			</div>
		</div>
		<div class="scrollBar" ref="groupScrollBar" v-show="groupIndex==1"></div>

		<div class="ctrl-panel" @click.stop="" v-show="isShowCtrl" :style="{top:ctrlTop+'px'}">
			<div class="row" @click="isShowGroupCtrl=true"><span class="iconfont icon-left"></span>邀请进群</div>
			<div class="row" @click="setIsBan()">移至{{ctrlText}}</div>
		</div>

		<div class="ctrl-panel l" @click.stop="" v-show="isShowGroupCtrl" :style="{top:ctrlTop+'px'}">
			<div class="row" v-for="item in groupList" :title="item.group_name" @click="addMember(item)">{{item.group_name}}</div>
		</div>
	</div>
</template>

<script>
import {mapState,mapActions} from 'vuex'
import ScrollBar from '@/assets/js/ScrollBar'
import {getStyle} from '@/assets/js/utils.js'
export default{
	props:['groupIndex','isShowToggle'],//好友和群聊间切换的下标
	data(){
		return{
			friendBar: false,
			groupBar: false,
			isShowCtrl: false,
			isShowGroupCtrl: false,
			ctrlTop: 0,
			ctrlText: '',
			selectFriend: {},
			isBan: 0
		}
	},
	computed:{
		...mapState({
			loginKey:state=>state.data.loginKey,
			friendList:state=>state.data.friendList,
			groupList:state=>state.data.groupList,
			friend:state=>state.data.friend,
			group:state=>state.data.group,
			chatType:state=>state.data.chatType,
		})
	},
	watch:{
		groupIndex(newValue){
			this.$refs.wrap.scrollTop = 0;
			if(newValue == 1 && !this.groupBar){
				this.$nextTick(()=>{
					if(!this.$isMobile){//自定义滚动条
						this.groupBar = new ScrollBar(this.$refs.wrap,this.$refs.groupInner,this.$refs.groupScrollBar,40);
						if(typeof this.groupBar.setBarHeight == 'function'){
							window.addEventListener('resize',this.groupBar.setBarHeight);
						}
						return;
					}
				})
			}
			this.setBarHeight();
		}
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody',
			setRidebarLoading: 'view/setRidebarLoading',
			setFriendList: 'data/setFriendList',
			setGroupList: 'data/setGroupList',
			send: 'data/send',
			setChatType: 'data/setChatType',
			setFriend: 'data/setFriend',
			setGroup: 'data/setGroup',
			setReturnView: 'view/setReturnView',
		}),
		setIsBan(){//拉黑或恢复好友
			this.send({data: {
				type: 'setIsBan',
				loginKey: this.loginKey,
				friend_id: this.selectFriend.user_id,
				is_ban: this.isBan
			},callback: (data)=>{
				this.getFriendList();
			}})
		},
		showCtrl(item,index,i){//显示操作
			let _height = i==1?document.querySelector(".list-inner .group").clientHeight+document.querySelector(".list-inner .rows").clientHeight:0;
			this.ctrlTop = 70 + 50 * index + _height;
			this.isShowCtrl = true;
			this.isBan = i?0:1;
			this.ctrlText = this.friendList[this.isBan].groupName;
			this.selectFriend = Object.assign({},item);
		},
		addMember(item){//拉好友入群
			this.send({data: {
				type: 'applyAddMember',
				loginKey: this.loginKey,
				target_id: this.selectFriend.user_id,
				group_id: item.group_id,
				write_date: Date.parse(new Date)/1000
			},callback: (data)=>{
				this.isShowCtrl = false;
				this.isShowGroupCtrl = false;
				this.$message({type: 'success',message: '成功发送申请，请等待对方审核'});
			}})
		},
		clickItem(item,type){
			if(type == 'friend' && (this.friend['user_id'] != item.user_id || this.chatType=='group')){//防止重复获取
				this.setShowBody(false);
				this.send({data: {
					type: 'getUserInfoById',loginKey: this.loginKey,user_id: item.user_id
				},callback: (data)=>{
					if(data.list.length==2){
						this.setFriend(Object.assign(data.list[0],{chatList: data.list[1]}));
					}
					this.setChatType('friend');
					this.setGroup({});//清空群信息
					this.setReturnView(false);
					this.setShowBody('friendInfo');
				}})
			}else if(type == 'group' && this.group['group_id'] != item.group_id){//防止重复获取
				this.setShowBody(false);
				this.send({data: {
					type: 'getGroupInfoById',loginKey: this.loginKey,group_id: item.group_id
				},callback: (data)=>{
					if(data.list.length==2){
						this.setGroup(Object.assign(data.list[0],{chatList: data.list[1]}));
					}
					this.setChatType('group');
					this.setFriend({});//清空好友信息
					this.setShowBody('chat');
				}})
			}else{//不获取直接打开
				if(type == 'friend'){
					this.setShowBody('friendInfo');
				}else if(type == 'group'){
					this.setShowBody('chat');
				}
			}
		},
		setBarHeight(){
			setTimeout(()=>{
				if(typeof this.friendBar.setBarHeight == 'function'){this.friendBar.setBarHeight();}
				if(typeof this.groupBar.setBarHeight == 'function'){this.groupBar.setBarHeight();}
			}, 500);
		},
		toggleRows(index){
			let row = this.$refs.rows[index];
			let icon = this.$refs.icons[index];
			row.style.height = row.style.height == '' ? this.friendList[index].list.length*50+'px' : '';
			icon.className = icon.className.indexOf('icon-down')==-1 ? icon.className+' icon-down' : 'iconfont icon-right';
			this.setBarHeight();
		},
		getFriendList(){
			this.send({data: {
				type: 'getFriendList',
				loginKey: this.loginKey
			},callback: (data)=>{
				this.setFriendList(data.list);
				this.setRidebarLoading(false);
				this.$nextTick(()=>{
					this.toggleRows(0);
					this.toggleRows(0);
					this.toggleRows(1);
					this.toggleRows(1);
				})
			}})
		},
		getGroupList(){
			this.send({data: {
				type: 'getGroupList',
				loginKey: this.loginKey
			},callback: (data)=>{
				this.setGroupList(data.list);
				this.setRidebarLoading(false);
			}})
		}
	},
	activated(){
		this.setRidebarLoading(true);
		this.getFriendList();
		this.getGroupList();
	},
	deactivated(){
		this.isShowCtrl = false;
		this.isShowGroupCtrl = false;
	},
	mounted(){
		if(!this.$isMobile){//自定义滚动条
			this.friendBar = new ScrollBar(this.$refs.wrap,this.$refs.friendInner,this.$refs.friendScrollBar,40);
			if(typeof this.friendBar.setBarHeight == 'function'){
				window.addEventListener('resize',this.friendBar.setBarHeight);
			}
		}
	}
}
</script>

<style scoped>
.contact-list{
	background-color: #fafafa!important;
}
.list-inner{
	position: absolute;
	left: 0;
	top: 0;
	margin-top: 40px;
	width: 100%;
	background-color: #fff;
}
.group{
	height: 35px;
	line-height: 35px;
	cursor: pointer;
	font-size: 16px;
}
.group .iconfont{
	color: #cccccc;
	margin: 0 7px;
	display: inline-block;
	vertical-align: top;
}
.group .groupName{
	width: 70%;
	display: inline-block;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}
.rows{
	height: 0;
	overflow: hidden;
	transition: height .2s;
}
.info-row{
	height: 35px;
	padding: 7px 0 7px 60px;
	position: relative;
	border-bottom: 1px solid #f0f0f0;
	cursor: pointer;
}
.info-row:hover,.info-row:active,.info-row.on{
	background-color: #EDFAFF;
}
.info-row .head{
	position: absolute;
	left: 13px;
	top: 7px;
	width: 35px;
	height: 35px;
	border-radius: 50%;
	float: left;
}
.info-row .name{
	width: 90%;
	font-size: 15px;
	color: #333;
	line-height: 20px;
}
.info-row .signature{
	width: 90%;
	font-size: 13px;
	color: #999999;
	line-height: 15px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}
.toggle-ctrl{
	position: absolute;
	right: 5px;
	top: 0px;
	width: 30px;
	height: 30px;
	line-height: 30px;
	text-align: center;
	color: #999999;
}
.ctrl-panel{
	position: absolute;
	box-shadow: 0 0 5px #888888;
	background-color: #fff;
	right: 30px;
	padding: 5px 0;
	border-radius: 3px;
	font-size: 15px;
	max-width: 130px;
	
	top: 0;
}
.ctrl-panel.l{
	right: 130px;
}
.ctrl-panel .row{
	margin: 3px 0;
	padding: 5px 10px;
	cursor: pointer;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}
.ctrl-panel .row:hover{
	background-color: #EDFAFF;
}
.ctrl-panel .iconfont{
	font-size: 16px;
	color: #999999;
	position: relative;
	left: -3px;
}
</style>