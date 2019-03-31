<template>
	<div class="msg-list" ref="wrap">
		<div class="list-inner" ref="inner">
			<div class="item-wrap" v-for="(item,index) in recordList" ref="itemWrap">
				<div :class="['item',item.sort==0?'':'top']" @click="clickItem(item)">
					<img :src="item.headPath" class="head" alt=""><!-- ../assets/img/group-head.png -->
					<p class="name" :title="item.nickName||item.name">{{item.nickName||item.name}}</p>
					<p class="value" v-html="item.content"></p>
					<div class="toggle-ctrl" v-show="isShowToggle" @click.stop="showCtrl(index)" ref="toggleCtrl">
						<span class="iconfont icon-left"></span>
					</div>
					<div class="point" v-if="item.is_check==0"></div>
					<span class="date">{{item.write_date_text}}</span>
				</div>
				<div class="right-ctrl">
					<div class="setTop" @click="sortRecord(item)" v-if="(item.type=='friendMsg'||item.type=='groupMsg')&&item.sort==0">置顶</div>
					<div class="setTop" @click="sortRecord(item)" v-if="(item.type=='friendMsg'||item.type=='groupMsg')&&item.sort>0">取消置顶</div>
					<div :class="['delete',item.type!='friendMsg'&&item.type!='groupMsg'?'b':'']" @click="deleteRecord(item)">删除</div>
				</div>
			</div>
		</div>
		<div class="scrollBar" ref="scrollBar"></div>
	</div>
</template>

<script>
import {mapState,mapActions} from 'vuex'
import ScrollBar from '@/assets/js/ScrollBar'
export default{
	props:['isShowToggle'],
	data(){
		return{
			bar:null
		}
	},
	computed:{
		...mapState({
			loginKey:state=>state.data.loginKey,
			recordList:state=>state.data.recordList,
			friend:state=>state.data.friend,
			group:state=>state.data.group,
			chatType:state=>state.data.chatType,
		})
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody',
			setRidebarLoading: 'view/setRidebarLoading',
			setGlobalLoading: 'view/setGlobalLoading',
			setRecordList: 'data/setRecordList',
			send: 'data/send',
			setChatType: 'data/setChatType',
			setFriend: 'data/setFriend',
			setGroup: 'data/setGroup',
			setUser: 'data/setUser'
		}),
		loading5Second(){
			this.setGlobalLoading(true);
			setTimeout(()=>{this.setGlobalLoading(false);}, 5000);//避免loading一直存在
		},
		clickItem(item){
			if(item.type=='friendMsg'||item.type=='groupMsg'){
				this.loading5Second();
				if(item.type == 'friendMsg' && (this.friend['user_id'] != item.id || this.chatType=='group')){//防止重复获取
					this.setShowBody(false);
					this.send({data: {
						type: 'getUserInfoById',loginKey: this.loginKey,user_id: item.id
					},callback: (data)=>{
						this.setGlobalLoading(false);
						if(data.list.length==2){
							this.setFriend(Object.assign(data.list[0],{chatList: data.list[1]}));
						}
						this.setChatType('friend');
						this.setGroup({});//清空群信息
						this.setShowBody('chat');
					}})
				}else if(item.type == 'groupMsg' && this.group['group_id'] != item.id){//防止重复获取
					this.setShowBody(false);
					this.send({data: {
						type: 'getGroupInfoById',loginKey: this.loginKey,group_id: item.id
					},callback: (data)=>{
						this.setGlobalLoading(false);
						if(data.list.length==2){
							this.setGroup(Object.assign(data.list[0],{chatList: data.list[1]}));
						}
						this.setChatType('group');
						this.setFriend({});//清空好友信息
						this.setShowBody('chat');
					}})
				}else{
					this.setShowBody('chat');
					this.setGlobalLoading(false);
				}
			}else{
				if(item.type == 'applyAddFriend'){//好友申请
					this.$Tip.showTip(item.creater+'想加你为好友,确定通过申请吗?',{sure:()=>{
						this.loading5Second();
						this.send({data:{
							type: 'passAddFriend',
							loginKey: this.loginKey,
							apply_id: item.apply_id
						},callback:(data)=>{
							this.setGlobalLoading(false);
							this.setRecordList([]);
							this.getRecord();
							if(data.user){
								this.setUser(data.user);
							}
							this.$message({type: 'success',message: '通过成功'});
						}})
					}})
				}else if(item.type == 'applyJoinGroup'){//申请入群
					this.$Tip.showTip(item.creater+item.name+',确定通过申请吗?',{sure:()=>{
						this.loading5Second();
						this.send({data:{
							type: 'passJoinGroup',
							loginKey: this.loginKey,
							apply_id: item.apply_id
						},callback:(data)=>{
							this.setGlobalLoading(false);
							this.setRecordList([]);
							this.getRecord();
							this.$message({type: 'success',message: '通过成功'});
						}})
					}})
				}else if(item.type == 'applyAddMember'){//邀请进群
					this.$Tip.showTip('确定接受邀请吗?',{sure:()=>{
						this.loading5Second();
						this.send({data:{
							type: 'passAddMember',
							loginKey: this.loginKey,
							apply_id: item.apply_id
						},callback:(data)=>{
							this.setGlobalLoading(false);
							this.setRecordList([]);
							this.getRecord();
							if(data.user){
								this.setUser(data.user);
							}
							this.$message({type: 'success',message: '通过成功'});
						}})
					}})
				}
			}
			if(item.is_check == 0){
				this.send({data: {
					type: 'readed',
					record_id: item.record_id
				},callback:(data)=>{

				}})
			}
		},
		showCtrl(index){
			this.$refs.itemWrap.forEach((item,i)=>{
				if(i == index && item.style.transform == ''){
					item.style.transform = 'translateX(-140px)';
				}else{
					item.style.transform = '';
				}
			})
			this.$refs.toggleCtrl.forEach((item,i)=>{
				if(i == index && item.style.transform == ''){
					item.style.transform = 'rotate(180deg)'
				}else{
					item.style.transform = '';
				}
			})
		},
		getRecord(){
			this.send({data: {
				type: 'getRecordList',
				loginKey: this.loginKey
			},callback: (data)=>{
				this.setRecordList(data.list);
				this.setRidebarLoading(false);
			}})
		},
		sortRecord(item){
			this.send({data: {
				type: 'sortRecord',
				record_id: item.record_id,
				loginKey: this.loginKey,
				tb_type: item.type,
				sort: item.sort==0?1:0
			},callback: (data)=>{
				this.setRecordList([]);
				this.getRecord();
			}})
		},
		deleteRecord(item){//删除消息
			this.$Tip.showTip('确定要删除吗？',{sure:()=>{
				if(item.type=='friendMsg'||item.type=='groupMsg'){
					this.send({data: {
						type: 'delRecord',
						record_id: item.record_id,
						loginKey: this.loginKey
					},callback: (data)=>{
						this.setRecordList([]);
						this.getRecord();
					}})
				}else{
					this.send({data: {
						type: 'delApply',
						apply_id: item.apply_id,
						loginKey: this.loginKey
					},callback: (data)=>{
						this.setRecordList([]);
						this.getRecord();
					}})
				}
			}});
		}
	},
	created(){
		this.getRecord();
	},
	updated(){
		if(!this.$isMobile){//自定义滚动条
			this.bar = new ScrollBar(this.$refs.wrap,this.$refs.inner,this.$refs.scrollBar,1);
			if(typeof this.bar.setBarHeight == 'function'){
				window.addEventListener('resize',this.bar.setBarHeight);
			}
		}
	}
}
</script>

<style scoped>
	.list-inner{
		position: absolute;
		width: 100%;
	}
	.item-wrap{
		width: 100%;
		height: 60px;
		padding-right: 140px;
		position: relative;
		transition: transform .2s;
	}
	.right-ctrl{
		width: 140px;
		height: 60px;
		line-height: 60px;
		position: absolute;
		top: 0;
		right: 0;
		overflow: hidden;
		cursor: pointer;
	}
	.right-ctrl>div{
		width: 70px;
		height: 100%;
		float: left;
		color: #fff;
		text-align: center;
	}
	.right-ctrl .setTop{
		background-color: #C8C7CC;
	}
	.right-ctrl .delete{
		background-color: #FF3A31;
	}
	.right-ctrl .delete.b{
		width: 140px;
	}
	.item{
		color: #333;
		border-bottom: 1px solid #f0f0f0;
		padding: 8px 70px 7px 60px;
		height: 45px;
		position: relative;
		cursor: pointer;
	}
	.item.top{
		background-color: #efefef;
	}
	.item:hover,.item:active,.item.on{
		background-color: #EDFAFF;
	}
	.item .head{
		width: 45px;
		height: 45px;
		border-radius: 50%;
		position: absolute;
		top: 8px;
		left: 8px;
	}
	.item p{
		width: 100%;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
	.item .name{
		font-size: 16px;
		line-height: 26px;
	}
	.item .value{
		font-size: 13px;
		height: 20px;
		line-height: 20px;
		color: #999999;
		overflow: hidden;
	}
	.item .point{
		width: 10px;
		height: 10px;
		border-radius: 50%;
		background-color: #E13523;
		position: absolute;
		left: 43px;
		top: 10px;
	}
	.item .date{
		font-size: 12px;
		color: #999999;
		position: absolute;
		right: 8px;
		bottom: 10px;
	}
	.item .toggle-ctrl{
		position: absolute;
		right: 5px;
		top: 5px;
		width: 30px;
		height: 30px;
		line-height: 30px;
		text-align: center;
		color: #999999;
	}
</style>

<style>
	.msg-list .item .value p{
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
	.msg-list .item .value img{
		width: 0;
		height: 0;
		overflow: visible;
	}
	.msg-list .item .value img[alt='face']{
		width: 16px;
		height: 16px;
		margin: 0 1px;
		vertical-align: text-top;
		display: inline-block;
		background-color: transparent!important;
	}
</style>