<template>
	<div class="area-selecter" v-show="isShow">
		<transition name="show">
			<div class="main" v-show="isShow">
				<div class="head">
					请选择
					<i class="iconfont icon-close" @click="close"></i>
				</div>
				<div class="body">
					<div :class="['row',item.on?'on':'']" v-for="item in list" @click="selectItem(item)">{{item.name}}</div>
				</div>
			</div>
		</transition>
	</div>
</template>

<script>
export default{
	props:['isShow','sexName','sexId'],
	data(){
		return{
			list: [{
				name:'男',on:false,id:1
			},{
				name:'女',on:false,id:2
			}]
		}
	},
	watch:{
		isShow(newValue){
			if(newValue){//显示
				this.list.forEach((item)=>{
					item.on = this.sexId==item.id && this.sexName==item.name;
				})
			}
		}
	},
	methods:{
		close(){
			this.$emit('update:isShow',false);
		},
		selectItem(item){
			this.$emit('update:sexName',item.name);
			this.$emit('update:sexId',item.id);
			this.close();
		}
	},
	created(){}
}
</script>

<style scoped>
.area-selecter{
	width: 100%;
	height: 100%;
	position: absolute;
	left: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.5);
	font-size: 18px;
}
@media screen and ( max-width: 1000px){
	.area-selecter{
		font-size: 16px;
	}
}
.main{
	width: 100%;
	background-color: #fff;
	border-radius: 0.5em 0.5em 0 0;
	position: absolute;
	left: 0;
	bottom: 0;
}
.main .head{
	height: 2em;
	line-height: 2em;
	text-align: center;
	font-size: 1em;
	position: relative;
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
	height: 4em;
	padding-left: 0.5em;
	padding-bottom: 0.5em;
	overflow-y: scroll;
	padding-right: 17px;
	width: 100%;
}
.main .title{
	height: 1em;
	line-height: 1em;
	font-size: 0.7em;
	color: #b2b2b2;
}
.main .row{
	height: 2em;
	line-height: 2em;
	text-align: center;
	cursor: pointer;
	opacity: 0.5;
}
.main .row.on{
	opacity: 1;
}

.show-enter-active{
  	animation: show .3s;
}
@keyframes show {
	from{
		transform: translateY(100%);
	}
	to{
		transform: translateY(0);
	}
}
</style>
