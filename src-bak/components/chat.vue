<template>
	<div :class="['chat',isOver?'over':'',isGroup?'group':'']">
		<div class="title">
			<span class="iconfont icon-left" @click="setShowBody(false)"></span>
			绝缘皮卡丘
			<span class="iconfont icon-group" v-if="isGroup" @click="setShowBody('groupInfo')"></span>
			<span class="iconfont icon-user" v-else @click="setShowBody('userInfo')"></span>
		</div>
		<div :class="['discuss-wrap',$isMobile?'mobile':'']" ref="wrap" @click="isOver=false">
			<div class="discuss-inner" ref="inner">
				<div class="discuss-row">
					<img src="static/img/user-head.png" alt="" class="head">
					<p class="name"><span class="ellipsis">绝缘皮卡丘</span></p>
					<div class="content">在吗？</div>
					<span class="date">2018/11/12 10:52:56</span>
				</div>
				<div class="discuss-row my">
					<img src="static/img/user-head.png" alt="" class="head">
					<p class="name"><span class="ellipsis">运气型选手</span></p>
					<div class="content">在的。</div>
					<span class="date">2018/11/12 10:52:58</span>
				</div>
				<div class="discuss-row">
					<img src="static/img/user-head.png" alt="" class="head">
					<p class="name"><span class="ellipsis">绝缘皮卡丘</span></p>
					<div class="content">给我发点图片。</div>
					<span class="date">2018/11/12 10:52:56</span>
				</div>
				<div class="discuss-row my">
					<img src="static/img/user-head.png" alt="" class="head">
					<p class="name"><span class="ellipsis">运气型选手</span></p>
					<div class="content">
						<a href="static/img/test-1.jpg" target="_blank" class="img">
							<img src="static/img/test-1.jpg" alt="">
						</a>
					</div>
					<span class="date">2018/11/12 10:52:58</span>
				</div>
				<div class="discuss-row my">
					<img src="static/img/user-head.png" alt="" class="head">
					<p class="name"><span class="ellipsis">运气型选手</span></p>
					<div class="content">
						<a href="static/img/test-2.jpg" target="_blank" class="img">
							<img src="static/img/test-2.jpg" alt="">
						</a>
					</div>
					<span class="date">2018/11/12 10:52:58</span>
				</div>
				<div class="discuss-row my">
					<img src="static/img/user-head.png" alt="" class="head">
					<p class="name"><span class="ellipsis">运气型选手</span></p>
					<div class="content">
						<a href="static/img/group-head.png" target="_blank" class="img">
							<img src="static/img/group-head.png" alt="">
						</a>
					</div>
					<span class="date">2018/11/12 10:52:58</span>
				</div>
				<div class="discuss-row my">
					<img src="static/img/user-head.png" alt="" class="head">
					<p class="name"><span class="ellipsis">运气型选手</span></p>
					<div class="content">
						<a href="static/img/test-3.jpg" target="_blank" class="img">
							<img src="static/img/test-3.jpg" alt="">
						</a>
					</div>
					<span class="date">2018/11/12 10:52:58</span>
				</div>
				<div class="discuss-row">
					<img src="static/img/user-head.png" alt="" class="head">
					<p class="name"><span class="ellipsis">绝缘皮卡丘</span></p>
					<div class="content">陈州有个陈白脖子，毫州有个毫白脖子。<br>陈州的陈白脖子和毫州的毫白脖子比白脖子。<br>陈州的陈白脖子比不过毫州的毫白脖子，毫州的毫白脖子的白脖子，比不过陈州的陈白脖子的长脖子。</div>
					<span class="date">2018/11/12 10:52:56</span>
				</div>
			</div>
			<div class="scrollBar" ref="bar"></div>
		</div>
		<div class="bottom-editor c">
			<div id="toolbar"></div>
			<div id="editor" @keydown="editorChange" @click.stop="editorChange"></div>
			<input type="file" class="hide" id="image" accept="image/*" @change="fileChange($event)">
			<button id="send" @click="send">发送</button>
		</div>
		<div class="image-wrap" v-if="imageSrc">
			<div class="image-inner">
				<div class="image-frame">
					<img :src="imageSrc" alt="">
				</div>
				<p>
					确定要发送吗？
					<button class="sure" @click="send">确认</button>
					<button class="cancel" @click="cancelImage">取消</button>
				</p>
			</div>
		</div>
	</div>
</template>

<script>
import ScrollBar from '@/assets/js/ScrollBar'
import {mapState,mapActions} from 'vuex'
export default{
	data(){
		return{
			bar: false,
			editor: false,
			isOver: false,
			imageSrc: '',
			isGroup: true,//是否是群聊
		}
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody'
		}),
		fileChange(e){
        	let file = e.target.files[0];
	        let reader = new FileReader();
          	let handler = (e)=>{
            	this.imageSrc = e.target.result;
            	reader.removeEventListener('load',handler);
          	};
          	reader.addEventListener('load',handler);
          	reader.readAsDataURL(file);
      	},
      	stopWrap(){//解决一开始添加图片或者输入文字会换行的问题
			if(this.editor.txt.html() == '<p><br></p>' && !this.$UA.isWebkit()){
				let br = document.querySelector("#editor p br");
				br.parentNode.removeChild(br);
			}
      	},
		editorChange(){
			this.stopWrap();
			if(typeof this.bar.setBarHeight == 'function' && !this.$isMobile){
				this.bar.setBarHeight();
			}
			setTimeout(()=>{
				let ps = document.querySelectorAll("#editor p");
				this.isOver = ps.length>=2;
				document.querySelectorAll("#editor p img").forEach((item)=>{
					item.style.width='18px';
					item.style.height='18px';
					item.style.margin='0 1px';
					item.style.verticalAlign='middle';
				})
			}, 111);
		},
		goBottom(){
			this.$refs.wrap.scrollTop = this.$refs.inner.clientHeight;
		},
		cancelImage(){
			this.imageSrc = '';
		},
		send(){
			this.goBottom();
		}
	},
	mounted(){
		this.$nextTick(()=>{
			if(!this.$isMobile){//自定义滚动条
				setTimeout(()=>{
					this.bar = new ScrollBar(this.$refs.wrap,this.$refs.inner,this.$refs.bar);
					if(typeof this.bar.setBarHeight == 'function'){
						window.addEventListener('resize',this.bar.setBarHeight);
					}
					this.goBottom();
				}, 555)
			}
			//生成富文本编辑器
			this.editor = new this.$E('#toolbar','#editor');
			this.editor.customConfig.menus = ['emoticon','image'];
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
			document.querySelector(".bottom-editor.c").addEventListener('click',(e)=>{
				if(e.target.getAttribute('alt') == 'face'){//添加表情
					this.stopWrap();
				}else if(e.target.className == 'w-e-icon-image'){//上传图片
					//重写上传图片
					e.target.addEventListener('click',(event)=>{event.stopPropagation()});//阻止冒泡
					let image = document.querySelector("#image");
					image.click();
				}
			},true)
		})
	}
}
</script>

<style scoped>
.chat{
	width: 100%;
	height: 100%;
	padding-top: 40px;
	padding-bottom: 50px;
	background-color: #ECF1F7;
	box-sizing: border-box;
	position: relative;
}
.title{
	width: 100%;
	height: 40px;
	line-height: 40px;
	position: absolute;
	left: 0;
	top: 0;
	text-align: center;
	color: #fff;
	background-color: #9BB7F1;
	font-size: 20px;
}
.title .icon-left{
	position: absolute;
	top: 0;
	left: 10px;
	height: 100%;
	font-size: 18px;
	cursor: pointer;
}
.title .icon-user,.title .icon-group{
	top: 0;
	position: absolute;
	right: 10px;
	height: 100%;
	font-size: 18px;
	cursor: pointer;
}
.title .icon-group{font-size: 25px;}
.discuss-wrap{
	width: 100%;
	min-height: 100%;
	overflow: hidden;
	overflow-y: scroll;
	overflow-x: hidden;
	padding-right: 17px;
	position: relative;
}
.discuss-wrap.mobile{
	padding-right: 0;
}
.discuss-inner{
	position: absolute;
	width: 100%;
}
.discuss-row{
	padding: 20px 50px 10px 50px;
	position: relative;
}
.discuss-row .head{
	width: 30px;
	height: 30px;
	position: absolute;
	left: 10px;
	top: 15px;
	border-radius: 50%;
}
.discuss-row .name{
	font-size: 12px;
	padding-bottom: 3px;
	display: none;
}
.discuss-row .name .ellipsis{
	width: 200px;
	display: inline-block;
}
.group .discuss-row .name{
	display: block;
}
.group .discuss-row .content::before,.discuss-row .content::after{
	top: 4px!important;
}
.discuss-row .content{
	display: inline-block;
	background-color: #d4d8dd;
	padding: 10px;
	line-height: 18px;
	font-size: 14px;
	border-radius: 5px;
	position: relative;
	word-break: break-all;
	text-align: left;
}
.discuss-row .content::before{
	content: '';
	width: 0;
	height: 0;
	border: 5px solid transparent;
	border-right-color: #d4d8dd;
	position: absolute;
	left: -10px;
	top: 10px;
}
.discuss-row .date{
	width: 100%;
	color: #999999;
	text-align: center;
	font-size: 12px;
	position: absolute;
	top: 3px;
	left: 0;
}
.discuss-row .content .img{
	display: block;
}
.discuss-row .content .img img{
	max-width: 220px;
	height: auto;
	display: block;
	border-radius: 5px;
}
@media screen and ( max-width: 400px){
	.discuss-row .content .img img{
		max-width: 160px
	}
}

.discuss-row.my{
	text-align: right;
}
.discuss-row.my .head{
	left: initial;
	right: 10px;
}
.discuss-row.my .name{

}
.discuss-row.my .content{
	background-color: #12B7F5;
	color: #fff;
}
.discuss-row.my .content::before{
	display: none;
}
.discuss-row.my .content::after{
	content: '';
	width: 0;
	height: 0;
	border: 5px solid transparent;
	border-left-color: #12B7F5;
	position: absolute;
	right: -10px;
	top: 10px;
}
.bottom-editor{
	width: 100%;
	height: 50px;
	line-height: 50px;
	/* padding-left: 80px;
	padding-right: 60px; */
	padding-left: 10px;
	padding-right: 140px;
	box-sizing: border-box;
	position: absolute;
	left: 0;
	bottom: 0;
	/* overflow: hidden; */
	background-color: #9BB7F1;
	padding-top: 8px;
	padding-bottom: 8px;
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
.chat .image-wrap{
	position: absolute;
	width: 100%;
	height: 100%;
	left: 0;
	top: 0;
	background-color: rgba(0,0,0,0.2);
}
.chat .image-inner{
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%,-50%);
	width: 260px;
	background-color: #12B7F5;
	padding: 15px 10px 10px 10px;
	border-radius: 5px;
	text-align: center;
}
.chat .image-inner .image-frame{
	max-height: 350px;
	overflow: hidden;
}
.chat .image-inner img{
	max-width: 260px;
	display: inline-block;
	margin: 0 auto;
}
.chat .image-inner p{
	padding-top: 5px;
	color: #fff;
}
.chat .image-inner button{
	width: 50px;
	height: 20px;
	color: #fff;
	border: 0;
	border-radius: 5px;
	cursor: pointer;
	margin-left: 10px;
}
.chat .image-inner button.sure{
	background-color: #2e6da4;
}
.chat .image-inner button.cancel{
	background-color: #d9534f;
}
.chat.over{
	padding-bottom: 100px;
}
.chat.over .bottom-editor{
	height: 100px;
	padding-right: 85px;
}
.chat.over #send{
	width: 60px;
}
</style>