import Vue from 'vue'

const getStyle = function(ele,attr){//获得样式
    var style = window.getComputedStyle(ele, null);
    if(style){
      return style.getPropertyValue(attr);
    }else{
      return ele.currentStyle.getAttribute(camelize(attr));
    }
}

let style = document.createElement('style');
style.appendChild(document.createTextNode('@keyframes v-loading{from {transform: rotate(180deg);}to {transform: rotate(540deg);}}.v-loading-mask{position: absolute;top: 0px;left: 0px;width: 100%;height: 100%;z-index: 99999;background-color: rgba(255, 255, 255, 0.8);}.v-loading-img{width: 40px;position: absolute;top: 40%;left: 50%;margin-top: -20px;margin-left: -20px;animation: v-loading 1s cubic-bezier(.17, .86, .73, .14) infinite;'));
document.querySelector('head').appendChild(style);

let config = {
	time: 5000//超时时间默认5秒
}

let cycleObj = false;
let isTimeOut = false;//超时

Vue.directive('loading',{
	bind(el,binding){
		let isLoading = binding.value;
		let position = getStyle(el,'position');
		el.style.position = position == 'absolute'?'absolute':'relative';
		let mask = document.createElement('div');
		mask.className = 'v-loading-mask';
		mask.style.display = isLoading?'block':'none';

		let img = document.createElement('img');
		img.src = 'data:image/png;base64,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';
		img.className = 'v-loading-img';

		mask.appendChild(img);
		el.appendChild(mask);
	},
	componentUpdated(el,binding){
		let isLoading = binding.value;
		if(isTimeOut && !isLoading){//!isLoading是因为binding.value是只读的，所以尽管隐藏了mask但是下次传入的会是false
			isLoading = true;
			isTimeOut = false;
		}
		let mask = el.querySelector('.v-loading-mask');
		mask.style.display = isLoading?'block':'none';
		if(isLoading){
			cycleObj = setTimeout(()=>{//超过超时时间
				isTimeOut = true;//记录
				mask.style.display = 'none';//隐藏mask
			},config.time)
		}else{
			clearTimeout(cycleObj);
		}
	}
});

export default config;