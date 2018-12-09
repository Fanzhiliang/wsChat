export default function(wrap,inner,bar,bias){
	bias = typeof bias == 'number' ? bias : 0;
	var barHeight = 0;//滚动条高度
	var valueScroll = 0;//内容可以滚动的高度
	var barScroll = 0;//滚动条可以滚动和高度
	var setBarHeight = function(){
		var wrapH = wrap.clientHeight - bias;
		var innerH = inner.clientHeight;
		barHeight = wrapH*(wrapH/innerH);
		valueScroll = innerH - wrapH;
		barScroll = wrapH - barHeight;
		if(isNaN(barHeight) || barHeight>=wrapH){
			bar.style.height = '';
			return;
		}
		wrap.style.position = 'relative';
		bar.style.height = barHeight-3+'px';
		scrollHandler();
	}
	window.addEventListener('resize',setBarHeight);

	//设置样式
	if(!document.getElementById('ScrollBar')){//检查是否添加过样式
		var style = document.createElement('style');
		var styleText = document.createTextNode(".scrollBar{width: 5px;height: 0;position: absolute;right: 2px;background-color: #000;opacity: 0.4;border-radius: 5px;}");
		style.setAttribute('id','ScrollBar');
		style.appendChild(styleText);
		document.getElementsByTagName('head')[0].appendChild(style);
	}

	
	var tempRate = 0.0;

	//绑定滚动事件
	var scrollHandler = function(){
		tempRate = wrap.scrollTop/valueScroll;
		bar.style.top = bias + wrap.scrollTop+(tempRate*barScroll) +'px';
	}
	wrap.addEventListener('scroll',scrollHandler);

	this.destroy = function(){
		wrap.style.position = 'initial';
		bar.style.height = 0;
		wrap.removeEventListener('scroll',scrollHandler);
		window.removeEventListener('resize',setBarHeight);
	}
	
	this.setBarHeight = setBarHeight;

	setBarHeight();
}