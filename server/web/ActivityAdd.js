var Config = require('../../Config/Config');
require("./Upload");//扩展Object.forEach
var Formidable = require("formidable");

var fs = require('fs');
var fsExtra = require('fs-extra');
var path = require('path');
var imagesUploadDir = Config.root + '/server/custom/images';

function process_upload_file(req, res, callback) {
    var form = new Formidable.IncomingForm();
    fsExtra.ensureDirSync(imagesUploadDir);
	form.uploadDir = imagesUploadDir;
    form.maxFieldsSize = 2 * 1024 * 1024 * 1024;  //2G
    form.parse(req, function (err, fields, files) {
        var upfile;

        Object.forEach(files, function (key, file) {
            upfile = file;
        });
        callback && callback(form, upfile, fields);
    });
} 
function finish_upload(req, res, fields) {
    var result = {
        time: Date.now(),
        name: fields["name"]
    }; 
    res.send(JSON.stringify(result));
}
var upload = function(req, res, next) {
    process_upload_file(req, res, function (form, file, fields) {
        var activityName = file.name.split('.')[0];
        fs.rename(file.path, form.uploadDir + "/" + (file.name));
        fields["name"] = file.name;
        finish_upload(req, res, fields);
    });
}
module.exports.uploadimages = function(req,res,next){
    upload(req,res,next);
};
module.exports.build = function(req,res,next){
    var info = req.body.info;
    var cutList = req.body.cutList;
    var ratio = req.body.ratio;
    var type = info.type == "1"? "pc":"mobile";
    var formIndex = 1;
    var calculate = function(value){
        if(type=="pc"){
            return (value/ratio).toFixed(2) + 'px';
        }else{
            return (value/ratio/1920*100/10).toFixed(2) + 'rem';
        }
    };

    //check dir exist
    var output = Config.root + '/server/custom/output/' + info.url;
    if(!fsExtra.pathExistsSync(output)){
        fsExtra.ensureDirSync(output);
    }
    if(fsExtra.pathExistsSync(output + '/' + type )){
        res.json({success:true,code:0});
        return;
    }else{
        fsExtra.ensureDirSync(output);
    }
    //make html
    var html_content = '';
    for(let c = 0 ; c < cutList.length ; c++){
        let cut = cutList[c];
        let initForm = false;
        if(cut.areaList.length == 0)
            html_content += '<img src="<%= images(\'' + cut.name + '\') %>" alt="极装吉住家装季" />\n';
        else{
            html_content += '<div class="activity-module">\n';
            html_content += '<img src="<%= images(\'' + cut.name + '\') %>"  alt="极装吉住家装季" />\n';
            for(let a = 0 ; a < cut.areaList.length ; a++){
                let area = cut.areaList[a];
                let styles = 'top:' + calculate(area.top) + ';left:' + calculate(area.left) + ';width:' + calculate(area.width) + ';height:' + calculate(area.height) + ';';
                switch(area.type.key){
                    case 'open-form':
                        html_content += '<button class="activity-button" style="'+ styles +'"></button>\n';
                        break;
                    case 'input-name':
                        if(!initForm){
                            initForm = true;
                            html_content += '<div id="j_form' + formIndex++ + '" form-baoming="' + c + '" >\n';
                        }
                        html_content += '<input type="text" class="c1" data-placeholder="请输入您的姓名" style="'+ styles +'" />\n';
                        break;
                    case 'input-telephone':
                        if(!initForm){
                            initForm = true;
                            html_content += '<div id="j_form' + formIndex++ + '" form-baoming="" >\n';
                        }
                        html_content += '<input type="tel" class="c2" data-placeholder="请输入您的联系方式" maxlength="11" style="'+ styles +'" />\n';
                        break;
                    case 'input-mianji':
                        if(!initForm){
                            initForm = true;
                            html_content += '<div id="j_form' + formIndex++ + '" form-baoming="" >\n';
                        }
                        html_content += '<input type="tel" class="c3" data-placeholder="请输入您的房屋面积" maxlength="11" style="'+ styles +'" />\n';
                        html_content = html_content.replace(new RegExp('form-baoming=\"' + c + '\"'),'form-baoming="baojia"');
                        break;
                    case 'input-text':
                        if(!initForm){
                            initForm = true;
                            html_content += '<div id="j_form' + formIndex++ + '" form-baoming="" >\n';
                        }
                        html_content += '<input type="text" data-placeholder="请输入您的房屋面积" maxlength="11" style="'+ styles +'" />\n';
                        break;
                    case 'input-submit':
                        if(!initForm){
                            initForm = true;
                            html_content += '<div id="j_form' + formIndex++ + '" form-baoming="" >\n';
                        }
                        html_content += '<button class="btn_submit" style="'+ styles +'"></button>\n';
                        break;

                }
            }
            if(initForm) html_content += '</div>\n';
            html_content += '</div>\n';
            
        }
    }
    //build html
    var html_template_url = Config.root + '/server/custom/template/' + type + '.html';
    var html_build_url = Config.root + '/server/custom/build/' + type + '/' + type + '.html';
    var html = fs.readFileSync(html_template_url,"utf-8");
    html = html.replace(/\[node-build-activity-title\]/g,info.title);
    html = html.replace(/\[node-build-activity-modules-placeholder\]/g,html_content);
    fs.writeFile(html_build_url,html,function(err){
        if (err) throw err;
        
        //build js

        //build images
        var images_build_url = Config.root + '/server/custom/build/' + type + '/' + type + '/images';
        fsExtra.removeSync(images_build_url);
        fsExtra.copySync(imagesUploadDir,images_build_url);

        //copy default images
        var images_default_url = Config.root + '/server/custom/template/' + type + '/images';
        fsExtra.copySync(images_default_url,images_build_url);
        
        //copy all to custom
        var all_build_url = Config.root + '/server/custom/build/';
        fsExtra.copySync(all_build_url + type , output);
        
        //clear pool
        fsExtra.removeSync(imagesUploadDir);
        res.json({success:true,code:1});
    });


};