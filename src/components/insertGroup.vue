<template>
	<div :class="['groupInfo',isShowList?'list':'']" v-loading2="isLoading">
		<div class="title">
			<span class="iconfont icon-left" @click="back"></span>
			<span class="title-main">创建群聊</span>
		</div>

		<div class="info-wrap">
			<div class="info-inner clearfix">
				<div class="start-upload" :style="'background-image:url('+(headResult||group.headPath)+')'">
					<img src="@/assets/img/upload.png" alt="" v-if="isEdit&&isLeader">
					<input type="file" accept="image/*" class="hide" ref="head" @change="fileChange($event)">
					<div class="mask" v-if="isEdit" @click="startUpload"></div>
				</div>

				<div class="input-row">
					<label for="nickame">群名称</label>
					<p class="value" v-if="isEdit">
						<input type="text" v-model="group.group_name">
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

			<div class="info-buts">
				<button @click="insert" class="save">创建</button>
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
			isEdit: true,
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
			returnView:state=>state.view.returnView,
			groupList:state=>state.data.groupList,
			recordList:state=>state.data.recordList,
		})
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
		reset(){
			this.headSrc = '';
			this.headResult = '';
			this.$refs.head.value = '';
			this.group = Object.assign({},this.other);
		},
		back(){
			if(this.returnView !== ''){
				this.setShowBody(this.returnView);
			}else{
				this.setShowBody('chat');
			}
		},
		insert(){
			if(this.headResult){
				this.group.headPath = this.headResult;
			}
			console.log(this.group)
			this.send({data: {
				type: 'insertGroup',
				loginKey: this.loginKey,
				group: this.group
			},callback: (data)=>{
				this.send({data:{
					type: 'getGroupList',
					loginKey: this.loginKey
				}})
				this.setShowBody(false);
			}})
		}
	},
	created(){
		
	},
	activated(){
		
	},
	deactivated(){
		
	},
	components:{
		headSelecter
	}
}
</script>

<style scoped>
@import '../assets/css/groupInfo.css';
</style>