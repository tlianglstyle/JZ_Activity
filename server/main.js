var router = require('express').Router();
//--------------------Web--------------------
var WebActivityAdd = require('./web/ActivityAdd');
router.post('/activity/uploadimages', WebActivityAdd.uploadimages);
router.post('/activity/build', WebActivityAdd.build);
module.exports = router; 
