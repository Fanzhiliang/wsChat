<template>
	<div class="area-selecter" v-show="isShow">
		<transition name="show">
			<div class="main" v-show="isShow">
				<div class="head">
					请选择
					<i class="iconfont icon-close" @click="close"></i>
				</div>
				<div class="result">
					<p :class="provinceName?'on':''" @click="showProvince">{{provinceName||'请选择省'}}</p>
					<!-- <div class="line" v-if="provinceName"></div> -->
					<p :class="cityName?'on':''" v-if="provinceName" @click="showCity">{{cityName||'请选择城市'}}</p>
					<!-- <div class="line" v-if="cityName"></div> -->
					<p :class="areaName?'on':''" v-if="cityName" @click="showArea">{{areaName||'请选择区/县'}}</p>
				</div>
				<div class="body">
					<!-- <div class="title">请选择省</div> -->
					<div class="list">
						<template v-for="item in showList">
							<template v-if="item.list.length>0">
								<div class="key">
									<span>{{item.key}}</span>
								</div>
								<div class="value" v-for="l in item.list">
									<span @click="selectItem(l)">{{l.name}}</span>
								</div>
							</template>
						</template>
					</div>
				</div>
			</div>
		</transition>
	</div>
</template>

<script>
import sortPinyin from '@/assets/js/sort-pinyin.js'
import province from '@/assets/js/province.js'
import city from '@/assets/js/city.js'
import area from '@/assets/js/area.js'
export default{
	props:['isShow','areaString','areaArray'],
	data(){
		return{
			province:sortPinyin(province,'name'),
			city:sortPinyin(city,'name'),
			area:sortPinyin(area,'name'),
			showList:[],
			provinceCode:0,
			provinceName:'',
			cityCode:0,
			cityName:'',
			areaCode:0,
			areaName:''
		}
	},
	watch:{
		isShow(newValue){//每次显示隐藏都重置数据
			if(newValue){//显示
				if(this.showList){//如果showList有数据就清空
					this.showList.forEach((item)=>{item.list=[];});
				}
				this.showProvince();
				if(!this.areaArray){//无地区数据返回
					return;
				}
				let tempArea = this.areaString.split(' ');
				this.provinceName = tempArea[0]||'';
				this.cityName = tempArea[1]||'';
				this.areaName = tempArea[2]||'';
				this.provinceCode = this.areaArray[0]||0;
				this.cityCode = this.areaArray[1]||0;
				this.areaCode = this.areaArray[2]||0;
			}else{//隐藏
				console.log(this.provinceName+' '+this.cityName+' '+this.areaName)
				this.$emit('update:areaString',this.provinceName+' '+this.cityName+' '+this.areaName);
				console.log([this.provinceCode,this.cityCode,this.areaCode])
				this.$emit('update:areaArray',[this.provinceCode,this.cityCode,this.areaCode]);
			}
		}
	},
	methods:{
		close(){
			this.$emit('update:isShow',false);
		},
		showProvince(){//显示省份
			this.showList = JSON.parse(JSON.stringify(this.province));
		},
		showCity(){//根据省份code显示城市
			//清空showList
			this.showList.forEach((item)=>{item.list=[];});
			//视图更新后，更新数据
			this.$nextTick(()=>{
				this.city.forEach((item,i)=>{
					this.$set(this.showList[i],'list',item.list.filter((it)=>{
						return it.parent_code==this.provinceCode;
					}));
				})
			})
		},
		showArea(){//根据城市code显示区/县
			//清空showList
			this.showList.forEach((item)=>{item.list=[];});
			//视图更新后，更新数据
			this.$nextTick(()=>{
				this.area.forEach((item,i)=>{
					this.$set(this.showList[i],'list',item.list.filter((it)=>{
						return it.parent_code==this.cityCode;
					}));
				})
			})
		},
		selectItem(item){
			switch ((item.code+'').length) {
				case 2:
					this.provinceCode = item.code;
					this.provinceName = item.name;
					this.showCity();
					//清空下级的选择
					this.cityCode = 0;
					this.cityName = '';
					this.areaCode = 0;
					this.areaName = '';
					break;
				case 4:
					this.cityCode = item.code;
					this.cityName = item.name;
					this.showArea();
					//清空下级的选择
					this.areaCode = 0;
					this.areaName = '';
					break;
				case 6:
					this.areaCode = item.code;
					this.areaName = item.name;
					break;
			}
		}
	},
	created(){
		
	}
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
.main .result{
	min-height: 2em;
	border-bottom: 2px solid #f4f4f4;
	padding: 0.5em 0 0.5em 0.5em;
	position: relative;
}
.main .result .line{
	position: absolute;
	width: 1px;
	height: 1.5em;
	background-color: #12B7F5;
	left: 0.6245em;
}
.main .result .line:nth-of-type(1){top: 1.55em;}
.main .result .line:nth-of-type(2){top: 3.35em;}
.main .result p{
	text-indent: 1.5em;
	font-size: 0.7em;
	line-height: 1.8em;
	position: relative;
	color: #12B7F5;
	cursor: pointer;
}
.main .result p::before{
	width: 0.3em;
	height: 0.3em;
	box-sizing: border-box;
	content: '';
	display: block;
	border: 1px solid #12B7F5;
	border-radius: 50%;
	position: absolute;
	top: 50%;
	transform: translateY(-50%);
}
.main .result p.on{
	color: #333;
}
.main .result p.on::before{
	background-color: #12B7F5;
}
.main .body{
	height: 10em;
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
.main .list{
	/* height: 15.5em; */
}
.main .list .key{
	height: 0;
	overflow: visible;
	margin-top: 0.5em;
}
.main .list .key span{
	line-height: 1.8em;
	font-size: 0.7em;
	color: #b2b2b2;
}
.main .list .value{
	height: 1.8em;
	line-height: 1.8em;
	padding-left: 1.5em;
	font-size: 0.7em;
	color: #333;
}
.main .list .value span{
	display: inline-block;
	/* width: 16em; */
	cursor: pointer;
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
