<template>
	<div :class="['groupInfo',isShowList?'list':'']">
		<div class="title">
			<span class="iconfont icon-left" @click="setShowBody('chat')"></span>
			<span class="title-main">群资料</span>
			<span class="iconfont icon-add" v-if="!isEdit&&!isShowList" title="添加新成员"></span>
			<span class="iconfont icon-edit" @click="isEdit=true" v-if="!isEdit&&!isShowList" title="编辑"></span>
			<span class="pub" @click="reset();isEdit=false;" v-if="isEdit">取消</span>
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
						<th>{{isCtrl?'操作':'最后发言'}}</th>
					</tr>
				</thead>
			</table>
			<div class="list-inner">
				<table class="value-table">
					<tbody>
						<tr v-for="(item,index) in new Array(15)" @click="">
							<td class="ellipsis" title="蚊子腿细也是肉">
								<img src="../assets/img/manager.png" alt="" class="manager-icon" v-if="index==0">
								<img src="static/img/test-1.jpg" alt="" class="list-head">蚊子腿细也是肉
							</td>
							<td class="ellipsis" title="计科151 樊致良">计科151 樊致良</td>
							<td class="ellipsis">潜水</td>
							<td class="ellipsis">333</td>
							<td class="ellipsis">
								<span class="iconfont icon-close" v-if="isLeader&&isCtrl" title="删除" @click.stop=""></span>
								<span v-else>2018/12/3</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

		<div class="info-wrap" v-else>
			<div class="info-inner clearfix">
				<div class="start-upload" :style="'background-image:url('+group.headPath+')'">
					<img src="@/assets/img/upload.png" alt="" v-if="isEdit&&isLeader">
					<input type="file" accept="image/*" class="hide" ref="head" @change="fileChange($event)">
					<div class="mask" v-if="isEdit" @click="startUpload"></div>
				</div>
				<p class="nickname ellipsis" :title="group.group_name" v-if="!isEdit||!isLeader">{{group.group_name}}</p>
				<p class="nickname ellipsis" :title="group.group_name" v-else>
					<input type="text" class="name" v-model="group.group_name">
				</p>
				<p class="nickname ellipsis account" :title="group.group_account">{{group.group_account}}</p>
				
				

				<div class="input-row">
					<label for="nickame">群名片</label>
					<p class="value" v-if="isEdit">
						<input type="text" v-model="stateUser.user_name">
					</p>
					<p class="value ellipsis" v-else>
						{{stateUser.user_name}}</span>
					</p>
				</div>

				<div class="input-row sign">
					<label for="">群介绍</label>
					<p class="value ellipsis" :title="group.info" v-if="!isEdit||!isLeader">{{group.info}}</p>
					<p class="value ellipsis" v-else>
						<input type="text" class="sign" v-model="group.info">
					</p>
				</div>
			</div>
			<div class="info-buts" v-if="isEdit">
				<button @click="save" class="save">保存</button>
				<button @click="reset" class="reset">重置</button>
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
			isCtrl: false
		}
	},
	computed:{
		...mapState({
			typeKeys:state=>state.data.typeKeys,
			loginKey:state=>state.data.loginKey,
			stateUser:state=>state.data.user,
			stateGroup:state=>state.data.group
		})
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody'
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
			this.$refs.head.value = '';
			this.group = Object.assign({},this.other);
		},
		save(){
			this.other = Object.assign({},this.group);
			this.isEdit = false;
		}
	},
	activated(){
		this.group = this.stateGroup;
		this.other = Object.assign({},this.group);
		this.isLeader = this.group['user_id'] == this.stateUser['user_id'];
	},
	components:{
		headSelecter
	}
}
</script>

<style scoped>
@import '../assets/css/groupInfo.css';
</style>