// APEX Image Cropper functions
// Author: Maxime Tremblay
// Version: 1.1

// global namespace
var apexCropper = {
    // parse string to boolean
    parseBoolean: function(pString) {
        var lBoolean;

        switch(pString.toLowerCase()) {
            case 'true':
                lBoolean = true;
                break;
            case 'false':
                lBoolean = false;
                break;
            default:
                lBoolean = undefined;
        }

        return lBoolean;
    },
    // builds a js array from long string
    clob2Array: function(clob, size, array) {
        loopCount = Math.floor(clob.length / size) + 1;

        for (var i = 0; i < loopCount; i++) {
            array.push(clob.slice(size * i, size * (i + 1)));
        }

        return array;
    },
    // converts DataURI to base64 string
    dataURI2base64: function(dataURI) {
        return dataURI.substr(dataURI.indexOf(',') + 1);;
    },
    // save to DB function
    save2Db: function(pAjaxIdentifier, pImage, pCroppedImageDataUrl, callback) {
        // img DataURI to base64
        var base64 = apexCropper.dataURI2base64(pCroppedImageDataUrl);

        // split base64 clob string to f01 array length 30k
        var f01Array = [];
        f01Array = apexCropper.clob2Array(base64, 30000, f01Array);

        // Apex Ajax Call
        apex.server.plugin(pAjaxIdentifier,
                           { f01: f01Array
                             },
                           { dataType: 'html',
                             // SUCESS function
                             success: function() {
                                // trigger apex plugin event
                                apex.event.trigger(pImage, 'apexcropper-saved-db', '');

                                // callback
                                callback();
                                },
                             // ERROR function
                             error: function(xhr, pMessage) {
                                // trigger apex plugin event
                                apex.event.trigger(pImage, 'apexcropper-error-db', '');

                                // log error in console
                                apex.debug.trace('apexCropper: apex.server.plugin ERROR:', pMessage);

                                // callback
                                callback();
                                }
                             });
    },
    // function that gets called from plugin
    apexCropperInit: function() {
        // plugin attributes
        var daThis = this;
        var $image               = this.affectedElements;
        var l_options            = JSON.parse(daThis.action.attribute01);
        var l_logging            = apexCropper.parseBoolean(l_options.logging);

        var l_saveSelector       = l_options.saveSelector;
        var l_croppedImageMaxWidth  = !isNaN(l_options.croppedImageWidth) ? parseInt(l_options.croppedImageWidth) : undefined;
        var l_croppedImageMaxHeight = !isNaN(l_options.croppedImageHeight) ? parseInt(l_options.croppedImageHeight) : undefined;
        var l_croppedImageWidth;
        var l_croppedImageHeight;
        var l_showSpinner        = apexCropper.parseBoolean(l_options.showSpinner);

        var options = {
            viewMode: parseInt(l_options.viewMode),
            dragMode: l_options.dragMode,
            aspectRatio: eval(l_options.aspectRatio),
            preview: l_options.previewSelector,
            minContainerWidth: parseInt(l_options.minContainerWidth),
            minContainerHeight: parseInt(l_options.minContainerHeight),
            minCanvasWidth: parseInt(l_options.minCanvasWidth),
            minCanvasHeight: parseInt(l_options.minCanvasHeight),
            minCropBoxWidth: parseInt(l_options.minCropBoxWidth),
            minCropBoxHeight: parseInt(l_options.minCropBoxHeight)
        };

        // Logging
        if (l_logging) {
            apex.debug.trace('apexCropper: Cropper Options :' + options);
            apex.debug.trace(options);
            apex.debug.trace('apexCropper: Attribute saveSelector:', l_saveSelector);
            apex.debug.trace('apexCropper: Attribute croppedImageWidth:', l_croppedImageMaxWidth);
            apex.debug.trace('apexCropper: Attribute croppedImageHeight:', l_croppedImageMaxHeight);
            apex.debug.trace('apexCropper: Attribute showSpinner:', l_showSpinner);
        }

        $image.cropper(options);

        // save cropped image to DB

        $(l_saveSelector).click(function() {
            var l_croppedImage;
            var l_croppedData = $image.cropper('getData');
            var l_croppedImageWidth  = l_croppedData.width;
            var l_croppedImageHeight = l_croppedData.height;
            var l_croppedImageRatio  = (l_croppedData.width / l_croppedData.height);

            // show wait spinner
            if (l_showSpinner) {
                var $spinner = apex.util.showSpinner();
            }

            // if there is a maximum width or height
            if (l_croppedImageMaxWidth || l_croppedImageMaxHeight){
                // if current width is greater than maximum width
                if (l_croppedImageMaxWidth && (l_croppedImageWidth > l_croppedImageMaxWidth)){
                    // adjust height to keep aspect ratio
                    l_croppedImageHeight = l_croppedImageHeight * (l_croppedImageMaxWidth / l_croppedImageWidth);
                    l_croppedImageWidth  = l_croppedImageMaxWidth;
                }

                // if current height is greater than maximum height
                if (l_croppedImageMaxHeight && (l_croppedImageHeight > l_croppedImageMaxHeight)){
                    // adjust width to keep aspect ratio
                    l_croppedImageWidth  = l_croppedImageWidth * (l_croppedImageMaxHeight / l_croppedImageHeight);
                    l_croppedImageHeight = l_croppedImageMaxHeight;
                }

                l_croppedImage = $image.cropper('getCroppedCanvas', {width: l_croppedImageWidth, height: l_croppedImageHeight});
            }
            else {
                l_croppedImage = $image.cropper('getCroppedCanvas');
            }

            // save image
            apexCropper.save2Db(l_options.ajaxIdentifier, $image, l_croppedImage.toDataURL(), function() {
                // remove wait spinner
                if (l_showSpinner) {
                    $spinner.remove();
                }
            });
        });
    }
};