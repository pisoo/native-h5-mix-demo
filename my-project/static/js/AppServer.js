var isDebug = 1;

var App = {
  /**
   * 
   * @param {String} custom    自定义参数
   * @param {Object} args      参数
   * @param {Function} success 成功回调
   * @param {Function} fail    失败回调
   */
  test: function (custom, args, success, fail) {
    // args，包括所有参数，包括自定义参数
    if (typeof args == "undefined") args = {};
    // 保留字段
    args["custom"] = custom;
    // 同步，比如设置文字标题
    Synchronize("Test", args, success, fail);
    // 异步，比如拍照，相册选择图片
    // Asynchronous("Test", args, success, fail);
  },
  
  log: function (custom, args, success, fail) {

    if (typeof args == "undefined") args = {};
    if (custom.length != 0) {
      args["custom"] = custom;
    }   
    Synchronize("Log", args, success, fail);
  },

  alert: function (custom, args, success, fail) {

    if (typeof args == "undefined") args = {};
    if (custom.length != 0) {
      args["custom"] = custom;
    }  
    Synchronize("Alert", args, success, fail);
  },

  jumpPage: function (pageName, args, success, fail) {
    if (typeof args == "undefined") args = {};
    if (pageName.length != 0) {
      args["pageName"] = pageName;
    }  
    Synchronize("JumpPage", args, success, fail);
  },  

  takePicture: function(custom, args, success, fail) {

    if (typeof args == "undefined") args = {};
    if (custom.length != 0) {
      args["custom"] = custom;
    }  
    // 异步
    Asynchronous("TakePicture", args, success, fail);
  }  
}

var Tool = {
  /**
   * 
   * @param {Object} args 
   * @returns base64 图片
   */
  getBase64Image: function (args) {
    return "data:image/jpeg;base64," + args.image
  }
}

// 同步
var Synchronize = function(cmd_name, cmd_args, cmd_success, cmd_fail) {

  var obj = {"cmd_name": cmd_name};
  AppServer.callNative(JSON.stringify(obj), JSON.stringify(cmd_args), cmd_success, cmd_fail);
}

// 异步
var Asynchronous = function(cmd_name, cmd_args, cmd_success, cmd_fail) {
  
  var obj = {"cmd_name": cmd_name};
  AppServer.callNative(JSON.stringify(obj), JSON.stringify(cmd_args), cmd_success, cmd_fail);
}


var AppServer = {
  
  ID_COUNTER: 0,
  COMMAND_NAME_SET: {},
  COMMAND_ARGS_SET: {},
  COMMAND_SUCCESS_COMPLETION_SET: {},
  COMMAND_FAIL_COMPLETION_SET: {},

  callNative: function (cmd_name, cmd_args, cmd_success, cmd_fail) {

    var key = this.ID_COUNTER++;       
    this.COMMAND_NAME_SET[key] = cmd_name;
    this.COMMAND_ARGS_SET[key] = cmd_args;
    if (typeof cmd_success != 'undefined') this.COMMAND_SUCCESS_COMPLETION_SET[key] = cmd_success;
    if (typeof cmd_fail != 'undefined') this.COMMAND_FAIL_COMPLETION_SET[key] = cmd_fail;
    
    // 调试
    if (isDebug == 1) {
      console.log("DEMO://AppServer?id=" + key);
      console.log("cmd_name = " + cmd_name);
      console.log("cmd_args = " + cmd_args);
    }

    var iframe = document.createElement("IFRAME");    
    iframe.setAttribute("src", "DEMO://AppServer?id=" + key);    
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
  },

  getCommandName: function(key) {
    return this.COMMAND_NAME_SET[key];
  },

  getCommandArgs: function(key) {
    return this.COMMAND_ARGS_SET[key];
  },

  callJS: function (key, args) {
 
    if (typeof args == "undefined") {
      args = JSON.stringify({});
      args = JSON.parse(args);
    }  

    // 参数
    var data = args.data;
    try {
      data = JSON.stringify(data);
    } catch(e) {
      alert(e.message);
    }

    var status = args.status;
    if (status == 1) {
      // 成功
      if (typeof this.COMMAND_SUCCESS_COMPLETION_SET[key] == "undefined") return;
      setTimeout("AppServer.COMMAND_SUCCESS_COMPLETION_SET['" + key + "']('" + data + "')", 0);
    }
    else if (status == 0) {
      // 失败
      if (typeof this.COMMAND_FAIL_COMPLETION_SET[key] == "undefined") return;
      setTimeout("AppServer.COMMAND_FAIL_COMPLETION_SET['" + key + "']('" + data + "')", 0);
    }
  }
}