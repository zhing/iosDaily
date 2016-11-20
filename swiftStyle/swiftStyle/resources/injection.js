    function showSwiftMessage(msg) {
        var textarea = document.getElementById("textarea");
        textarea.value = msg;
    }

    var objs = document.getElementsByTagName("img")
    function getImageUrls() {
        images = [];
        for (var i=0;i<objs.length;i++) {
            images[i] = objs[i].src;
        }
        return images;
    }

    for (var i=0;i<objs.length;i++) {
        var obj = objs[i];
        obj.addEventListener("click", function(){
                                 alert("click on image:");
                                 window.webkit.messageHandlers.imgClicked.postMessage(obj.src);
                                 }, false);
    }
