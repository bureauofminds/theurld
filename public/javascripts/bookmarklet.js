if (0 < frames.length) {
    d = window[0].document
} else {
    d = document
}

var backdrop = d.createElement('div');
backdrop.id = '__urld_backdrop';
backdrop.style.zIndex = '99998';
backdrop.style.position = 'fixed';
backdrop.style.top = '0px';
backdrop.style.left = '0px';
backdrop.style.width = '100%';
backdrop.style.height = '100%';
backdrop.style.margin = '0px';
backdrop.style.padding = '0px';
backdrop.style.backgroundColor = '#fff';
backdrop.style.opacity = '.50';
d.body.appendChild(backdrop);

var links = d.getElementsByTagName('a');
var found = false;
for (var i = 0; i < links.length; i++) {
    var link = links[i];
    found = true;
    
    link.href = "#";
    link.style.position = 'relative';
    link.style.zIndex = '99999';
    link.style.color = '#fff';
    link.style.backgroundColor = '#00f';
    link.style.cursor = 'pointer';
    link.style.padding = "2px";
    link.onclick = function() {
        addToFound();
        return false
    };
    link.onmouseover = function() {
        this.style.backgroundColor = '#fff';
        this.style.color = '#00f';
    };
    link.onmouseout = function() {
        this.style.color = '#fff';
        this.style.backgroundColor = '#00f';
    }
}


/*
(function() {
    var token = '6dz1cjgwzb0roA4zyXAvUUAUtcOYlUaLfHwHoIg5JXfVbkSAwpqlW3zbitIPMdOD+8Efo2EYV86ZCZ7a8/Gh1FpkqcMjnCWSAmsAYXcnGDc=';
    var regex_found=/^https?:\/\/.*?\.?ffffound\.com\//
    if (location.href.match(regex_found)) {
        window.alert('This bookmarklet cannot use in ffffound.com domain.');
        return
    }
    var res_endpoint = 'http://ffffound.com/add_asset';
    var res_popupimg_src = 'http://ffffound.com/assets/bookmarklet_01.r2414.gif';
    var res_popupimg_w = 149;
    var res_popupimg_h = 44;
    var res_popupimg2_src = 'http://ffffound.com/assets/bookmarklet_02.r2414.gif';
    var res_popupimg2_w = 149;
    var res_popupimg2_h = 44;
    var min_size = 200;
    var style_em_size = 10;
    var style_background1_color = '#ffffff';
    var style_background2_color = '#000000';
    var style_text_color = '#000000';
    var style_om_color = '#ffffff';
    var style_om_color_ff = 'rgb(255, 255, 0)';
    var isie = 0 <= navigator.appName.indexOf('Internet Explorer');
    var isff = 0 <= navigator.userAgent.indexOf('Firefox');
    var iswk = 0 <= navigator.userAgent.indexOf('Safari');
    var frames = document.getElementsByTagName('frame');
    var d;
    if (0 < frames.length) {
        d = window[0].document
    } else {
        d = document
    }
    var selectedimg = null;
    
    var ele_background1 = d.createElement('div');
    ele_background1.id = '__found-background';
    ele_background1.style.zIndex = 10000;
    ele_background1.style.position = 'fixed';
    ele_background1.style.top = '0px';
    ele_background1.style.left = '0px';
    ele_background1.style.width = '100%';
    ele_background1.style.height = '100%';
    ele_background1.style.margin = '0px';
    ele_background1.style.padding = '0px';
    ele_background1.style.borderWidth = '0px';
    ele_background1.style.backgroundColor = style_background1_color;
    ele_background1.style.opacity = '.25';
    
    var ele_background2 = d.createElement('div');
    ele_background2.id = '__found-background';
    ele_background2.style.zIndex = 10000;
    ele_background2.style.position = 'fixed';
    ele_background2.style.top = '0px';
    ele_background2.style.left = '0px';
    ele_background2.style.width = '100%';
    ele_background2.style.height = '100%';
    ele_background2.style.margin = '0px';
    ele_background2.style.padding = '0px';
    ele_background2.style.borderWidth = '0px';
    ele_background2.style.backgroundColor = style_background2_color;
    ele_background2.style.opacity = '.50';
    
    var ele_popup = d.createElement('div');
    ele_popup.id = '__found-popup';
    ele_popup.style.display = 'none';
    ele_popup.style.zIndex = 10001;
    ele_popup.style.position = 'absolute';
    ele_popup.style.margin = '0px';
    ele_popup.style.padding = '0px';
    ele_popup.style.borderWidth = '0px';
    ele_popup.onmouseout = function() {
        selectedimg = null;
        setTimeout(function() {
            resetAll()
        },
        50)
    };
    d.body.appendChild(ele_background1);
    d.body.appendChild(ele_background2);
    d.body.appendChild(ele_popup);
    var as = d.getElementsByTagName('a');
    var found = false;
    for (var i = 0; i < as.length; i++) {
        var a = as[i];
        if (a.href.match(regex_found)) {
            continue
        } else {
            found = true;
            a.style.position = 'relative';
            a.style.zIndex = '10002';
            a.style.color = style_text_color;
            a.style.backgroundColor = style_om_color;
            a.style.cursor = 'pointer';
            a.onclick = function() {
                addToFound();
                return false
            };
            a.onmouseover = function() {
                selectedimg = this;
                var ele_a = d.createElement('a');
                ele_a.href = 'javascript:void(0);';
                ele_a.onclick = function() {
                    addToFound();
                    return false
                };
                if (ele_popup.firstChild) {
                    ele_popup.removeChild(ele_popup.firstChild)
                }
                ele_popup.appendChild(ele_a);
                var offset = getElementOffset(this);
                ele_popup.style.left = offset[0] + ((this.width + (style_em_size * 2)) / 2) - (res_popupimg_w / 2) + 'px';
                ele_popup.style.top = offset[1] + ((this.height + (style_em_size * 2)) / 2) - (res_popupimg_h / 2) + 'px';
                ele_popup.style.display = '';
                var img = this;
                ele_popup.onmouseover = function() {
                    selectedimg = a
                };
                this.style.backgroundColor = '#ffff00';
                this.style.color = '#000000';
            };
            a.onmouseout = function() {
                selectedimg = null;
                setTimeout(function() {
                    resetAll()
                },
                50)
            }
        }
    }
    if (!found) {
        window.alert('Image not found.')
    }
    function resetAll() {
        for (var i = 0; i < imgs.length; i++) {
            var img = imgs[i];
            if (hide(img)) {
                img.style.border = style_em_size + 'px solid ' + style_em_color;
                if (selectedimg == null) {
                    ele_popup.style.display = 'none'
                }
            }
        }
        function hide(img) {
            if (img == selectedimg) {
                return
            }
            if (iswk) {
                return img.style.borderTopWidth == style_em_size + 'px' && img.style.borderTopStyle == 'solid' && img.style.borderTopColor == style_om_color_ff
            } else if (isff) {
                return img.style.border == style_em_size + 'px solid ' + style_om_color_ff
            } else {
                return img.style.border == style_om_color + ' ' + style_em_size + 'px solid'
            }
        }
    }
    function getElementOffset(element) {
        var valueT = 0,
        valueL = 0;
        do {
            valueT += element.offsetTop || 0;
            valueL += element.offsetLeft || 0;
            element = element.offsetParent;
            if (element) {
                p = element.style.position;
                if (p == 'relative' || p == 'absolute') break
            }
        }
        while (element);
        return [valueL, valueT]
    }
})();
*/