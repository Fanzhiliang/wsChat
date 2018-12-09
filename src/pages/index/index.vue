<template>
	<div class="index">
		<div class="inner">
			<div class="header">
				
			</div>

			<v-main/>

			<div class="footer">
				
			</div>
		</div>
	</div>
</template>

<script>
import main from './main'
export default{
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
</style>