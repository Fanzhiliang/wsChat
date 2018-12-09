let isMobile = /Android|webOS|iPhone|iPod|iPad|BlackBerry|Phone|Mobile/i.test(navigator.userAgent);
// if(isMobile){
	var documentEl = document.documentElement,
        resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize',
        recalc = function() {
            var clientWidth = documentEl.clientWidth;
            if (!clientWidth) return;
            documentEl.style.fontSize = 20 * (clientWidth / 375) + 'px';
        };
    if (!!document.addEventListener){
    	window.addEventListener(resizeEvt, recalc, false);
	    document.addEventListener('DOMContentLoaded', recalc, false);
    } 
// }
export default isMobile;
