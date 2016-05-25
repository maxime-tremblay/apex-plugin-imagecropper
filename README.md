# Oracle APEX Dynamic Action Plugin - Apex Image Cropper <a name="top"></a>
This dynamic action plugin is used to crop an image using an HTML5 canvas and saves the resulting cropped image into the database.

This plugin is based on the Cropper jQuery plugin ([https://github.com/fengyuanchen/cropper](https://github.com/fengyuanchen/cropper)).

## Table of contents <a name="table-of-contents"></a>

  - [Changelog](#changelog)
  - [Install](#install)
  - [Plugin Settings](#plugin-settings)
  - [How to use](#how-to-use)
  - [Demo Application](#demo)
  - [Preview](#preview)

## Changelog <a name="changelog"></a>
### 1.0 - Initial Release

[⬆ back to top](#top)

## Install <a name="install"></a>
- Import plugin file "dynamic_action_plugin_ca_maximet_apexcropper.sql" from source directory into your application
- (Optional) Deploy the JS and CSS files from "server" directory on your webserver and change the "File Prefix" to webservers folder.

[⬆ back to top](#top)

## Plugin Settings <a name="plugin-settings"></a>
### Application Attribute
None

### Component Attribute
#### viewMode
- Type: `Select List`
- Default: `0`
- Options:
  - `0`: the crop box is just within the container
  - `1`: the crop box should be within the canvas
  - `2`: the canvas should not be within the container
  - `3`: the container should be within the canvas

Define the view mode of the cropper.


#### dragMode
- Type: `Select List`
- Default: `'crop'`
- Options:
  - `'crop'`: create a new crop box
  - `'move'`: move the canvas
  - `'none'`: do nothing

Define the dragging mode of the cropper.


#### aspectRatio
- Type: `Number`
- Default: `NaN`

Set the aspect ratio of the crop box. By default, the crop box is free ratio.


#### preview
- Type: `String` (*jQuery selector*)
- Default: `''`

Add extra elements (containers) for previewing.

**Notes:**

- The maximum width is the initial width of preview container.
- The maximum height is the initial height of preview container.
- If you set an `aspectRatio` option, be sure to set the preview container with the same aspect ratio.
- If preview is not getting properly displayed, set `overflow:hidden` to the preview container.


#### minContainerWidth
- Type: `Number`
- Default: `200`

The minimum width of the container.


#### minContainerHeight
- Type: `Number`
- Default: `100`

The minimum height of the container.


#### minCanvasWidth
- Type: `Number`
- Default: `0`

The minimum width of the canvas (image wrapper).


#### minCanvasHeight
- Type: `Number`
- Default: `0`

The minimum height of the canvas (image wrapper).


#### minCropBoxWidth
- Type: `Number`
- Default: `0`

The minimum width of the crop box.

> **Note:** This size is relative to the page, not the image.


#### minCropBoxHeight
- Type: `Number`
- Default: `0`

The minimum height of the crop box.

> **Note:** This size is relative to the page, not the image.


#### PLSQL Code to Save Cropped Image
- Type: `PLSQL Code`
- Default: `PL/SQL code that saves the cropped image as blob`


#### Save Button jQuery Selector
- Type: `String` (**jQuery selector**)
- Default: `''`

See [Save Cropped Image to DB](#how-to-use)

#### croppedImageWidth
- Type: `Number`
- Default: `null`

The width of the cropped image. Only used when saving the image.

> **Note:** Both croppedImageWidth and croppedImageHeight need to be specified and they must match with the defined aspectRatio.


#### croppedImageHeight
- Type: `Number`
- Default: `null`

The height of the cropped image. Only used when saving the image.

> **Note:** Both croppedImageWidth and croppedImageHeight need to be specified and they must match with the defined aspectRatio.


#### showSpinner
- Type: `Yes/No`
- Default: `Yes`

Show a spinner while running the PLSQL Code to save the cropped image.


## How to use <a name="how-to-use"></a>

### Save Cropped Image to DB
For saving the cropped image to DB you can use a PL/SQL function like this (default):
```language-sql
declare
    l_collection_name varchar2(100) := 'APEX_IMAGE_CROPPER';
    l_chunk           varchar2(32000);
    l_clob            clob;
    l_blob            blob;
    l_blob_size       number;
    l_filename        varchar2(100) := 'image_cropper_' || to_char(sysdate, 'YYYYMMDDHH24MISS') || '.png';
    l_mime_type       varchar2(100) := 'image/png';
begin
    -- build CLOB from f01 30k Array
    dbms_lob.createtemporary(l_clob,
                             false,
                             dbms_lob.session);

    for i in 1 .. apex_application.g_f01.count
    loop
        l_chunk := wwv_flow.g_f01(i);

        if length(l_chunk) > 0 then
            dbms_lob.writeappend(l_clob,
                                 length(l_chunk),
                                 l_chunk);
        end if;
    end loop;

    -- convert base64 CLOB to BLOB (mimetype: image/png)
    l_blob := apex_web_service.clobbase642blob(p_clob => l_clob);
    l_blob_size := dbms_lob.getlength(lob_loc => l_blob);

    --
    -- here starts custom part (for example a Insert statement)
    --

    -- create or truncate the collection
    apex_collection.create_or_truncate_collection(l_collection_name);

    -- add collection member (only if BLOB not null)
    if l_blob_size is not null then
        apex_collection.add_member(p_collection_name => l_collection_name,
                                   p_c001            => l_filename, -- filename
                                   p_c002            => l_mime_type, -- mime_type
                                   p_n001            => l_blob_size, -- blob size
                                   p_d001            => sysdate, -- date created
                                   p_blob001         => l_blob); -- BLOB img content
    end if;
end;
```

### Default Collection Definition
- Collection Name: `APEX_IMAGE_CROPPER`
- Columns
  - c001: `Filename`
  - c002: `Mime Type`
  - d001: `Date Created`
  - n001: `BLOB Size`
  - blob001: `BLOB of Cropped Image`

[⬆ back to top](#top)

### Demo Setup
Here's how you can reproduce the demo application

#### Page Button
1. Save
  - Satic ID: `SAVE_BTN`

#### Page Items
1. Filebrowse item: `P2_UPLOAD`
 - Set the storage type to "Table APEX_APPLICATION_TEMP_FILE"
 - Display Condition :
    - Type: `Item is NULL`
 - Item: P2_UPLOAD
2. Display image item: `P2_DISPLAY`
 - Based On: `BLOB Column returned by SQL statement`
 - SQL Statement:
   ```language-sql
select blob_content
  from apex_application_temp_files
 where name = :P2_UPLOAD
```
   
 - Display Condition :
    - Type: `Item is NOT NULL`
    - Item: P2_UPLOAD

    > If you're displaying the image in a modal dialog and don't want the original image to be wider or taller that the dialog's width/height wrap the item in a div as follow:
    > - Pre Text: `<div style="max-width: 80vw; max-height: 80vh; margin: auto;">`
    > - Post Text: `</div>`

#### Dynamic Actions
1. Filebrowse Change
  - Event: `Change`
  - Selection Type: `Item(s)`
  - Item: `P2_UPLOAD`

  - True Action
    - Action: `Submit Page`

2. Initialize Cropper
  - Event: `Page Load`

  - True Action
    - Action: `Apex Image Cropper`
      > Set settings according to desired behaviour

      > Make sure that the save button jQuery selector matches the static id (e.g.: #SAVE_BTN)

3. Cropper Save Done
  - Event: `Cropped Image Save to DB`
  - Selection Type: `JavaScript Expression`
  - JavaScript Expression: `document`

  - True Action
    - Action: `Submit Page`
    - Request/Button Name: `SAVE`

#### Process
1. Save Process
  - PL/SQL Code:
  ```language-sql
declare
  l_blob blob;
begin
  insert into mp_cropper_file_upload(blob_content, file_name, mime_type, doc_size)
  select blob001 AS img_content,
         c001 AS filename,
         c002 AS mime_type,
         dbms_lob.getlength(blob001) doc_size
    from apex_collections
   where collection_name = 'APEX_IMAGE_CROPPER';
end;
```
  - Condition
    - Type: `Request = Value`
    - Value: `SAVE`

## Demo Application <a name="demo"></a>
[http://max-playground.no-ip.org/ords/f?p=DEMO:1100](http://max-playground.no-ip.org/ords/f?p=DEMO:1100)

## Preview <a name="preview"></a>
## ![](https://github.com/maxime-tremblay/apex-plugin-imagecropper/blob/master/preview.gif)

[⬆ back to top](#top)
