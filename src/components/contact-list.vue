<template>
	<div class="contact-list" ref="wrap">
		<div class="list-inner" ref="friendInner" v-show="groupIndex==0">
			<template v-for="(friend,index) in friendList">
				<div class="group" @click="toggleRows(index)">
					<span class="iconfont icon-right" ref="icons"></span>
					<span class="groupName">{{friend.groupName}}</span>
				</div>
				<div class="rows" ref="rows">
					<div class="info-row" v-for="friend in friend.list" @click="setShowBody('chat')">
						<img :src="friend.headPath" alt="" class="head">
						<p class="name" :title="friend.nickName||friend.user_name">{{friend.nickName||friend.user_name}}</p>
						<p class="signature" :title="friend.sign">{{friend.status==1?'[在线]':'[离线]'}} {{friend.sign}}</p>
					</div>
				</div>
			</template>
		</div>
		<div class="scrollBar" ref="friendScrollBar" v-show="groupIndex==0"></div>

		<div class="list-inner" ref="groupInner" v-show="groupIndex==1">
			<div class="info-row" v-for="group in groupList" @click="setShowBody('chat')">
				<img :src="group.headPath" alt="" class="head">
				<p class="name" :title="group.group_name" :style="{'line-height':!group.last_date?'30px':''}">
					{{group.group_name}}
				</p>
				<p class="signature">{{group.last_date?'最近活跃：'+group.last_date:''}}</p>
			</div>
		</div>
		<div class="scrollBar" ref="groupScrollBar" v-show="groupIndex==1"></div>
	</div>
</template>

<script>
import {mapState,mapActions} from 'vuex'
import ScrollBar from '@/assets/js/ScrollBar'
import {getFriendList,getGroupList} from '@/api/api.js'
export default{
	props:['groupIndex'],//好友和群聊间切换的下标
	data(){
		return{
			friendBar: false,
			groupBar: false
		}
	},
	computed:{
		...mapState({
			typeKeys:state=>state.data.typeKeys,
			loginKey:state=>state.data.loginKey,
			friendList:state=>state.data.friendList,
			groupList:state=>state.data.groupList
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
			addTypeKeys: 'data/addTypeKeys',
			setFriendList: 'data/setFriendList',
			setGroupList: 'data/setGroupList',
			send: 'data/send'
		}),
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
			if(typeof this.typeKeys['getFriendList_success'] != 'function'){
				this.addTypeKeys({
					'getFriendList_success': (data)=>{
						this.setFriendList(data.list);
						this.setRidebarLoading(false);
					}
				})
			}
			this.setRidebarLoading(true);
			this.send({
				type: 'getFriendList',
				loginKey: this.loginKey
			})
		},
		getGroupList(){
			// if(typeof this.typeKeys['getGroupList_success'] != 'function'){
			// 	this.addTypeKeys({
			// 		'getGroupList_success': (data)=>{
			// 			this.setGroupList(data.list);
			// 			this.setRidebarLoading(false);
			// 		}
			// 	})
			// }
			this.setRidebarLoading(true);
			// this.send({
			// 	type: 'getGroupList',
			// 	loginKey: this.loginKey
			// })
			this.send({data: {
				type: 'getGroupList',
				loginKey: this.loginKey
			},callback: (data)=>{
				this.setGroupList(data.list);
				this.setRidebarLoading(false);
			}})
		}
	},
	created(){
		this.getFriendList();
		this.getGroupList();
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
</style>