<template>
	<div class="setMessage">
		<div class="title">
			<span class="iconfont icon-left" @click="setShowBody(false)"></span>
			消息相关设置
		</div>
		<div class="set-wrap">
			<div class="set-but double">
				<div class="but">
					声音
					<div :class="['slider-but',isShowAudio?'on':'']" @click="setShowAudio(!isShowAudio)">
						<div class="move-obj"></div>
					</div>
				</div>
				<div class="but">
					弹框提示
					<div :class="['slider-but',isShowAlert?'on':'']" @click="setShowAlert(!isShowAlert)">
						<div class="move-obj"></div>
					</div>
				</div>
			</div>

			<div class="set-but">
				保存登录记录
				<div :class="['slider-but',isSaveRecord?'on':'']" @click="setSaveRecord(!isSaveRecord)">
					<div class="move-obj"></div>
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

		}
	},
	computed:{
		...mapState({
			isShowAudio:state=>state.view.isShowAudio,
			isShowAlert:state=>state.view.isShowAlert,
			isSaveRecord:state=>state.data.isSaveRecord
		})
	},
	methods:{
		...mapActions({
			setShowBody: 'view/setShowBody',
			setShowAudio: 'view/setShowAudio',
			setShowAlert: 'view/setShowAlert',
			setSaveRecord: 'data/setSaveRecord',
			showAlert: 'view/showAlert',
		})
	},
	activated(){
		
	}
}
</script>

<style>
.setMessage{
	width: 100%;
	height: 100%;
	padding-top: 40px;
	background-color: #fff;
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
	left: 10px;
	height: 100%;
	font-size: 18px;
	cursor: pointer;
}
.set-wrap{
	width: 100%;
	min-height: 100%;
	padding: 15px 4%;
	box-sizing: border-box;
}
.set-but{
	height: 40px;
	line-height: 40px;
	padding: 0 10px;
	border: 1px solid #AFC8E2;
	border-radius: 5px;
	font-size: 18px;
	margin-bottom: 20px;
}
.set-but.double{
	height: 80px;
	padding: 0;
}
.set-but.double .but{
	border-top: 1px solid #AFC8E2;
	padding: 0 10px;
}
.set-but.double .but:first-of-type{
	border: 0;
}
.set-but .slider-but{
	width: 50px;
	height: 30px;
	margin-top: 5px;
	float: right;
	background-color: #999999;
	border-radius: 20px;
	cursor: pointer;
	overflow: hidden;
}
.set-but .slider-but .move-obj{
	width: 26px;
	height: 26px;
	margin: 2px;
	background-color: #fff;
	border-radius: 50%;
	float: right;
}
.set-but .slider-but.on{
	background-color: #18AC19;
}
.set-but .slider-but.on .move-obj{
	float: left;
}
</style>