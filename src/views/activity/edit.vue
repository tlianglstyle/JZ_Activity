<template lang="pug">
  <div class="article-editor" ref="container">
    el-form(label-position="left", label-width="100px")
      el-form-item.el-dialog__footer
        <a target="_blank" :href="pageUrl" v-if="pageUrl!=null">页面已生成!</a>
        <el-checkbox v-model="defaults.memorySize">记住尺寸和位置</el-checkbox>&nbsp;
        el-button(type="primary", @click.prevent="save") 生成活动
      <div class="wrap">
        <div v-for="item in fileList">
          <el-row>
            <el-col :md="20" :sm="24" align="bottom">
              <el-row>
                <template v-for="group in areaTypeList">
                  <el-col :xs="24" :sm="12">
                    <el-form-item :label="group.name" label-width="70px" class = "custom-form-item">
                      <el-button-group>
                        <el-button v-for="areaType in group.data" type="primary" size="mini" v-on:click="add(item,areaType)" :icon="areaType.icon">{{areaType.text}}</el-button>
                      </el-button-group>
                    </el-form-item>
                  </el-col>
                </template>
              </el-row>
            </el-col>
            <el-col :md="4" :sm="24" align="right">
              <el-form-item :label="f" label-width="70px" class = "custom-form-item">
                <el-button type="warning" size="small"  v-on:click="clear(item)" icon="delete">清空</el-button>
              </el-form-item>
            </el-col>
          </el-row>

          <div class="box" v-on:mousemove="cut_move" v-on:mouseup="cut_up">
              <img :src='item.name | imgUrl' style="height:100%;width:100%" />
              <div v-for="area in item.areaList" v-on:mousedown.prevent="move_down($event,area)" v-on:mousemove.prevent="move_move($event,area)" v-on:mouseup.prevent="move_up($event,area)" :style="{left:area.left + 'px',top:area.top + 'px',width:area.width + 'px',height:area.height + 'px',}" :class="area.type" >
                <span>{{area.type.text}}</span>
                <button class="remove" v-on:click.prevent="remove($event,area,item)" style="移除">X</button>
                <button class="change" v-on:mousedown.prevent="change_down($event,area)" v-on:mousemove.prevent="change_move($event,area)" v-on:mouseup.prevent="change_up($event,area)" title="缩放"></button>
              </div>
          </div>
        </div>
      </div>
    </div>
</template>
<style lang="less">
@import '../../styles/var.less';
.custom-form-item{margin-bottom:5px;}
.btn-add{margin:5px 0px;}
.box{.relative;overflow:hidden;user-select:none;margin:5px 0;
  >div{.tc;
    height:30px;width:100px;border:1px solid #000;position:absolute;left:0px;top:0px;border:none;cursor:move;
    &:after{.block;.absolute;
      background-color:#000;
      box-shadow:inset 0px 0px 1px 1px #fff;
      width:100%;height:100%;left:0;top:0;opacity:0.7;
      content:'';
    }
    > *{outline:none;}
    > span{
      .tc;.inline-block;.relative;
      font-size: 12px;line-height:20px;padding:0px 5px;
      top: calc( 50% - 15px );z-index:10;
      color: #2d2d2d;border-radius:3px;
      background: rgba(255, 255, 255, 0.9);
    }
    .remove{.absolute;.block;#transition(1.5);
      z-index:1;border:none;
      height:20px;width:20px;background: #fff;border-radius:50%;right:-10px;top:-10px;cursor:pointer;
      border: 1px solid #f15f5f;
      font-family: initial;
      font-size: 12px;
      color: #f15f5f;
      &:hover{
        border-color:red;
        transform:scale(1.2);
      }
    }
    .change{.absolute;.block;#transition(1.5);
      z-index:1;border:none;
      height:20px;width:20px;background: #fff;border-radius:50%;right:-10px;bottom:-10px;cursor:nw-resize;cursor:se-resize;
      border: 1px solid #ddd;
      //transform:scale(0);
      &:hover{
        border-color:#ffd817;
        transform:scale(1.2);
      }
    }
    &.open-form{

    }
  }
}
</style>

<script>
  var removeObjWithArr = function (_arr,_obj) {
      var length = _arr.length;
      for(var i = 0; i < length; i++)
      {
          if(_arr[i] == _obj)
          {
              if(i == 0)
              {
                  _arr.shift(); //删除并返回数组的第一个元素
                  return;
              }
              else if(i == length-1)
              {
                  _arr.pop();  //删除并返回数组的最后一个元素
                  return;
              }
              else
              {
                  _arr.splice(i,1); //删除下标为i的元素
                  return;
              }
          }
      }
  };
import Vue from 'vue'
export default {
  components: {},
  data () {
    return {
      defaults:{
        width:0,height:0,left:0,top:0,
        memorySize : true,//记住上一次尺寸
        currentCutName:''
      },
      pageUrl:null,//生成地址
      info:{},//活动信息
      fileList : [],//切片列表
      currentMoveArea : null,//补充未快速响应的移动事件
      currentChangeArea : null,//补充未快速响应的移动事件
      areaTypeList :[
        {
          name:'组件库',
          type:2,
          data:[
            { key : 'slider-zhucai' , icon : 'menu' , text : '主材轮播',width:300,height:200},
            { key : 'slider-fangan' , icon : 'menu' , text : '整装方案轮播',width:300,height:200},
            { key : 'slider-ybj' , icon : 'menu' , text : '样板间轮播',width:300,height:200}
          ]
        },
        {
          name:'热区元素',
          type:3,
          data:[
            { key : 'open-form' , icon : 'view' , text : '弹出表单',width:100,height:50},
            { key : 'open-link' , icon : 'view' , text : '超链接',width:200,height:50}
          ]
        },
        {
          name:'表单录入',
          type:3,
          data:[
            { key : 'input-name' , icon : 'edit' , text : '姓名',width:200,height:50},
            { key : 'input-telephone' , icon : 'edit' , text : '电话',width:200,height:50},
            { key : 'input-mianji' , icon : 'edit' , text : '面积',width:200,height:50},
            { key : 'input-text' , icon : 'edit' , text : '文本',width:200,height:50},
            { key : 'input-submit' , icon : 'check' , text : '提交',width:200,height:50}
          ]
        }
      ]
    }
  },
  filters: {
    imgUrl (name) {
      return Vue.globalOptions.root + '/static/server/custom/images/' + name;
    }
  }, 
  methods: {
    init (info,fileList){
      this.info = info
      this.fileList = fileList
    },
    add (item,type){
      var width,height,left,top;
      if(this.defaults.memorySize && this.defaults.left != 0 && item.name == this.defaults.currentCutName){
          width = this.defaults.width;
          height = this.defaults.height;
          left = this.defaults.left;
          this.defaults.top += this.defaults.height + 10;//跟上一个area加点间距
          top = this.defaults.top
      }else{
          width = this.defaults.width = type.width;
          height = this.defaults.height = type.height;
          left = this.defaults.left = 100;
          top = this.defaults.top = 20;
      }
      this.defaults.currentCutName = item.name;
      item.areaList.push({
        type:type,
        drag:{
          move_flag:false,
          change_flag:false,
          mousePosition:{x:0,y:0},
          areaPosition:{x:0,y:0},
          areaSize:{width:0,height:0}
        },
        left:left,
        top:top,
        width:width,
        height:height
      });
    },
    clear (item){
      item.areaList = [];
      this.defaults.width = 0;
      this.defaults.height = 0;
      this.defaults.left = 0;
      this.defaults.top = 0;
    },
    move_down (event,area){
      if(!area.drag.move_flag){
        this.currentMoveArea = area;
        area.drag.move_flag = true;
        area.drag.mousePosition = {x:event.clientX,y:event.clientY};
        area.drag.areaPosition = {x:area.left,y:area.top};
      }
    },
    move_move (event,area){
      if(area.drag.move_flag){
        let left = area.drag.areaPosition.x + event.clientX - area.drag.mousePosition.x;
        let top  = area.drag.areaPosition.y + event.clientY - area.drag.mousePosition.y;
        area.left = left > 0 ? left : 0;
        area.top = top > 0 ? top : 0;
        if(this.defaults.memorySize){
          this.defaults.left = left;
          this.defaults.top = top;
          this.defaults.width = area.width;
          this.defaults.height = area.height;
        }
      }
    },
    move_up (event,area){
      if(area.drag.move_flag){
        area.drag.move_flag = false;
      }
    },
    remove (event,area,item){
      removeObjWithArr(item.areaList,area);
      //设置最后一个area为默认尺寸
      if(item.areaList.length>0){
        let lastArea = item.areaList[item.areaList.length-1];
        this.defaults.width = lastArea.width;
        this.defaults.height = lastArea.height;
        this.defaults.left = lastArea.left;
        this.defaults.top = lastArea.top;
      }else{
        this.defaults.width = 0;
        this.defaults.height = 0;
        this.defaults.left = 0;
        this.defaults.top = 0;
      }
    },
    change_down (event,area){
      event.cancelBubble = true;
      if(!area.drag.change_flag){
        this.currentChangeArea = area;
        area.drag.change_flag = true;
        area.drag.mousePosition = {x:event.clientX,y:event.clientY};
        area.drag.areaSize = {width:area.width,height:area.height};
      }
    },
    change_move (event,area){
      if(area.drag.change_flag){
        var width = area.drag.areaSize.width + event.clientX - area.drag.mousePosition.x;
        var height = area.drag.areaSize.height + event.clientY - area.drag.mousePosition.y;
        area.width = width > 50 ? width : 50;
        area.height = height > 30 ? height : 30;
        if(this.defaults.memorySize){
          this.defaults.width = width;
          this.defaults.height = height;
          this.defaults.left = area.left;
          this.defaults.top = area.top;
        }
      }
    },
    change_up (event,area){
      if(area.drag.change_flag){
        this.currentMoveArea = null;
        area.drag.change_flag = false;
      }
    },
    cut_move (event){//补充未快速响应的移动事件
      if(this.currentMoveArea != null){
        this.move_move(event,this.currentMoveArea);
      }else if(this.currentChangeArea != null){
        this.change_move(event,this.currentChangeArea);//补充未快速响应的移动事件
      }
    },
    cut_up (event){//结束未快速响应的移动事件
      if(this.currentMoveArea != null){
        this.currentMoveArea.drag.move_flag = false;
        this.currentMoveArea = null;
      }else if(this.currentChangeArea != null){
        this.currentChangeArea.drag.change_flag = false;
        this.currentChangeArea = null;
      }
    },
    save (){
      var form = {
          info:this.info,
          cutList:this.fileList
        };
        var container = this.$refs.container;
        var width;
        if (window.getComputedStyle) {
            width = window.getComputedStyle(container, null).width;
        } else { 
            width = container.currentStyle.width;
        }
        form.ratio = (parseFloat(width)/1920).toFixed(2);
        this.$post('activity/build', form, { emulateJSON: false }).then(function(data){
          data = JSON.parse(data.bodyText);
          if(data.code == 0 ){
            this.$message({
              message: '已存在的页面地址(请确认活动路径和页面名称是否重复)！',
              type: 'warning'
            });
          }else{
            this.pageUrl = "//localhost:8999/preview/" + this.info.url + '/' + (this.info.type=="1"?"pc":"mobile");
          }
          //this.$emit('close');
          //this.$emit('reload');
        })
    }
  }
}
</script>
