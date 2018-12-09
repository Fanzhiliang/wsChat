import axios from 'axios'
import Qs from 'qs'
axios.defaults.headers = {"Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"};

const host = 'http://www.test3.com/wsChat/api/';
// const host = 'http://ws.alcyh.com/api/';

export const upload = async (file)=>{
	let formDate = new FormData();
	formDate.append('file',file);
	let res = await axios.post(host+'upload.php',formDate);
	return new Promise((resolve)=>{
		if(res.data.err_code == 0){
			resolve(res.data.list[0]);
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

export const getRecord = async (loginKey)=>{
	let res = await axios.post(host+'getRecord.php',Qs.stringify({loginKey}));
	return new Promise((resolve)=>{
		if(res.data.err_code == 0){
			resolve(res.data.list);
		}else{
			resolve(res.data.err_msg);
		}
	})
}

export const getFriendList = async (loginKey)=>{
	let res = await axios.post(host+'getFriendList.php',Qs.stringify({loginKey}));
	return new Promise((resolve)=>{
		if(res.data.err_code == 0){
			resolve(res.data.list);
		}else{
			resolve(res.data.err_msg);
		}
	})
}

export const getGroupList = async (loginKey)=>{
	let res = await axios.post(host+'getGroupList.php',Qs.stringify({loginKey}));
	return new Promise((resolve)=>{
		if(res.data.err_code == 0){
			resolve(res.data.list);
		}else{
			resolve(res.data.err_msg);
		}
	})
}