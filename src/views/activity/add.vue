<template lang="pug">
.article-editor
  el-form(label-position="right", label-width="100px", :rules="rules", :model="form" ref="form")
    .flexrow
      .flex-1
        el-form-item(label="活动标题" required)
          el-input(v-model="form.title")
        el-form-item(label="路径名称" required)
          el-input(v-model="form.url")
        el-form-item(label="描述信息")
          el-input( type="textarea")
        <el-form-item label="活动类型" required>
          <el-radio-group v-model="form.type">
            <el-radio label="1">PC端</el-radio>
            <el-radio label="2">移动端</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="模块">
          <el-checkbox v-model="form.include_header_default">默认头</el-checkbox>
          <el-checkbox v-model="form.include_header_ad">推广头</el-checkbox>
          <el-checkbox v-model="form.include_pc_zixun">在线咨询(PC)</el-checkbox>
          <el-checkbox v-model="form.include_pc_bottom_form">悬浮报名(PC)</el-checkbox>
          <el-checkbox v-model="form.include_mobile_footer_nav">底部导航(M)</el-checkbox>
        </el-form-item>
        el-form-item(label="上传切片" required)
          el-upload.upload-demo(ref="upload",
            :action="uploadConfig.url",
            :name="uploadConfig.name",
            :on-success="uploadSuccess",
            :before-upload="beforeUpload",
            :on-change="handleChange",
            :multiple="true",
            :headers="uploadConfig.header",
            :on-error="uploadError",
            :auto-upload="false")
            <el-button slot="trigger" size="small" type="primary">选取图片</el-button>
            <el-button style="margin-left: 10px;" size="small" type="success" @click="submitUpload">上传</el-button>
            <div slot="tip" class="el-upload__tip">jpg/png，200kb以内</div>

        
</template>
<script>

import Vue from 'vue'
export default {
  components: {},
  data () {
    return {
      form : {
        title:'',url:'',type:"1",
        include_header_default:true,
        include_header_ad:false,
        include_pc_zixun:true,
        include_pc_bottom_form:false,
        include_mobile_footer_nav:false
      },
      fileList:[],
      fileIndex:0
    }
  },
  computed: {
    uploadConfig () {
      return {
        url: Vue.globalOptions.uploadActivityImagesUrl,
        name: 'file',
        accept: 'image/jpg,image/jpeg,image/png,image/gif',
        header: this.mix_headers
      } 
    }
  }, 
  methods: {
    submitUpload() {
      console.log(this.fileList.length)
      this.$refs.upload.submit();
    },
    handleChange(file, fileList) {
      this.fileList = fileList;
    },
    uploadError (e) {
      this.$message.error('upload error: ' + (e.responseText || e))
    },
    beforeUpload (e) {
      
    },
    uploadSuccess (r) {
      this.fileIndex++;
      if(this.fileIndex==this.fileList.length){
        let fileList = [];
        for(let i in this.fileList){
          fileList.push({
            name:this.fileList[i].name,
            areaList:[]
          });
        }
        this.$emit('openEditActivity',this.form,fileList)
        this.$emit('close')
      }
    }
  }
}
</script>

<style lang="less">

</style>
