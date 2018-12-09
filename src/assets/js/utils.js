export const getOffset = function(ele){//获得节点离body偏移量
	var offset = {
		top: ele.offsetTop,
		left: ele.offsetLeft
	}
	if(!ele.offsetParent){
		return offset;
	}else{
		var parentOffset = getOffset(ele.offsetParent);
		return {
			top: offset.top + parentOffset.top,
			left: offset.left + parentOffset.left
		}
	}
}

export const getWindowWidth = function(){//获得屏幕宽度
	var _width = 0;
	if(document.compatMode == "CSS1Compat"){
		_width = document.documentElement.clientWidth;
	}else{
		_width = document.body.clientWidth;
	}
	return _width;
}

export const setCookie = (c_name, value, expiredays) => {//设置cookie
  var exdate = new Date();　　　　
  exdate.setDate(exdate.getDate() + expiredays);　　
  document.cookie = c_name + "=" + escape(value) + ((expiredays == null) ? "" : ";expires=" + exdate.toGMTString());
}

export const getCookie = (name) => {//获取cookie
  var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");
  if (arr = document.cookie.match(reg))
    return unescape(arr[2]);
  else
    return null;
};

export const delCookie =(name) => {//删除cookie
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval = getCookie(name);
    if (cval != null)
      document.cookie = name + "=" + cval + ";expires=" + exp.toGMTString();
}

export const camelize = function(attr){// - 转驼峰
  // /\-(\w)/g 正则内的 (\w) 是一个捕获，捕获的内容对应后面 function 的 letter
  // 意思是将 匹配到的 -x 结构的 x 转换为大写的 X (x 这里代表任意字母)
  return attr.replace(/\-(\w)/g, function(all, letter) {
    return letter.toUpperCase();
  });
}

export const getStyle = function(ele,attr){//获得样式
    var style = window.getComputedStyle(ele, null);
    if(style){
      return style.getPropertyValue(attr);
    }else{
      return ele.currentStyle.getAttribute(camelize(attr));
    }
}

export const UA = {
    _ua: navigator.userAgent,

    // 是否 webkit
    isWebkit: function isWebkit() {
        var reg = /webkit/i;
        return reg.test(this._ua);
    },

    // 是否 IE
    isIE: function isIE() {
        return 'ActiveXObject' in window;
    }
}

