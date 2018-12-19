<template>
	<div class="dynamic-list" ref="wrap" @mousedown="isShowCtrl=false;setShowEditor(false)">
		<div class="list-inner" ref="inner">
			<div class="dynamic" v-for="(item,index) in dynamicList">
				<div class="head-wrap">
					<a href="#"><img :src="item.headPath" alt="" class="head"></a> 
				</div>
				<a href="#" class="name ellipsis" :title="item.name">{{item.name}}</a>
				<p class="text" v-html="item.content" ref="text"></p>
				<p class="toggle" ref="toggle">
					<a href="#" @click.prevent="toggleText(index,true)" v-if="!item.isToggle">全文</a>
					<a href="#" @click.prevent="toggleText(index,false)" v-else>收起</a>
				</p>
				<div class="clearfix">
					<div class="img-frame" v-for="img in item.img_srcs">
						<a :href="img" class="img-wrap" target="_blank" :style="'background-image:url('+img+')'"></a>
					</div>
				</div>
				<p v-if="item.address" class="address ellipsis" :title="item.address">{{item.address}}</p>
				<p class="bottom">
					<span class="date">{{item.write_date_text}}</span>
					<a href="#" class="delete" @click="delDynamic(item.dynamic_id)" v-if="item.user_id==user.user_id">删除</a>
					<span class="iconfont icon-more" ref="more" @click.stop="clickMore(index)"></span>
				</p>

				<div class="discuss" v-if="item.likes.length>0 || item.discussList.length>0">
					<div class="like" v-if="item.likes.length>0">
						<span class="iconfont icon-heart1"></span>
						<template v-for="(like,index) in item.likes">
							<a href="#" class="like-name">{{like.name}}</a>
							<span class="separate" v-if="index<item.likes.length-1">,</span>
						</template>
					</div>

					<div class="discuss-list" v-if="item.discussList.length>0">
						<p v-for="discuss in item.discussList">
							<a href="#" class="discuss-name">{{discuss.name}}:</a><span v-html="discuss.content"></span>
						</p>
					</div>
				</div>
			</div>
		</div>
		<div class="dynamic-mask" v-if="isShowCtrl||isShowEditor"></div>
		<div class="scrollBar" ref="bar"></div>
		<div class="fixed-ctrl clearfix" ref="fixedCtrl" v-show="isShowCtrl" @mousedown.stop="" v-if="">
			<a href="#" @mousedown="setLikeDynamic" v-if="ctrlDynamic && !ctrlDynamic.hasMylike">
				<span class="iconfont icon-heart1"></span>赞
			</a>
			<a href="#" @mousedown="setLikeDynamic" v-else></span>取消</a>
			<a href="#" @mousedown="isShowCtrl=false;setShowEditor(true)">
				<span class="iconfont icon-chatbubbleoutline"></span>评论
			</a>
		</div>
	</div>
</template>

<script>
import ScrollBar from '@/assets/js/ScrollBar'
import {mapState,mapActions} from 'vuex'
export default{
	data(){
		return{
			pageNo: 1,//当前页码
			pageSize: 10,//一页有10条动态
			bar: false,
			isShowCtrl: false
		}
	},
	computed:{
		...mapState({
			typeKeys:state=>state.data.typeKeys,
			isShowEditor:state=>state.view.isShowEditor,
			loginKey:state=>state.data.loginKey,
			user:state=>state.data.user,
			dynamicList:state=>state.data.dynamicList,
			dynamicIndex:state=>state.data.dynamicIndex,
		}),
		ctrlDynamic(){
			if(typeof this.dynamicList[this.dynamicIndex] != 'undefined'){
				return this.dynamicList[this.dynamicIndex];
			}else{
				return false;
			}
		}
	},
	methods:{
		...mapActions({
			setShowEditor: 'view/setShowEditor',
			setRidebarLoading: 'view/setRidebarLoading',
			addTypeKeys: 'data/addTypeKeys',
			send: 'data/send',
			clearDynamicList: 'data/clearDynamicList',
			setDynamicList: 'data/setDynamicList',
			setDynamicToggle: 'data/setDynamicToggle',
			setDynamicIndex: 'data/setDynamicIndex',
			setDynamicLike: 'data/setDynamicLike'
		}),
		toggleText(index,res){
			this.setDynamicToggle({index,data: res});
			document.querySelectorAll(".dynamic-list .text")[index].style.maxHeight = res?'initial':'108px';
			if(typeof this.bar.setBarHeight == 'function'){
				this.bar.setBarHeight();
			}
		},
		clickMore(index){
			this.isShowCtrl = !this.isShowCtrl;
			let more = this.$refs.more[index],
				moreTop = more.offsetTop,
				parentTop = more.offsetParent.offsetTop;
			this.$refs.fixedCtrl.style.top = (moreTop + parentTop - 10) + 'px';
			this.setDynamicIndex(index);
		},
		getDynamicList(){
			if(typeof this.typeKeys['getDynamicList_success'] != 'function'){
				this.addTypeKeys({
					'getDynamicList_success': (data)=>{
						this.setDynamicList({
							list: data.list,
							user_id: this.user.user_id
						});
						this.setRidebarLoading(false);
					}
				})
			}
			this.setRidebarLoading(true);
			this.send({
				type: 'getDynamicList',
				loginKey: this.loginKey,
				pageNo: this.pageNo,
				pageSize: this.pageSize
			})
		},
		delDynamic(dynamicId){
			this.$Tip.showTip('确定要删除吗？',{
				sure:()=>{
					if(typeof this.typeKeys['delDynamic_success'] != 'function'){
						this.addTypeKeys({
							'delDynamic_success': (data)=>{
								this.setRidebarLoading(false);
								this.clearDynamicList();
								this.$nextTick(()=>{
									this.getDynamicList();
								});
							}
						})
					}
					this.setRidebarLoading(true);
					this.send({
						type: 'delDynamic',
						loginKey: this.loginKey,
						dynamic_id: dynamicId
					})
				}
			})		
		},
		setLikeDynamic(){
			if(typeof this.typeKeys['setLikeDynamic_success'] != 'function'){
				this.addTypeKeys({
					'setLikeDynamic_success': (data)=>{
						this.setRidebarLoading(false);
						this.isShowCtrl = false;
						this.setDynamicLike({
							index:this.dynamicIndex,
							likes:data.list
						})
					}
				})
			}
			this.setRidebarLoading(true);
			this.send({
				type: 'setLikeDynamic',
				loginKey: this.loginKey,
				dynamic_id: this.ctrlDynamic.dynamic_id
			})
		}
	},
	activated(){
		this.clearDynamicList();
		this.$nextTick(()=>{
			this.getDynamicList();
		});
	},
	updated(){
		if(!this.$isMobile){//自定义滚动条
			this.bar = new ScrollBar(this.$refs.wrap,this.$refs.inner,this.$refs.bar);
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
		left: 0;
		top: 0;
		width: 100%;
		background-color: #fff;
	}
	.dynamic-mask{
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
	}
	.dynamic{
		padding: 15px 3% 15px 18%;
		position: relative;
		border-bottom: 1px solid #f0f0f0;
	}
	.head-wrap{
		width: 12%;
		padding-top: 12%;
		position: absolute;
		left: 3%;
		top: 15px;
	}
	.head-wrap .head{
		width: 100%;
		height: auto;
		position: absolute;
		top: 0;
		left: 0;
	}
	.name{
		display: block;
		width: 100%;
		margin-bottom: 4.5%;
	}
	.text{
		font-size: 14px;
		line-height: 18px;
		overflow: hidden;
		/* max-height: 108px; */
	}
	.toggle{
		font-size: 14px;
		color: #60729B;
		line-height: 24px;
		visibility: hidden;
	}
	.img-frame{
		width: 68.8px;
		height: 68.8px;
		margin-right: 3.2px;
		margin-bottom: 3.2px;
		float: left;
	}
	.img-wrap{
		width: 100%;
		height: 100%;
		display: block;
		background-size: cover;
		background-position: center center;
	}
	@media screen and ( max-width: 1000px){
		.img-frame{
			width: 4.3rem;
			height: 4.3rem;
			margin-right: 0.2rem;
			margin-bottom: 0.2rem;
		}
	}
	.bottom{
		font-size: 13px;
		padding-top: 2%;
		padding-bottom: 2%;
		line-height: 20px;
	}
	.bottom .date{
		color: #999999;
	}
	.bottom .delete{
		margin-left: 3px;
	}
	.bottom .icon-more{
		color: #60729B;
		float: right;
		font-size: 20px;
		cursor: pointer;
	}
	.address{
		width: 100%;
		color: #60729B;
		font-size: 12px;
		line-height: 26px;
		padding-top: 2%;
	}
	.fixed-ctrl{
		width: 180px;
		height: 40px;
		line-height: 40px;
		position: absolute;
		right: 11%;
		top: 0;
		background-color: #303030;
		border-radius: 3px;
		font-size: 14px;
		overflow: hidden;
	}
	.fixed-ctrl a{
		width: 50%;
		height: 100%;
		float: left;
		color: #fff;
		text-align: center;
	}
	.fixed-ctrl a:hover{
		background-color: #262626;
	}
	.fixed-ctrl a .iconfont{
		margin-right: 3px;
	}
	.discuss{
		background-color: #eeeeee;
		padding: 3%;
		position: relative;
		font-size: 14px;
	}
	.discuss::before{
		content: '';
		width: 0;
		height: 0;
		border: 10px solid transparent;
		border-bottom-color: #eeeeee;
		position: absolute;
		top: -16px;
		left: 10px;
	}
	.discuss .like{
		word-break: break-all;
		padding-bottom: 3%;
		line-height: 18px;
		color: #60729B;
	}
	.discuss .like-name{

	}
	.discuss-list{
		padding-top: 3%;
		border-top: 1px solid #e6e6e6;
	}
	.discuss-name{
		float: left;
	}
	.discuss-list p{
		padding-bottom: 5px;
		line-height: 18px;
	}
</style>

<style>
	.discuss-list img{
		width: 18px;
		height: 18px;
		display: inline-block;
		vertical-align: text-bottom;
	}
	.text img{
		width: 20px;
		height: 20px;
		display: inline-block;
		vertical-align: text-bottom;
	}
</style>