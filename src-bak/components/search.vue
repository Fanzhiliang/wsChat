<template>
	<div class="search">
		<div class="title">
			<span class="iconfont icon-left" @click="setShowBody(false)"></span>
			<span class="title-main">搜索</span>
		</div>
		<div class="input-row">
			<div class="input-inner">
				<span class="iconfont icon-search1"></span>
				<input type="text">
			</div>
		</div>
		<div :class="['list-wrap',$isMobile?'mobile':'']">
			<div class="list-inner">
				<div class="list">
					<div class="list-tile">搜索联系人</div>
					<div class="rows">
						<div class="item-row">
							<img src="static/img/test-1.jpg" alt="">
							<p class="name ellipsis">谢建华f32sad1f32as1df32as1df32sda1f32sd1f</p>
							<p class="account ellipsis">1103023796</p>
						</div>
						<div class="item-row">
							<img src="static/img/test-1.jpg" alt="">
							<p class="name ellipsis">陈绮韵</p>
							<p class="account ellipsis">1107159909</p>
						</div>
					</div>

					<div class="list-tile">搜索群聊</div>
					<div class="rows">
						<div class="item-row">
							<img src="static/img/test-1.jpg" alt="">
							<p class="name ellipsis">弱智交流群</p>
							<p class="account ellipsis">1103023796</p>
						</div>
						<div class="item-row">
							<img src="static/img/test-1.jpg" alt="">
							<p class="name ellipsis">本地交友群</p>
							<p class="account ellipsis">11071599099</p>
						</div>
					</div>

					<div class="list-tile">我的好友</div>
					<div class="rows">
						<div class="item-row">
							<img src="static/img/test-1.jpg" alt="">
							<p class="name ellipsis">谢建华f32sad1f32as1df32as1df32sda1f32sd1f</p>
							<p class="account ellipsis">1103023796</p>
						</div>
						<div class="item-row">
							<img src="static/img/test-1.jpg" alt="">
							<p class="name ellipsis">陈绮韵</p>
							<p class="account ellipsis">1107159909</p>
						</div>
						<div class="item-row">
							<img src="static/img/test-1.jpg" alt="">
							<p class="name ellipsis">谢建华f32sad1f32as1df32as1df32sda1f32sd1f</p>
							<p class="account ellipsis">1103023796</p>
						</div>
						<div class="item-row">
							<img src="static/img/test-1.jpg" alt="">
							<p class="name ellipsis">陈绮韵</p>
							<p class="account ellipsis">1107159909</p>
						</div>
					</div>

					<div class="list-tile">我的群聊</div>
					<div class="rows">
						<div class="item-row">
							<img src="static/img/test-1.jpg" alt="">
							<p class="name ellipsis">弱智交流群</p>
							<p class="account ellipsis">1103023796</p>
						</div>
						<div class="item-row">
							<img src="static/img/test-1.jpg" alt="">
							<p class="name ellipsis">本地交友群</p>
							<p class="account ellipsis">11071599099</p>
						</div>
					</div>
						
				</div>
			</div>
		</div>
	</div>
</template>

<script>
import {mapState,mapActions} from 'vuex'
export default{
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody'
		})
	},
}
</script>

<style scoped>
.search{
	width: 100%;
	height: 100%;
	padding-top: 80px;
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
.input-row{
	width: 100%;
	height: 40px;
	line-height: 40px;
	padding: 4px 8px;
	box-sizing: border-box;
	position: absolute;
	left: 0;
	top: 40px;
}
.input-row .input-inner{
	height: 34px;
	line-height: 34px;
	background-color: #fff;
	border-radius: 3px;
	padding-left: 25px;
}
.input-row .iconfont{
	position: absolute;
	left: 14px;
	top: 4px;
}
.input-row input{
	display: inline-block;
	width: 100%;
	height: 32px;
	border: 0;
	box-sizing: border-box;
	padding-right: 10px;
	padding-left: 5px;
	vertical-align: top;
	font-size: 15px;
}
.list-wrap{
	width: 100%;
	height: 100%;
	overflow-x: hidden;
	overflow-y: scroll;
	position: relative;
	padding-right: 17px;
}
.list-wrap.mobile{
	padding-right: 0;
}
.list-inner{
	position: absolute;
	width: 100%;
	left: 0;
	top: 0;
	padding: 0 8px;
	box-sizing: border-box;
	padding-bottom: 10px;
}
.list{
	background-color: #fff;
}
.list-tile{
	color: #666;
	font-size: 15px;
	border-bottom: 1px solid #dddddd;
	padding: 12px 0;
	margin: 8px;
}
.item-row{
	height: 60px;
	line-height: 60px;
	cursor: pointer;
}
.item-row:hover{
	background-color: #EDFAFF;
}
.item-row img{
	width: 50px;
	height: 50px;
	float: left;
	border-radius: 50%;
	margin: 5px 8px;
}
.item-row .name{
	padding-right: 8px;
	line-height: 35px;
	color: #333;
}
.item-row .account{
	padding-right: 8px;
	line-height: 16px;
	color: #7e7e7e;
}
.rows{
	padding: 5px 0;
	border-bottom: 2px solid #ECF1F7;
}
</style>