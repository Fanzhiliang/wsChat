<template>
	<div class="dynamic-list" ref="wrap" @click="isShowCtrl=false;setShowEditor(false)">
		<div class="list-inner" ref="inner">
			<div class="dynamic" v-for="(item,index) in list">
				<div class="head-wrap">
					<a href="#"><img :src="item.head" alt="" class="head"></a> 
				</div>
				<a href="#" class="name ellipsis" :title="item.name">{{item.name}}</a>
				<p class="text" v-html="item.text" ref="text"></p>
				<p class="toggle" ref="toggle">
					<a href="#" @click.prevent="toggleText(index,true)" v-if="!item.isToggle">全文</a>
					<a href="#" @click.prevent="toggleText(index,false)" v-else>收起</a>
				</p>
				<div class="clearfix">
					<div class="img-frame" v-for="img in item.imgs">
						<a :href="img" class="img-wrap" target="_blank" :style="'background-image:url('+img+')'"></a>
					</div>
				</div>
				<p v-if="item.address" class="address ellipsis" :title="item.address">{{item.address}}</p>
				<p class="bottom">
					<span class="date">{{item.date}}</span>
					<a href="#" class="delete">删除</a>
					<span class="iconfont icon-more" ref="more" @click.stop="clickMore(index)"></span>
				</p>

				<div class="discuss" v-if="item.likes&&item.discussList&&item.likes.length>0&&item.discussList.length>0">
					<div class="like" v-if="item.likes.length>0">
						<span class="iconfont icon-heart1"></span>
						<template v-for="(like,index) in item.likes">
							<a href="#" class="like-name">{{like.name}}</a>
							<span class="separate" v-if="index<item.likes.length-1">,</span>
						</template>
					</div>

					<div class="discuss-list" v-if="item.discussList.length>0">
						<p v-for="discuss in item.discussList">
							<a href="#">{{discuss.name}}</a><span>:{{discuss.content}}</span>
						</p>
					</div>
				</div>
			</div>
		</div>
		<div class="dynamic-mask" v-if="isShowCtrl||isShowEditor"></div>
		<div class="scrollBar" ref="bar"></div>
		<div class="fixed-ctrl clearfix" ref="fixedCtrl" v-show="isShowCtrl" @click.stop="">
			<a href="#"><span class="iconfont icon-heart1"></span>赞</a>
			<a href="#" @click="isShowCtrl=false;setShowEditor(true)">
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
			list:[
				{
					head: 'static/img/user-head.png',
					name: '蚊子腿细也是肉',
					date: '2016年11月11日 00:45',
					address: '广东省广州市南沙区横沥镇新村中心村五街四号',
					text: '2018.11.03~2018.11.10<br>很开心认识了新加坡的Tina，北京的霍大哥，胡志明的越南小哥。<br>Welcome to China.<br><br>旅行同时思考思考自己。一次开心放松的旅行，感恩所见到的一切<br><br>图一图二是一组，图四图五是一组',
					imgs: [
						'static/img/test-1.jpg','static/img/test-2.jpg','static/img/test-3.jpg',
						'static/img/test-1.jpg','static/img/test-2.jpg','static/img/test-3.jpg',
						'static/img/test-1.jpg','static/img/test-2.jpg','static/img/test-3.jpg'
					],
					likes: [
						{name: '小明'},{name: '小红'},{name: '小青'},{name: 'Fanzhiliang'},{name: 'NM$L'},
						{name: '弱智'},{name: '777'},{name: '小智'},{name: '小刚'},{name: '小霞'},{name: '皮卡丘'},
					],
					discussList: [
						{
							name: '小明',
							content: '出门在外，注意安全。'
						},
						{
							name: '皮卡丘',
							content: '肩背一匹布，手提一瓶醋，走了一里路，看见一只兔，卸下布，放下醋，去捉兔。跑了兔，丢了布，洒了醋。'
						}
					]
				},
				{
					head: 'static/img/user-head.png',
					name: 'fzl',
					date: '2016年11月11日 00:45',
					address: '广东省广州市南沙区横沥镇新村中心村五街四号',
					text: '美好的一天~',
				},
				{
					head: 'static/img/user-head.png',
					name: '蚊子腿细也是肉',
					date: '2016年11月11日 00:45',
					address: '广东省广州市南沙区横沥镇新村中心村五街四号',
					text: '2018.11.03~2018.11.10<br>很开心认识了新加坡的Tina，北京的霍大哥，胡志明的越南小哥。<br>Welcome to China.<br><br>旅行同时思考思考自己。一次开心放松的旅行，感恩所见到的一切<br><br>图一图二是一组，图四图五是一组',
				},
				{
					head: 'static/img/user-head.png',
					name: 'fzl',
					date: '2016年11月11日 00:45',
					address: '广东省广州市南沙区横沥镇新村中心村五街四号',
					text: '美好的一天~',
				},
				{
					head: 'static/img/user-head.png',
					name: '蚊子腿细也是肉',
					date: '2016年11月11日 00:45',
					address: '广东省广州市南沙区横沥镇新村中心村五街四号',
					text: '2018.11.03~2018.11.10<br>很开心认识了新加坡的Tina，北京的霍大哥，胡志明的越南小哥。<br>Welcome to China.<br><br>旅行同时思考思考自己。一次开心放松的旅行，感恩所见到的一切<br><br>图一图二是一组，图四图五是一组',
				},
				{
					head: 'static/img/user-head.png',
					name: 'fzl',
					date: '2016年11月11日 00:45',
					address: '广东省广州市南沙区横沥镇新村中心村五街四号',
					text: '美好的一天~',
				},
				{
					head: 'static/img/user-head.png',
					name: '蚊子腿细也是肉',
					date: '2016年11月11日 00:45',
					address: '广东省广州市南沙区横沥镇新村中心村五街四号',
					text: '2018.11.03~2018.11.10<br>很开心认识了新加坡的Tina，北京的霍大哥，胡志明的越南小哥。<br>Welcome to China.<br><br>旅行同时思考思考自己。一次开心放松的旅行，感恩所见到的一切<br><br>图一图二是一组，图四图五是一组',
				},
				{
					head: 'static/img/user-head.png',
					name: 'fzl',
					date: '2016年11月11日 00:45',
					address: '广东省广州市南沙区横沥镇新村中心村五街四号',
					text: '美好的一天~',
				}
			],
			bar: false,
			isShowCtrl: false
		}
	},
	computed:{
		...mapState({
			isShowEditor:state=>state.view.isShowEditor
		})
	},
	methods:{
		...mapActions({
			setShowEditor: 'view/setShowEditor'
		}),
		toggleText(index,res){
			this.$set(this.list[index],'isToggle',res);
			this.$refs.text[index].style.maxHeight = res?'initial':'';
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
		}
	},
	mounted(){
		this.$nextTick(()=>{
			this.$refs.text.forEach((item,i)=>{
				if(item.clientHeight == 108){
					this.$refs.toggle[i].style.display = 'inline';
					this.$set(this.list[i],'isToggle',false);
				}
			});
			if(!this.$isMobile){//自定义滚动条
				this.bar = new ScrollBar(this.$refs.wrap,this.$refs.inner,this.$refs.bar);
				if(typeof this.bar.setBarHeight == 'function'){
					window.addEventListener('resize',this.bar.setBarHeight);
				}
			}
		})
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
	max-height: 108px;
}
.toggle{
	font-size: 14px;
	color: #60729B;
	line-height: 24px;
	display: none;
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
	border-bottom: 1px solid #e6e6e6;
	padding-bottom: 3%;
	line-height: 18px;
	color: #60729B;
}
.discuss .like-name{

}
.discuss-list{
	padding-top: 3%;
}
.discuss-list p{
	padding-bottom: 5px;
	line-height: 18px;
}
</style>