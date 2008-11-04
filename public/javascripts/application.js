// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Used to copy text into the users clipboard
// http://bravo9.com/journal/copying-text-into-the-clipboard-with-javascript-in-firefox-safari-ie-opera-292559a2-cc6c-4ebf-9724-d23e8bc5ad8a/
function copyIntoClipboard(text) {
    var flashId = 'flashId-HKxmj5';
    var clipboardSWF = '/other/clipboard.swf';

    if (!document.getElementById(flashId)) {
        var div = document.createElement('div');
        div.id = flashId;
        document.body.appendChild(div);
    }
    document.getElementById(flashId).innerHTML = '';
    var content = '<embed src="' +
    clipboardSWF +
    '" FlashVars="clipboard=' + encodeURIComponent(text) +
    '" width="0" height="0" type="application/x-shockwave-flash"></embed>';
    document.getElementById(flashId).innerHTML = content;
}
