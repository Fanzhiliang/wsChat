<template>
	<div class="index">
		<div class="index-bg" :style="indexStyle">
			<div class="inner">
				<div class="header"></div>

				<v-main/>

				<div class="footer">
					<div class="bg-ctrl">
						<span class="iconfont icon-cc-arrow-left-circle" @click="prevBg"></span>
						<span class="iconfont icon-cc-arrow-right-circle" @click="nextBg"></span>
						<span class="iconfont icon-image" title="查看背景" @click="showBg"></span>
						<span class="iconfont icon-file" title="上传背景" @click="showUpload"></span>
						<input type="file" id="bgFile" accept="image/*" @change="startUpload($event)">
						<img v-for="item,index in bgImgUrls" :src="item" :data-index="index" class="source" preview="0">
					</div>
					<div class="bg-AD" v-if="isShowBgAD">
						<span class="iconfont icon-online" title="选为背景" @click="selectBg"></span>
						<span class="iconfont icon-offline" title="删除" @click="deleteBg"></span>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
import main from './main'
import {setCookie,getCookie} from '../../assets/js/utils.js'
import {mapState,mapActions} from 'vuex'
import {upload} from '@/api/api.js'
export default{
	data(){
		return{
			bgIndex: 0,
			bgImgUrls: [
				'http://ws.alcyh.com/static/img/bg.png'
			],
			isShowBgAD: false//是否显示确认/删除背景
		}
	},
	computed: {
		...mapState({
			user:state=>state.data.user,
			loginKey:state=>state.data.loginKey
		}),
		indexStyle(){
			return this.bgImgUrls.length==1?{}:{
				'background-image': `url(${this.bgImgUrls[this.bgIndex]})`,
				'background-position': 'center center',
				'background-size': (()=>{
					return this.bgIndex!=0 ? 'cover' : '';
				})()
			};
		}
	},
	methods: {
		...mapActions({
			send: 'data/send',
			setGlobalLoading: 'view/setGlobalLoading'
		}),
		setBgIndex(val){
			this.bgIndex = val;
			setCookie('bgIndex',this.bgIndex,31);
		},
		resetBgImgUrls(){//重置背景
			this.bgIndex = 0;//这里不要用setBgIndex
			this.bgImgUrls = ['http://ws.alcyh.com/static/img/bg.png'];
		},
		getBgImgUrls(){//获得背景
			this.resetBgImgUrls();
			this.send({data: {
				type: 'getBgImgUrls',
				loginKey: this.loginKey
			},callback: (data)=>{
				if(data.list.length>0){
					this.bgImgUrls = this.bgImgUrls.concat(data.list);
					let tempIndex = parseInt(getCookie('bgIndex'));
					this.bgIndex = tempIndex?tempIndex:0;
					this.$previewRefresh();
				}
			}})
		},
		showBg(){//展示背景
			document.querySelectorAll('.source')[this.bgIndex].click();
			this.isShowBgAD = true;
		},
		prevBg(){//上一张图片
			let temp = this.bgIndex - 1;
			if(temp<0){
				temp = this.bgImgUrls.length-1;
			}
			this.setBgIndex(temp);
		},
		nextBg(){//下一张图片
			let temp = this.bgIndex + 1;
			if(temp>this.bgImgUrls.length-1){
				temp = 0;
			}
			this.setBgIndex(temp);
		},
		showUpload(){//显示上传背景
			document.getElementById('bgFile').click();
		},
		async startUpload(e){//开始上传背景
			this.setGlobalLoading(true);
			if(e.target.files.length == 1){
				let imageSrcs = await upload(e.target.files,this.user.user_id);
				this.bgImgUrls.push(imageSrcs[0]);
				this.bgIndex = this.bgImgUrls.length - 1;
				//设置背景
				this.send({data: {
					type: 'setBgImgUrls',
					loginKey: this.loginKey,
					bgImgUrls: this.bgImgUrls.slice(1).join(',')
				},callback: (data)=>{}})
				this.$previewRefresh();
			}
			this.setGlobalLoading(false);
		},
		selectBg(){//选为背景
			this.setBgIndex(this.$preview.self.currItem.el.dataset.index);
			this.$preview.self.close();
		},
		deleteBg(){//删除
			if(this.$preview.self.currItem.el.dataset.index==0){
				this.$preview.self.close();
				this.$message({type: 'warning',message: '默认背景不能删除'});
			}else{
				this.bgImgUrls.splice(this.$preview.self.currItem.el.dataset.index,1);
				//设置背景
				this.send({data: {
					type: 'setBgImgUrls',
					loginKey: this.loginKey,
					bgImgUrls: this.bgImgUrls.slice(1).join(',')
				},callback: (data)=>{}})
				this.prevBg();
				this.$preview.self.close();
			}
		}
	},
	mounted(){
		this.$preview.on('close',()=>{
			this.isShowBgAD = false;
		})
		setTimeout(this.getBgImgUrls, 300);
	},
	components:{
		'v-main':main
	}
}
</script>

<style>
.index{
	width: 100%;
	height: 100%;
	position: relative;
	background-image: url('../../assets/img/bg.png');
}
.index .inner{
	width: 1000px;
	height: 100%;
	margin: 0 auto;
	padding-top: 75px;
	padding-bottom: 45px;
	position: relative;
	box-sizing: border-box;
}

@media screen and ( min-width: 1600px){
	.index .inner{
		padding-top: 200px;
	}
}

.index .header{
	width: 100%;
	height: 75px;
	position: absolute;
	left: 0;
	top: 0;
}

.index .footer{
	width: 100%;
	height: 45px;
	position: absolute;
	left: 0;
	bottom: 0;
}
@media screen and ( max-width: 1000px){
	.header,.footer{
		display: none;
	}
}

.bg-ctrl{
	height: 30px;
	line-height: 30px;
	width: 150px;
	margin: 5px 10px;
}

.bg-ctrl .iconfont{
	color: #d3d3d3;
	font-size: 20px;
	margin-right: 10px;
	cursor: pointer;
}

.bg-ctrl .source{
	width: 0;
	height: 0;
}

#bgFile{
	display: none;
}

.bg-AD{
	position: fixed;
	bottom: 15px;
	right: 25px;
	z-index: 999999;
}
.bg-AD .iconfont{
	color: #d3d3d3;
	cursor: pointer;
	font-size: 20px;
	margin-right: 20px;
}
.index-bg{
	width: 100%;
	height: 100%;
}
</style>