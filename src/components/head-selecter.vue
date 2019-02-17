<template>
	<div class="head-selecter" v-show="isShow" v-loading2="isLoading">
		<transition name="show">
			<div class="main" v-show="isShow">
				<div class="head">
					<i class="iconfont icon-close" @click="close"></i>
				</div>
				<div class="body">
					<div class="top-row">
						<div class="userHead" ref="headFrame">
							<img :src="src" alt="" :style="headStyle">
						</div>
						<button class="save" @click="sure">保存头像</button>
						<button class="cancel" @click="close">取消选择</button>
					</div>
					
					<div class="selecter-main" @mousemove="moveing($event);scaleing($event)" @mouseleave="moveEnd($event);scaleEnd($event)" @mouseup="scaleEnd">
						<img :src="src" alt="" class="bg" ref="bg" @load="init" :style="bgStyle">
						<div class="mask"></div>
						<div class="selecter" :style="selecterStyle" @mousedown="moveStart" @mouseup="moveEnd" ref="selecter">
							<div class="inner">
								<img :src="src" alt="" class="selecter-bg" :style="selecterBgStyle">
							</div>
							<div class="point tl" @mousedown="scaleStart" @mouseup="scaleEnd"></div>
							<div class="point tc" @mousedown="scaleStart" @mouseup="scaleEnd"></div>
							<div class="point tr" @mousedown="scaleStart" @mouseup="scaleEnd"></div>
							<div class="point cl" @mousedown="scaleStart" @mouseup="scaleEnd"></div>
							<div class="point cr" @mousedown="scaleStart" @mouseup="scaleEnd"></div>
							<div class="point dl" @mousedown="scaleStart" @mouseup="scaleEnd"></div>
							<div class="point dc" @mousedown="scaleStart" @mouseup="scaleEnd"></div>
							<div class="point dr" @mousedown="scaleStart" @mouseup="scaleEnd"></div>
						</div>
					</div>
				</div>
			</div>
		</transition>
	</div>
</template>

<script>
import {getWindowWidth} from '@/assets/js/utils.js'
import {mapState,mapActions} from 'vuex'
import {upload,cutHead} from '@/api/api.js'
export default{
	props:['isShow','src','head','result'],
	data(){
		return{
			isMove: false,
			isScale: false,
			isInit: false,
			posX: 0,
			posY: 0,
			selecterTop: 0,
			selecterLeft: 0,
			bgWidth: '',
			bgHeight: '',
			selecterWidth: '',
			selecterHeight: '',
			headWidth: '',
			headHeight: '',
			rate: 0,
			pointClass: '',
			isLoading: false
		}
	},
	watch:{
		isShow(newValue){}
	},
	computed:{
		...mapState({
			user:state=>state.data.user
		}),
		bgStyle(){
			return this.isInit?{
				width: this.bgWidth+'px',height: this.bgHeight+'px'
			}:{}
		},
		selecterStyle(){
			return{
				width: this.selecterWidth+'px',height: this.selecterHeight+'px',
				top: this.selecterTop+'px',left: this.selecterLeft+'px'
			}
		},
		selecterBgStyle(){
			return{
				width: this.bgWidth+'px',height: this.bgHeight+'px',
				top: -this.selecterTop+'px',left: -this.selecterLeft+'px'
			}
		},
		headStyle(){
			return{
				width: this.bgWidth/this.rate+'px',height: this.bgHeight/this.rate+'px',
				top: -this.selecterTop/this.rate+'px',left: -this.selecterLeft/this.rate+'px'
			}
		}
	},
	methods:{
		close(res){
			this.$emit('update:isShow',false);
			this.$emit('update:src','');
			this.$emit('update:result',res||'');
			this.selecterTop = 0;
			this.selecterLeft = 0;
			this.isInit = false;
		},
		init(){
			this.setWH();
			this.isInit = true;
			if(this.bgWidth<this.bgHeight){
				this.headWidth = this.bgWidth/5;
				this.selecterTop = (this.bgHeight - this.selecterHeight)/2;
			}else{
				this.headHeight = this.bgHeight/5;
				this.selecterLeft = (this.bgWidth - this.selecterWidth)/2;
			}
		},
		setWH(){
			this.bgWidth = this.$refs.bg.clientWidth;
			this.bgHeight = this.$refs.bg.clientHeight;
			this.selecterWidth = this.bgWidth<this.bgHeight?this.bgWidth:this.bgHeight;
			this.selecterHeight = this.bgWidth<this.bgHeight?this.bgWidth:this.bgHeight;
			this.rate =  this.selecterWidth / this.$refs.headFrame.clientWidth;
		},
		moveStart(e){
			e.preventDefault();
			this.isMove = true;
			this.posX = e.pageX;
			this.posY = e.pageY;
		},
		moveEnd(){
			this.isMove = false;
		},
		moveing(e){
			e.preventDefault();
			if(this.isMove){
				let tempLeft = this.selecterLeft + e.pageX-this.posX;
				let tempTop = this.selecterTop + e.pageY-this.posY;
				if(tempLeft<0){
					tempLeft = 0;
				}else if(tempLeft>this.bgWidth-this.selecterWidth){
					tempLeft = this.bgWidth-this.selecterWidth;
				}
				if(tempTop<0){
					tempTop = 0;
				}else if(tempTop>this.bgHeight-this.selecterHeight){
					tempTop = this.bgHeight-this.selecterHeight;
				}
				this.selecterLeft = tempLeft;
				this.selecterTop = tempTop;
				this.posX = e.pageX;
				this.posY = e.pageY;
			}
		},
		scaleStart(e){
			e.preventDefault();
			e.stopPropagation();
			this.isScale = true;
			this.posX = e.pageX;
			this.posY = e.pageY;
			this.pointClass = e.target.className.split(' ')[1];
		},
		scaleEnd(){
			this.isScale = false;
		},
		scaleing(e){
			e.preventDefault();
			if(this.isScale){
				let tempX = parseFloat(e.pageX-this.posX),
					tempY = parseFloat(e.pageY-this.posY),
					maxLimit = this.bgWidth<this.bgHeight?this.bgWidth:this.bgHeight,
					maxPos1 = this.bgWidth<this.bgHeight?this.selecterLeft:this.selecterTop,
					maxPos2 = maxLimit-this.selecterWidth-maxPos1,
					newLeft = this.selecterLeft,
					newTop = this.selecterTop,
					successHandler = null,
					tempGap = 0,
					limit = maxLimit;
				switch (this.pointClass) {
					case 'tl':
						tempGap = Math.abs(tempX)>Math.abs(tempY)?-tempX:-tempY;
						limit = maxLimit - maxPos2;
						successHandler = ()=>{
							this.selecterLeft -= tempGap;
							this.selecterTop -= tempGap;
						}
						break;
					case 'cr':
						tempGap = tempX;
						limit = maxLimit - maxPos1;
						break;
					case 'tc':
					case 'tr':
						tempGap = -tempY;
						limit = maxLimit - maxPos2;
						successHandler = ()=>{this.selecterTop += tempY;}
						break;
					case 'cl':
					case 'dl':
						tempGap = -tempX;
						limit = maxLimit - maxPos1;
						successHandler = ()=>{this.selecterLeft += tempX;}
						break;
					case 'dc':
					case 'dr':
						tempGap = tempY;
						limit = maxLimit - maxPos1;
						break;
				}
				let selecterSize = this.selecterWidth + tempGap;
				if(selecterSize>=maxLimit){
					selecterSize = maxLimit;
				}else if(selecterSize>=limit){
					selecterSize = limit;
				}else if(this.selecterLeft+selecterSize>this.bgWidth){
					if(typeof successHandler == 'function'){successHandler();}
				}else{
					if(typeof successHandler == 'function'){successHandler();}
				}
				this.selecterWidth = selecterSize;
				this.selecterHeight = selecterSize;
				this.rate =  this.selecterWidth / this.$refs.headFrame.clientWidth;
				this.posX = e.pageX;
				this.posY = e.pageY;
			}
		},
		async sure(){
			this.isLoading = true;
			let imageSrcs = await upload(this.head.files,this.user.user_id);
			if(imageSrcs[0]){
				let newSrc = await cutHead({
					startX: this.selecterLeft/this.bgWidth,
					endX: (this.selecterLeft+this.selecterWidth)/this.bgWidth,
					startY: this.selecterTop/this.bgHeight,
					endY: (this.selecterTop+this.selecterHeight)/this.bgHeight,
					imageSrc: imageSrcs[0]
				});
				this.isLoading = false;
				this.close(newSrc);
			}
		}
	},
	mounted(){}
}
</script>

<style scoped>
.top-row{
	position: absolute;
	top: 0.5em;
	left: 50%;
	transform: translateX(-50%);
	height: 4em;
	overflow: hidden;
	z-index: 5;
}
.userHead{
	width: 4em;
	height: 4em;
	border: 1px solid #d3d3d3;
	cursor: pointer;
	float: left;
	margin-right: 0.5em;
	overflow: hidden;
	position: relative;
}
.userHead img{
	width: auto;
	height: auto;
	position: absolute;
	top: 0;
	left: 0;
}
button{
	padding: 2px 8px;
	margin: 0.6em 0;
	text-align: center;
	border-radius: 5px;
	color: #fff;
	display: block;
	border: 0;
	cursor: pointer;
}
.save{
	background-color: rgb(18,150,219);
}
.cancel{
	background-color: rgb(204,50,47);
}

.selecter-main{
	position: absolute;
	top: 5em;
	left: 50%;
	transform: translateX(-50%);
}
.selecter-main .bg{
	width: auto;
	height: 20em;
	display: block;
}
.selecter-main .mask{
	position: absolute;
    width: 100%;
    height: 100%;
    left: 0;
    top: 0;
    background-color: rgba(0,0,0,0.4);
}
.selecter-main .selecter{
	width: 10em;
	height: 10em;
	position: absolute;
	left: 0;
	top: 0;
	cursor: move;
	box-sizing: border-box;
	border: 1px solid #1296DB;
}
.selecter-main .selecter .inner{
	width: 100%;
	height: 100%;
	position: absolute;
	left: 0;
	top: 0;
	overflow: hidden;
	padding: 0;
}
.selecter-main .selecter-bg{
	width: auto;
	height: 20em;
	position: absolute;
	top: 0;
	left: 0;
}
.selecter-main .selecter .point{
	width: 6px;
	height: 6px;
	position: absolute;
	background-color: rgb(18,150,219);
}

.selecter-main .selecter .tl{
	top: -3px;
	left: -3px;
	cursor: nw-resize;
}

.selecter-main .selecter .tc{
	top: -3px;
	left: 50%;
	margin-left: -3px;
	cursor: n-resize;
}

.selecter-main .selecter .tr{
	top: -3px;
	left: 100%;
	margin-left: -3px;
	cursor: ne-resize;
}

.selecter-main .selecter .dl{
	bottom: -3px;
	left: -3px;
	cursor: ne-resize;
}

.selecter-main .selecter .dc{
	bottom: -3px;
	left: 50%;
	margin-left: -3px;
	cursor: n-resize;
}

.selecter-main .selecter .dr{
	bottom: -3px;
	left: 100%;
	margin-left: -3px;
	cursor: nw-resize;
}

.selecter-main .selecter .cl{
	top: 50%;
	left: -3px;
	margin-top: -3px;
	cursor: e-resize;
}

.selecter-main .selecter .cr{
	top: 50%;
	left: 100%;
	margin-top: -3px;
	margin-left: -3px;
	cursor: e-resize;
}






.head-selecter{
	width: 100%;
	height: 100%;
	position: absolute!important;
	left: 0;
	top: 40px;
	background-color: rgba(0, 0, 0, 0.5);
	font-size: 18px;
}
.main{
	width: 100%;
	background-color: #fff;
	border-radius: 0 0 0.5em 0.5em;
	position: absolute;
	left: 0;
	top: 0;
}
.main .head{
	height: 2em;
	line-height: 2em;
	text-align: center;
	font-size: 1em;
	position: absolute;
	top: 0;
	right: 0;
}
.main .iconfont{
	position: absolute;
	height: 2em;
	color: #b2b2b2;
	font-size: 1.5em;
	right: 0.2em;
	cursor: pointer;
}
.main .body{
	height: 25.5em;
	width: 100%;
}
.main .title{
	height: 1em;
	line-height: 1em;
	font-size: 0.7em;
	color: #b2b2b2;
}
.show-enter-active{
  	animation: show .3s;
}
@keyframes show {
	from{
		transform: translateY(-100%);
	}
	to{
		transform: translateY(0);
	}
}
@media screen and ( max-width: 1000px){
	.head-selecter{
		font-size: 16px;
	}
	button{
		font-size: 12px;
	}
}
@media screen and ( max-width: 580px){
	.head-selecter{
		font-size: 14px;
	}
	.main .body{
		height: 27em;
	}
	.selecter-main{
		top: 5em;
	}
	button{
		float: left;
		margin-top: 1em;
		margin-bottom: 0;
		margin-left: 0.3em;
	}
}
@media screen and ( max-width: 510px){
	.head-selecter{
		font-size: 12px;
	}
	.main .iconfont{
		margin-top: 0.7em;
	}
	.main .iconfont::before{
		font-size: 40px;
	}
}
@media screen and ( max-width: 440px){
	.head-selecter{
		font-size: 10px;
	}
}
@media screen and ( max-width: 390px){
	.head-selecter{
		font-size: 8px;
	}
	.selecter-main{
		top: 5.5em;
	}
	button{
		margin-top: 0.7em;
	}
}
@media screen and ( max-width: 350px){
	.top-row{
		width: 23em;
	}
}
	
</style>
