var theurldId = 'theurld-n3jj4';

if (!document.getElementById(theurldId)) {
    var div = document.createElement('div');
    div.id = theurldId;
    document.body.appendChild(div);
    
    if (document.createStyleSheet) {
        document.createStyleSheet('http://localhost:3020/stylesheets/bookmarklet.css');
    } else {
        var styles = "@import \"http://localhost:3020/stylesheets/bookmarklet.css\";";
        var newSS = document.createElement('link');
        newSS.rel = 'stylesheet';
        newSS.href = 'data:text/css,' + escape(styles);
        document.getElementsByTagName("head")[0].appendChild(newSS);
    }

    document.getElementById(theurldId).innerHTML = '';
    var content = '<div id="quick_bar"><p class="post_url"><a href="/links/new">Post a URL</a></p><form action="/links/new" method="post"><p><label for="link_uri">Quick submit</label><input id="link_uri" name="link[uri]" onfocus="this.value = \'\'; this.style.color = \'#000\';" style="color: #aaa;" type="text" value="http://" /><select id="link_category_id" name="link[category_id]"><option value="">Select category</option><option value="4">Apparel</option><option value="1">Design</option><option value="2">Programming</option></select><input name="commit" type="submit" value="Go" class="submit" /><input id="link_quick" name="link[quick]" type="hidden" value="true" /></p></form><ul id="quick_navigation"><li><a href="#">My Account</a></li><li><a href="#">Settings</a></li><li><a href="/logout">Logout</a></li></ul></div>';
    document.getElementById(theurldId).innerHTML = content;
} else {
    var div = document.getElementById(theurldId);
    document.body.removeChile(div);
}