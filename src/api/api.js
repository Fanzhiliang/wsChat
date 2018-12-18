import axios from 'axios'
import Qs from 'qs'
axios.defaults.headers = {"Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"};

const host = 'http://www.test3.com/wsChat/api/';
// const host = 'http://ws.alcyh.com/api/';

export const upload = async (files,user_id)=>{
	let formDate = new FormData();
	for(let i=0;i<files.length;i++){
		formDate.append(i,files[i]);
	}
	formDate.append('user_id',user_id);
	let res = await axios.post(host+'upload.php',formDate);
	return new Promise((resolve)=>{
		if(res.data.err_code == 0){
			resolve(res.data.list);
		}else{
			resolve(false);
		}
	})
}

export const cutHead = async (data)=>{
	let res = await axios.post(host+'cut_head.php',Qs.stringify(data));
	return new Promise((resolve)=>{
		if(res.data.err_code == 0){
			resolve(res.data.list[0]);
		}else{
			resolve(false);
		}
	})
}

export const getCode = async (data)=>{
	let res = await axios.post(host+'getCode.php',Qs.stringify(data));
	return new Promise((resolve)=>{
		if(res.data.err_code == 0){
			resolve('');
		}else{
			resolve(res.data.err_msg);
		}
	})
}

export const getIp = async ()=>{
	let res = await axios.post('http://ws.alcyh.com/utils/'+'getIp.php');//本地服务器不能正确获取ip，需要在服务器上的使用接口
	return new Promise((resolve)=>{
		if(res.data){
			resolve(res.data);
		}else{
			resolve(false);
		}
	})
}