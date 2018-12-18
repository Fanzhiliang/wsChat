var Tip = function(){
	var isMobile = /Android|webOS|iPhone|iPod|iPad|BlackBerry|Phone|Mobile/i.test(navigator.userAgent);

	if(document.querySelectorAll("#tip").length==0){
		var style = document.createElement('style');
		if(isMobile){
			style.appendChild(document.createTextNode('#tip {transition: opacity .2s;width: 100%;height: 100%;position: fixed;top: 0;left: 0;z-index: 999999;text-align: center;display: none;}#tip .tip-body {transition: all .3s;width: 0;/*width: 60%;*/height: 0;/*height: 20%;*/padding: 0;/*padding: 10%;*/display: inline-block;background-color: #fff;position: relative;top: 25%;border-radius: 5px;box-shadow: 0px 0px 5px #888888;font-size: 0.9rem;}#tip .tip-main{word-wrap: break-word;}#tip .tip-btns {width: 100%;height: 20%;position: absolute;left: 0;bottom: 0;}#tip .tip-btns button {color: #fff;border: 0;border-radius: 5px;padding: 4px 15px;cursor: pointer;}#tip .sure {background-color: rgb(18, 150, 219);margin-right: 10%;}#tip .cancel {background-color: rgb(204, 50, 47);margin-left: 10%;}#tip .tip-body>* {opacity: 0;}'));
			document.querySelector("head").appendChild(style);
		}else{
			style.appendChild(document.createTextNode('#tip {transition: opacity .2s;display: none;position: fixed;width: 100%;height: 100%;top: 0;left: 0;z-index: 999999;}#tip .tip-body {transition: all .3s;width: 0;/*width: 240px;*/height: 0;/*height: 140px;*/padding: 0;/*padding: 30px;*/position: absolute;top: 50%;left: 50%;transform: translateX(-50%) translateY(-50%);background-color: #fff;border-radius: 5px;box-shadow: 0 0 5px #888888;}#tip .tip-main{padding: 20px 10px;font-size: 16px;text-align: center;height: 100px;word-wrap: break-word;}#tip .tip-btns {position: absolute;width: 100%;height: 30px;left: 0;bottom: 10px;text-align: center;}#tip .tip-btns button {color: #fff;border: 0;border-radius: 5px;padding: 4px 15px;cursor: pointer;}#tip .sure {background-color: rgb(18, 150, 219);margin-right: 10%;}#tip .cancel {background-color: rgb(204, 50, 47);margin-left: 10%;}#tip .tip-body>* {opacity: 0;}'));
			document.querySelector("head").appendChild(style)
		}
		var div = document.createElement('div');
		div.innerHTML = '<div class="tip-body"><div class="tip-main">提示内容</div><div class="tip-btns"><button class="sure">确认</button><button class="cancel">取消</button></div></div>';
		div.id = 'tip';
		document.querySelector("body").appendChild(div);
	}
		
	//保证前面执行完
	setTimeout(function(){},0)
	var tip = document.querySelector("#tip"),
		tipBody = tip.querySelector(".tip-body"),
		tipItem = tip.querySelectorAll(".tip-body>*"),
		tipMain = tip.querySelector(".tip-body .tip-main"),
		sureBtn = tip.querySelector(".sure"),
		cancelBtn = tip.querySelector(".cancel"),
		handler = {},
		showTip = function(message,obj){
			if(typeof message != 'string'){
				return false
			}
			if(obj){
				handler = {
					sure: typeof obj.sure == 'function' ? obj.sure : {},
					cancel: typeof obj.cancel == 'function' ? obj.cancel : {}
				}
			}
			tipMain.innerText = message;
			tip.style.opacity = 1;
			tip.style.display = 'block';
			setTimeout(function(){
				if(isMobile){
					tipBody.style.width = '60%';
					tipBody.style.height = '20%';
					tipBody.style.padding = '10%';
				}else{
					tipBody.style.width = '240px';
					tipBody.style.height = '140px';
					tipBody.style.padding = '30px';
				}
				setTimeout(function(){
					Array.prototype.forEach.call(tipItem,function(item){
						item.style.opacity = 1;
					});
					if(obj && typeof obj.time == 'number' && obj.time>0){
							setTimeout(hideTip,obj.time*1000);
					}
				},200)
			}, 50)
		},
		hideTip = function(){
			tip.style.opacity = 0;
			setTimeout(function(){
				tip.style.display = 'none';
				tipBody.style.width = '';
				tipBody.style.height = '';
				tipBody.style.padding = '';
				Array.prototype.forEach.call(tipItem,function(item){
					item.style.opacity = 0;
				});
			}, 500)
		}
		
	sureBtn.addEventListener('click',function(){
		if(typeof handler.sure == 'function'){
			handler.sure()
		}
		handler = {}
		hideTip()
	})
	cancelBtn.addEventListener('click',function(){
		if(typeof handler.cancel == 'function'){
			handler.cancel()
		}
		handler = {}
		hideTip()
	})
	tip.addEventListener('click',function(e){
		e.stopPropagation();
	})
	this.showTip = showTip
	this.hideTip = hideTip
}

export default new Tip();
