<template>
	<div :class="['main','chat',isOverM?'overM':'']">
		<div class="sidebar" ref="sidebar" v-loading2="sidebarLoading">
			<div class="title" :style="barIndex==3?'text-align:center':''">
				{{bottomBar[barIndex].name}}
				<span class="iconfont icon-add add" v-if="barIndex==1" @click="isShowAdd=true"></span>
				<!-- <span class="iconfont icon-search1 search" v-if="barIndex==1" @click="setShowBody('search')"></span> -->
				<span class="iconfont icon-sort sort" v-if="barIndex==0" @click="isShowToggle=!isShowToggle" title="操作"></span>
				<span class="iconfont icon-sort sort l" v-if="barIndex==1" @click="isShowToggle=!isShowToggle" title="操作"></span>
				<span class="iconfont icon-user user" v-if="barIndex==2&&!isSelf" @click="isSelf=true" title="只看自己"></span>
				<span class="iconfont icon-group group" v-if="barIndex==2&&isSelf" @click="isSelf=false" title="全部"></span>
				<span class="iconfont icon-edit edit" v-if="barIndex==2" @click="setShowBody('publish')"></span>
			</div>

			<keep-alive>
				<component :is="bottomBar[barIndex].is" :isShowToggle="isShowToggle" :groupIndex="groupIndex" :isSelf.sync="isSelf"></component>
			</keep-alive>

			<div class="ctrl-header clearfix" v-if="barIndex==1">
				<div :class="['ctrl-item',groupIndex==0?'on':'']">
					<span @click="groupIndex=0">好友</span>
				</div>
				<div :class="['ctrl-item',groupIndex==1?'on':'']">
					<span @click="groupIndex=1">群聊</span>
				</div>
			</div>

			<div class="bottom-bar">
				<div v-for="(item,index) in bottomBar" :class="['bar-item',index==barIndex?'on':'']" @click="barClick(index)">
					<span class="iconfont"></span>
					<p>{{item.name}}</p>
					<div class="point" v-if="hasNewDynamic&&index==2"></div>
				</div>
			</div>

			<div class="add-wrap" v-if="barIndex==1" v-show="isShowAdd" @click="isShowAdd=false">
				<transition name="scale">
					<div class="add-panel" @click.stop="" v-show="isShowAdd">
						<a href="#" @click="setShowBody('insertGroup')"><span class="iconfont icon-addenvironment"></span>创建群聊</a>
						<a href="#" @click="setShowBody('search')"><span class="iconfont icon-search1"></span>搜索人/群</a>
					</div>
				</transition>
			</div>

			<div class="bottom-editor m" v-show="barIndex==2&&isShowEditor" @click.stop="">
				<div id="toolbar-m"></div>
				<div id="editor-m" @keydown="editorChange" @click.stop="editorChange"></div>
				<button id="send" @click="publishMsg">发送</button>
				<span v-if="typeof isShowEditor.name != 'undefined'" class="callUser">
					{{'@'+isShowEditor.name+':'}}
				</span>
			</div>
		</div>

		<div :class="['body',isShowBody?'on':'']">
			<component v-if="bodyIs == 'chat'" :is="bodyIs"></component>
			<keep-alive v-else>
				<component :is="bodyIs"></component>
			</keep-alive>
		</div>
	</div>
</template>

<script>
import msgList from '@/components/msg-list'
import contactList from '@/components/contact-list'
import dynamicList from '@/components/dynamic-list'
import setting from '@/components/setting'
import {mapState,mapActions} from 'vuex'
import chat from '@/components/chat'
import publish from '@/components/publish'
import setMessage from '@/components/setMessage'
import userInfo from '@/components/userInfo'
import friendInfo from '@/components/friendInfo'
import groupInfo from '@/components/groupInfo'
import search from '@/components/search'
import insertGroup from '@/components/insertGroup'

export default{
	data(){
		return{
			barIndex: 0,
			bottomBar:[
				{name: '消息',is: 'msgList'},{name: '联系人',is: 'contactList'},
				{name: '动态',is: 'dynamicList'},{name: '设置',is: 'setting'}
			],
			pageSize: 10,//一页有10条动态
			isShowAdd: false,
			isShowToggle: false,
			groupIndex: 0,
			isOverM: false,
			editor: {},
			hasNewDynamic: false,//是否有新的动态
			isSelf: false,//是否只看自己的动态
		}
	},
	computed:{
		...mapState({
			typeKeys:state=>state.data.typeKeys,
			isShowBody:state=>state.view.isShowBody,
			isShowEditor:state=>state.view.isShowEditor,
			bodyIs:state=>state.view.bodyIs,
			sidebarLoading:state=>state.view.sidebarLoading,
			loginKey:state=>state.data.loginKey,
			user:state=>state.data.user,
			dynamicIndex:state=>state.data.dynamicIndex,
			dynamicList:state=>state.data.dynamicList
		})
	},
	watch:{
		isShowEditor(newValue){
			if(newValue === false && typeof this.editor.txt.clear == 'function'){//隐藏编辑框清空编辑框内容
				this.editor.txt.clear();
			}else if(typeof newValue.name != 'undefined' && typeof this.editor.txt.html == 'function'){//有需要@的人
				this.$nextTick(()=>{//显示@留空
					let _width = document.querySelector(".callUser").clientWidth+'px';
					this.editor.txt.html('<p><span style="width: '+_width+';display:inline-block;">&nbsp;</span><span>&nbsp;</span></p>');
				})
			}
		},
		barIndex(newValue){
			if(newValue==2){
				this.hasNewDynamic = false;
			}
		}
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody',
			setRidebarLoading: 'view/setRidebarLoading',
			setShowEditor: 'view/setShowEditor',
			addTypeKeys: 'data/addTypeKeys',
			send: 'data/send',
			clearDynamicList: 'data/clearDynamicList'
		}),
		stopWrap(){//解决一开始添加图片或者输入文字会换行的问题
			if(this.editor.txt.html() == '<p><br></p>' && !this.$UA.isWebkit()){
				let br = document.querySelector("#editor-m p br");
				br.parentNode.removeChild(br);
			}
      	},
		editorChange(){
			this.stopWrap();
			setTimeout(()=>{
				let ps = document.querySelectorAll("#editor-m p");
				this.isOverM = ps.length>=2;
				// this.isOverM = ps[0].clientHeight>40;
				document.querySelectorAll("#editor-m p img").forEach((item)=>{
					item.style.width='18px';
					item.style.height='18px';
					item.style.margin='0 1px';
					item.style.verticalAlign='middle';
				})
			}, 111);
		},
		publishMsg(){
			this.setRidebarLoading(true);
			let callUserSpace = document.querySelectorAll("#editor-m p span");
			if(callUserSpace && callUserSpace.length>0){
				callUserSpace[0].style.display = 'none';//清空@留空
			}

			this.send({data: {
				type: 'insertDynamicMsg',
				loginKey: this.loginKey,
				dynamic_id: this.dynamicList[this.dynamicIndex]['dynamic_id'],
				content: this.editor.txt.html(),
				callUser_id: (()=>{
					return typeof this.isShowEditor.user_id!='undefined'?this.isShowEditor.user_id:undefined;
				})()
			},callback: (data)=>{
				this.dynamicList[this.dynamicIndex].discussList.push({
					name: this.user.user_name,
					content: this.editor.txt.html(),
					callUser: this.isShowEditor
				})
				this.setShowEditor(false);
				this.setRidebarLoading(false);
			}})
		},
		barClick(index){
			this.isSelf = false;
			this.isShowToggle = false;
			this.setRidebarLoading(false);
			if(index == 2 && this.barIndex==index){//如果重复点击动态图标，重新刷新动态列表
				this.clearDynamicList();
				this.setRidebarLoading(true);
				this.send({data: {
					type: 'getDynamicList',
					loginKey: this.loginKey,
					pageNo: 1,pageSize: this.pageSize
				}})
			}
			this.barIndex=index;
		}
	},
	components:{
		msgList,
		contactList,
		dynamicList,
		setting,
		chat,
		publish,
		setMessage,
		userInfo,
		friendInfo,
		groupInfo,
		search,
		insertGroup
	},
	mounted(){
		this.$nextTick(()=>{
			if(this.$isMobile){//如果是移动端显示浏览器的默认滚动条
				this.$refs.sidebar.style.paddingRight = '17px';
			}
			//生成富文本编辑器
			this.editor = new this.$E('#toolbar-m','#editor-m');
			this.editor.customConfig.menus = ['emoticon'];
			this.editor.customConfig.emotions = [{
		            title: '默认',
		            type: 'image',
		            content: (()=>{
		            	let result = [];
		            	let num = '';
		            	for(let i=0;i<70;i++){
		            		num = i<9 ? '0'+(i+1) : i+1;
		            		result.push({
		            			alt: 'face',
		            			src: './static/img/fFace/fFace_' + num + '.png'
		            		})
		            	}
		            	return result;
		            })()
		    }]
			this.editor.create();
			//要用捕抓方式监听click事件
			document.querySelector(".bottom-editor.m").addEventListener('click',(e)=>{
				if(e.target.getAttribute('alt') == 'face'){//添加表情
					this.stopWrap();
				}
			},true)
		})
		this.hasNewDynamic = this.user.hasNewDynamic==1 || this.user.hasNewDynamicMsg==1?true:false;//新动态或者新评论都显示红点
		this.addTypeKeys({
			'friend_insertDynamic': (data)=>{
				this.hasNewDynamic = true;
			},
			'apply_join_group': (data)=>{
				this.barIndex = 0;
			},
			'apply_add_friend': (data)=>{
				this.barIndex = 0;
			}
		})
	}
}
</script>

<style scoped>
	.main{
		width: 100%;
		height: 100%;
		overflow: hidden;
	}
	.main .sidebar{
		width: 280px;
		height: 100%;
		margin-right: 20px;
		padding-top: 40px;
		padding-bottom: 50px;
		float: left;
		position: relative;
		box-sizing: border-box;
		border-radius: 5px;
		overflow: hidden;
	}
	.main .body{
		width: 700px;
		height: 100%;
		float: left;
		border-radius: 5px;
		overflow: hidden;
		display: none;
		position: relative;
		z-index: 99;
	}
	.ctrl-header{
		position: absolute;
		left: 0;
		top: 40px;
		width: 100%;
		height: 38px;
		line-height: 38px;
		border-bottom: 2px solid #cccccc;
		background-color: #fff;
		z-index: 8;
	}
	.ctrl-item{
		width: 50%;
		height: 40px;
		float: left;
		text-align: center;
		cursor: pointer;
	}
	.ctrl-item span{
		width: 100%;
		height: 38px;
		border-bottom: 2px solid transparent;
		display: inline-block;
		font-size: 16px;
		vertical-align: top;
	}
	.ctrl-item.on span{
		border-bottom-color: #66B4EA;
		color: #66B4EA;
	}
	.sidebar .title{
		width: 100%;
		height: 40px;
		line-height: 40px;
		position: absolute;
		left: 0;
		top: 0;
		/* text-align: center; */
		text-align: left;
		text-indent: 10px;
		color: #fff;
		background-color: #9BB7F1;
		font-size: 20px;
		z-index: 6;
	}
	.sidebar .title .search,.sidebar .title .edit{
		position: absolute;
		top: 0;
		right: 40px;
		height: 100%;
		font-size: 18px;
		cursor: pointer;
	}
	.sidebar .title .sort,.sidebar .title .user,.sidebar .title .add,.sidebar .title .group{
		position: absolute;
		top: 0;
		right: 10px;
		height: 100%;
		font-size: 18px;
		cursor: pointer;
	}
	.sidebar .title .group{
		font-size: 20px;
	}
	.sidebar .title .sort.l{
		right: 40px;
	}
	.sidebar>:nth-child(2){
		width: 100%;
		min-height: 100%;
		z-index: 5;
		background-color: #fff;
		overflow: hidden;
		overflow-y: scroll;
		overflow-x: hidden;
		padding-right: 17px;
		position: relative;
	}
	.sidebar .bottom-bar{
		width: 100%;
		height: 50px;
		position: absolute;
		left: 0;
		bottom: 0;
		background-color: #fff;
		border-top: 1px solid #f0f0f0;
		z-index: 6;
		overflow: hidden;
	}
	.bottom-bar .bar-item{
		width: 25%;
		padding-top: 5px;
		float: left;
		text-align: center;
		color: #878787;
		cursor: pointer;
		position: relative;
	}
	.bottom-bar .point{
		position: absolute;
		background-color: #E13523;
		width: 10px;
		height: 10px;
		border-radius: 50%;
		top: 10%;
		right: 30%;
	}
	.bottom-bar .bar-item .iconfont{
		display: inline-block;
		font-size: 24px;
	}
	.bottom-bar .bar-item:nth-of-type(1) .iconfont::before{
		content: "\e624";
	}
	.bottom-bar .bar-item:nth-of-type(2) .iconfont::before{
		content: "\e7da";
	}
	.bottom-bar .bar-item:nth-of-type(3) .iconfont::before{
		content: "\e64a";
	}
	.bottom-bar .bar-item:nth-of-type(4) .iconfont::before{
		content: "\e67d";
	}
	.bottom-bar .bar-item p{
		font-size: 12px;
		padding-top: 2px;
	}
	@keyframes scaleXY{
		0%{transform: scale(1, 1);}
		50%{transform: scale(0.7, 0.7);}
		100%{transform: scale(1, 1);}
	}
	.bottom-bar .bar-item.on{
		color: #42BAFC;
	}
	.bottom-bar .bar-item.on .iconfont{
		animation: scaleXY .1s;
	}
	.bottom-bar .bar-item:nth-of-type(1).on .iconfont::before{
		content: "\e625";
	}
	.bottom-bar .bar-item:nth-of-type(2).on .iconfont::before{
		content: "\e7be";
	}
	.bottom-bar .bar-item:nth-of-type(3).on .iconfont::before{
		content: "\ef81";
	}
	.bottom-bar .bar-item:nth-of-type(4).on .iconfont::before{
		content: "\e656";
	}
	.add-wrap{
		width: 100%;
		height: 100%;
		position: absolute;
		top: 0;
		left: 0;
		background-color: rgba(0, 0, 0, 0.1);
		z-index: 8;
	}
	.add-wrap::before{
		content: '';
		width: 0;
		height: 0;
		border: 10px solid transparent;
		border-bottom-color: #fff;
		position: absolute;
		right: 8px;
		top: 30px;
	}
	.add-wrap .add-panel{
		width: 120px;
		position: absolute;
		right: 4px;
		top: 47px;
		background-color: #fff;
		border-radius: 5px;
		overflow: hidden;
	}
	.add-wrap .add-panel a{
		display: block;
		text-decoration: none;
		color: #333;
		padding: 5px 5px 5px 25px;
		font-size: 14px;
		position: relative;
		height: 30px;
		line-height: 30px;
		text-align: center;
	}
	.add-wrap .add-panel a:hover,.add-wrap .add-panel a:active{
		background-color: #f0f0f0;
	}
	.add-wrap .add-panel a .iconfont{
		color: #61667B;
		position: absolute;
		left: 10px;
	}

	@media screen and ( max-width: 1000px){
		.main{
			position: fixed;
			left: 0;
			top: 0;
			width: 200%;
		}
		.main .sidebar{
			/* padding-right: 17px; */
		}
		.main .sidebar,.main .body{
			width: 50%;
			border-radius: 0;
			margin-right: 0;
		}
	}
	.scale-enter-active,.scale-leave-active{
		transition: transform .3s;
		transform-origin: 100% 0;
	}
	.scale-enter,.scale-leave-to{
		transform: scale(0, 0);
	}
	.scale-enter-to,.scale-leave{
		transform: scale(1, 1);
	}
	.main .body.on{
		display: inline-block;
	}
	@media screen and ( max-width: 1000px){
		.main .body{
			display: inline-block!important;
			border-radius: 0;
		}
		.main .body.on{
			transition: transform .3s;
			transform: translateX(-100%);
		}
	}
	.bottom-editor{
		width: 100%;
		height: 50px;
		line-height: 50px;
		padding-left: 10px;
		padding-right: 95px;
		box-sizing: border-box;
		position: absolute;
		left: 0;
		bottom: 0;
		background-color: #9BB7F1;
		padding-top: 8px;
		padding-bottom: 8px;
		z-index: 9;
		overflow: visible;
	}
	.chat.overM .bottom-editor.m{
		height: 100px;
		padding-right: 65px;
	}
	#send{
		width: 50px;
		height: 35px;
		position: absolute;
		right: 5px;
		bottom: 8px;
		background-color: #12B7F5;
		color: #fff;
		border: 0;
		border-radius: 5px;
		cursor: pointer;
	}
	.callUser{
		position: absolute;
		background-color: #fff;
		top: 8px;
		left: 20px;
		height: 32px;
		line-height: 32px;
		color: #60729B;
		border-radius: 10px;
		font-size: 17px;
		padding-right: 2px;
		z-index: 999999;
	}
</style>

<style>
	.sidebar .v-loading-mask{
		top: 40px;
		z-index: 5;
	}
</style>