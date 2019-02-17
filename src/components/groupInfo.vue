<template>
	<div :class="['groupInfo',isShowList?'list':'']" v-loading2="isLoading">
		<div class="title">
			<span class="iconfont icon-left" @click="back"></span>
			<span class="title-main">群资料</span>
			<!-- <span class="iconfont icon-add" v-if="!isEdit&&!isShowList" title="添加新成员"></span> -->
			<template v-if="isMember">
				<span class="iconfont icon-edit" @click="isEdit=true" v-if="!isEdit&&!isShowList" title="编辑"></span>
				<span class="pub" @click="reset();isEdit=false;" v-if="isEdit">取消</span>
			</template>
		</div>
		<a class="toggle" href="#" v-if="!isEdit" @click.prevent="isShowList=!isShowList;isCtrl=false;">
			{{isShowList?'返回':'查看成员'}}
		</a>
		<a class="ctrl" href="#" v-if="isShowList&&isLeader" @click="setCtrl">{{isCtrl?'取消操作':'操作'}}</a>

		<div class="list-wrap" v-if="isShowList">
			<p class="list-title">{{group.name}}</p>
			<table class="table-head">
				<thead>
					<tr>
						<th>成员</th>
						<th>群名片</th>
						<th>等级</th>
						<th>积分</th>
						<th>{{isCtrl?'操作':'最后活跃'}}</th>
					</tr>
				</thead>
			</table>
			<div class="list-inner">
				<table class="value-table">
					<tbody>
						<tr v-for="(item,index) in memberList" @click="memberClick(item)">
							<td class="ellipsis" :title="item.user_name">
								<img src="../assets/img/manager.png" alt="" class="manager-icon" v-if="item.isLeader">
								<img :src="item.headPath" alt="" class="list-head">{{item.user_name}}
							</td>
							<td class="ellipsis" :title="item.carte">{{item.carte}}</td>
							<td class="ellipsis">潜水</td>
							<td class="ellipsis">{{item.integral}}</td>
							<td class="ellipsis">
								<span class="iconfont icon-close" v-if="isLeader&&isCtrl&&(item.user_id!=stateUser.user_id)" title="删除" @click.stop="delGroupMember(item)"></span>
								<span v-else>
									<span class="time-text">{{item.last_date}}</span>
									<span class="iconfont icon-IDcard card" title="查看资料"></span>
								</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

		<div class="info-wrap" v-else>
			<div class="info-inner clearfix">
				<div class="start-upload" :style="'background-image:url('+(headResult||group.headPath)+')'">
					<img src="@/assets/img/upload.png" alt="" v-if="isEdit&&isLeader">
					<input type="file" accept="image/*" class="hide" ref="head" @change="fileChange($event)">
					<div class="mask" v-if="isEdit" @click="startUpload"></div>
				</div>
				<p class="nickname ellipsis" :title="group.group_name" v-if="!isEdit||!isLeader">{{group.group_name}}</p>
				<p class="nickname ellipsis" :title="group.group_name" v-else>
					<input type="text" class="name" v-model="group.group_name">
				</p>
				<p class="nickname ellipsis account" :title="group.group_account">{{group.group_account}}</p>
				

				<div class="input-row" v-if="isMember">
					<label for="nickame">群名片</label>
					<p class="value" v-if="isEdit">
						<input type="text" v-model="group.carte">
					</p>
					<p class="value ellipsis" v-else>
						<span>{{group.carte}}</span>
					</p>
				</div>

				<div class="input-row sign">
					<label for="">群介绍</label>
					<p class="value" :title="group.info" v-if="!isEdit||!isLeader">{{group.info}}</p>
					<p class="value ellipsis" v-else>
						<input type="text" class="sign" v-model="group.info">
					</p>
				</div>
			</div>

			<div class="info-buts" v-if="!isEdit">
				<button @click="join" class="save" v-if="!isMember">申请加入</button>
				<button class="save" v-if="isMember" @click="setShowBody('chat')">聊天</button>
				<button @click="exitGroup" class="reset" v-if="isMember&&!isLeader">退出</button>
			</div>
			<div class="info-buts" v-else>
				<button @click="save" class="save">保存</button>
				<button @click="reset" class="reset">取消</button>
			</div>
		</div>

		<headSelecter :isShow.sync="isShowHead" :src.sync="headSrc" :head="$refs.head" :result.sync="headResult"/>
	</div>
</template>

<script>
import {mapState,mapActions} from 'vuex'
import headSelecter from '@/components/head-selecter';
export default{
	data(){
		return{
			group: {},
			isEdit: false,
			other: {},
			headSrc: '',
			headResult: '',
			isShowList: false,
			isShowHead: false,
			isLeader: true,//是否是群主
			isCtrl: false,
			isLoading: false,
			otherCarte: '',//保存群名片
			memberList: [],//群成员
		}
	},
	computed:{
		...mapState({
			loginKey:state=>state.data.loginKey,
			stateUser:state=>state.data.user,
			stateGroup:state=>state.data.group,
			returnView:state=>state.view.returnView,
			groupList:state=>state.data.groupList,
			recordList:state=>state.data.recordList,
		}),
		isMember(){//检测我是否是成员
			if(!this.stateUser.group_ids){return false;}
			var list = this.stateUser.group_ids.split(',');
			for(var i = 0;i<list.length;i++){
				if(this.stateGroup.group_id == list[i]){
					return true;
				}
			}
			return false;
		}
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody',
			setReturnView: 'view/setReturnView',
			send: 'data/send',
			setGroup: 'data/setGroup',
			setFriend: 'data/setFriend',
			setReturnView: 'view/setReturnView',
			addTypeKeys: 'data/addTypeKeys',
			setGroupList: 'data/setGroupList',
			setUser: 'data/setUser',
			setRecordList: 'data/setRecordList',
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
      	setCtrl(){
      		this.isCtrl=!this.isCtrl;
      		document.querySelector('.groupInfo').scrollLeft = 999;
      	},
		reset(){
			this.headSrc = '';
			this.headResult = '';
			this.$refs.head.value = '';
			this.group = Object.assign({},this.other);
		},
		save(){
			if(this.headResult){//有更换头像
				this.group.headPath = this.headResult;
			}

			this.isLoading = true;

			if(this.otherCarte != this.group.carte){//如果修改了群名片
				this.send({data: {//修改群基本信息
					type: 'setCarte',
					loginKey: this.loginKey,
					group_id: this.group.group_id,
					carte: this.group.carte
				},callback: (data)=>{
					this.setGroup(Object.assign(this.group,{carte:data.list[0]}));
					this.otherCarte = data.list[0]+'';
					this.isLoading = false;
					this.isEdit = false;
					this.getGroupMember();
				}})
			}

			if(this.isLeader){//如果是群主
				this.send({data: {//修改群基本信息
					type: 'updateGroup',
					loginKey: this.loginKey,
					info: this.group
				},callback: (data)=>{
					this.setGroup(data.list[0]);
					this.group = Object.assign({},data.list[0]);
					this.other = Object.assign({},this.group);
					this.isLoading = false;
					this.isEdit = false;

					this.send({data: {
						type: 'getRecordList',
						loginKey: this.loginKey
					}})
				}})
			}
		},
		getGroupMember(){//获得群成员
			this.send({data: {//修改群基本信息
				type: 'getGroupMember',
				loginKey: this.loginKey,
				group_id: this.group.group_id
			},callback: (data)=>{
				data.list.sort((a,b)=>{return b.integral - a.integral;});//按积分降序
				data.list.forEach((item,i)=>{//将群主放在第一
					if(item.isLeader){
						let temp = Object.assign({},item);
						data.list.splice(i,1);
						data.list.unshift(temp);
					}
				})
				this.memberList = data.list;
			}})
		},
		memberClick(item){//点击群成员
			if(item.user_id == this.stateUser.user_id){//点击的是自己
				return;
			}
			this.send({data: {
				type: 'getUserInfoById',loginKey: this.loginKey,user_id: item.user_id
			},callback: (data)=>{
				if(data.list.length==2){
					this.setFriend(Object.assign(data.list[0],{
						chatList: data.list[1],
						carte: item.carte
					}));
					this.setReturnView('groupInfo');
					this.setShowBody('friendInfo');
				}
			}})
		},
		delGroupMember(item){//删除群成员
			this.$Tip.showTip('确定删除该成员吗？',{
				sure:()=>{
					this.send({data: {
						type: 'delGroupMember',
						loginKey: this.loginKey,
						member_id: item.user_id,
						group_id: this.group.group_id
					},callback: (data)=>{
						this.memberList = this.memberList.filter((it)=>{
							return it.user_id != item.user_id;
						})
					}})
				}
			});
		},
		back(){
			if(this.returnView !== ''){
				this.setShowBody(this.returnView);
			}else{
				this.setShowBody('chat');
			}
		},
		join(){//申请加入
			this.$prompt('请输入验证信息(可为空)', '提示', {
	          	confirmButtonText: '确定',cancelButtonText: '取消'
	        }).then(({ value }) => {
	          	this.send({data: {
					type: 'applyJoinGroup',
					loginKey: this.loginKey,
					group_id: this.group.group_id,
					apply_content: value,
					write_date: Date.parse(new Date())/1000
				},callback: (data)=>{}})
				this.$message({type: 'success',message: '成功发送申请，请等待群主审核'});
	        });
		},
		exitGroup(){//退出群聊
			this.$Tip.showTip('确定退出该群吗？',{
				sure:()=>{
					
					this.send({data: {
						type: 'delGroupMember',
						loginKey: this.loginKey,
						member_id: this.stateUser.user_id,
						group_id: this.group.group_id
					},callback: (data)=>{
						//重新获得消息列表
						this.setRecordList(this.recordList.filter((item)=>{return item.group_id!=this.group.group_id}));
						//重新获得群列表
						this.setGroupList(this.groupList.filter((item)=>{return item.group_id != this.group.group_id}))
						//重新获得个人信息
						let tempUser = Object.assign({},this.stateUser);
						tempUser.group_ids = tempUser.group_ids.split(',').filter((item)=>{
							return item != this.group.group_id
						}).join(',');
						this.setUser(tempUser);
						this.setGroup({});
						this.setShowBody(false);
					}})
				}
			});
		}
	},
	created(){
		this.addTypeKeys({
			'member_exit_group': (data)=>{
				if(this.stateGroup.group_id == data.from_group){
					this.getGroupMember();
				}
			}
		})
	},
	activated(){
		this.group = this.stateGroup;
		this.otherCarte = this.group.carte+'';
		this.other = Object.assign({},this.group);
		this.isLeader = this.group['user_id'] == this.stateUser['user_id'];
		this.getGroupMember();
	},
	deactivated(){
		this.reset();
		this.isEdit = false;
		this.setReturnView(false);
	},
	components:{
		headSelecter
	}
}
</script>

<style scoped>
@import '../assets/css/groupInfo.css';
</style>