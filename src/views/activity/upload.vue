<template lang="pug">
.article-editor
  el-form(label-position="left", label-width="100px", :rules="rules", :model="form" ref="form")
    .flexrow
      .flex-1
        el-form-item(label="")
          el-upload.upload-demo(
            :action="uploadConfig.url",
            :name="uploadConfig.name",
            :on-success="uploadSuccess",
            :multiple="false",
            :headers="uploadConfig.header",
            :on-error="uploadError")
            el-button(type="primary" size="small") 点击上传活动文件压缩包(zip)
        
</template>
<script>
import Vue from 'vue'
export default {
  components: {
  },
  data () {
    return {
      form : {}
    }
  },
  computed: {
    uploadConfig () {
      return {
        url: Vue.globalOptions.uploadActivityUrl,
        name: 'file',
        accept: 'image/jpg,image/jpeg,image/png,image/gif',
        header: this.mix_headers
      } 
    }
  }, 
  methods: {
    uploadError (e) {
      this.$message.error('upload error: ' + (e.responseText || e))
    },
    uploadSuccess (r) {
      console.log(r);
    }
  }
}
</script>

<style lang="less">

</style>
