<template>
  <div id="demo">
    <div @click="logClick()" class="line"> Log </div>
    <div @click="alertClick()" class="line"> Alert </div>
    <div @click="jumpPageClick()" class="line"> 跳转页面 </div>
    <div @click="takePictureClicked('拍照')" class="line"> 拍照 </div>
    <img :src="imageBase64Data" alt="" class="box">
  </div>
</template>

<script>

export default {
  name: 'Demo',
  data () {
    return {
      imageBase64Data: ''
    }
  },
  methods: {

    testClick() {
      var args = {"test": "测试"};
      App.test("自定义测试字段", args, function(data) {
        // 成功
        var args = JSON.parse(data);
        console.log(args.message);
      },
      function(data) {
        // 失败
        var args = JSON.parse(data);
        console.log(args.message);
      });
    },

    logClick() {
      var args = {"log": "测试"};
      App.log("自定义测试字段", args, function(data) {
        // 成功
        var args = JSON.parse(data);
        console.log(args.message);
      },
      function(data) {
        // 失败
        var args = JSON.parse(data);
        console.log(args.message);
      });
    },

    alertClick() {
      var args = {"title": "H5设置的标题", "message": "H5传过来的信息！！！"};
      App.alert("", args, function(data) {
        // 成功
        var args = JSON.parse(data);
      },
      function(data) {
        // 失败
        var args = JSON.parse(data);
        console.log(args.message);
      });
    },

    jumpPageClick() {
      App.jumpPage("list", {}, function(data) {
        // 成功
        var args = JSON.parse(data);
      },
      function(data) {
        // 失败
        var args = JSON.parse(data);
        console.log(args.message);
      });
    },

    takePictureClicked() {
      var that=this;
      var args = {};
      App.takePicture("", args, function(data) {
        var args = JSON.parse(data);
        that.imageBase64Data = Tool.getBase64Image(args);
      }, function(data) {        
        var args = JSON.parse(data);
        console.log(args.message);
      });
    }
  }
}
</script>


<style scoped>
#demo {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  height: 100%;
}
.box {
  width: 160px;
  height: 160px;
  background: red;
}
.line {
  line-height: 40px;
  margin-bottom: 40px;
  width: 80px;
  height: 40px;
  border-radius: 5px;
  border: 1px solid black;
}
</style>
