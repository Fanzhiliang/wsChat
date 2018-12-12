<template>
	<div class="publish">
		<div class="title">
			<span class="iconfont icon-left" @click="setShowBody(false)"></span>
			<span class="pub">发表</span>
			<div id="toolbar-p"></div>
		</div>
		<div :class="['publish-inner',$isMobile?'mobile':'']">
			<p class="placeholder" v-show="isShowInput">这一刻的想法</p>
			<div class="publish-wrap">
				<div id="editor-p" @keydown="editorChange" @click.stop="editorChange"></div>
			</div>
			<div class="image-wrap">
				<template v-for="(src,index) in imageSrcs">
					<a v-if="src" href="#" class="image col" @click.prevent="" :style="'background-image:url('+src+')'">
						<span class="iconfont icon-offline" @click="deleteSelect(index)"></span>
					</a>
					<input type="file" class="hide" ref="image" @change="fileChange($event)">
				</template>
				
				<div class="add col" @click="startSelect" v-show="imageCount<imageSrcs.length">
					<img src="../assets/img/add.png" alt="">
				</div>
			</div>
		</div>
	</div>
</template>

<script>
import {mapState,mapActions} from 'vuex'
export default{
	data(){
		return{
			imageSrcs:(()=>{
				let result = [];
				for(let i=0;i<9;i++){
					result.push('');
				}
				return result;
			})(),
			imageCount: 0,
			editor: {},
			isShowInput: true
		}
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody'
		}),
		startSelect(){
			this.$refs.image[this.imageCount].click();
		},
		deleteSelect(index){
			this.imageSrcs.splice(index,1);
			this.imageSrcs.push('');
			--this.imageCount;
		},
		fileChange(e){
        	let file = e.target.files[0];
	        let reader = new FileReader();
          	let handler = (e)=>{
          		this.$set(this.imageSrcs,this.imageCount,e.target.result);
            	reader.removeEventListener('load',handler);
            	++this.imageCount;
          	};
          	reader.addEventListener('load',handler);
          	reader.readAsDataURL(file);
      	},
		stopWrap(){//解决一开始添加图片或者输入文字会换行的问题
			if(this.editor.txt.html() == '<p><br></p>' && !this.$UA.isWebkit()){
				let br = document.querySelector("#editor-p p br");
				br.parentNode.removeChild(br);
			}
      	},
      	editorChange(){
			this.stopWrap();
			let html = this.editor.txt.html();
			this.isShowInput = html=='<p><br></p>'||html=='<p></p>'||html=='';
			setTimeout(()=>{
				let ps = document.querySelectorAll("#editor-p p");
				html = this.editor.txt.html();
				this.isOver = ps.length>=2;
				this.isShowInput = html=='<p><br></p>'||html=='<p></p>'||html=='';
				document.querySelectorAll("#editor-p p img").forEach((item)=>{
					item.style.width='18px';
					item.style.height='18px';
					item.style.margin='0 1px';
					item.style.verticalAlign='middle';
				})
			}, 111);
		}
	},
	mounted(){
		this.$nextTick(()=>{
			//生成富文本编辑器
			this.editor = new this.$E('#toolbar-p','#editor-p');
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
			document.querySelector(".publish").addEventListener('click',(e)=>{
				if(e.target.getAttribute('alt') == 'face'){//添加表情
					this.stopWrap();
					this.isShowInput = false;
				}
			},true)
		})
	}
}
</script>

<style>
.publish{
	width: 100%;
	height: 100%;
	padding-top: 40px;
	background-color: #fff;
	position: relative;
}
.publish-inner{
	width: 100%;
	height: 100%;
	overflow-x: hidden;
	overflow-y: scroll;
	padding-right: 17px;
	position: relative;
}
.publish-inner.mobile{
	padding-right: 0;
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
	left: 10px;
	height: 100%;
	font-size: 18px;
	cursor: pointer;
}
.title .pub{
	position: absolute;
	right: 10px;
	height: 100%;
	font-size: 16px;
	cursor: pointer;
}
.publish-wrap{
	width: 100%;
	height: 140px;
	position: relative;
	z-index: 7;
}
.placeholder{
	border: 0;
	background-color: transparent;
	position: absolute;
	width: 100%;
	padding: 8px 10px;
	z-index: 1;
	color: #999999;
}
#editor-p{
	height: 140px;
}
#editor-p,#editor-p *{
	background-color: transparent;
}
.image-wrap{
	padding: 9% 10px 25px 10px;
	margin-bottom: 6%;
	position: absolute;
	top: 140px;
	left: 0;
	width: 100%;
	box-sizing: border-box;
	overflow: hidden;
}
.image-wrap .col{
	float: left;
	width: 30.8%;
	height: 30%;
	padding-top: 30%;
	margin-right: 3%;
	margin-bottom: 3%;
}
.image-wrap .col:nth-of-type(3n){
	margin-right: 0;
}
.image-wrap .col img{
	width: 100%;
	height: 100%;
	display: block;
	cursor: pointer;
}
.image-wrap .add.col{
	width: 30%;
	padding-top: 0;
	margin-right: 0;
}
.image-wrap .image.col{
	background-size: cover;
	background-position: center;
	background-repeat: no-repeat;
	position: relative;
}
.image-wrap .image.col .iconfont{
	color: #d81e06;
	position: absolute;
	right: 0;
	top: 0;
	font-size: 20px;
	background-color: #fff;
	width: 10px;
	height: 10px;
}
.image-wrap .image.col .iconfont::before{
	position: relative;
	top: -5px;
	left: -5px;
}
</style>