(function($) {

    var app = $.sammy("#contents", function() {

        this.before(function(){
            path = ajaxPath(this.path);
            loadingNotification();
        });

        this.get('#/', function() {
            getAndShow(path);
        });

        this.get('#/topics/new', function() {
            getAndShow(path);
        });

        this.post('/topics', function() {
            postAndShow(path, this.params);
        });

        this.get('#/topics/page/:page_id', function() {
            getAndShow(path);
        });

        this.get('#/topics/:id', function() {
            getAndShow(path);
        });

        this.post('/topics/:id/posts', function() {
            postAndAdd(path, this.params);
        });

        this.post('/topics/:id/members', function() {
            postAndAdd(path, this.params);
        });

        this.get('#/topics/:id/page/:page_id', function() {
            getAndShow(path);
        });

        this.get('#/topics/:id/page/:page_id/:anchor', function() {
            params = this.params;
            getAndShow("/topics/"+params['id']+"/page/"+params['page_id']+".js");
            goToByScroll(params['anchor']);
        });

        this.get('#/topics/:id/posts/:post_id/edit', function() {
            var post_id = this.params['post_id'];
            $.get(path,function(data){
                if (data) {
                    showEdit(data, post_id);
                }
            });
        });

        this.put('/topics/:id/posts/:post_id', function() {
            postAndReplace(path, this.params);
        });

        this.get('#/users/:id', function() {
            getAndShow(path);
        });

        this.get('#/dashboard', function() {
            getAndShow(path);
        });

        this.get('#/smilies', function() {
            getAndShow(path);
        });

        this.get('#/smilies/new', function() {
            getAndShow(path);
        });

    });


    $(function() {
        app.run('#/');
    });

    function getAndShow(path) {
        $.get(path,function(data){
            if (data) {
                showContent(data);
            }
        });
    }

    function postAndShow(path, params) {
        $.ajax({
            type: "POST",
            url: path,
            data: $.param(params.toHash()),
            success: function(msg){
                showContent(msg)
            }
        });
    }

    function postAndReplace(path, params) {
        $.ajax({
            type: "POST",
            url: path,
            data: $.param(params.toHash()),
            success: function(msg){
                replaceContent(msg, params['post_id'])
            }
        });
    }

    function postAndAdd(path, params) {
        $.ajax({
            type: "POST",
            url: path,
            data: $.param(params.toHash()),
            success: function(msg){
                addContent(msg)
            }
        });
    }

    function upload() {
        $("#uploader").livequery(function()
        {
            var uploader = new qq.FileUploader({
            element: document.getElementById('uploader'),
            action: '/smilies'
        });
        $("#new_smiley").hide();
    });
}

})(jQuery);
