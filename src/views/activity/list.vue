<template lang="pug">
div
    el-button(type="primary" @click="add()") 创建活动
    el-button(type="primary" @click="upload()") 上线代码
    el-button(type="primary") 活动模板
    el-dialog.editor-dialog(title="上传", v-model="addDialog", size="full" v-if="addDialog")
      add(:data="addData" @openEditActivity="edit" @close="closeAdd" @cancel="addDialog = false" v-loading="saveLoading" v-on:reload="reload")
    el-dialog.editor-dialog(title="编辑活动"  v-model="editActivityDialog"  size="full" v-if="editActivityDialog")
      edit(:data="editActivityData" ref="editActivity" @close="closeEditActivity" @cancel="editActivityDialog = false" v-loading="saveLoading")
    el-dialog.editor-dialog(title="上传", v-model="uploadDialog", size="full" v-if="uploadDialog")
      upload(:data="uploadData" @close="closeUpload" @cancel="uploadDialog = false" v-loading="saveLoading" v-on:reload="reload")
</template>

<script>
import add from './add'
import edit from './edit'
import upload from './upload'
import Vue from 'vue'
export default {
  created () {
   //return;
    this.edit({type:"1",title:""},[{name:'4.jpg',
      width:100,height:100,left:0,top:0,areaList:[]
    }]);
  },
  components: { add,edit,upload },
  data () {
    return {
      addData: {},
      addDialog: false,
      editActivityData: {},
      editActivityDialog: false,
      uploadData: {},
      uploadDialog: false,
      saveLoading: false,
    }
  },
  methods:{
    reload () {
      
    },
    add (){
      this.addData = {}
      this.addDialog = true
    },
    edit (info,fileList){
      this.editActivityDialog = true
      var _that = this;
      Vue.nextTick(function () {
        _that.$refs.editActivity.init(info,fileList);
      });
    },
    upload (){
      this.uploadData = {}
      this.uploadDialog = true
    },
    closeAdd () {
      this.addDialog = false
    },
    closeEditActivity () {
      this.editActivityDialog = false
    },
    closeUpload () {
      this.uploadDialog = false
    }
  }
}
</script>

<style lang="less">
.table-input{
  input{
    padding: 0;
    border: 0;
    background: none;
  }
}
.editor-dialog{
  @title-padding: 20px;
  .el-dialog--full{
    display: flex;
    flex-direction: column;
  }
  .el-dialog__header{
    padding:@title-padding;
  }
  .el-dialog__body{
    flex: 1;
    overflow: auto;
  }
  .el-dialog__footer{
    position: absolute;
    top: 0px;
    right: @title-padding * 2;
  }
}
</style>
