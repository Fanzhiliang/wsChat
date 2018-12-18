<template>
	<div class="msg-list" ref="wrap">
		<div class="list-inner" ref="inner">
			<div class="item-wrap" v-for="(item,index) in recordList" ref="itemWrap">
				<div :class="['item',item.sort==0?'':'top']" @click="clickItem(index)">
					<img :src="item.headPath" class="head" alt=""><!-- ../assets/img/group-head.png -->
					<p class="name" :title="item.name">{{item.name}}</p>
					<p class="value" v-html="item.content"></p>
					<div class="toggle-ctrl" v-show="isShowToggle" @click.stop="showCtrl(index)" ref="toggleCtrl">
						<span class="iconfont icon-left"></span>
					</div>
					<div class="point" v-if="item.is_check==0"></div>
					<span class="date">{{item.write_date_text}}</span>
				</div>
				<div class="right-ctrl">
					<div class="setTop" @click="sortRecord(item)" v-if="item.sort==0">置顶</div>
					<div class="setTop" @click="sortRecord(item)" v-else>取消置顶</div>
					<div class="delete">删除</div>
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
			typeKeys:state=>state.data.typeKeys,
			loginKey:state=>state.data.loginKey,
			recordList:state=>state.data.recordList
		})
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody',
			setRidebarLoading: 'view/setRidebarLoading',
			addTypeKeys: 'data/addTypeKeys',
			setRecordList: 'data/setRecordList',
			send: 'data/send'
		}),
		clickItem(index){
			this.setShowBody('chat');
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
			if(typeof this.typeKeys['getRecordList_success'] != 'function'){
				this.addTypeKeys({
					'getRecordList_success': (data)=>{
						this.setRecordList(data.list);
						this.setRidebarLoading(false);
					}
				})
			}
			this.setRidebarLoading(true);
			this.send({
				type: 'getRecordList',
				loginKey: this.loginKey
			})
		},
		sortRecord(item){
			if(typeof this.typeKeys['sortRecord_success'] != 'function'){
				this.addTypeKeys({
					'sortRecord_success': (data)=>{
						this.setRecordList([]);
						this.getRecord();
					}
				})
			}
			this.send({
				type: 'sortRecord',
				record_id: item.record_id,
				loginKey: this.loginKey,
				tb_type: item.type,
				sort: item.sort==0?1:0
			})
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
	}
</style>