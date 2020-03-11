set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.2.00.07'
,p_default_workspace_id=>1691260780111927
,p_default_application_id=>200
,p_default_owner=>'DEMO_APP'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/dynamic_action/ca_maximet_apexcropper
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(56064276942500481)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'CA.MAXIMET.APEXCROPPER'
,p_display_name=>'APEX Image Cropper'
,p_category=>'INIT'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'/*-------------------------------------',
' * APEX Image Cropper functions',
' * Version: 1.1 (2016-06-27)',
' * Author:  Maxime Tremblay',
' *-------------------------------------',
' */',
'',
'--',
'-- Function that initialize the image cropper plugin',
'function render_image_cropper(p_dynamic_action in apex_plugin.t_dynamic_action,',
'                              p_plugin         in apex_plugin.t_plugin)',
'return apex_plugin.t_dynamic_action_render_result is',
'    l_result                   apex_plugin.t_dynamic_action_render_result;',
'',
'    -- plugin attributes',
'    l_showSpinner              p_plugin.attribute_01%type  := p_plugin.attribute_01;',
'',
'    -- dynamic action attributes',
'    l_viewMode                 p_dynamic_action.attribute_01%type  := p_dynamic_action.attribute_01;',
'    l_dragMode                 p_dynamic_action.attribute_02%type  := p_dynamic_action.attribute_02;',
'    l_aspectRatio              p_dynamic_action.attribute_03%type  := p_dynamic_action.attribute_03;',
'    l_previewSelector          p_dynamic_action.attribute_04%type  := sys.htf.escape_sc(p_dynamic_action.attribute_04);',
'    l_minContainerWidth        p_dynamic_action.attribute_05%type  := p_dynamic_action.attribute_05;',
'    l_minContainerHeight       p_dynamic_action.attribute_06%type  := p_dynamic_action.attribute_06;',
'    l_minCanvasWidth           p_dynamic_action.attribute_07%type  := p_dynamic_action.attribute_07;',
'    l_minCanvasHeight          p_dynamic_action.attribute_08%type  := p_dynamic_action.attribute_08;',
'    l_minCropBoxWidth          p_dynamic_action.attribute_09%type  := p_dynamic_action.attribute_09;',
'    l_minCropBoxHeight         p_dynamic_action.attribute_10%type  := p_dynamic_action.attribute_10;',
'    l_saveSelector             p_dynamic_action.attribute_12%type  := sys.htf.escape_sc(p_dynamic_action.attribute_12);',
'    l_croppedImageWidth        p_dynamic_action.attribute_13%type  := p_dynamic_action.attribute_13;',
'    l_croppedImageHeight       p_dynamic_action.attribute_14%type  := p_dynamic_action.attribute_14;',
'',
'    l_min_file                 varchar2(4)  := ''.min'';',
'    l_logging                  varchar2(10) := ''false'';',
'begin',
'    -- Debug',
'    if apex_application.g_debug then',
'        apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,',
'                                              p_dynamic_action => p_dynamic_action);',
'        l_logging  := ''true'';',
'        l_min_file := '''';',
'    end if;',
'',
'    -- add javascript files',
'    apex_javascript.add_library(p_name      => ''cropper'' || l_min_file,',
'                                p_directory => p_plugin.file_prefix || ''js/'');',
'    apex_javascript.add_library(p_name      => ''apexCropper'' || l_min_file,',
'                                p_directory => p_plugin.file_prefix || ''js/'');',
'',
'    -- add css files',
'    apex_css.add_file(p_name      => ''cropper'' || l_min_file,',
'                      p_directory => p_plugin.file_prefix || ''css/'');',
'',
'    -- function that initialize the image cropper',
'    l_result.javascript_function := ''apexCropper.apexCropperInit'';',
'    l_result.attribute_01        := ''{'' || apex_javascript.add_attribute(''ajaxIdentifier'', apex_plugin.get_ajax_identifier) ||',
'                                           apex_javascript.add_attribute(''logging'', l_logging) ||',
'                                           apex_javascript.add_attribute(''viewMode'', l_viewMode) ||',
'                                           apex_javascript.add_attribute(''dragMode'', l_dragMode) ||',
'                                           apex_javascript.add_attribute(''aspectRatio'', l_aspectRatio) ||',
'                                           apex_javascript.add_attribute(''previewSelector'', l_previewSelector) ||',
'                                           apex_javascript.add_attribute(''minContainerWidth'', l_minContainerWidth) ||',
'                                           apex_javascript.add_attribute(''minContainerHeight'', l_minContainerHeight) ||',
'                                           apex_javascript.add_attribute(''minCanvasWidth'', l_minCanvasWidth) ||',
'                                           apex_javascript.add_attribute(''minCanvasHeight'', l_minCanvasHeight) ||',
'                                           apex_javascript.add_attribute(''minCropBoxWidth'', l_minCropBoxWidth) ||',
'                                           apex_javascript.add_attribute(''minCropBoxHeight'', l_minCropBoxHeight) ||',
'                                           apex_javascript.add_attribute(''saveSelector'', l_saveSelector) ||',
'                                           apex_javascript.add_attribute(''croppedImageWidth'', l_croppedImageWidth) ||',
'                                           apex_javascript.add_attribute(''croppedImageHeight'', l_croppedImageHeight) ||',
'                                           apex_javascript.add_attribute(''showSpinner'', l_showSpinner, false, false) ||',
'                                           ''}'';',
'',
'    return l_result;',
'end render_image_cropper;',
'',
'--',
'-- AJAX function that runs the PLSQL code which saves the cropped',
'-- image to database tables or collections.',
'function ajax_image_cropper(p_dynamic_action in apex_plugin.t_dynamic_action,',
'                            p_plugin         in apex_plugin.t_plugin)',
'return apex_plugin.t_dynamic_action_ajax_result is',
'    -- plugin attributes',
'    l_plsql_code  p_plugin.attribute_11%type  := p_dynamic_action.attribute_11;',
'begin',
'    -- execute PL/SQL',
'    apex_plugin_util.execute_plsql_code(p_plsql_code => l_plsql_code);',
'',
'    return null;',
'end ajax_image_cropper;'))
,p_render_function=>'render_image_cropper'
,p_ajax_function=>'ajax_image_cropper'
,p_standard_attributes=>'ITEM:JQUERY_SELECTOR:REQUIRED'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'This dynamic action plugin is used to crop an image using an HTML5 canvas and saves the resulting cropped image into the database.'
,p_version_identifier=>'1.1'
,p_about_url=>'https://github.com/maxime-tremblay/apex-plugin-imagecropper'
,p_files_version=>57
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(63645831556647658)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'showSpinner'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'true'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(63647566751650195)
,p_plugin_attribute_id=>wwv_flow_api.id(63645831556647658)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(63647901819650763)
,p_plugin_attribute_id=>wwv_flow_api.id(63645831556647658)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56064429703500496)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'viewMode'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'0'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Define the view mode of the cropper.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56064809027500497)
,p_plugin_attribute_id=>wwv_flow_api.id(56064429703500496)
,p_display_sequence=>10
,p_display_value=>'the crop box is just within the container'
,p_return_value=>'0'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56065371262500498)
,p_plugin_attribute_id=>wwv_flow_api.id(56064429703500496)
,p_display_sequence=>20
,p_display_value=>'the crop box should be within the canvas'
,p_return_value=>'1'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56065862159500498)
,p_plugin_attribute_id=>wwv_flow_api.id(56064429703500496)
,p_display_sequence=>30
,p_display_value=>'the canvas should not be within the container'
,p_return_value=>'2'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56066365222500499)
,p_plugin_attribute_id=>wwv_flow_api.id(56064429703500496)
,p_display_sequence=>40
,p_display_value=>'the container should be within the canvas'
,p_return_value=>'3'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56066863732500500)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'dragMode'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'crop'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Define the dragging mode of the cropper.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56067209503500500)
,p_plugin_attribute_id=>wwv_flow_api.id(56066863732500500)
,p_display_sequence=>10
,p_display_value=>'create a new crop box'
,p_return_value=>'crop'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56067719083500501)
,p_plugin_attribute_id=>wwv_flow_api.id(56066863732500500)
,p_display_sequence=>20
,p_display_value=>'move the canvas'
,p_return_value=>'move'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56068240374500501)
,p_plugin_attribute_id=>wwv_flow_api.id(56066863732500500)
,p_display_sequence=>30
,p_display_value=>'do nothing'
,p_return_value=>'none'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56068711553500501)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'aspectRatio'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'NaN'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Set the aspect ratio of the crop box. By default, the crop box is free ratio.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56069159255500501)
,p_plugin_attribute_id=>wwv_flow_api.id(56068711553500501)
,p_display_sequence=>10
,p_display_value=>'16:9'
,p_return_value=>'16 / 9'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56069607582500502)
,p_plugin_attribute_id=>wwv_flow_api.id(56068711553500501)
,p_display_sequence=>20
,p_display_value=>'4:3'
,p_return_value=>'4 / 3'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56070101495500502)
,p_plugin_attribute_id=>wwv_flow_api.id(56068711553500501)
,p_display_sequence=>30
,p_display_value=>'1:1'
,p_return_value=>'1 / 1'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56070650711500502)
,p_plugin_attribute_id=>wwv_flow_api.id(56068711553500501)
,p_display_sequence=>40
,p_display_value=>'2:3'
,p_return_value=>'2 / 3'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56071177704500502)
,p_plugin_attribute_id=>wwv_flow_api.id(56068711553500501)
,p_display_sequence=>50
,p_display_value=>'Free'
,p_return_value=>'NaN'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56071628555500503)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'preview Selector'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_display_length=>50
,p_max_length=>500
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'jQuery selector used to add extra elements (containers) for previewing.',
'<br>',
'<br><b>Notes:</b>',
'<ul>',
'<li>The maximum width is the initial width of preview container.</li>',
'<li>The maximum height is the initial height of preview container.</li>',
'<li>If you set an aspectRatio option, be sure to set the preview container with the same aspect ratio.</li>',
'<li>If preview is not getting properly displayed, set overflow:hidden to the preview container.</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56072056105500503)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'minContainerWidth'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'200'
,p_is_translatable=>false
,p_help_text=>'The minimum width of the container.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56072475474500504)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'minContainerHeight'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'100'
,p_is_translatable=>false
,p_help_text=>'The minimum height of the container.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56072870364500504)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'minCanvasWidth'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'0'
,p_is_translatable=>false
,p_help_text=>'The minimum width of the canvas (image wrapper).'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56073285851500504)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'minCanvasHeight'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'0'
,p_is_translatable=>false
,p_help_text=>'The minimum height of the canvas (image wrapper).'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56073680653500504)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'minCropBoxWidth'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'0'
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'The minimum width of the crop box.',
'<br>',
'<br><b>**Note:**</b> This size is relative to the page, not the image.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56074016656500505)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'minCropBoxHeight'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'0'
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'The minimum height of the crop box.',
'<br>',
'<br><b>**Note:**</b> This size is relative to the page, not the image.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56074489563500505)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'PLSQL Code'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_default_value=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'declare',
'    l_collection_name varchar2(100);',
'    l_chunk           varchar2(32000);',
'    l_clob            clob;',
'    l_blob            blob;',
'    l_blob_size       number;',
'    l_filename        varchar2(100);',
'    l_mime_type       varchar2(100);',
'begin',
'    -- get defaults',
'    l_filename  := ''image_cropper_'' || to_char(SYSDATE, ''YYYYMMDDHH24MISS'') || ''.png'';',
'    l_mime_type := ''image/png'';',
'    ',
'    -- build CLOB from f01 30k Array',
'    dbms_lob.createtemporary(l_clob,',
'                             false,',
'                             dbms_lob.session);',
'    ',
'    for i in 1 .. apex_application.g_f01.count',
'    loop',
'        l_chunk := wwv_flow.g_f01(i);',
'        ',
'        if length(l_chunk) > 0 then',
'            dbms_lob.writeappend(l_clob,',
'                                 length(l_chunk),',
'                                 l_chunk);',
'        end if;',
'    end loop;',
'    ',
'    -- convert base64 CLOB to BLOB (mimetype: image/png)',
'    l_blob := apex_web_service.clobbase642blob(p_clob => l_clob);',
'    l_blob_size := dbms_lob.getlength(lob_loc => l_blob);',
'    ',
'    --',
'    -- here starts custom part (for example a Insert statement)',
'    --',
'    l_collection_name := ''APEX_IMAGE_CROPPER'';',
'    ',
'    -- create or truncate the collection',
'    apex_collection.create_or_truncate_collection(l_collection_name);',
'    ',
'    -- add collection member (only if BLOB not null)',
'    if l_blob_size is not null then',
'        apex_collection.add_member(p_collection_name => l_collection_name,',
'                                   p_c001            => l_filename, -- filename',
'                                   p_c002            => l_mime_type, -- mime_type',
'                                   p_n001            => l_blob_size, -- blob size',
'                                   p_d001            => sysdate, -- date created',
'                                   p_blob001         => l_blob); -- BLOB img content',
'    end if;',
'end;'))
,p_is_translatable=>false
,p_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'SELECT c001    AS filename,<br>',
'       c002    AS mime_type,<br>',
'       n001    AS img_size,<br>',
'       d001    AS date_created,<br>',
'       blob001 AS img_content<br>',
'  FROM apex_collections<br>',
' WHERE collection_name = ''APEX_IMAGE_CROPPER'';'))
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'PLSQL code which saves the resulting image to database tables or collections.<br>',
'Default to Collection "APEX_IMAGE_CROPPER".<br>',
'Column c001 => filename<br>',
'Column c002 => mime_type<br>',
'Column n001 => image size<br>',
'Column d001 => date created<br>',
'Column blob001 => BLOB of image<br>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56074830879500506)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Save Button jQuery Selector'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56075242284500506)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Cropped Image Maximum Width'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Maximum width of the cropped image'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56075696831500506)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Cropped Image Maximum Height'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Maximum height of the cropped image'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(56077805974500512)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_name=>'apexcropper-error-db'
,p_display_name=>'Cropped Image Saved to DB Error'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(56078215420500512)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_name=>'apexcropper-saved-db'
,p_display_name=>'Cropped Image Saved to DB'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A210A202A2043726F707065722076322E322E350A202A2068747470733A2F2F6769746875622E636F6D2F66656E677975616E6368656E2F63726F707065720A202A0A202A20436F707972696768742028632920323031342D323031362046656E6779';
wwv_flow_api.g_varchar2_table(2) := '75616E204368656E20616E6420636F6E7472696275746F72730A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A0A202A20446174653A20323031362D30312D31385430353A34323A32392E3633395A0A202A2F';
wwv_flow_api.g_varchar2_table(3) := '0A2E63726F707065722D636F6E7461696E6572207B0A2020666F6E742D73697A653A20303B0A20206C696E652D6865696768743A20303B0A0A2020706F736974696F6E3A2072656C61746976653B0A0A20202D7765626B69742D757365722D73656C6563';
wwv_flow_api.g_varchar2_table(4) := '743A206E6F6E653B0A20202020202D6D6F7A2D757365722D73656C6563743A206E6F6E653B0A2020202020202D6D732D757365722D73656C6563743A206E6F6E653B0A20202020202020202020757365722D73656C6563743A206E6F6E653B0A0A202064';
wwv_flow_api.g_varchar2_table(5) := '6972656374696F6E3A206C74722021696D706F7274616E743B0A20202D6D732D746F7563682D616374696F6E3A206E6F6E653B0A202020202020746F7563682D616374696F6E3A206E6F6E653B0A20202D7765626B69742D7461702D686967686C696768';
wwv_flow_api.g_varchar2_table(6) := '742D636F6C6F723A207472616E73706172656E743B0A20202D7765626B69742D746F7563682D63616C6C6F75743A206E6F6E653B0A7D0A0A2E63726F707065722D636F6E7461696E657220696D67207B0A2020646973706C61793A20626C6F636B3B0A0A';
wwv_flow_api.g_varchar2_table(7) := '202077696474683A20313030253B0A20206D696E2D77696474683A20302021696D706F7274616E743B0A20206D61782D77696474683A206E6F6E652021696D706F7274616E743B0A20206865696768743A20313030253B0A20206D696E2D686569676874';
wwv_flow_api.g_varchar2_table(8) := '3A20302021696D706F7274616E743B0A20206D61782D6865696768743A206E6F6E652021696D706F7274616E743B0A0A2020696D6167652D6F7269656E746174696F6E3A20306465672021696D706F7274616E743B0A7D0A0A2E63726F707065722D7772';
wwv_flow_api.g_varchar2_table(9) := '61702D626F782C0A2E63726F707065722D63616E7661732C0A2E63726F707065722D647261672D626F782C0A2E63726F707065722D63726F702D626F782C0A2E63726F707065722D6D6F64616C207B0A2020706F736974696F6E3A206162736F6C757465';
wwv_flow_api.g_varchar2_table(10) := '3B0A2020746F703A20303B0A202072696768743A20303B0A2020626F74746F6D3A20303B0A20206C6566743A20303B0A7D0A0A2E63726F707065722D777261702D626F78207B0A20206F766572666C6F773A2068696464656E3B0A7D0A0A2E63726F7070';
wwv_flow_api.g_varchar2_table(11) := '65722D647261672D626F78207B0A20206F7061636974793A20303B0A20206261636B67726F756E642D636F6C6F723A20236666663B0A0A202066696C7465723A20616C706861286F7061636974793D30293B0A7D0A0A2E63726F707065722D6D6F64616C';
wwv_flow_api.g_varchar2_table(12) := '207B0A20206F7061636974793A202E353B0A20206261636B67726F756E642D636F6C6F723A20233030303B0A0A202066696C7465723A20616C706861286F7061636974793D3530293B0A7D0A0A2E63726F707065722D766965772D626F78207B0A202064';
wwv_flow_api.g_varchar2_table(13) := '6973706C61793A20626C6F636B3B0A20206F766572666C6F773A2068696464656E3B0A0A202077696474683A20313030253B0A20206865696768743A20313030253B0A0A20206F75746C696E653A2031707820736F6C696420233339663B0A20206F7574';
wwv_flow_api.g_varchar2_table(14) := '6C696E652D636F6C6F723A20726762612835312C203135332C203235352C202E3735293B0A7D0A0A2E63726F707065722D646173686564207B0A2020706F736974696F6E3A206162736F6C7574653B0A0A2020646973706C61793A20626C6F636B3B0A0A';
wwv_flow_api.g_varchar2_table(15) := '20206F7061636974793A202E353B0A2020626F726465723A20302064617368656420236565653B0A0A202066696C7465723A20616C706861286F7061636974793D3530293B0A7D0A0A2E63726F707065722D6461736865642E6461736865642D68207B0A';
wwv_flow_api.g_varchar2_table(16) := '2020746F703A2033332E3333333333253B0A20206C6566743A20303B0A0A202077696474683A20313030253B0A20206865696768743A2033332E3333333333253B0A0A2020626F726465722D746F702D77696474683A203170783B0A2020626F72646572';
wwv_flow_api.g_varchar2_table(17) := '2D626F74746F6D2D77696474683A203170783B0A7D0A0A2E63726F707065722D6461736865642E6461736865642D76207B0A2020746F703A20303B0A20206C6566743A2033332E3333333333253B0A0A202077696474683A2033332E3333333333253B0A';
wwv_flow_api.g_varchar2_table(18) := '20206865696768743A20313030253B0A0A2020626F726465722D72696768742D77696474683A203170783B0A2020626F726465722D6C6566742D77696474683A203170783B0A7D0A0A2E63726F707065722D63656E746572207B0A2020706F736974696F';
wwv_flow_api.g_varchar2_table(19) := '6E3A206162736F6C7574653B0A2020746F703A203530253B0A20206C6566743A203530253B0A0A2020646973706C61793A20626C6F636B3B0A0A202077696474683A20303B0A20206865696768743A20303B0A0A20206F7061636974793A202E37353B0A';
wwv_flow_api.g_varchar2_table(20) := '0A202066696C7465723A20616C706861286F7061636974793D3735293B0A7D0A0A2E63726F707065722D63656E7465723A6265666F72652C0A2E63726F707065722D63656E7465723A6166746572207B0A2020706F736974696F6E3A206162736F6C7574';
wwv_flow_api.g_varchar2_table(21) := '653B0A0A2020646973706C61793A20626C6F636B3B0A0A2020636F6E74656E743A202720273B0A0A20206261636B67726F756E642D636F6C6F723A20236565653B0A7D0A0A2E63726F707065722D63656E7465723A6265666F7265207B0A2020746F703A';
wwv_flow_api.g_varchar2_table(22) := '20303B0A20206C6566743A202D3370783B0A0A202077696474683A203770783B0A20206865696768743A203170783B0A7D0A0A2E63726F707065722D63656E7465723A6166746572207B0A2020746F703A202D3370783B0A20206C6566743A20303B0A0A';
wwv_flow_api.g_varchar2_table(23) := '202077696474683A203170783B0A20206865696768743A203770783B0A7D0A0A2E63726F707065722D666163652C0A2E63726F707065722D6C696E652C0A2E63726F707065722D706F696E74207B0A2020706F736974696F6E3A206162736F6C7574653B';
wwv_flow_api.g_varchar2_table(24) := '0A0A2020646973706C61793A20626C6F636B3B0A0A202077696474683A20313030253B0A20206865696768743A20313030253B0A0A20206F7061636974793A202E313B0A0A202066696C7465723A20616C706861286F7061636974793D3130293B0A7D0A';
wwv_flow_api.g_varchar2_table(25) := '0A2E63726F707065722D66616365207B0A2020746F703A20303B0A20206C6566743A20303B0A0A20206261636B67726F756E642D636F6C6F723A20236666663B0A7D0A0A2E63726F707065722D6C696E65207B0A20206261636B67726F756E642D636F6C';
wwv_flow_api.g_varchar2_table(26) := '6F723A20233339663B0A7D0A0A2E63726F707065722D6C696E652E6C696E652D65207B0A2020746F703A20303B0A202072696768743A202D3370783B0A0A202077696474683A203570783B0A0A2020637572736F723A20652D726573697A653B0A7D0A0A';
wwv_flow_api.g_varchar2_table(27) := '2E63726F707065722D6C696E652E6C696E652D6E207B0A2020746F703A202D3370783B0A20206C6566743A20303B0A0A20206865696768743A203570783B0A0A2020637572736F723A206E2D726573697A653B0A7D0A0A2E63726F707065722D6C696E65';
wwv_flow_api.g_varchar2_table(28) := '2E6C696E652D77207B0A2020746F703A20303B0A20206C6566743A202D3370783B0A0A202077696474683A203570783B0A0A2020637572736F723A20772D726573697A653B0A7D0A0A2E63726F707065722D6C696E652E6C696E652D73207B0A2020626F';
wwv_flow_api.g_varchar2_table(29) := '74746F6D3A202D3370783B0A20206C6566743A20303B0A0A20206865696768743A203570783B0A0A2020637572736F723A20732D726573697A653B0A7D0A0A2E63726F707065722D706F696E74207B0A202077696474683A203570783B0A202068656967';
wwv_flow_api.g_varchar2_table(30) := '68743A203570783B0A0A20206F7061636974793A202E37353B0A20206261636B67726F756E642D636F6C6F723A20233339663B0A0A202066696C7465723A20616C706861286F7061636974793D3735293B0A7D0A0A2E63726F707065722D706F696E742E';
wwv_flow_api.g_varchar2_table(31) := '706F696E742D65207B0A2020746F703A203530253B0A202072696768743A202D3370783B0A0A20206D617267696E2D746F703A202D3370783B0A0A2020637572736F723A20652D726573697A653B0A7D0A0A2E63726F707065722D706F696E742E706F69';
wwv_flow_api.g_varchar2_table(32) := '6E742D6E207B0A2020746F703A202D3370783B0A20206C6566743A203530253B0A0A20206D617267696E2D6C6566743A202D3370783B0A0A2020637572736F723A206E2D726573697A653B0A7D0A0A2E63726F707065722D706F696E742E706F696E742D';
wwv_flow_api.g_varchar2_table(33) := '77207B0A2020746F703A203530253B0A20206C6566743A202D3370783B0A0A20206D617267696E2D746F703A202D3370783B0A0A2020637572736F723A20772D726573697A653B0A7D0A0A2E63726F707065722D706F696E742E706F696E742D73207B0A';
wwv_flow_api.g_varchar2_table(34) := '2020626F74746F6D3A202D3370783B0A20206C6566743A203530253B0A0A20206D617267696E2D6C6566743A202D3370783B0A0A2020637572736F723A20732D726573697A653B0A7D0A0A2E63726F707065722D706F696E742E706F696E742D6E65207B';
wwv_flow_api.g_varchar2_table(35) := '0A2020746F703A202D3370783B0A202072696768743A202D3370783B0A0A2020637572736F723A206E652D726573697A653B0A7D0A0A2E63726F707065722D706F696E742E706F696E742D6E77207B0A2020746F703A202D3370783B0A20206C6566743A';
wwv_flow_api.g_varchar2_table(36) := '202D3370783B0A0A2020637572736F723A206E772D726573697A653B0A7D0A0A2E63726F707065722D706F696E742E706F696E742D7377207B0A2020626F74746F6D3A202D3370783B0A20206C6566743A202D3370783B0A0A2020637572736F723A2073';
wwv_flow_api.g_varchar2_table(37) := '772D726573697A653B0A7D0A0A2E63726F707065722D706F696E742E706F696E742D7365207B0A202072696768743A202D3370783B0A2020626F74746F6D3A202D3370783B0A0A202077696474683A20323070783B0A20206865696768743A2032307078';
wwv_flow_api.g_varchar2_table(38) := '3B0A0A2020637572736F723A2073652D726573697A653B0A0A20206F7061636974793A20313B0A0A202066696C7465723A20616C706861286F7061636974793D313030293B0A7D0A0A2E63726F707065722D706F696E742E706F696E742D73653A626566';
wwv_flow_api.g_varchar2_table(39) := '6F7265207B0A2020706F736974696F6E3A206162736F6C7574653B0A202072696768743A202D3530253B0A2020626F74746F6D3A202D3530253B0A0A2020646973706C61793A20626C6F636B3B0A0A202077696474683A20323030253B0A202068656967';
wwv_flow_api.g_varchar2_table(40) := '68743A20323030253B0A0A2020636F6E74656E743A202720273B0A0A20206F7061636974793A20303B0A20206261636B67726F756E642D636F6C6F723A20233339663B0A0A202066696C7465723A20616C706861286F7061636974793D30293B0A7D0A0A';
wwv_flow_api.g_varchar2_table(41) := '406D6564696120286D696E2D77696474683A20373638707829207B0A20202E63726F707065722D706F696E742E706F696E742D7365207B0A2020202077696474683A20313570783B0A202020206865696768743A20313570783B0A20207D0A7D0A0A406D';
wwv_flow_api.g_varchar2_table(42) := '6564696120286D696E2D77696474683A20393932707829207B0A20202E63726F707065722D706F696E742E706F696E742D7365207B0A2020202077696474683A20313070783B0A202020206865696768743A20313070783B0A20207D0A7D0A0A406D6564';
wwv_flow_api.g_varchar2_table(43) := '696120286D696E2D77696474683A2031323030707829207B0A20202E63726F707065722D706F696E742E706F696E742D7365207B0A2020202077696474683A203570783B0A202020206865696768743A203570783B0A0A202020206F7061636974793A20';
wwv_flow_api.g_varchar2_table(44) := '2E37353B0A0A2020202066696C7465723A20616C706861286F7061636974793D3735293B0A20207D0A7D0A0A2E63726F707065722D696E76697369626C65207B0A20206F7061636974793A20303B0A0A202066696C7465723A20616C706861286F706163';
wwv_flow_api.g_varchar2_table(45) := '6974793D30293B0A7D0A0A2E63726F707065722D6267207B0A20206261636B67726F756E642D696D6167653A2075726C2827646174613A696D6167652F706E673B6261736536342C6956424F5277304B47676F414141414E535568455567414141424141';
wwv_flow_api.g_varchar2_table(46) := '4141415141514D414141416C505730694141414141334E435356514943416A6234552F6741414141426C424D5645584D7A4D7A2F2F2F2F546A525632414141414358424957584D41414172724141414B3677474369773161414141414848524657485254';
wwv_flow_api.g_varchar2_table(47) := '62325A30643246795A5142425A4739695A53424761584A6C6432397961334D6751314D32364C79796A4141414142464A52454655434A6C6A2B4D2F4167425668462F30504148362F442F486B44784F474141414141456C46546B5375516D434327293B0A';
wwv_flow_api.g_varchar2_table(48) := '7D0A0A2E63726F707065722D68696465207B0A2020706F736974696F6E3A206162736F6C7574653B0A0A2020646973706C61793A20626C6F636B3B0A0A202077696474683A20303B0A20206865696768743A20303B0A7D0A0A2E63726F707065722D6869';
wwv_flow_api.g_varchar2_table(49) := '6464656E207B0A2020646973706C61793A206E6F6E652021696D706F7274616E743B0A7D0A0A2E63726F707065722D6D6F7665207B0A2020637572736F723A206D6F76653B0A7D0A0A2E63726F707065722D63726F70207B0A2020637572736F723A2063';
wwv_flow_api.g_varchar2_table(50) := '726F7373686169723B0A7D0A0A2E63726F707065722D64697361626C6564202E63726F707065722D647261672D626F782C0A2E63726F707065722D64697361626C6564202E63726F707065722D666163652C0A2E63726F707065722D64697361626C6564';
wwv_flow_api.g_varchar2_table(51) := '202E63726F707065722D6C696E652C0A2E63726F707065722D64697361626C6564202E63726F707065722D706F696E74207B0A2020637572736F723A206E6F742D616C6C6F7765643B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(56078631183500514)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_file_name=>'css/cropper.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A210A202A2043726F707065722076322E322E350A202A2068747470733A2F2F6769746875622E636F6D2F66656E677975616E6368656E2F63726F707065720A202A0A202A20436F707972696768742028632920323031342D323031362046656E6779';
wwv_flow_api.g_varchar2_table(2) := '75616E204368656E20616E6420636F6E7472696275746F72730A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A0A202A20446174653A20323031362D30312D31385430353A34323A32392E3633395A0A202A2F';
wwv_flow_api.g_varchar2_table(3) := '2E63726F707065722D636F6E7461696E65727B666F6E742D73697A653A303B6C696E652D6865696768743A303B706F736974696F6E3A72656C61746976653B2D7765626B69742D757365722D73656C6563743A6E6F6E653B2D6D6F7A2D757365722D7365';
wwv_flow_api.g_varchar2_table(4) := '6C6563743A6E6F6E653B2D6D732D757365722D73656C6563743A6E6F6E653B757365722D73656C6563743A6E6F6E653B646972656374696F6E3A6C747221696D706F7274616E743B2D6D732D746F7563682D616374696F6E3A6E6F6E653B746F7563682D';
wwv_flow_api.g_varchar2_table(5) := '616374696F6E3A6E6F6E653B2D7765626B69742D7461702D686967686C696768742D636F6C6F723A7472616E73706172656E743B2D7765626B69742D746F7563682D63616C6C6F75743A6E6F6E657D2E63726F707065722D636F6E7461696E657220696D';
wwv_flow_api.g_varchar2_table(6) := '677B646973706C61793A626C6F636B3B77696474683A313030253B6D696E2D77696474683A3021696D706F7274616E743B6D61782D77696474683A6E6F6E6521696D706F7274616E743B6865696768743A313030253B6D696E2D6865696768743A302169';
wwv_flow_api.g_varchar2_table(7) := '6D706F7274616E743B6D61782D6865696768743A6E6F6E6521696D706F7274616E743B696D6167652D6F7269656E746174696F6E3A3064656721696D706F7274616E747D2E63726F707065722D63616E7661732C2E63726F707065722D63726F702D626F';
wwv_flow_api.g_varchar2_table(8) := '782C2E63726F707065722D647261672D626F782C2E63726F707065722D6D6F64616C2C2E63726F707065722D777261702D626F787B706F736974696F6E3A6162736F6C7574653B746F703A303B72696768743A303B626F74746F6D3A303B6C6566743A30';
wwv_flow_api.g_varchar2_table(9) := '7D2E63726F707065722D777261702D626F787B6F766572666C6F773A68696464656E7D2E63726F707065722D647261672D626F787B6F7061636974793A303B6261636B67726F756E642D636F6C6F723A236666663B66696C7465723A616C706861286F70';
wwv_flow_api.g_varchar2_table(10) := '61636974793D30297D2E63726F707065722D6461736865642C2E63726F707065722D6D6F64616C7B6F7061636974793A2E353B66696C7465723A616C706861286F7061636974793D3530297D2E63726F707065722D6D6F64616C7B6261636B67726F756E';
wwv_flow_api.g_varchar2_table(11) := '642D636F6C6F723A233030307D2E63726F707065722D766965772D626F787B646973706C61793A626C6F636B3B6F766572666C6F773A68696464656E3B77696474683A313030253B6865696768743A313030253B6F75746C696E653A2333396620736F6C';
wwv_flow_api.g_varchar2_table(12) := '6964203170783B6F75746C696E652D636F6C6F723A726762612835312C3135332C3235352C2E3735297D2E63726F707065722D6461736865647B706F736974696F6E3A6162736F6C7574653B646973706C61793A626C6F636B3B626F726465723A302064';
wwv_flow_api.g_varchar2_table(13) := '617368656420236565657D2E63726F707065722D6461736865642E6461736865642D687B746F703A33332E3333333333253B6C6566743A303B77696474683A313030253B6865696768743A33332E3333333333253B626F726465722D746F702D77696474';
wwv_flow_api.g_varchar2_table(14) := '683A3170783B626F726465722D626F74746F6D2D77696474683A3170787D2E63726F707065722D6461736865642E6461736865642D767B746F703A303B6C6566743A33332E3333333333253B77696474683A33332E3333333333253B6865696768743A31';
wwv_flow_api.g_varchar2_table(15) := '3030253B626F726465722D72696768742D77696474683A3170783B626F726465722D6C6566742D77696474683A3170787D2E63726F707065722D63656E7465727B706F736974696F6E3A6162736F6C7574653B746F703A3530253B6C6566743A3530253B';
wwv_flow_api.g_varchar2_table(16) := '646973706C61793A626C6F636B3B77696474683A303B6865696768743A303B6F7061636974793A2E37353B66696C7465723A616C706861286F7061636974793D3735297D2E63726F707065722D63656E7465723A61667465722C2E63726F707065722D63';
wwv_flow_api.g_varchar2_table(17) := '656E7465723A6265666F72657B706F736974696F6E3A6162736F6C7574653B646973706C61793A626C6F636B3B636F6E74656E743A2720273B6261636B67726F756E642D636F6C6F723A236565657D2E63726F707065722D63656E7465723A6265666F72';
wwv_flow_api.g_varchar2_table(18) := '657B746F703A303B6C6566743A2D3370783B77696474683A3770783B6865696768743A3170787D2E63726F707065722D63656E7465723A61667465727B746F703A2D3370783B6C6566743A303B77696474683A3170783B6865696768743A3770787D2E63';
wwv_flow_api.g_varchar2_table(19) := '726F707065722D666163652C2E63726F707065722D6C696E652C2E63726F707065722D706F696E747B706F736974696F6E3A6162736F6C7574653B646973706C61793A626C6F636B3B77696474683A313030253B6865696768743A313030253B6F706163';
wwv_flow_api.g_varchar2_table(20) := '6974793A2E313B66696C7465723A616C706861286F7061636974793D3130297D2E63726F707065722D666163657B746F703A303B6C6566743A303B6261636B67726F756E642D636F6C6F723A236666667D2E63726F707065722D6C696E652C2E63726F70';
wwv_flow_api.g_varchar2_table(21) := '7065722D706F696E747B6261636B67726F756E642D636F6C6F723A233339667D2E63726F707065722D6C696E652E6C696E652D657B746F703A303B72696768743A2D3370783B77696474683A3570783B637572736F723A652D726573697A657D2E63726F';
wwv_flow_api.g_varchar2_table(22) := '707065722D6C696E652E6C696E652D6E7B746F703A2D3370783B6C6566743A303B6865696768743A3570783B637572736F723A6E2D726573697A657D2E63726F707065722D6C696E652E6C696E652D777B746F703A303B6C6566743A2D3370783B776964';
wwv_flow_api.g_varchar2_table(23) := '74683A3570783B637572736F723A772D726573697A657D2E63726F707065722D6C696E652E6C696E652D737B626F74746F6D3A2D3370783B6C6566743A303B6865696768743A3570783B637572736F723A732D726573697A657D2E63726F707065722D70';
wwv_flow_api.g_varchar2_table(24) := '6F696E747B77696474683A3570783B6865696768743A3570783B6F7061636974793A2E37353B66696C7465723A616C706861286F7061636974793D3735297D2E63726F707065722D706F696E742E706F696E742D657B746F703A3530253B72696768743A';
wwv_flow_api.g_varchar2_table(25) := '2D3370783B6D617267696E2D746F703A2D3370783B637572736F723A652D726573697A657D2E63726F707065722D706F696E742E706F696E742D6E7B746F703A2D3370783B6C6566743A3530253B6D617267696E2D6C6566743A2D3370783B637572736F';
wwv_flow_api.g_varchar2_table(26) := '723A6E2D726573697A657D2E63726F707065722D706F696E742E706F696E742D777B746F703A3530253B6C6566743A2D3370783B6D617267696E2D746F703A2D3370783B637572736F723A772D726573697A657D2E63726F707065722D706F696E742E70';
wwv_flow_api.g_varchar2_table(27) := '6F696E742D737B626F74746F6D3A2D3370783B6C6566743A3530253B6D617267696E2D6C6566743A2D3370783B637572736F723A732D726573697A657D2E63726F707065722D706F696E742E706F696E742D6E657B746F703A2D3370783B72696768743A';
wwv_flow_api.g_varchar2_table(28) := '2D3370783B637572736F723A6E652D726573697A657D2E63726F707065722D706F696E742E706F696E742D6E777B746F703A2D3370783B6C6566743A2D3370783B637572736F723A6E772D726573697A657D2E63726F707065722D706F696E742E706F69';
wwv_flow_api.g_varchar2_table(29) := '6E742D73777B626F74746F6D3A2D3370783B6C6566743A2D3370783B637572736F723A73772D726573697A657D2E63726F707065722D706F696E742E706F696E742D73657B72696768743A2D3370783B626F74746F6D3A2D3370783B77696474683A3230';
wwv_flow_api.g_varchar2_table(30) := '70783B6865696768743A323070783B637572736F723A73652D726573697A653B6F7061636974793A313B66696C7465723A616C706861286F7061636974793D313030297D2E63726F707065722D706F696E742E706F696E742D73653A6265666F72657B70';
wwv_flow_api.g_varchar2_table(31) := '6F736974696F6E3A6162736F6C7574653B72696768743A2D3530253B626F74746F6D3A2D3530253B646973706C61793A626C6F636B3B77696474683A323030253B6865696768743A323030253B636F6E74656E743A2720273B6F7061636974793A303B62';
wwv_flow_api.g_varchar2_table(32) := '61636B67726F756E642D636F6C6F723A233339663B66696C7465723A616C706861286F7061636974793D30297D406D6564696120286D696E2D77696474683A3736387078297B2E63726F707065722D706F696E742E706F696E742D73657B77696474683A';
wwv_flow_api.g_varchar2_table(33) := '313570783B6865696768743A313570787D7D406D6564696120286D696E2D77696474683A3939327078297B2E63726F707065722D706F696E742E706F696E742D73657B77696474683A313070783B6865696768743A313070787D7D406D6564696120286D';
wwv_flow_api.g_varchar2_table(34) := '696E2D77696474683A313230307078297B2E63726F707065722D706F696E742E706F696E742D73657B77696474683A3570783B6865696768743A3570783B6F7061636974793A2E37353B66696C7465723A616C706861286F7061636974793D3735297D7D';
wwv_flow_api.g_varchar2_table(35) := '2E63726F707065722D696E76697369626C657B6F7061636974793A303B66696C7465723A616C706861286F7061636974793D30297D2E63726F707065722D62677B6261636B67726F756E642D696D6167653A75726C28646174613A696D6167652F706E67';
wwv_flow_api.g_varchar2_table(36) := '3B6261736536342C6956424F5277304B47676F414141414E5355684555674141414241414141415141514D414141416C505730694141414141334E435356514943416A6234552F6741414141426C424D5645584D7A4D7A2F2F2F2F546A52563241414141';
wwv_flow_api.g_varchar2_table(37) := '4358424957584D41414172724141414B367747436977316141414141484852465748525462325A30643246795A5142425A4739695A53424761584A6C6432397961334D6751314D32364C79796A4141414142464A52454655434A6C6A2B4D2F4167425668';
wwv_flow_api.g_varchar2_table(38) := '462F30504148362F442F486B44784F474141414141456C46546B5375516D4343297D2E63726F707065722D686964657B706F736974696F6E3A6162736F6C7574653B646973706C61793A626C6F636B3B77696474683A303B6865696768743A307D2E6372';
wwv_flow_api.g_varchar2_table(39) := '6F707065722D68696464656E7B646973706C61793A6E6F6E6521696D706F7274616E747D2E63726F707065722D6D6F76657B637572736F723A6D6F76657D2E63726F707065722D63726F707B637572736F723A63726F7373686169727D2E63726F707065';
wwv_flow_api.g_varchar2_table(40) := '722D64697361626C6564202E63726F707065722D647261672D626F782C2E63726F707065722D64697361626C6564202E63726F707065722D666163652C2E63726F707065722D64697361626C6564202E63726F707065722D6C696E652C2E63726F707065';
wwv_flow_api.g_varchar2_table(41) := '722D64697361626C6564202E63726F707065722D706F696E747B637572736F723A6E6F742D616C6C6F7765647D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(56079010965500514)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_file_name=>'css/cropper.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2F204150455820496D6167652043726F707065722066756E6374696F6E730D0A2F2F20417574686F723A204D6178696D65205472656D626C61790D0A2F2F2056657273696F6E3A20312E310D0A0D0A2F2F20676C6F62616C206E616D6573706163650D';
wwv_flow_api.g_varchar2_table(2) := '0A766172206170657843726F70706572203D207B0D0A202020202F2F20706172736520737472696E6720746F20626F6F6C65616E0D0A202020207061727365426F6F6C65616E3A2066756E6374696F6E2870537472696E6729207B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(3) := '20766172206C426F6F6C65616E3B0D0A0D0A20202020202020207377697463682870537472696E672E746F4C6F77657243617365282929207B0D0A20202020202020202020202063617365202774727565273A0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(4) := '206C426F6F6C65616E203D20747275653B0D0A20202020202020202020202020202020627265616B3B0D0A20202020202020202020202063617365202766616C7365273A0D0A202020202020202020202020202020206C426F6F6C65616E203D2066616C';
wwv_flow_api.g_varchar2_table(5) := '73653B0D0A20202020202020202020202020202020627265616B3B0D0A20202020202020202020202064656661756C743A0D0A202020202020202020202020202020206C426F6F6C65616E203D20756E646566696E65643B0D0A20202020202020207D0D';
wwv_flow_api.g_varchar2_table(6) := '0A0D0A202020202020202072657475726E206C426F6F6C65616E3B0D0A202020207D2C0D0A202020202F2F206275696C64732061206A732061727261792066726F6D206C6F6E6720737472696E670D0A20202020636C6F623241727261793A2066756E63';
wwv_flow_api.g_varchar2_table(7) := '74696F6E28636C6F622C2073697A652C20617272617929207B0D0A20202020202020206C6F6F70436F756E74203D204D6174682E666C6F6F7228636C6F622E6C656E677468202F2073697A6529202B20313B0D0A0D0A2020202020202020666F72202876';
wwv_flow_api.g_varchar2_table(8) := '61722069203D20303B2069203C206C6F6F70436F756E743B20692B2B29207B0D0A20202020202020202020202061727261792E7075736828636C6F622E736C6963652873697A65202A20692C2073697A65202A202869202B20312929293B0D0A20202020';
wwv_flow_api.g_varchar2_table(9) := '202020207D0D0A0D0A202020202020202072657475726E2061727261793B0D0A202020207D2C0D0A202020202F2F20636F6E7665727473204461746155524920746F2062617365363420737472696E670D0A202020206461746155524932626173653634';
wwv_flow_api.g_varchar2_table(10) := '3A2066756E6374696F6E286461746155524929207B0D0A202020202020202072657475726E20646174615552492E73756273747228646174615552492E696E6465784F6628272C2729202B2031293B3B0D0A202020207D2C0D0A202020202F2F20736176';
wwv_flow_api.g_varchar2_table(11) := '6520746F2044422066756E6374696F6E0D0A20202020736176653244623A2066756E6374696F6E2870416A61784964656E7469666965722C2070496D6167652C207043726F70706564496D6167654461746155726C2C2063616C6C6261636B29207B0D0A';
wwv_flow_api.g_varchar2_table(12) := '20202020202020202F2F20696D67204461746155524920746F206261736536340D0A202020202020202076617220626173653634203D206170657843726F707065722E6461746155524932626173653634287043726F70706564496D6167654461746155';
wwv_flow_api.g_varchar2_table(13) := '726C293B0D0A0D0A20202020202020202F2F2073706C69742062617365363420636C6F6220737472696E6720746F20663031206172726179206C656E6774682033306B0D0A2020202020202020766172206630314172726179203D205B5D3B0D0A202020';
wwv_flow_api.g_varchar2_table(14) := '20202020206630314172726179203D206170657843726F707065722E636C6F62324172726179286261736536342C2033303030302C206630314172726179293B0D0A0D0A20202020202020202F2F204170657820416A61782043616C6C0D0A2020202020';
wwv_flow_api.g_varchar2_table(15) := '202020617065782E7365727665722E706C7567696E2870416A61784964656E7469666965722C0D0A2020202020202020202020202020202020202020202020202020207B206630313A2066303141727261790D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(16) := '202020202020202020202020207D2C0D0A2020202020202020202020202020202020202020202020202020207B2064617461547970653A202768746D6C272C0D0A20202020202020202020202020202020202020202020202020202020202F2F20535543';
wwv_flow_api.g_varchar2_table(17) := '4553532066756E6374696F6E0D0A2020202020202020202020202020202020202020202020202020202020737563636573733A2066756E6374696F6E2829207B0D0A20202020202020202020202020202020202020202020202020202020202020202F2F';
wwv_flow_api.g_varchar2_table(18) := '2074726967676572206170657820706C7567696E206576656E740D0A2020202020202020202020202020202020202020202020202020202020202020617065782E6576656E742E747269676765722870496D6167652C20276170657863726F707065722D';
wwv_flow_api.g_varchar2_table(19) := '73617665642D6462272C202727293B0D0A0D0A20202020202020202020202020202020202020202020202020202020202020202F2F2063616C6C6261636B0D0A202020202020202020202020202020202020202020202020202020202020202063616C6C';
wwv_flow_api.g_varchar2_table(20) := '6261636B28293B0D0A20202020202020202020202020202020202020202020202020202020202020207D2C0D0A20202020202020202020202020202020202020202020202020202020202F2F204552524F522066756E6374696F6E0D0A20202020202020';
wwv_flow_api.g_varchar2_table(21) := '202020202020202020202020202020202020202020206572726F723A2066756E6374696F6E287868722C20704D65737361676529207B0D0A20202020202020202020202020202020202020202020202020202020202020202F2F20747269676765722061';
wwv_flow_api.g_varchar2_table(22) := '70657820706C7567696E206576656E740D0A2020202020202020202020202020202020202020202020202020202020202020617065782E6576656E742E747269676765722870496D6167652C20276170657863726F707065722D6572726F722D6462272C';
wwv_flow_api.g_varchar2_table(23) := '202727293B0D0A0D0A20202020202020202020202020202020202020202020202020202020202020202F2F206C6F67206572726F7220696E20636F6E736F6C650D0A20202020202020202020202020202020202020202020202020202020202020206170';
wwv_flow_api.g_varchar2_table(24) := '65782E64656275672E747261636528276170657843726F707065723A20617065782E7365727665722E706C7567696E204552524F523A272C20704D657373616765293B0D0A0D0A2020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(25) := '2020202F2F2063616C6C6261636B0D0A202020202020202020202020202020202020202020202020202020202020202063616C6C6261636B28293B0D0A20202020202020202020202020202020202020202020202020202020202020207D0D0A20202020';
wwv_flow_api.g_varchar2_table(26) := '202020202020202020202020202020202020202020202020207D293B0D0A202020207D2C0D0A202020202F2F2066756E6374696F6E207468617420676574732063616C6C65642066726F6D20706C7567696E0D0A202020206170657843726F7070657249';
wwv_flow_api.g_varchar2_table(27) := '6E69743A2066756E6374696F6E2829207B0D0A20202020202020202F2F20706C7567696E20617474726962757465730D0A202020202020202076617220646154686973203D20746869733B0D0A20202020202020207661722024696D6167652020202020';
wwv_flow_api.g_varchar2_table(28) := '202020202020202020203D20746869732E6166666563746564456C656D656E74733B0D0A2020202020202020766172206C5F6F7074696F6E732020202020202020202020203D204A534F4E2E7061727365286461546869732E616374696F6E2E61747472';
wwv_flow_api.g_varchar2_table(29) := '69627574653031293B0D0A2020202020202020766172206C5F6C6F6767696E672020202020202020202020203D206170657843726F707065722E7061727365426F6F6C65616E286C5F6F7074696F6E732E6C6F6767696E67293B0D0A0D0A202020202020';
wwv_flow_api.g_varchar2_table(30) := '2020766172206C5F7361766553656C6563746F72202020202020203D206C5F6F7074696F6E732E7361766553656C6563746F723B0D0A2020202020202020766172206C5F63726F70706564496D6167654D6178576964746820203D202169734E614E286C';
wwv_flow_api.g_varchar2_table(31) := '5F6F7074696F6E732E63726F70706564496D616765576964746829203F207061727365496E74286C5F6F7074696F6E732E63726F70706564496D616765576964746829203A20756E646566696E65643B0D0A2020202020202020766172206C5F63726F70';
wwv_flow_api.g_varchar2_table(32) := '706564496D6167654D6178486569676874203D202169734E614E286C5F6F7074696F6E732E63726F70706564496D61676548656967687429203F207061727365496E74286C5F6F7074696F6E732E63726F70706564496D61676548656967687429203A20';
wwv_flow_api.g_varchar2_table(33) := '756E646566696E65643B0D0A2020202020202020766172206C5F63726F70706564496D61676557696474683B0D0A2020202020202020766172206C5F63726F70706564496D6167654865696768743B0D0A2020202020202020766172206C5F73686F7753';
wwv_flow_api.g_varchar2_table(34) := '70696E6E657220202020202020203D206170657843726F707065722E7061727365426F6F6C65616E286C5F6F7074696F6E732E73686F775370696E6E6572293B0D0A0D0A2020202020202020766172206F7074696F6E73203D207B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(35) := '2020202020766965774D6F64653A207061727365496E74286C5F6F7074696F6E732E766965774D6F6465292C0D0A202020202020202020202020647261674D6F64653A206C5F6F7074696F6E732E647261674D6F64652C0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(36) := '20617370656374526174696F3A206576616C286C5F6F7074696F6E732E617370656374526174696F292C0D0A202020202020202020202020707265766965773A206C5F6F7074696F6E732E7072657669657753656C6563746F722C0D0A20202020202020';
wwv_flow_api.g_varchar2_table(37) := '20202020206D696E436F6E7461696E657257696474683A207061727365496E74286C5F6F7074696F6E732E6D696E436F6E7461696E65725769647468292C0D0A2020202020202020202020206D696E436F6E7461696E65724865696768743A2070617273';
wwv_flow_api.g_varchar2_table(38) := '65496E74286C5F6F7074696F6E732E6D696E436F6E7461696E6572486569676874292C0D0A2020202020202020202020206D696E43616E76617357696474683A207061727365496E74286C5F6F7074696F6E732E6D696E43616E7661735769647468292C';
wwv_flow_api.g_varchar2_table(39) := '0D0A2020202020202020202020206D696E43616E7661734865696768743A207061727365496E74286C5F6F7074696F6E732E6D696E43616E766173486569676874292C0D0A2020202020202020202020206D696E43726F70426F7857696474683A207061';
wwv_flow_api.g_varchar2_table(40) := '727365496E74286C5F6F7074696F6E732E6D696E43726F70426F785769647468292C0D0A2020202020202020202020206D696E43726F70426F784865696768743A207061727365496E74286C5F6F7074696F6E732E6D696E43726F70426F784865696768';
wwv_flow_api.g_varchar2_table(41) := '74290D0A20202020202020207D3B0D0A0D0A20202020202020202F2F204C6F6767696E670D0A2020202020202020696620286C5F6C6F6767696E6729207B0D0A202020202020202020202020617065782E64656275672E74726163652827617065784372';
wwv_flow_api.g_varchar2_table(42) := '6F707065723A2043726F70706572204F7074696F6E73203A27202B206F7074696F6E73293B0D0A202020202020202020202020617065782E64656275672E7472616365286F7074696F6E73293B0D0A202020202020202020202020617065782E64656275';
wwv_flow_api.g_varchar2_table(43) := '672E747261636528276170657843726F707065723A20417474726962757465207361766553656C6563746F723A272C206C5F7361766553656C6563746F72293B0D0A202020202020202020202020617065782E64656275672E7472616365282761706578';
wwv_flow_api.g_varchar2_table(44) := '43726F707065723A204174747269627574652063726F70706564496D61676557696474683A272C206C5F63726F70706564496D6167654D61785769647468293B0D0A202020202020202020202020617065782E64656275672E7472616365282761706578';
wwv_flow_api.g_varchar2_table(45) := '43726F707065723A204174747269627574652063726F70706564496D6167654865696768743A272C206C5F63726F70706564496D6167654D6178486569676874293B0D0A202020202020202020202020617065782E64656275672E747261636528276170';
wwv_flow_api.g_varchar2_table(46) := '657843726F707065723A204174747269627574652073686F775370696E6E65723A272C206C5F73686F775370696E6E6572293B0D0A20202020202020207D0D0A0D0A202020202020202024696D6167652E63726F70706572286F7074696F6E73293B0D0A';
wwv_flow_api.g_varchar2_table(47) := '0D0A20202020202020202F2F20736176652063726F7070656420696D61676520746F2044420D0A0D0A202020202020202024286C5F7361766553656C6563746F72292E636C69636B2866756E6374696F6E2829207B0D0A20202020202020202020202076';
wwv_flow_api.g_varchar2_table(48) := '6172206C5F63726F70706564496D6167653B0D0A202020202020202020202020766172206C5F63726F7070656444617461203D2024696D6167652E63726F7070657228276765744461746127293B0D0A202020202020202020202020766172206C5F6372';
wwv_flow_api.g_varchar2_table(49) := '6F70706564496D616765576964746820203D206C5F63726F70706564446174612E77696474683B0D0A202020202020202020202020766172206C5F63726F70706564496D616765486569676874203D206C5F63726F70706564446174612E686569676874';
wwv_flow_api.g_varchar2_table(50) := '3B0D0A202020202020202020202020766172206C5F63726F70706564496D616765526174696F20203D20286C5F63726F70706564446174612E7769647468202F206C5F63726F70706564446174612E686569676874293B0D0A0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(51) := '2020202F2F2073686F772077616974207370696E6E65720D0A202020202020202020202020696620286C5F73686F775370696E6E657229207B0D0A2020202020202020202020202020202076617220247370696E6E6572203D20617065782E7574696C2E';
wwv_flow_api.g_varchar2_table(52) := '73686F775370696E6E657228293B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020202F2F2069662074686572652069732061206D6178696D756D207769647468206F72206865696768740D0A20202020202020202020202069';
wwv_flow_api.g_varchar2_table(53) := '6620286C5F63726F70706564496D6167654D61785769647468207C7C206C5F63726F70706564496D6167654D6178486569676874297B0D0A202020202020202020202020202020202F2F2069662063757272656E74207769647468206973206772656174';
wwv_flow_api.g_varchar2_table(54) := '6572207468616E206D6178696D756D2077696474680D0A20202020202020202020202020202020696620286C5F63726F70706564496D6167654D6178576964746820262620286C5F63726F70706564496D6167655769647468203E206C5F63726F707065';
wwv_flow_api.g_varchar2_table(55) := '64496D6167654D6178576964746829297B0D0A20202020202020202020202020202020202020202F2F2061646A7573742068656967687420746F206B6565702061737065637420726174696F0D0A20202020202020202020202020202020202020206C5F';
wwv_flow_api.g_varchar2_table(56) := '63726F70706564496D616765486569676874203D206C5F63726F70706564496D616765486569676874202A20286C5F63726F70706564496D6167654D61785769647468202F206C5F63726F70706564496D6167655769647468293B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(57) := '202020202020202020202020206C5F63726F70706564496D616765576964746820203D206C5F63726F70706564496D6167654D617857696474683B0D0A202020202020202020202020202020207D0D0A0D0A202020202020202020202020202020202F2F';
wwv_flow_api.g_varchar2_table(58) := '2069662063757272656E74206865696768742069732067726561746572207468616E206D6178696D756D206865696768740D0A20202020202020202020202020202020696620286C5F63726F70706564496D6167654D617848656967687420262620286C';
wwv_flow_api.g_varchar2_table(59) := '5F63726F70706564496D616765486569676874203E206C5F63726F70706564496D6167654D617848656967687429297B0D0A20202020202020202020202020202020202020202F2F2061646A75737420776964746820746F206B65657020617370656374';
wwv_flow_api.g_varchar2_table(60) := '20726174696F0D0A20202020202020202020202020202020202020206C5F63726F70706564496D616765576964746820203D206C5F63726F70706564496D6167655769647468202A20286C5F63726F70706564496D6167654D6178486569676874202F20';
wwv_flow_api.g_varchar2_table(61) := '6C5F63726F70706564496D616765486569676874293B0D0A20202020202020202020202020202020202020206C5F63726F70706564496D616765486569676874203D206C5F63726F70706564496D6167654D61784865696768743B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(62) := '2020202020202020207D0D0A0D0A202020202020202020202020202020206C5F63726F70706564496D616765203D2024696D6167652E63726F70706572282767657443726F7070656443616E766173272C207B77696474683A206C5F63726F7070656449';
wwv_flow_api.g_varchar2_table(63) := '6D61676557696474682C206865696768743A206C5F63726F70706564496D6167654865696768747D293B0D0A2020202020202020202020207D0D0A202020202020202020202020656C7365207B0D0A202020202020202020202020202020206C5F63726F';
wwv_flow_api.g_varchar2_table(64) := '70706564496D616765203D2024696D6167652E63726F70706572282767657443726F7070656443616E76617327293B0D0A2020202020202020202020207D0D0A0D0A2020202020202020202020202F2F207361766520696D6167650D0A20202020202020';
wwv_flow_api.g_varchar2_table(65) := '20202020206170657843726F707065722E73617665324462286C5F6F7074696F6E732E616A61784964656E7469666965722C2024696D6167652C206C5F63726F70706564496D6167652E746F4461746155524C28292C2066756E6374696F6E2829207B0D';
wwv_flow_api.g_varchar2_table(66) := '0A202020202020202020202020202020202F2F2072656D6F76652077616974207370696E6E65720D0A20202020202020202020202020202020696620286C5F73686F775370696E6E657229207B0D0A202020202020202020202020202020202020202024';
wwv_flow_api.g_varchar2_table(67) := '7370696E6E65722E72656D6F766528293B0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D293B0D0A20202020202020207D293B0D0A202020207D0D0A7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(56079455640500515)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_file_name=>'js/apexCropper.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '766172206170657843726F707065723D7B7061727365426F6F6C65616E3A66756E6374696F6E2865297B76617220703B73776974636828652E746F4C6F776572436173652829297B636173652274727565223A703D21303B627265616B3B636173652266';
wwv_flow_api.g_varchar2_table(2) := '616C7365223A703D21313B627265616B3B64656661756C743A703D766F696420307D72657475726E20707D2C636C6F623241727261793A66756E6374696F6E28652C702C61297B6C6F6F70436F756E743D4D6174682E666C6F6F7228652E6C656E677468';
wwv_flow_api.g_varchar2_table(3) := '2F70292B313B666F7228766172206F3D303B6F3C6C6F6F70436F756E743B6F2B2B29612E7075736828652E736C69636528702A6F2C702A286F2B312929293B72657475726E20617D2C64617461555249326261736536343A66756E6374696F6E2865297B';
wwv_flow_api.g_varchar2_table(4) := '72657475726E20652E73756273747228652E696E6465784F6628222C22292B31297D2C736176653244623A66756E6374696F6E28652C702C612C6F297B76617220723D6170657843726F707065722E64617461555249326261736536342861292C743D5B';
wwv_flow_api.g_varchar2_table(5) := '5D3B743D6170657843726F707065722E636C6F6232417272617928722C3365342C74292C617065782E7365727665722E706C7567696E28652C7B6630313A747D2C7B64617461547970653A2268746D6C222C737563636573733A66756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(6) := '7B617065782E6576656E742E7472696767657228702C226170657863726F707065722D73617665642D6462222C2222292C6F28297D2C6572726F723A66756E6374696F6E28652C61297B617065782E6576656E742E7472696767657228702C2261706578';
wwv_flow_api.g_varchar2_table(7) := '63726F707065722D6572726F722D6462222C2222292C617065782E64656275672E747261636528226170657843726F707065723A20617065782E7365727665722E706C7567696E204552524F523A222C61292C6F28297D7D297D2C6170657843726F7070';
wwv_flow_api.g_varchar2_table(8) := '6572496E69743A66756E6374696F6E28297B766172206461546869733D746869732C24696D6167653D746869732E6166666563746564456C656D656E74732C6C5F6F7074696F6E733D4A534F4E2E7061727365286461546869732E616374696F6E2E6174';
wwv_flow_api.g_varchar2_table(9) := '747269627574653031292C6C5F6C6F6767696E673D6170657843726F707065722E7061727365426F6F6C65616E286C5F6F7074696F6E732E6C6F6767696E67292C6C5F7361766553656C6563746F723D6C5F6F7074696F6E732E7361766553656C656374';
wwv_flow_api.g_varchar2_table(10) := '6F722C6C5F63726F70706564496D6167654D617857696474683D69734E614E286C5F6F7074696F6E732E63726F70706564496D6167655769647468293F766F696420303A7061727365496E74286C5F6F7074696F6E732E63726F70706564496D61676557';
wwv_flow_api.g_varchar2_table(11) := '69647468292C6C5F63726F70706564496D6167654D61784865696768743D69734E614E286C5F6F7074696F6E732E63726F70706564496D616765486569676874293F766F696420303A7061727365496E74286C5F6F7074696F6E732E63726F7070656449';
wwv_flow_api.g_varchar2_table(12) := '6D616765486569676874292C6C5F63726F70706564496D61676557696474682C6C5F63726F70706564496D6167654865696768742C6C5F73686F775370696E6E65723D6170657843726F707065722E7061727365426F6F6C65616E286C5F6F7074696F6E';
wwv_flow_api.g_varchar2_table(13) := '732E73686F775370696E6E6572292C6F7074696F6E733D7B766965774D6F64653A7061727365496E74286C5F6F7074696F6E732E766965774D6F6465292C647261674D6F64653A6C5F6F7074696F6E732E647261674D6F64652C61737065637452617469';
wwv_flow_api.g_varchar2_table(14) := '6F3A6576616C286C5F6F7074696F6E732E617370656374526174696F292C707265766965773A6C5F6F7074696F6E732E7072657669657753656C6563746F722C6D696E436F6E7461696E657257696474683A7061727365496E74286C5F6F7074696F6E73';
wwv_flow_api.g_varchar2_table(15) := '2E6D696E436F6E7461696E65725769647468292C6D696E436F6E7461696E65724865696768743A7061727365496E74286C5F6F7074696F6E732E6D696E436F6E7461696E6572486569676874292C6D696E43616E76617357696474683A7061727365496E';
wwv_flow_api.g_varchar2_table(16) := '74286C5F6F7074696F6E732E6D696E43616E7661735769647468292C6D696E43616E7661734865696768743A7061727365496E74286C5F6F7074696F6E732E6D696E43616E766173486569676874292C6D696E43726F70426F7857696474683A70617273';
wwv_flow_api.g_varchar2_table(17) := '65496E74286C5F6F7074696F6E732E6D696E43726F70426F785769647468292C6D696E43726F70426F784865696768743A7061727365496E74286C5F6F7074696F6E732E6D696E43726F70426F78486569676874297D3B6C5F6C6F6767696E6726262861';
wwv_flow_api.g_varchar2_table(18) := '7065782E64656275672E747261636528226170657843726F707065723A2043726F70706572204F7074696F6E73203A222B6F7074696F6E73292C617065782E64656275672E7472616365286F7074696F6E73292C617065782E64656275672E7472616365';
wwv_flow_api.g_varchar2_table(19) := '28226170657843726F707065723A20417474726962757465207361766553656C6563746F723A222C6C5F7361766553656C6563746F72292C617065782E64656275672E747261636528226170657843726F707065723A204174747269627574652063726F';
wwv_flow_api.g_varchar2_table(20) := '70706564496D61676557696474683A222C6C5F63726F70706564496D6167654D61785769647468292C617065782E64656275672E747261636528226170657843726F707065723A204174747269627574652063726F70706564496D616765486569676874';
wwv_flow_api.g_varchar2_table(21) := '3A222C6C5F63726F70706564496D6167654D6178486569676874292C617065782E64656275672E747261636528226170657843726F707065723A204174747269627574652073686F775370696E6E65723A222C6C5F73686F775370696E6E657229292C24';
wwv_flow_api.g_varchar2_table(22) := '696D6167652E63726F70706572286F7074696F6E73292C24286C5F7361766553656C6563746F72292E636C69636B2866756E6374696F6E28297B76617220652C703D24696D6167652E63726F7070657228226765744461746122292C613D702E77696474';
wwv_flow_api.g_varchar2_table(23) := '682C6F3D702E6865696768743B702E77696474682F702E6865696768743B6966286C5F73686F775370696E6E65722976617220723D617065782E7574696C2E73686F775370696E6E657228293B6C5F63726F70706564496D6167654D617857696474687C';
wwv_flow_api.g_varchar2_table(24) := '7C6C5F63726F70706564496D6167654D61784865696768743F286C5F63726F70706564496D6167654D617857696474682626613E6C5F63726F70706564496D6167654D617857696474682626286F2A3D6C5F63726F70706564496D6167654D6178576964';
wwv_flow_api.g_varchar2_table(25) := '74682F612C613D6C5F63726F70706564496D6167654D61785769647468292C6C5F63726F70706564496D6167654D617848656967687426266F3E6C5F63726F70706564496D6167654D6178486569676874262628612A3D6C5F63726F70706564496D6167';
wwv_flow_api.g_varchar2_table(26) := '654D61784865696768742F6F2C6F3D6C5F63726F70706564496D6167654D6178486569676874292C653D24696D6167652E63726F70706572282267657443726F7070656443616E766173222C7B77696474683A612C6865696768743A6F7D29293A653D24';
wwv_flow_api.g_varchar2_table(27) := '696D6167652E63726F70706572282267657443726F7070656443616E76617322292C6170657843726F707065722E73617665324462286C5F6F7074696F6E732E616A61784964656E7469666965722C24696D6167652C652E746F4461746155524C28292C';
wwv_flow_api.g_varchar2_table(28) := '66756E6374696F6E28297B6C5F73686F775370696E6E65722626722E72656D6F766528297D297D297D7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(56079815467500515)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_file_name=>'js/apexCropper.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A210A202A2043726F707065722076322E322E350A202A2068747470733A2F2F6769746875622E636F6D2F66656E677975616E6368656E2F63726F707065720A202A0A202A20436F707972696768742028632920323031342D323031362046656E6779';
wwv_flow_api.g_varchar2_table(2) := '75616E204368656E20616E6420636F6E7472696275746F72730A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A0A202A20446174653A20323031362D30312D31385430353A34323A35302E3830305A0A202A2F';
wwv_flow_api.g_varchar2_table(3) := '0A0A2866756E6374696F6E2028666163746F727929207B0A202069662028747970656F6620646566696E65203D3D3D202766756E6374696F6E2720262620646566696E652E616D6429207B0A202020202F2F20414D442E20526567697374657220617320';
wwv_flow_api.g_varchar2_table(4) := '616E6F6E796D6F7573206D6F64756C652E0A20202020646566696E65285B276A7175657279275D2C20666163746F7279293B0A20207D20656C73652069662028747970656F66206578706F727473203D3D3D20276F626A6563742729207B0A202020202F';
wwv_flow_api.g_varchar2_table(5) := '2F204E6F6465202F20436F6D6D6F6E4A530A20202020666163746F7279287265717569726528276A71756572792729293B0A20207D20656C7365207B0A202020202F2F2042726F7773657220676C6F62616C732E0A20202020666163746F7279286A5175';
wwv_flow_api.g_varchar2_table(6) := '657279293B0A20207D0A7D292866756E6374696F6E20282429207B0A0A20202775736520737472696374273B0A0A20202F2F20476C6F62616C730A2020766172202477696E646F77203D20242877696E646F77293B0A20207661722024646F63756D656E';
wwv_flow_api.g_varchar2_table(7) := '74203D202428646F63756D656E74293B0A2020766172206C6F636174696F6E203D2077696E646F772E6C6F636174696F6E3B0A2020766172204172726179427566666572203D2077696E646F772E41727261794275666665723B0A20207661722055696E';
wwv_flow_api.g_varchar2_table(8) := '74384172726179203D2077696E646F772E55696E743841727261793B0A2020766172204461746156696577203D2077696E646F772E44617461566965773B0A20207661722062746F61203D2077696E646F772E62746F613B0A0A20202F2F20436F6E7374';
wwv_flow_api.g_varchar2_table(9) := '616E74730A2020766172204E414D455350414345203D202763726F70706572273B0A0A20202F2F20436C61737365730A202076617220434C4153535F4D4F44414C203D202763726F707065722D6D6F64616C273B0A202076617220434C4153535F484944';
wwv_flow_api.g_varchar2_table(10) := '45203D202763726F707065722D68696465273B0A202076617220434C4153535F48494444454E203D202763726F707065722D68696464656E273B0A202076617220434C4153535F494E56495349424C45203D202763726F707065722D696E76697369626C';
wwv_flow_api.g_varchar2_table(11) := '65273B0A202076617220434C4153535F4D4F5645203D202763726F707065722D6D6F7665273B0A202076617220434C4153535F43524F50203D202763726F707065722D63726F70273B0A202076617220434C4153535F44495341424C4544203D20276372';
wwv_flow_api.g_varchar2_table(12) := '6F707065722D64697361626C6564273B0A202076617220434C4153535F4247203D202763726F707065722D6267273B0A0A20202F2F204576656E74730A2020766172204556454E545F4D4F5553455F444F574E203D20276D6F757365646F776E20746F75';
wwv_flow_api.g_varchar2_table(13) := '6368737461727420706F696E746572646F776E204D53506F696E746572446F776E273B0A2020766172204556454E545F4D4F5553455F4D4F5645203D20276D6F7573656D6F766520746F7563686D6F766520706F696E7465726D6F7665204D53506F696E';
wwv_flow_api.g_varchar2_table(14) := '7465724D6F7665273B0A2020766172204556454E545F4D4F5553455F5550203D20276D6F757365757020746F756368656E6420746F75636863616E63656C20706F696E746572757020706F696E74657263616E63656C204D53506F696E7465725570204D';
wwv_flow_api.g_varchar2_table(15) := '53506F696E74657243616E63656C273B0A2020766172204556454E545F574845454C203D2027776865656C206D6F757365776865656C20444F4D4D6F7573655363726F6C6C273B0A2020766172204556454E545F44424C434C49434B203D202764626C63';
wwv_flow_api.g_varchar2_table(16) := '6C69636B273B0A2020766172204556454E545F4C4F4144203D20276C6F61642E27202B204E414D4553504143453B0A2020766172204556454E545F4552524F52203D20276572726F722E27202B204E414D4553504143453B0A2020766172204556454E54';
wwv_flow_api.g_varchar2_table(17) := '5F524553495A45203D2027726573697A652E27202B204E414D4553504143453B202F2F2042696E6420746F2077696E646F772077697468206E616D6573706163650A2020766172204556454E545F4255494C44203D20276275696C642E27202B204E414D';
wwv_flow_api.g_varchar2_table(18) := '4553504143453B0A2020766172204556454E545F4255494C54203D20276275696C742E27202B204E414D4553504143453B0A2020766172204556454E545F43524F505F5354415254203D202763726F7073746172742E27202B204E414D4553504143453B';
wwv_flow_api.g_varchar2_table(19) := '0A2020766172204556454E545F43524F505F4D4F5645203D202763726F706D6F76652E27202B204E414D4553504143453B0A2020766172204556454E545F43524F505F454E44203D202763726F70656E642E27202B204E414D4553504143453B0A202076';
wwv_flow_api.g_varchar2_table(20) := '6172204556454E545F43524F50203D202763726F702E27202B204E414D4553504143453B0A2020766172204556454E545F5A4F4F4D203D20277A6F6F6D2E27202B204E414D4553504143453B0A0A20202F2F20526567457870730A202076617220524547';
wwv_flow_api.g_varchar2_table(21) := '4558505F414354494F4E53203D202F657C777C737C6E7C73657C73777C6E657C6E777C616C6C7C63726F707C6D6F76657C7A6F6F6D2F3B0A2020766172205245474558505F444154415F55524C203D202F5E646174615C3A2F3B0A202076617220524547';
wwv_flow_api.g_varchar2_table(22) := '4558505F444154415F55524C5F48454144203D202F5E646174615C3A285B5E5C3B5D2B295C3B6261736536342C2F3B0A2020766172205245474558505F444154415F55524C5F4A504547203D202F5E646174615C3A696D6167655C2F6A7065672E2A3B62';
wwv_flow_api.g_varchar2_table(23) := '61736536342C2F3B0A0A20202F2F2044617461206B6579730A202076617220444154415F50524556494557203D202770726576696577273B0A202076617220444154415F414354494F4E203D2027616374696F6E273B0A0A20202F2F20416374696F6E73';
wwv_flow_api.g_varchar2_table(24) := '0A202076617220414354494F4E5F45415354203D202765273B0A202076617220414354494F4E5F57455354203D202777273B0A202076617220414354494F4E5F534F555448203D202773273B0A202076617220414354494F4E5F4E4F525448203D20276E';
wwv_flow_api.g_varchar2_table(25) := '273B0A202076617220414354494F4E5F534F5554485F45415354203D20277365273B0A202076617220414354494F4E5F534F5554485F57455354203D20277377273B0A202076617220414354494F4E5F4E4F5254485F45415354203D20276E65273B0A20';
wwv_flow_api.g_varchar2_table(26) := '2076617220414354494F4E5F4E4F5254485F57455354203D20276E77273B0A202076617220414354494F4E5F414C4C203D2027616C6C273B0A202076617220414354494F4E5F43524F50203D202763726F70273B0A202076617220414354494F4E5F4D4F';
wwv_flow_api.g_varchar2_table(27) := '5645203D20276D6F7665273B0A202076617220414354494F4E5F5A4F4F4D203D20277A6F6F6D273B0A202076617220414354494F4E5F4E4F4E45203D20276E6F6E65273B0A0A20202F2F20537570706F7274730A202076617220535550504F52545F4341';
wwv_flow_api.g_varchar2_table(28) := '4E564153203D20242E697346756E6374696F6E282428273C63616E7661733E27295B305D2E676574436F6E74657874293B0A0A20202F2F204D617468730A2020766172206E756D203D204E756D6265723B0A2020766172206D696E203D204D6174682E6D';
wwv_flow_api.g_varchar2_table(29) := '696E3B0A2020766172206D6178203D204D6174682E6D61783B0A202076617220616273203D204D6174682E6162733B0A20207661722073696E203D204D6174682E73696E3B0A202076617220636F73203D204D6174682E636F733B0A2020766172207371';
wwv_flow_api.g_varchar2_table(30) := '7274203D204D6174682E737172743B0A202076617220726F756E64203D204D6174682E726F756E643B0A202076617220666C6F6F72203D204D6174682E666C6F6F723B0A0A20202F2F205574696C69746965730A20207661722066726F6D43686172436F';
wwv_flow_api.g_varchar2_table(31) := '6465203D20537472696E672E66726F6D43686172436F64653B0A0A202066756E6374696F6E2069734E756D626572286E29207B0A2020202072657475726E20747970656F66206E203D3D3D20276E756D62657227202626202169734E614E286E293B0A20';
wwv_flow_api.g_varchar2_table(32) := '207D0A0A202066756E6374696F6E206973556E646566696E6564286E29207B0A2020202072657475726E20747970656F66206E203D3D3D2027756E646566696E6564273B0A20207D0A0A202066756E6374696F6E20746F4172726179286F626A2C206F66';
wwv_flow_api.g_varchar2_table(33) := '6673657429207B0A202020207661722061726773203D205B5D3B0A0A202020202F2F2054686973206973206E656365737361727920666F72204945380A202020206966202869734E756D626572286F66667365742929207B0A202020202020617267732E';
wwv_flow_api.g_varchar2_table(34) := '70757368286F6666736574293B0A202020207D0A0A2020202072657475726E20617267732E736C6963652E6170706C79286F626A2C2061726773293B0A20207D0A0A20202F2F20437573746F6D2070726F787920746F2061766F6964206A517565727927';
wwv_flow_api.g_varchar2_table(35) := '7320677569640A202066756E6374696F6E2070726F787928666E2C20636F6E7465787429207B0A202020207661722061726773203D20746F417272617928617267756D656E74732C2032293B0A0A2020202072657475726E2066756E6374696F6E202829';
wwv_flow_api.g_varchar2_table(36) := '207B0A20202020202072657475726E20666E2E6170706C7928636F6E746578742C20617267732E636F6E63617428746F417272617928617267756D656E74732929293B0A202020207D3B0A20207D0A0A202066756E6374696F6E20697343726F73734F72';
wwv_flow_api.g_varchar2_table(37) := '6967696E55524C2875726C29207B0A20202020766172207061727473203D2075726C2E6D61746368282F5E2868747470733F3A295C2F5C2F285B5E5C3A5C2F5C3F235D2B293A3F285C642A292F69293B0A0A2020202072657475726E2070617274732026';
wwv_flow_api.g_varchar2_table(38) := '2620280A20202020202070617274735B315D20213D3D206C6F636174696F6E2E70726F746F636F6C207C7C0A20202020202070617274735B325D20213D3D206C6F636174696F6E2E686F73746E616D65207C7C0A20202020202070617274735B335D2021';
wwv_flow_api.g_varchar2_table(39) := '3D3D206C6F636174696F6E2E706F72740A20202020293B0A20207D0A0A202066756E6374696F6E2061646454696D657374616D702875726C29207B0A202020207661722074696D657374616D70203D202774696D657374616D703D27202B20286E657720';
wwv_flow_api.g_varchar2_table(40) := '446174652829292E67657454696D6528293B0A0A2020202072657475726E202875726C202B202875726C2E696E6465784F6628273F2729203D3D3D202D31203F20273F27203A2027262729202B2074696D657374616D70293B0A20207D0A0A202066756E';
wwv_flow_api.g_varchar2_table(41) := '6374696F6E2067657443726F73734F726967696E2863726F73734F726967696E29207B0A2020202072657475726E2063726F73734F726967696E203F20272063726F73734F726967696E3D2227202B2063726F73734F726967696E202B20272227203A20';
wwv_flow_api.g_varchar2_table(42) := '27273B0A20207D0A0A202066756E6374696F6E20676574496D61676553697A6528696D6167652C2063616C6C6261636B29207B0A20202020766172206E6577496D6167653B0A0A202020202F2F204D6F6465726E2062726F77736572730A202020206966';
wwv_flow_api.g_varchar2_table(43) := '2028696D6167652E6E61747572616C576964746829207B0A20202020202072657475726E2063616C6C6261636B28696D6167652E6E61747572616C57696474682C20696D6167652E6E61747572616C486569676874293B0A202020207D0A0A202020202F';
wwv_flow_api.g_varchar2_table(44) := '2F204945383A20446F6E27742075736520606E657720496D6167652829602068657265202823333139290A202020206E6577496D616765203D20646F63756D656E742E637265617465456C656D656E742827696D6727293B0A0A202020206E6577496D61';
wwv_flow_api.g_varchar2_table(45) := '67652E6F6E6C6F6164203D2066756E6374696F6E202829207B0A20202020202063616C6C6261636B28746869732E77696474682C20746869732E686569676874293B0A202020207D3B0A0A202020206E6577496D6167652E737263203D20696D6167652E';
wwv_flow_api.g_varchar2_table(46) := '7372633B0A20207D0A0A202066756E6374696F6E206765745472616E73666F726D286F7074696F6E7329207B0A20202020766172207472616E73666F726D73203D205B5D3B0A2020202076617220726F74617465203D206F7074696F6E732E726F746174';
wwv_flow_api.g_varchar2_table(47) := '653B0A20202020766172207363616C6558203D206F7074696F6E732E7363616C65583B0A20202020766172207363616C6559203D206F7074696F6E732E7363616C65593B0A0A202020206966202869734E756D62657228726F746174652929207B0A2020';
wwv_flow_api.g_varchar2_table(48) := '202020207472616E73666F726D732E707573682827726F746174652827202B20726F74617465202B20276465672927293B0A202020207D0A0A202020206966202869734E756D626572287363616C6558292026262069734E756D626572287363616C6559';
wwv_flow_api.g_varchar2_table(49) := '2929207B0A2020202020207472616E73666F726D732E7075736828277363616C652827202B207363616C6558202B20272C27202B207363616C6559202B20272927293B0A202020207D0A0A2020202072657475726E207472616E73666F726D732E6C656E';
wwv_flow_api.g_varchar2_table(50) := '677468203F207472616E73666F726D732E6A6F696E2827202729203A20276E6F6E65273B0A20207D0A0A202066756E6374696F6E20676574526F746174656453697A657328646174612C206973526576657273656429207B0A2020202076617220646567';
wwv_flow_api.g_varchar2_table(51) := '203D2061627328646174612E646567726565292025203138303B0A2020202076617220617263203D2028646567203E203930203F2028313830202D2064656729203A2064656729202A204D6174682E5049202F203138303B0A202020207661722073696E';
wwv_flow_api.g_varchar2_table(52) := '417263203D2073696E28617263293B0A2020202076617220636F73417263203D20636F7328617263293B0A20202020766172207769647468203D20646174612E77696474683B0A2020202076617220686569676874203D20646174612E6865696768743B';
wwv_flow_api.g_varchar2_table(53) := '0A2020202076617220617370656374526174696F203D20646174612E617370656374526174696F3B0A20202020766172206E657757696474683B0A20202020766172206E65774865696768743B0A0A202020206966202821697352657665727365642920';
wwv_flow_api.g_varchar2_table(54) := '7B0A2020202020206E65775769647468203D207769647468202A20636F73417263202B20686569676874202A2073696E4172633B0A2020202020206E6577486569676874203D207769647468202A2073696E417263202B20686569676874202A20636F73';
wwv_flow_api.g_varchar2_table(55) := '4172633B0A202020207D20656C7365207B0A2020202020206E65775769647468203D207769647468202F2028636F73417263202B2073696E417263202F20617370656374526174696F293B0A2020202020206E6577486569676874203D206E6577576964';
wwv_flow_api.g_varchar2_table(56) := '7468202F20617370656374526174696F3B0A202020207D0A0A2020202072657475726E207B0A20202020202077696474683A206E657757696474682C0A2020202020206865696768743A206E65774865696768740A202020207D3B0A20207D0A0A202066';
wwv_flow_api.g_varchar2_table(57) := '756E6374696F6E20676574536F7572636543616E76617328696D6167652C206461746129207B0A202020207661722063616E766173203D202428273C63616E7661733E27295B305D3B0A2020202076617220636F6E74657874203D2063616E7661732E67';
wwv_flow_api.g_varchar2_table(58) := '6574436F6E746578742827326427293B0A202020207661722078203D20303B0A202020207661722079203D20303B0A20202020766172207769647468203D20646174612E6E61747572616C57696474683B0A2020202076617220686569676874203D2064';
wwv_flow_api.g_varchar2_table(59) := '6174612E6E61747572616C4865696768743B0A2020202076617220726F74617465203D20646174612E726F746174653B0A20202020766172207363616C6558203D20646174612E7363616C65583B0A20202020766172207363616C6559203D2064617461';
wwv_flow_api.g_varchar2_table(60) := '2E7363616C65593B0A20202020766172207363616C61626C65203D2069734E756D626572287363616C6558292026262069734E756D626572287363616C65592920262620287363616C655820213D3D2031207C7C207363616C655920213D3D2031293B0A';
wwv_flow_api.g_varchar2_table(61) := '2020202076617220726F74617461626C65203D2069734E756D62657228726F746174652920262620726F7461746520213D3D20303B0A2020202076617220616476616E636564203D20726F74617461626C65207C7C207363616C61626C653B0A20202020';
wwv_flow_api.g_varchar2_table(62) := '7661722063616E7661735769647468203D2077696474683B0A202020207661722063616E766173486569676874203D206865696768743B0A20202020766172207472616E736C617465583B0A20202020766172207472616E736C617465593B0A20202020';
wwv_flow_api.g_varchar2_table(63) := '76617220726F74617465643B0A0A20202020696620287363616C61626C6529207B0A2020202020207472616E736C61746558203D207769647468202F20323B0A2020202020207472616E736C61746559203D20686569676874202F20323B0A202020207D';
wwv_flow_api.g_varchar2_table(64) := '0A0A2020202069662028726F74617461626C6529207B0A202020202020726F7461746564203D20676574526F746174656453697A6573287B0A202020202020202077696474683A2077696474682C0A20202020202020206865696768743A206865696768';
wwv_flow_api.g_varchar2_table(65) := '742C0A20202020202020206465677265653A20726F746174650A2020202020207D293B0A0A20202020202063616E7661735769647468203D20726F74617465642E77696474683B0A20202020202063616E766173486569676874203D20726F7461746564';
wwv_flow_api.g_varchar2_table(66) := '2E6865696768743B0A2020202020207472616E736C61746558203D20726F74617465642E7769647468202F20323B0A2020202020207472616E736C61746559203D20726F74617465642E686569676874202F20323B0A202020207D0A0A2020202063616E';
wwv_flow_api.g_varchar2_table(67) := '7661732E7769647468203D2063616E76617357696474683B0A2020202063616E7661732E686569676874203D2063616E7661734865696768743B0A0A2020202069662028616476616E63656429207B0A20202020202078203D202D7769647468202F2032';
wwv_flow_api.g_varchar2_table(68) := '3B0A20202020202079203D202D686569676874202F20323B0A0A202020202020636F6E746578742E7361766528293B0A202020202020636F6E746578742E7472616E736C617465287472616E736C617465582C207472616E736C61746559293B0A202020';
wwv_flow_api.g_varchar2_table(69) := '207D0A0A2020202069662028726F74617461626C6529207B0A202020202020636F6E746578742E726F7461746528726F74617465202A204D6174682E5049202F20313830293B0A202020207D0A0A202020202F2F2053686F756C642063616C6C20607363';
wwv_flow_api.g_varchar2_table(70) := '616C656020616674657220726F74617465640A20202020696620287363616C61626C6529207B0A202020202020636F6E746578742E7363616C65287363616C65582C207363616C6559293B0A202020207D0A0A20202020636F6E746578742E6472617749';
wwv_flow_api.g_varchar2_table(71) := '6D61676528696D6167652C20666C6F6F722878292C20666C6F6F722879292C20666C6F6F72287769647468292C20666C6F6F722868656967687429293B0A0A2020202069662028616476616E63656429207B0A202020202020636F6E746578742E726573';
wwv_flow_api.g_varchar2_table(72) := '746F726528293B0A202020207D0A0A2020202072657475726E2063616E7661733B0A20207D0A0A202066756E6374696F6E20676574546F756368657343656E74657228746F756368657329207B0A20202020766172206C656E677468203D20746F756368';
wwv_flow_api.g_varchar2_table(73) := '65732E6C656E6774683B0A20202020766172207061676558203D20303B0A20202020766172207061676559203D20303B0A0A20202020696620286C656E67746829207B0A202020202020242E6561636828746F75636865732C2066756E6374696F6E2028';
wwv_flow_api.g_varchar2_table(74) := '692C20746F75636829207B0A20202020202020207061676558202B3D20746F7563682E70616765583B0A20202020202020207061676559202B3D20746F7563682E70616765593B0A2020202020207D293B0A0A2020202020207061676558202F3D206C65';
wwv_flow_api.g_varchar2_table(75) := '6E6774683B0A2020202020207061676559202F3D206C656E6774683B0A202020207D0A0A2020202072657475726E207B0A20202020202070616765583A2070616765582C0A20202020202070616765593A2070616765590A202020207D3B0A20207D0A0A';
wwv_flow_api.g_varchar2_table(76) := '202066756E6374696F6E20676574537472696E6746726F6D43686172436F64652864617461566965772C2073746172742C206C656E67746829207B0A2020202076617220737472203D2027273B0A2020202076617220693B0A0A20202020666F72202869';
wwv_flow_api.g_varchar2_table(77) := '203D2073746172742C206C656E677468202B3D2073746172743B2069203C206C656E6774683B20692B2B29207B0A202020202020737472202B3D2066726F6D43686172436F64652864617461566965772E67657455696E7438286929293B0A202020207D';
wwv_flow_api.g_varchar2_table(78) := '0A0A2020202072657475726E207374723B0A20207D0A0A202066756E6374696F6E206765744F7269656E746174696F6E28617272617942756666657229207B0A20202020766172206461746156696577203D206E65772044617461566965772861727261';
wwv_flow_api.g_varchar2_table(79) := '79427566666572293B0A20202020766172206C656E677468203D2064617461566965772E627974654C656E6774683B0A20202020766172206F7269656E746174696F6E3B0A2020202076617220657869664944436F64653B0A2020202076617220746966';
wwv_flow_api.g_varchar2_table(80) := '664F66667365743B0A202020207661722066697273744946444F66667365743B0A20202020766172206C6974746C65456E6469616E3B0A2020202076617220656E6469616E6E6573733B0A20202020766172206170703153746172743B0A202020207661';
wwv_flow_api.g_varchar2_table(81) := '722069666453746172743B0A20202020766172206F66667365743B0A2020202076617220693B0A0A202020202F2F204F6E6C792068616E646C65204A50454720696D6167652028737461727420627920307846464438290A202020206966202864617461';
wwv_flow_api.g_varchar2_table(82) := '566965772E67657455696E7438283029203D3D3D20307846462026262064617461566965772E67657455696E7438283129203D3D3D203078443829207B0A2020202020206F6666736574203D20323B0A0A2020202020207768696C6520286F6666736574';
wwv_flow_api.g_varchar2_table(83) := '203C206C656E67746829207B0A20202020202020206966202864617461566965772E67657455696E7438286F666673657429203D3D3D20307846462026262064617461566965772E67657455696E7438286F6666736574202B203129203D3D3D20307845';
wwv_flow_api.g_varchar2_table(84) := '3129207B0A20202020202020202020617070315374617274203D206F66667365743B0A20202020202020202020627265616B3B0A20202020202020207D0A0A20202020202020206F66667365742B2B3B0A2020202020207D0A202020207D0A0A20202020';
wwv_flow_api.g_varchar2_table(85) := '6966202861707031537461727429207B0A202020202020657869664944436F6465203D20617070315374617274202B20343B0A202020202020746966664F6666736574203D20617070315374617274202B2031303B0A0A20202020202069662028676574';
wwv_flow_api.g_varchar2_table(86) := '537472696E6746726F6D43686172436F64652864617461566965772C20657869664944436F64652C203429203D3D3D2027457869662729207B0A2020202020202020656E6469616E6E657373203D2064617461566965772E67657455696E743136287469';
wwv_flow_api.g_varchar2_table(87) := '66664F6666736574293B0A20202020202020206C6974746C65456E6469616E203D20656E6469616E6E657373203D3D3D203078343934393B0A0A2020202020202020696620286C6974746C65456E6469616E207C7C20656E6469616E6E657373203D3D3D';
wwv_flow_api.g_varchar2_table(88) := '20307834443444202F2A20626967456E6469616E202A2F29207B0A202020202020202020206966202864617461566965772E67657455696E74313628746966664F6666736574202B20322C206C6974746C65456E6469616E29203D3D3D20307830303241';
wwv_flow_api.g_varchar2_table(89) := '29207B0A20202020202020202020202066697273744946444F6666736574203D2064617461566965772E67657455696E74333228746966664F6666736574202B20342C206C6974746C65456E6469616E293B0A0A20202020202020202020202069662028';
wwv_flow_api.g_varchar2_table(90) := '66697273744946444F6666736574203E3D203078303030303030303829207B0A20202020202020202020202020206966645374617274203D20746966664F6666736574202B2066697273744946444F66667365743B0A2020202020202020202020207D0A';
wwv_flow_api.g_varchar2_table(91) := '202020202020202020207D0A20202020202020207D0A2020202020207D0A202020207D0A0A2020202069662028696664537461727429207B0A2020202020206C656E677468203D2064617461566965772E67657455696E7431362869666453746172742C';
wwv_flow_api.g_varchar2_table(92) := '206C6974746C65456E6469616E293B0A0A202020202020666F72202869203D20303B2069203C206C656E6774683B20692B2B29207B0A20202020202020206F6666736574203D206966645374617274202B2069202A203132202B20323B0A0A2020202020';
wwv_flow_api.g_varchar2_table(93) := '2020206966202864617461566965772E67657455696E743136286F66667365742C206C6974746C65456E6469616E29203D3D3D20307830313132202F2A204F7269656E746174696F6E202A2F29207B0A0A202020202020202020202F2F20382069732074';
wwv_flow_api.g_varchar2_table(94) := '6865206F6666736574206F66207468652063757272656E742074616727732076616C75650A202020202020202020206F6666736574202B3D20383B0A0A202020202020202020202F2F2047657420746865206F726967696E616C206F7269656E74617469';
wwv_flow_api.g_varchar2_table(95) := '6F6E2076616C75650A202020202020202020206F7269656E746174696F6E203D2064617461566965772E67657455696E743136286F66667365742C206C6974746C65456E6469616E293B0A0A202020202020202020202F2F204F76657272696465207468';
wwv_flow_api.g_varchar2_table(96) := '65206F7269656E746174696F6E2077697468207468652064656661756C742076616C75653A20310A2020202020202020202064617461566965772E73657455696E743136286F66667365742C20312C206C6974746C65456E6469616E293B0A2020202020';
wwv_flow_api.g_varchar2_table(97) := '2020202020627265616B3B0A20202020202020207D0A2020202020207D0A202020207D0A0A2020202072657475726E206F7269656E746174696F6E3B0A20207D0A0A202066756E6374696F6E206461746155524C546F4172726179427566666572286461';
wwv_flow_api.g_varchar2_table(98) := '746155524C29207B0A2020202076617220626173653634203D206461746155524C2E7265706C616365285245474558505F444154415F55524C5F484541442C202727293B0A202020207661722062696E617279203D2061746F6228626173653634293B0A';
wwv_flow_api.g_varchar2_table(99) := '20202020766172206C656E677468203D2062696E6172792E6C656E6774683B0A20202020766172206172726179427566666572203D206E6577204172726179427566666572286C656E677468293B0A20202020766172206461746156696577203D206E65';
wwv_flow_api.g_varchar2_table(100) := '772055696E74384172726179286172726179427566666572293B0A2020202076617220693B0A0A20202020666F72202869203D20303B2069203C206C656E6774683B20692B2B29207B0A20202020202064617461566965775B695D203D2062696E617279';
wwv_flow_api.g_varchar2_table(101) := '2E63686172436F646541742869293B0A202020207D0A0A2020202072657475726E2061727261794275666665723B0A20207D0A0A20202F2F204F6E6C7920617661696C61626C6520666F72204A50454720696D6167650A202066756E6374696F6E206172';
wwv_flow_api.g_varchar2_table(102) := '726179427566666572546F4461746155524C28617272617942756666657229207B0A20202020766172206461746156696577203D206E65772055696E74384172726179286172726179427566666572293B0A20202020766172206C656E677468203D2064';
wwv_flow_api.g_varchar2_table(103) := '617461566965772E6C656E6774683B0A2020202076617220626173653634203D2027273B0A2020202076617220693B0A0A20202020666F72202869203D20303B2069203C206C656E6774683B20692B2B29207B0A202020202020626173653634202B3D20';
wwv_flow_api.g_varchar2_table(104) := '66726F6D43686172436F64652864617461566965775B695D293B0A202020207D0A0A2020202072657475726E2027646174613A696D6167652F6A7065673B6261736536342C27202B2062746F6128626173653634293B0A20207D0A0A202066756E637469';
wwv_flow_api.g_varchar2_table(105) := '6F6E2043726F7070657228656C656D656E742C206F7074696F6E7329207B0A20202020746869732E24656C656D656E74203D202428656C656D656E74293B0A20202020746869732E6F7074696F6E73203D20242E657874656E64287B7D2C2043726F7070';
wwv_flow_api.g_varchar2_table(106) := '65722E44454641554C54532C20242E6973506C61696E4F626A656374286F7074696F6E7329202626206F7074696F6E73293B0A20202020746869732E69734C6F61646564203D2066616C73653B0A20202020746869732E69734275696C74203D2066616C';
wwv_flow_api.g_varchar2_table(107) := '73653B0A20202020746869732E6973436F6D706C65746564203D2066616C73653B0A20202020746869732E6973526F7461746564203D2066616C73653B0A20202020746869732E697343726F70706564203D2066616C73653B0A20202020746869732E69';
wwv_flow_api.g_varchar2_table(108) := '7344697361626C6564203D2066616C73653B0A20202020746869732E69735265706C61636564203D2066616C73653B0A20202020746869732E69734C696D69746564203D2066616C73653B0A20202020746869732E776865656C696E67203D2066616C73';
wwv_flow_api.g_varchar2_table(109) := '653B0A20202020746869732E6973496D67203D2066616C73653B0A20202020746869732E6F726967696E616C55726C203D2027273B0A20202020746869732E63616E766173203D206E756C6C3B0A20202020746869732E63726F70426F78203D206E756C';
wwv_flow_api.g_varchar2_table(110) := '6C3B0A20202020746869732E696E697428293B0A20207D0A0A202043726F707065722E70726F746F74797065203D207B0A20202020636F6E7374727563746F723A2043726F707065722C0A0A20202020696E69743A2066756E6374696F6E202829207B0A';
wwv_flow_api.g_varchar2_table(111) := '202020202020766172202474686973203D20746869732E24656C656D656E743B0A2020202020207661722075726C3B0A0A2020202020206966202824746869732E69732827696D67272929207B0A2020202020202020746869732E6973496D67203D2074';
wwv_flow_api.g_varchar2_table(112) := '7275653B0A0A20202020202020202F2F2053686F756C64207573652060242E666E2E617474726020686572652E20652E672E3A2022696D672F706963747572652E6A7067220A2020202020202020746869732E6F726967696E616C55726C203D2075726C';
wwv_flow_api.g_varchar2_table(113) := '203D2024746869732E61747472282773726327293B0A0A20202020202020202F2F2053746F70207768656E2069742773206120626C616E6B20696D6167650A2020202020202020696620282175726C29207B0A2020202020202020202072657475726E3B';
wwv_flow_api.g_varchar2_table(114) := '0A20202020202020207D0A0A20202020202020202F2F2053686F756C64207573652060242E666E2E70726F706020686572652E20652E672E3A2022687474703A2F2F6578616D706C652E636F6D2F696D672F706963747572652E6A7067220A2020202020';
wwv_flow_api.g_varchar2_table(115) := '20202075726C203D2024746869732E70726F70282773726327293B0A2020202020207D20656C7365206966202824746869732E6973282763616E766173272920262620535550504F52545F43414E56415329207B0A202020202020202075726C203D2024';
wwv_flow_api.g_varchar2_table(116) := '746869735B305D2E746F4461746155524C28293B0A2020202020207D0A0A202020202020746869732E6C6F61642875726C293B0A202020207D2C0A0A202020202F2F20412073686F727463757420666F722074726967676572696E6720637573746F6D20';
wwv_flow_api.g_varchar2_table(117) := '6576656E74730A20202020747269676765723A2066756E6374696F6E2028747970652C206461746129207B0A2020202020207661722065203D20242E4576656E7428747970652C2064617461293B0A0A202020202020746869732E24656C656D656E742E';
wwv_flow_api.g_varchar2_table(118) := '747269676765722865293B0A0A20202020202072657475726E20653B0A202020207D2C0A0A202020206C6F61643A2066756E6374696F6E202875726C29207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A2020';
wwv_flow_api.g_varchar2_table(119) := '20202020766172202474686973203D20746869732E24656C656D656E743B0A20202020202076617220726561643B0A202020202020766172207868723B0A0A202020202020696620282175726C29207B0A202020202020202072657475726E3B0A202020';
wwv_flow_api.g_varchar2_table(120) := '2020207D0A0A2020202020202F2F2054726967676572206275696C64206576656E742066697273740A20202020202024746869732E6F6E65284556454E545F4255494C442C206F7074696F6E732E6275696C64293B0A0A20202020202069662028746869';
wwv_flow_api.g_varchar2_table(121) := '732E74726967676572284556454E545F4255494C44292E697344656661756C7450726576656E746564282929207B0A202020202020202072657475726E3B0A2020202020207D0A0A202020202020746869732E75726C203D2075726C3B0A202020202020';
wwv_flow_api.g_varchar2_table(122) := '746869732E696D616765203D207B7D3B0A0A20202020202069662028216F7074696F6E732E636865636B4F7269656E746174696F6E207C7C2021417272617942756666657229207B0A202020202020202072657475726E20746869732E636C6F6E652829';
wwv_flow_api.g_varchar2_table(123) := '3B0A2020202020207D0A0A20202020202072656164203D20242E70726F787928746869732E726561642C2074686973293B0A0A2020202020202F2F20584D4C487474705265717565737420646973616C6C6F777320746F206F70656E2061204461746120';
wwv_flow_api.g_varchar2_table(124) := '55524C20696E20736F6D652062726F7773657273206C696B65204945313120616E64205361666172690A202020202020696620285245474558505F444154415F55524C2E746573742875726C2929207B0A202020202020202072657475726E2052454745';
wwv_flow_api.g_varchar2_table(125) := '58505F444154415F55524C5F4A5045472E746573742875726C29203F0A2020202020202020202072656164286461746155524C546F41727261794275666665722875726C2929203A0A20202020202020202020746869732E636C6F6E6528293B0A202020';
wwv_flow_api.g_varchar2_table(126) := '2020207D0A0A202020202020786872203D206E657720584D4C487474705265717565737428293B0A0A2020202020207868722E6F6E6572726F72203D207868722E6F6E61626F7274203D20242E70726F78792866756E6374696F6E202829207B0A202020';
wwv_flow_api.g_varchar2_table(127) := '2020202020746869732E636C6F6E6528293B0A2020202020207D2C2074686973293B0A0A2020202020207868722E6F6E6C6F6164203D2066756E6374696F6E202829207B0A20202020202020207265616428746869732E726573706F6E7365293B0A2020';
wwv_flow_api.g_varchar2_table(128) := '202020207D3B0A0A2020202020207868722E6F70656E2827676574272C2075726C293B0A2020202020207868722E726573706F6E736554797065203D20276172726179627566666572273B0A2020202020207868722E73656E6428293B0A202020207D2C';
wwv_flow_api.g_varchar2_table(129) := '0A0A20202020726561643A2066756E6374696F6E2028617272617942756666657229207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A202020202020766172206F7269656E746174696F6E203D206765744F72';
wwv_flow_api.g_varchar2_table(130) := '69656E746174696F6E286172726179427566666572293B0A20202020202076617220696D616765203D20746869732E696D6167653B0A20202020202076617220726F746174653B0A202020202020766172207363616C65583B0A20202020202076617220';
wwv_flow_api.g_varchar2_table(131) := '7363616C65593B0A0A202020202020696620286F7269656E746174696F6E203E203129207B0A2020202020202020746869732E75726C203D206172726179427566666572546F4461746155524C286172726179427566666572293B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(132) := '2073776974636820286F7269656E746174696F6E29207B0A0A202020202020202020202F2F20666C697020686F72697A6F6E74616C0A202020202020202020206361736520323A0A2020202020202020202020207363616C6558203D202D313B0A202020';
wwv_flow_api.g_varchar2_table(133) := '202020202020202020627265616B3B0A0A202020202020202020202F2F20726F74617465206C65667420313830C2B00A202020202020202020206361736520333A0A202020202020202020202020726F74617465203D202D3138303B0A20202020202020';
wwv_flow_api.g_varchar2_table(134) := '2020202020627265616B3B0A0A202020202020202020202F2F20666C697020766572746963616C0A202020202020202020206361736520343A0A2020202020202020202020207363616C6559203D202D313B0A202020202020202020202020627265616B';
wwv_flow_api.g_varchar2_table(135) := '3B0A0A202020202020202020202F2F20666C697020766572746963616C202B20726F74617465207269676874203930C2B00A202020202020202020206361736520353A0A202020202020202020202020726F74617465203D2039303B0A20202020202020';
wwv_flow_api.g_varchar2_table(136) := '20202020207363616C6559203D202D313B0A202020202020202020202020627265616B3B0A0A202020202020202020202F2F20726F74617465207269676874203930C2B00A202020202020202020206361736520363A0A20202020202020202020202072';
wwv_flow_api.g_varchar2_table(137) := '6F74617465203D2039303B0A202020202020202020202020627265616B3B0A0A202020202020202020202F2F20666C697020686F72697A6F6E74616C202B20726F74617465207269676874203930C2B00A202020202020202020206361736520373A0A20';
wwv_flow_api.g_varchar2_table(138) := '2020202020202020202020726F74617465203D2039303B0A2020202020202020202020207363616C6558203D202D313B0A202020202020202020202020627265616B3B0A0A202020202020202020202F2F20726F74617465206C656674203930C2B00A20';
wwv_flow_api.g_varchar2_table(139) := '2020202020202020206361736520383A0A202020202020202020202020726F74617465203D202D39303B0A202020202020202020202020627265616B3B0A20202020202020207D0A2020202020207D0A0A202020202020696620286F7074696F6E732E72';
wwv_flow_api.g_varchar2_table(140) := '6F74617461626C6529207B0A2020202020202020696D6167652E726F74617465203D20726F746174653B0A2020202020207D0A0A202020202020696620286F7074696F6E732E7363616C61626C6529207B0A2020202020202020696D6167652E7363616C';
wwv_flow_api.g_varchar2_table(141) := '6558203D207363616C65583B0A2020202020202020696D6167652E7363616C6559203D207363616C65593B0A2020202020207D0A0A202020202020746869732E636C6F6E6528293B0A202020207D2C0A0A20202020636C6F6E653A2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(142) := '202829207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A202020202020766172202474686973203D20746869732E24656C656D656E743B0A2020202020207661722075726C203D20746869732E75726C3B0A20';
wwv_flow_api.g_varchar2_table(143) := '20202020207661722063726F73734F726967696E203D2027273B0A2020202020207661722063726F73734F726967696E55726C3B0A2020202020207661722024636C6F6E653B0A0A202020202020696620286F7074696F6E732E636865636B43726F7373';
wwv_flow_api.g_varchar2_table(144) := '4F726967696E20262620697343726F73734F726967696E55524C2875726C2929207B0A202020202020202063726F73734F726967696E203D2024746869732E70726F70282763726F73734F726967696E27293B0A0A20202020202020206966202863726F';
wwv_flow_api.g_varchar2_table(145) := '73734F726967696E29207B0A2020202020202020202063726F73734F726967696E55726C203D2075726C3B0A20202020202020207D20656C7365207B0A2020202020202020202063726F73734F726967696E203D2027616E6F6E796D6F7573273B0A0A20';
wwv_flow_api.g_varchar2_table(146) := '2020202020202020202F2F204275737420636163686520282331343829207768656E207468657265206973206E6F742061202263726F73734F726967696E222070726F70657274790A2020202020202020202063726F73734F726967696E55726C203D20';
wwv_flow_api.g_varchar2_table(147) := '61646454696D657374616D702875726C293B0A20202020202020207D0A2020202020207D0A0A202020202020746869732E63726F73734F726967696E203D2063726F73734F726967696E3B0A202020202020746869732E63726F73734F726967696E5572';
wwv_flow_api.g_varchar2_table(148) := '6C203D2063726F73734F726967696E55726C3B0A202020202020746869732E24636C6F6E65203D2024636C6F6E65203D202428273C696D6727202B2067657443726F73734F726967696E2863726F73734F726967696E29202B2027207372633D2227202B';
wwv_flow_api.g_varchar2_table(149) := '202863726F73734F726967696E55726C207C7C2075726C29202B2027223E27293B0A0A20202020202069662028746869732E6973496D6729207B0A20202020202020206966202824746869735B305D2E636F6D706C65746529207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(150) := '2020746869732E737461727428293B0A20202020202020207D20656C7365207B0A2020202020202020202024746869732E6F6E65284556454E545F4C4F41442C20242E70726F787928746869732E73746172742C207468697329293B0A20202020202020';
wwv_flow_api.g_varchar2_table(151) := '207D0A2020202020207D20656C7365207B0A202020202020202024636C6F6E652E0A202020202020202020206F6E65284556454E545F4C4F41442C20242E70726F787928746869732E73746172742C207468697329292E0A202020202020202020206F6E';
wwv_flow_api.g_varchar2_table(152) := '65284556454E545F4552524F522C20242E70726F787928746869732E73746F702C207468697329292E0A20202020202020202020616464436C61737328434C4153535F48494445292E0A20202020202020202020696E7365727441667465722824746869';
wwv_flow_api.g_varchar2_table(153) := '73293B0A2020202020207D0A202020207D2C0A0A2020202073746172743A2066756E6374696F6E202829207B0A2020202020207661722024696D616765203D20746869732E24656C656D656E743B0A2020202020207661722024636C6F6E65203D207468';
wwv_flow_api.g_varchar2_table(154) := '69732E24636C6F6E653B0A0A2020202020206966202821746869732E6973496D6729207B0A202020202020202024636C6F6E652E6F6666284556454E545F4552524F522C20746869732E73746F70293B0A202020202020202024696D616765203D202463';
wwv_flow_api.g_varchar2_table(155) := '6C6F6E653B0A2020202020207D0A0A202020202020676574496D61676553697A652824696D6167655B305D2C20242E70726F78792866756E6374696F6E20286E61747572616C57696474682C206E61747572616C48656967687429207B0A202020202020';
wwv_flow_api.g_varchar2_table(156) := '2020242E657874656E6428746869732E696D6167652C207B0A202020202020202020206E61747572616C57696474683A206E61747572616C57696474682C0A202020202020202020206E61747572616C4865696768743A206E61747572616C4865696768';
wwv_flow_api.g_varchar2_table(157) := '742C0A20202020202020202020617370656374526174696F3A206E61747572616C5769647468202F206E61747572616C4865696768740A20202020202020207D293B0A0A2020202020202020746869732E69734C6F61646564203D20747275653B0A2020';
wwv_flow_api.g_varchar2_table(158) := '202020202020746869732E6275696C6428293B0A2020202020207D2C207468697329293B0A202020207D2C0A0A2020202073746F703A2066756E6374696F6E202829207B0A202020202020746869732E24636C6F6E652E72656D6F766528293B0A202020';
wwv_flow_api.g_varchar2_table(159) := '202020746869732E24636C6F6E65203D206E756C6C3B0A202020207D2C0A0A202020206275696C643A2066756E6374696F6E202829207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A20202020202076617220';
wwv_flow_api.g_varchar2_table(160) := '2474686973203D20746869732E24656C656D656E743B0A2020202020207661722024636C6F6E65203D20746869732E24636C6F6E653B0A202020202020766172202463726F707065723B0A202020202020766172202463726F70426F783B0A2020202020';
wwv_flow_api.g_varchar2_table(161) := '207661722024666163653B0A0A2020202020206966202821746869732E69734C6F6164656429207B0A202020202020202072657475726E3B0A2020202020207D0A0A2020202020202F2F20556E6275696C64206669727374207768656E207265706C6163';
wwv_flow_api.g_varchar2_table(162) := '650A20202020202069662028746869732E69734275696C7429207B0A2020202020202020746869732E756E6275696C6428293B0A2020202020207D0A0A2020202020202F2F204372656174652063726F7070657220656C656D656E74730A202020202020';
wwv_flow_api.g_varchar2_table(163) := '746869732E24636F6E7461696E6572203D2024746869732E706172656E7428293B0A202020202020746869732E2463726F70706572203D202463726F70706572203D20242843726F707065722E54454D504C415445293B0A202020202020746869732E24';
wwv_flow_api.g_varchar2_table(164) := '63616E766173203D202463726F707065722E66696E6428272E63726F707065722D63616E76617327292E617070656E642824636C6F6E65293B0A202020202020746869732E2464726167426F78203D202463726F707065722E66696E6428272E63726F70';
wwv_flow_api.g_varchar2_table(165) := '7065722D647261672D626F7827293B0A202020202020746869732E2463726F70426F78203D202463726F70426F78203D202463726F707065722E66696E6428272E63726F707065722D63726F702D626F7827293B0A202020202020746869732E24766965';
wwv_flow_api.g_varchar2_table(166) := '77426F78203D202463726F707065722E66696E6428272E63726F707065722D766965772D626F7827293B0A202020202020746869732E2466616365203D202466616365203D202463726F70426F782E66696E6428272E63726F707065722D666163652729';
wwv_flow_api.g_varchar2_table(167) := '3B0A0A2020202020202F2F204869646520746865206F726967696E616C20696D6167650A20202020202024746869732E616464436C61737328434C4153535F48494444454E292E6166746572282463726F70706572293B0A0A2020202020202F2F205368';
wwv_flow_api.g_varchar2_table(168) := '6F772074686520636C6F6E6520696D6167652069662069732068696464656E0A2020202020206966202821746869732E6973496D6729207B0A202020202020202024636C6F6E652E72656D6F7665436C61737328434C4153535F48494445293B0A202020';
wwv_flow_api.g_varchar2_table(169) := '2020207D0A0A202020202020746869732E696E69745072657669657728293B0A202020202020746869732E62696E6428293B0A0A2020202020206F7074696F6E732E617370656374526174696F203D206D617828302C206F7074696F6E732E6173706563';
wwv_flow_api.g_varchar2_table(170) := '74526174696F29207C7C204E614E3B0A2020202020206F7074696F6E732E766965774D6F6465203D206D617828302C206D696E28332C20726F756E64286F7074696F6E732E766965774D6F6465292929207C7C20303B0A0A202020202020696620286F70';
wwv_flow_api.g_varchar2_table(171) := '74696F6E732E6175746F43726F7029207B0A2020202020202020746869732E697343726F70706564203D20747275653B0A0A2020202020202020696620286F7074696F6E732E6D6F64616C29207B0A20202020202020202020746869732E246472616742';
wwv_flow_api.g_varchar2_table(172) := '6F782E616464436C61737328434C4153535F4D4F44414C293B0A20202020202020207D0A2020202020207D20656C7365207B0A20202020202020202463726F70426F782E616464436C61737328434C4153535F48494444454E293B0A2020202020207D0A';
wwv_flow_api.g_varchar2_table(173) := '0A20202020202069662028216F7074696F6E732E67756964657329207B0A20202020202020202463726F70426F782E66696E6428272E63726F707065722D64617368656427292E616464436C61737328434C4153535F48494444454E293B0A2020202020';
wwv_flow_api.g_varchar2_table(174) := '207D0A0A20202020202069662028216F7074696F6E732E63656E74657229207B0A20202020202020202463726F70426F782E66696E6428272E63726F707065722D63656E74657227292E616464436C61737328434C4153535F48494444454E293B0A2020';
wwv_flow_api.g_varchar2_table(175) := '202020207D0A0A202020202020696620286F7074696F6E732E63726F70426F784D6F7661626C6529207B0A202020202020202024666163652E616464436C61737328434C4153535F4D4F5645292E6461746128444154415F414354494F4E2C2041435449';
wwv_flow_api.g_varchar2_table(176) := '4F4E5F414C4C293B0A2020202020207D0A0A20202020202069662028216F7074696F6E732E686967686C6967687429207B0A202020202020202024666163652E616464436C61737328434C4153535F494E56495349424C45293B0A2020202020207D0A0A';
wwv_flow_api.g_varchar2_table(177) := '202020202020696620286F7074696F6E732E6261636B67726F756E6429207B0A20202020202020202463726F707065722E616464436C61737328434C4153535F4247293B0A2020202020207D0A0A20202020202069662028216F7074696F6E732E63726F';
wwv_flow_api.g_varchar2_table(178) := '70426F78526573697A61626C6529207B0A20202020202020202463726F70426F782E66696E6428272E63726F707065722D6C696E652C202E63726F707065722D706F696E7427292E616464436C61737328434C4153535F48494444454E293B0A20202020';
wwv_flow_api.g_varchar2_table(179) := '20207D0A0A202020202020746869732E736574447261674D6F6465286F7074696F6E732E647261674D6F6465293B0A202020202020746869732E72656E64657228293B0A202020202020746869732E69734275696C74203D20747275653B0A2020202020';
wwv_flow_api.g_varchar2_table(180) := '20746869732E73657444617461286F7074696F6E732E64617461293B0A20202020202024746869732E6F6E65284556454E545F4255494C542C206F7074696F6E732E6275696C74293B0A0A2020202020202F2F205472696767657220746865206275696C';
wwv_flow_api.g_varchar2_table(181) := '74206576656E74206173796E6368726F6E6F75736C7920746F206B656570206064617461282763726F7070657227296020697320646566696E65640A20202020202073657454696D656F757428242E70726F78792866756E6374696F6E202829207B0A20';
wwv_flow_api.g_varchar2_table(182) := '20202020202020746869732E74726967676572284556454E545F4255494C54293B0A2020202020202020746869732E6973436F6D706C65746564203D20747275653B0A2020202020207D2C2074686973292C2030293B0A202020207D2C0A0A2020202075';
wwv_flow_api.g_varchar2_table(183) := '6E6275696C643A2066756E6374696F6E202829207B0A2020202020206966202821746869732E69734275696C7429207B0A202020202020202072657475726E3B0A2020202020207D0A0A202020202020746869732E69734275696C74203D2066616C7365';
wwv_flow_api.g_varchar2_table(184) := '3B0A202020202020746869732E6973436F6D706C65746564203D2066616C73653B0A202020202020746869732E696E697469616C496D616765203D206E756C6C3B0A0A2020202020202F2F20436C6561722060696E697469616C43616E76617360206973';
wwv_flow_api.g_varchar2_table(185) := '206E6563657373617279207768656E207265706C6163650A202020202020746869732E696E697469616C43616E766173203D206E756C6C3B0A202020202020746869732E696E697469616C43726F70426F78203D206E756C6C3B0A202020202020746869';
wwv_flow_api.g_varchar2_table(186) := '732E636F6E7461696E6572203D206E756C6C3B0A202020202020746869732E63616E766173203D206E756C6C3B0A0A2020202020202F2F20436C656172206063726F70426F7860206973206E6563657373617279207768656E207265706C6163650A2020';
wwv_flow_api.g_varchar2_table(187) := '20202020746869732E63726F70426F78203D206E756C6C3B0A202020202020746869732E756E62696E6428293B0A0A202020202020746869732E72657365745072657669657728293B0A202020202020746869732E2470726576696577203D206E756C6C';
wwv_flow_api.g_varchar2_table(188) := '3B0A0A202020202020746869732E2476696577426F78203D206E756C6C3B0A202020202020746869732E2463726F70426F78203D206E756C6C3B0A202020202020746869732E2464726167426F78203D206E756C6C3B0A202020202020746869732E2463';
wwv_flow_api.g_varchar2_table(189) := '616E766173203D206E756C6C3B0A202020202020746869732E24636F6E7461696E6572203D206E756C6C3B0A0A202020202020746869732E2463726F707065722E72656D6F766528293B0A202020202020746869732E2463726F70706572203D206E756C';
wwv_flow_api.g_varchar2_table(190) := '6C3B0A202020207D2C0A0A2020202072656E6465723A2066756E6374696F6E202829207B0A202020202020746869732E696E6974436F6E7461696E657228293B0A202020202020746869732E696E697443616E76617328293B0A20202020202074686973';
wwv_flow_api.g_varchar2_table(191) := '2E696E697443726F70426F7828293B0A0A202020202020746869732E72656E64657243616E76617328293B0A0A20202020202069662028746869732E697343726F7070656429207B0A2020202020202020746869732E72656E64657243726F70426F7828';
wwv_flow_api.g_varchar2_table(192) := '293B0A2020202020207D0A202020207D2C0A0A20202020696E6974436F6E7461696E65723A2066756E6374696F6E202829207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A2020202020207661722024746869';
wwv_flow_api.g_varchar2_table(193) := '73203D20746869732E24656C656D656E743B0A2020202020207661722024636F6E7461696E6572203D20746869732E24636F6E7461696E65723B0A202020202020766172202463726F70706572203D20746869732E2463726F707065723B0A0A20202020';
wwv_flow_api.g_varchar2_table(194) := '20202463726F707065722E616464436C61737328434C4153535F48494444454E293B0A20202020202024746869732E72656D6F7665436C61737328434C4153535F48494444454E293B0A0A2020202020202463726F707065722E6373732828746869732E';
wwv_flow_api.g_varchar2_table(195) := '636F6E7461696E6572203D207B0A202020202020202077696474683A206D61782824636F6E7461696E65722E776964746828292C206E756D286F7074696F6E732E6D696E436F6E7461696E6572576964746829207C7C20323030292C0A20202020202020';
wwv_flow_api.g_varchar2_table(196) := '206865696768743A206D61782824636F6E7461696E65722E68656967687428292C206E756D286F7074696F6E732E6D696E436F6E7461696E657248656967687429207C7C20313030290A2020202020207D29293B0A0A20202020202024746869732E6164';
wwv_flow_api.g_varchar2_table(197) := '64436C61737328434C4153535F48494444454E293B0A2020202020202463726F707065722E72656D6F7665436C61737328434C4153535F48494444454E293B0A202020207D2C0A0A202020202F2F2043616E7661732028696D6167652077726170706572';
wwv_flow_api.g_varchar2_table(198) := '290A20202020696E697443616E7661733A2066756E6374696F6E202829207B0A20202020202076617220766965774D6F6465203D20746869732E6F7074696F6E732E766965774D6F64653B0A20202020202076617220636F6E7461696E6572203D207468';
wwv_flow_api.g_varchar2_table(199) := '69732E636F6E7461696E65723B0A20202020202076617220636F6E7461696E65725769647468203D20636F6E7461696E65722E77696474683B0A20202020202076617220636F6E7461696E6572486569676874203D20636F6E7461696E65722E68656967';
wwv_flow_api.g_varchar2_table(200) := '68743B0A20202020202076617220696D616765203D20746869732E696D6167653B0A20202020202076617220696D6167654E61747572616C5769647468203D20696D6167652E6E61747572616C57696474683B0A20202020202076617220696D6167654E';
wwv_flow_api.g_varchar2_table(201) := '61747572616C486569676874203D20696D6167652E6E61747572616C4865696768743B0A2020202020207661722069733930446567726565203D2061627328696D6167652E726F7461746529203D3D3D2039303B0A202020202020766172206E61747572';
wwv_flow_api.g_varchar2_table(202) := '616C5769647468203D2069733930446567726565203F20696D6167654E61747572616C486569676874203A20696D6167654E61747572616C57696474683B0A202020202020766172206E61747572616C486569676874203D206973393044656772656520';
wwv_flow_api.g_varchar2_table(203) := '3F20696D6167654E61747572616C5769647468203A20696D6167654E61747572616C4865696768743B0A20202020202076617220617370656374526174696F203D206E61747572616C5769647468202F206E61747572616C4865696768743B0A20202020';
wwv_flow_api.g_varchar2_table(204) := '20207661722063616E7661735769647468203D20636F6E7461696E657257696474683B0A2020202020207661722063616E766173486569676874203D20636F6E7461696E65724865696768743B0A2020202020207661722063616E7661733B0A0A202020';
wwv_flow_api.g_varchar2_table(205) := '20202069662028636F6E7461696E6572486569676874202A20617370656374526174696F203E20636F6E7461696E6572576964746829207B0A202020202020202069662028766965774D6F6465203D3D3D203329207B0A2020202020202020202063616E';
wwv_flow_api.g_varchar2_table(206) := '7661735769647468203D20636F6E7461696E6572486569676874202A20617370656374526174696F3B0A20202020202020207D20656C7365207B0A2020202020202020202063616E766173486569676874203D20636F6E7461696E65725769647468202F';
wwv_flow_api.g_varchar2_table(207) := '20617370656374526174696F3B0A20202020202020207D0A2020202020207D20656C7365207B0A202020202020202069662028766965774D6F6465203D3D3D203329207B0A2020202020202020202063616E766173486569676874203D20636F6E746169';
wwv_flow_api.g_varchar2_table(208) := '6E65725769647468202F20617370656374526174696F3B0A20202020202020207D20656C7365207B0A2020202020202020202063616E7661735769647468203D20636F6E7461696E6572486569676874202A20617370656374526174696F3B0A20202020';
wwv_flow_api.g_varchar2_table(209) := '202020207D0A2020202020207D0A0A20202020202063616E766173203D207B0A20202020202020206E61747572616C57696474683A206E61747572616C57696474682C0A20202020202020206E61747572616C4865696768743A206E61747572616C4865';
wwv_flow_api.g_varchar2_table(210) := '696768742C0A2020202020202020617370656374526174696F3A20617370656374526174696F2C0A202020202020202077696474683A2063616E76617357696474682C0A20202020202020206865696768743A2063616E7661734865696768740A202020';
wwv_flow_api.g_varchar2_table(211) := '2020207D3B0A0A20202020202063616E7661732E6F6C644C656674203D2063616E7661732E6C656674203D2028636F6E7461696E65725769647468202D2063616E766173576964746829202F20323B0A20202020202063616E7661732E6F6C64546F7020';
wwv_flow_api.g_varchar2_table(212) := '3D2063616E7661732E746F70203D2028636F6E7461696E6572486569676874202D2063616E76617348656967687429202F20323B0A0A202020202020746869732E63616E766173203D2063616E7661733B0A202020202020746869732E69734C696D6974';
wwv_flow_api.g_varchar2_table(213) := '6564203D2028766965774D6F6465203D3D3D2031207C7C20766965774D6F6465203D3D3D2032293B0A202020202020746869732E6C696D697443616E76617328747275652C2074727565293B0A202020202020746869732E696E697469616C496D616765';
wwv_flow_api.g_varchar2_table(214) := '203D20242E657874656E64287B7D2C20696D616765293B0A202020202020746869732E696E697469616C43616E766173203D20242E657874656E64287B7D2C2063616E766173293B0A202020207D2C0A0A202020206C696D697443616E7661733A206675';
wwv_flow_api.g_varchar2_table(215) := '6E6374696F6E2028697353697A654C696D697465642C206973506F736974696F6E4C696D6974656429207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A20202020202076617220766965774D6F6465203D206F';
wwv_flow_api.g_varchar2_table(216) := '7074696F6E732E766965774D6F64653B0A20202020202076617220636F6E7461696E6572203D20746869732E636F6E7461696E65723B0A20202020202076617220636F6E7461696E65725769647468203D20636F6E7461696E65722E77696474683B0A20';
wwv_flow_api.g_varchar2_table(217) := '202020202076617220636F6E7461696E6572486569676874203D20636F6E7461696E65722E6865696768743B0A2020202020207661722063616E766173203D20746869732E63616E7661733B0A20202020202076617220617370656374526174696F203D';
wwv_flow_api.g_varchar2_table(218) := '2063616E7661732E617370656374526174696F3B0A2020202020207661722063726F70426F78203D20746869732E63726F70426F783B0A20202020202076617220697343726F70706564203D20746869732E697343726F707065642026262063726F7042';
wwv_flow_api.g_varchar2_table(219) := '6F783B0A202020202020766172206D696E43616E76617357696474683B0A202020202020766172206D696E43616E7661734865696768743B0A202020202020766172206E657743616E7661734C6566743B0A202020202020766172206E657743616E7661';
wwv_flow_api.g_varchar2_table(220) := '73546F703B0A0A20202020202069662028697353697A654C696D6974656429207B0A20202020202020206D696E43616E7661735769647468203D206E756D286F7074696F6E732E6D696E43616E766173576964746829207C7C20303B0A20202020202020';
wwv_flow_api.g_varchar2_table(221) := '206D696E43616E766173486569676874203D206E756D286F7074696F6E732E6D696E43616E76617348656967687429207C7C20303B0A0A202020202020202069662028766965774D6F646529207B0A2020202020202020202069662028766965774D6F64';
wwv_flow_api.g_varchar2_table(222) := '65203E203129207B0A2020202020202020202020206D696E43616E7661735769647468203D206D6178286D696E43616E76617357696474682C20636F6E7461696E65725769647468293B0A2020202020202020202020206D696E43616E76617348656967';
wwv_flow_api.g_varchar2_table(223) := '6874203D206D6178286D696E43616E7661734865696768742C20636F6E7461696E6572486569676874293B0A0A20202020202020202020202069662028766965774D6F6465203D3D3D203329207B0A2020202020202020202020202020696620286D696E';
wwv_flow_api.g_varchar2_table(224) := '43616E766173486569676874202A20617370656374526174696F203E206D696E43616E766173576964746829207B0A202020202020202020202020202020206D696E43616E7661735769647468203D206D696E43616E766173486569676874202A206173';
wwv_flow_api.g_varchar2_table(225) := '70656374526174696F3B0A20202020202020202020202020207D20656C7365207B0A202020202020202020202020202020206D696E43616E766173486569676874203D206D696E43616E7661735769647468202F20617370656374526174696F3B0A2020';
wwv_flow_api.g_varchar2_table(226) := '2020202020202020202020207D0A2020202020202020202020207D0A202020202020202020207D20656C7365207B0A202020202020202020202020696620286D696E43616E766173576964746829207B0A20202020202020202020202020206D696E4361';
wwv_flow_api.g_varchar2_table(227) := '6E7661735769647468203D206D6178286D696E43616E76617357696474682C20697343726F70706564203F2063726F70426F782E7769647468203A2030293B0A2020202020202020202020207D20656C736520696620286D696E43616E76617348656967';
wwv_flow_api.g_varchar2_table(228) := '687429207B0A20202020202020202020202020206D696E43616E766173486569676874203D206D6178286D696E43616E7661734865696768742C20697343726F70706564203F2063726F70426F782E686569676874203A2030293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(229) := '202020207D20656C73652069662028697343726F7070656429207B0A20202020202020202020202020206D696E43616E7661735769647468203D2063726F70426F782E77696474683B0A20202020202020202020202020206D696E43616E766173486569';
wwv_flow_api.g_varchar2_table(230) := '676874203D2063726F70426F782E6865696768743B0A0A2020202020202020202020202020696620286D696E43616E766173486569676874202A20617370656374526174696F203E206D696E43616E766173576964746829207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(231) := '202020202020206D696E43616E7661735769647468203D206D696E43616E766173486569676874202A20617370656374526174696F3B0A20202020202020202020202020207D20656C7365207B0A202020202020202020202020202020206D696E43616E';
wwv_flow_api.g_varchar2_table(232) := '766173486569676874203D206D696E43616E7661735769647468202F20617370656374526174696F3B0A20202020202020202020202020207D0A2020202020202020202020207D0A202020202020202020207D0A20202020202020207D0A0A2020202020';
wwv_flow_api.g_varchar2_table(233) := '202020696620286D696E43616E7661735769647468202626206D696E43616E76617348656967687429207B0A20202020202020202020696620286D696E43616E766173486569676874202A20617370656374526174696F203E206D696E43616E76617357';
wwv_flow_api.g_varchar2_table(234) := '6964746829207B0A2020202020202020202020206D696E43616E766173486569676874203D206D696E43616E7661735769647468202F20617370656374526174696F3B0A202020202020202020207D20656C7365207B0A2020202020202020202020206D';
wwv_flow_api.g_varchar2_table(235) := '696E43616E7661735769647468203D206D696E43616E766173486569676874202A20617370656374526174696F3B0A202020202020202020207D0A20202020202020207D20656C736520696620286D696E43616E766173576964746829207B0A20202020';
wwv_flow_api.g_varchar2_table(236) := '2020202020206D696E43616E766173486569676874203D206D696E43616E7661735769647468202F20617370656374526174696F3B0A20202020202020207D20656C736520696620286D696E43616E76617348656967687429207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(237) := '20206D696E43616E7661735769647468203D206D696E43616E766173486569676874202A20617370656374526174696F3B0A20202020202020207D0A0A202020202020202063616E7661732E6D696E5769647468203D206D696E43616E76617357696474';
wwv_flow_api.g_varchar2_table(238) := '683B0A202020202020202063616E7661732E6D696E486569676874203D206D696E43616E7661734865696768743B0A202020202020202063616E7661732E6D61785769647468203D20496E66696E6974793B0A202020202020202063616E7661732E6D61';
wwv_flow_api.g_varchar2_table(239) := '78486569676874203D20496E66696E6974793B0A2020202020207D0A0A202020202020696620286973506F736974696F6E4C696D6974656429207B0A202020202020202069662028766965774D6F646529207B0A202020202020202020206E657743616E';
wwv_flow_api.g_varchar2_table(240) := '7661734C656674203D20636F6E7461696E65725769647468202D2063616E7661732E77696474683B0A202020202020202020206E657743616E766173546F70203D20636F6E7461696E6572486569676874202D2063616E7661732E6865696768743B0A0A';
wwv_flow_api.g_varchar2_table(241) := '2020202020202020202063616E7661732E6D696E4C656674203D206D696E28302C206E657743616E7661734C656674293B0A2020202020202020202063616E7661732E6D696E546F70203D206D696E28302C206E657743616E766173546F70293B0A2020';
wwv_flow_api.g_varchar2_table(242) := '202020202020202063616E7661732E6D61784C656674203D206D617828302C206E657743616E7661734C656674293B0A2020202020202020202063616E7661732E6D6178546F70203D206D617828302C206E657743616E766173546F70293B0A0A202020';
wwv_flow_api.g_varchar2_table(243) := '2020202020202069662028697343726F7070656420262620746869732E69734C696D6974656429207B0A20202020202020202020202063616E7661732E6D696E4C656674203D206D696E280A202020202020202020202020202063726F70426F782E6C65';
wwv_flow_api.g_varchar2_table(244) := '66742C0A202020202020202020202020202063726F70426F782E6C656674202B2063726F70426F782E7769647468202D2063616E7661732E77696474680A202020202020202020202020293B0A20202020202020202020202063616E7661732E6D696E54';
wwv_flow_api.g_varchar2_table(245) := '6F70203D206D696E280A202020202020202020202020202063726F70426F782E746F702C0A202020202020202020202020202063726F70426F782E746F70202B2063726F70426F782E686569676874202D2063616E7661732E6865696768740A20202020';
wwv_flow_api.g_varchar2_table(246) := '2020202020202020293B0A20202020202020202020202063616E7661732E6D61784C656674203D2063726F70426F782E6C6566743B0A20202020202020202020202063616E7661732E6D6178546F70203D2063726F70426F782E746F703B0A0A20202020';
wwv_flow_api.g_varchar2_table(247) := '202020202020202069662028766965774D6F6465203D3D3D203229207B0A20202020202020202020202020206966202863616E7661732E7769647468203E3D20636F6E7461696E6572576964746829207B0A202020202020202020202020202020206361';
wwv_flow_api.g_varchar2_table(248) := '6E7661732E6D696E4C656674203D206D696E28302C206E657743616E7661734C656674293B0A2020202020202020202020202020202063616E7661732E6D61784C656674203D206D617828302C206E657743616E7661734C656674293B0A202020202020';
wwv_flow_api.g_varchar2_table(249) := '20202020202020207D0A0A20202020202020202020202020206966202863616E7661732E686569676874203E3D20636F6E7461696E657248656967687429207B0A2020202020202020202020202020202063616E7661732E6D696E546F70203D206D696E';
wwv_flow_api.g_varchar2_table(250) := '28302C206E657743616E766173546F70293B0A2020202020202020202020202020202063616E7661732E6D6178546F70203D206D617828302C206E657743616E766173546F70293B0A20202020202020202020202020207D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(251) := '207D0A202020202020202020207D0A20202020202020207D20656C7365207B0A2020202020202020202063616E7661732E6D696E4C656674203D202D63616E7661732E77696474683B0A2020202020202020202063616E7661732E6D696E546F70203D20';
wwv_flow_api.g_varchar2_table(252) := '2D63616E7661732E6865696768743B0A2020202020202020202063616E7661732E6D61784C656674203D20636F6E7461696E657257696474683B0A2020202020202020202063616E7661732E6D6178546F70203D20636F6E7461696E6572486569676874';
wwv_flow_api.g_varchar2_table(253) := '3B0A20202020202020207D0A2020202020207D0A202020207D2C0A0A2020202072656E64657243616E7661733A2066756E6374696F6E202869734368616E67656429207B0A2020202020207661722063616E766173203D20746869732E63616E7661733B';
wwv_flow_api.g_varchar2_table(254) := '0A20202020202076617220696D616765203D20746869732E696D6167653B0A20202020202076617220726F74617465203D20696D6167652E726F746174653B0A202020202020766172206E61747572616C5769647468203D20696D6167652E6E61747572';
wwv_flow_api.g_varchar2_table(255) := '616C57696474683B0A202020202020766172206E61747572616C486569676874203D20696D6167652E6E61747572616C4865696768743B0A20202020202076617220617370656374526174696F3B0A20202020202076617220726F74617465643B0A0A20';
wwv_flow_api.g_varchar2_table(256) := '202020202069662028746869732E6973526F746174656429207B0A2020202020202020746869732E6973526F7461746564203D2066616C73653B0A0A20202020202020202F2F20436F6D707574657320726F74617465642073697A657320776974682069';
wwv_flow_api.g_varchar2_table(257) := '6D6167652073697A65730A2020202020202020726F7461746564203D20676574526F746174656453697A6573287B0A2020202020202020202077696474683A20696D6167652E77696474682C0A202020202020202020206865696768743A20696D616765';
wwv_flow_api.g_varchar2_table(258) := '2E6865696768742C0A202020202020202020206465677265653A20726F746174650A20202020202020207D293B0A0A2020202020202020617370656374526174696F203D20726F74617465642E7769647468202F20726F74617465642E6865696768743B';
wwv_flow_api.g_varchar2_table(259) := '0A0A202020202020202069662028617370656374526174696F20213D3D2063616E7661732E617370656374526174696F29207B0A2020202020202020202063616E7661732E6C656674202D3D2028726F74617465642E7769647468202D2063616E766173';
wwv_flow_api.g_varchar2_table(260) := '2E776964746829202F20323B0A2020202020202020202063616E7661732E746F70202D3D2028726F74617465642E686569676874202D2063616E7661732E68656967687429202F20323B0A2020202020202020202063616E7661732E7769647468203D20';
wwv_flow_api.g_varchar2_table(261) := '726F74617465642E77696474683B0A2020202020202020202063616E7661732E686569676874203D20726F74617465642E6865696768743B0A2020202020202020202063616E7661732E617370656374526174696F203D20617370656374526174696F3B';
wwv_flow_api.g_varchar2_table(262) := '0A2020202020202020202063616E7661732E6E61747572616C5769647468203D206E61747572616C57696474683B0A2020202020202020202063616E7661732E6E61747572616C486569676874203D206E61747572616C4865696768743B0A0A20202020';
wwv_flow_api.g_varchar2_table(263) := '2020202020202F2F20436F6D707574657320726F74617465642073697A65732077697468206E61747572616C20696D6167652073697A65730A2020202020202020202069662028726F7461746520252031383029207B0A20202020202020202020202072';
wwv_flow_api.g_varchar2_table(264) := '6F7461746564203D20676574526F746174656453697A6573287B0A202020202020202020202020202077696474683A206E61747572616C57696474682C0A20202020202020202020202020206865696768743A206E61747572616C4865696768742C0A20';
wwv_flow_api.g_varchar2_table(265) := '202020202020202020202020206465677265653A20726F746174650A2020202020202020202020207D293B0A0A20202020202020202020202063616E7661732E6E61747572616C5769647468203D20726F74617465642E77696474683B0A202020202020';
wwv_flow_api.g_varchar2_table(266) := '20202020202063616E7661732E6E61747572616C486569676874203D20726F74617465642E6865696768743B0A202020202020202020207D0A0A20202020202020202020746869732E6C696D697443616E76617328747275652C2066616C7365293B0A20';
wwv_flow_api.g_varchar2_table(267) := '202020202020207D0A2020202020207D0A0A2020202020206966202863616E7661732E7769647468203E2063616E7661732E6D61785769647468207C7C2063616E7661732E7769647468203C2063616E7661732E6D696E576964746829207B0A20202020';
wwv_flow_api.g_varchar2_table(268) := '2020202063616E7661732E6C656674203D2063616E7661732E6F6C644C6566743B0A2020202020207D0A0A2020202020206966202863616E7661732E686569676874203E2063616E7661732E6D6178486569676874207C7C2063616E7661732E68656967';
wwv_flow_api.g_varchar2_table(269) := '6874203C2063616E7661732E6D696E48656967687429207B0A202020202020202063616E7661732E746F70203D2063616E7661732E6F6C64546F703B0A2020202020207D0A0A20202020202063616E7661732E7769647468203D206D696E286D61782863';
wwv_flow_api.g_varchar2_table(270) := '616E7661732E77696474682C2063616E7661732E6D696E5769647468292C2063616E7661732E6D61785769647468293B0A20202020202063616E7661732E686569676874203D206D696E286D61782863616E7661732E6865696768742C2063616E766173';
wwv_flow_api.g_varchar2_table(271) := '2E6D696E486569676874292C2063616E7661732E6D6178486569676874293B0A0A202020202020746869732E6C696D697443616E7661732866616C73652C2074727565293B0A0A20202020202063616E7661732E6F6C644C656674203D2063616E766173';
wwv_flow_api.g_varchar2_table(272) := '2E6C656674203D206D696E286D61782863616E7661732E6C6566742C2063616E7661732E6D696E4C656674292C2063616E7661732E6D61784C656674293B0A20202020202063616E7661732E6F6C64546F70203D2063616E7661732E746F70203D206D69';
wwv_flow_api.g_varchar2_table(273) := '6E286D61782863616E7661732E746F702C2063616E7661732E6D696E546F70292C2063616E7661732E6D6178546F70293B0A0A202020202020746869732E2463616E7661732E637373287B0A202020202020202077696474683A2063616E7661732E7769';
wwv_flow_api.g_varchar2_table(274) := '6474682C0A20202020202020206865696768743A2063616E7661732E6865696768742C0A20202020202020206C6566743A2063616E7661732E6C6566742C0A2020202020202020746F703A2063616E7661732E746F700A2020202020207D293B0A0A2020';
wwv_flow_api.g_varchar2_table(275) := '20202020746869732E72656E646572496D61676528293B0A0A20202020202069662028746869732E697343726F7070656420262620746869732E69734C696D6974656429207B0A2020202020202020746869732E6C696D697443726F70426F7828747275';
wwv_flow_api.g_varchar2_table(276) := '652C2074727565293B0A2020202020207D0A0A2020202020206966202869734368616E67656429207B0A2020202020202020746869732E6F757470757428293B0A2020202020207D0A202020207D2C0A0A2020202072656E646572496D6167653A206675';
wwv_flow_api.g_varchar2_table(277) := '6E6374696F6E202869734368616E67656429207B0A2020202020207661722063616E766173203D20746869732E63616E7661733B0A20202020202076617220696D616765203D20746869732E696D6167653B0A2020202020207661722072657665727365';
wwv_flow_api.g_varchar2_table(278) := '643B0A0A20202020202069662028696D6167652E726F7461746529207B0A20202020202020207265766572736564203D20676574526F746174656453697A6573287B0A2020202020202020202077696474683A2063616E7661732E77696474682C0A2020';
wwv_flow_api.g_varchar2_table(279) := '20202020202020206865696768743A2063616E7661732E6865696768742C0A202020202020202020206465677265653A20696D6167652E726F746174652C0A20202020202020202020617370656374526174696F3A20696D6167652E6173706563745261';
wwv_flow_api.g_varchar2_table(280) := '74696F0A20202020202020207D2C2074727565293B0A2020202020207D0A0A202020202020242E657874656E6428696D6167652C207265766572736564203F207B0A202020202020202077696474683A2072657665727365642E77696474682C0A202020';
wwv_flow_api.g_varchar2_table(281) := '20202020206865696768743A2072657665727365642E6865696768742C0A20202020202020206C6566743A202863616E7661732E7769647468202D2072657665727365642E776964746829202F20322C0A2020202020202020746F703A202863616E7661';
wwv_flow_api.g_varchar2_table(282) := '732E686569676874202D2072657665727365642E68656967687429202F20320A2020202020207D203A207B0A202020202020202077696474683A2063616E7661732E77696474682C0A20202020202020206865696768743A2063616E7661732E68656967';
wwv_flow_api.g_varchar2_table(283) := '68742C0A20202020202020206C6566743A20302C0A2020202020202020746F703A20300A2020202020207D293B0A0A202020202020746869732E24636C6F6E652E637373287B0A202020202020202077696474683A20696D6167652E77696474682C0A20';
wwv_flow_api.g_varchar2_table(284) := '202020202020206865696768743A20696D6167652E6865696768742C0A20202020202020206D617267696E4C6566743A20696D6167652E6C6566742C0A20202020202020206D617267696E546F703A20696D6167652E746F702C0A202020202020202074';
wwv_flow_api.g_varchar2_table(285) := '72616E73666F726D3A206765745472616E73666F726D28696D616765290A2020202020207D293B0A0A2020202020206966202869734368616E67656429207B0A2020202020202020746869732E6F757470757428293B0A2020202020207D0A202020207D';
wwv_flow_api.g_varchar2_table(286) := '2C0A0A20202020696E697443726F70426F783A2066756E6374696F6E202829207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A2020202020207661722063616E766173203D20746869732E63616E7661733B0A';
wwv_flow_api.g_varchar2_table(287) := '20202020202076617220617370656374526174696F203D206F7074696F6E732E617370656374526174696F3B0A202020202020766172206175746F43726F7041726561203D206E756D286F7074696F6E732E6175746F43726F704172656129207C7C2030';
wwv_flow_api.g_varchar2_table(288) := '2E383B0A2020202020207661722063726F70426F78203D207B0A20202020202020202020202077696474683A2063616E7661732E77696474682C0A2020202020202020202020206865696768743A2063616E7661732E6865696768740A20202020202020';
wwv_flow_api.g_varchar2_table(289) := '2020207D3B0A0A20202020202069662028617370656374526174696F29207B0A20202020202020206966202863616E7661732E686569676874202A20617370656374526174696F203E2063616E7661732E776964746829207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(290) := '63726F70426F782E686569676874203D2063726F70426F782E7769647468202F20617370656374526174696F3B0A20202020202020207D20656C7365207B0A2020202020202020202063726F70426F782E7769647468203D2063726F70426F782E686569';
wwv_flow_api.g_varchar2_table(291) := '676874202A20617370656374526174696F3B0A20202020202020207D0A2020202020207D0A0A202020202020746869732E63726F70426F78203D2063726F70426F783B0A202020202020746869732E6C696D697443726F70426F7828747275652C207472';
wwv_flow_api.g_varchar2_table(292) := '7565293B0A0A2020202020202F2F20496E697469616C697A65206175746F2063726F7020617265610A20202020202063726F70426F782E7769647468203D206D696E286D61782863726F70426F782E77696474682C2063726F70426F782E6D696E576964';
wwv_flow_api.g_varchar2_table(293) := '7468292C2063726F70426F782E6D61785769647468293B0A20202020202063726F70426F782E686569676874203D206D696E286D61782863726F70426F782E6865696768742C2063726F70426F782E6D696E486569676874292C2063726F70426F782E6D';
wwv_flow_api.g_varchar2_table(294) := '6178486569676874293B0A0A2020202020202F2F20546865207769647468206F66206175746F2063726F702061726561206D757374206C61726765207468616E20226D696E5769647468222C20616E64207468652068656967687420746F6F2E20282331';
wwv_flow_api.g_varchar2_table(295) := '3634290A20202020202063726F70426F782E7769647468203D206D61782863726F70426F782E6D696E57696474682C2063726F70426F782E7769647468202A206175746F43726F7041726561293B0A20202020202063726F70426F782E68656967687420';
wwv_flow_api.g_varchar2_table(296) := '3D206D61782863726F70426F782E6D696E4865696768742C2063726F70426F782E686569676874202A206175746F43726F7041726561293B0A20202020202063726F70426F782E6F6C644C656674203D2063726F70426F782E6C656674203D2063616E76';
wwv_flow_api.g_varchar2_table(297) := '61732E6C656674202B202863616E7661732E7769647468202D2063726F70426F782E776964746829202F20323B0A20202020202063726F70426F782E6F6C64546F70203D2063726F70426F782E746F70203D2063616E7661732E746F70202B202863616E';
wwv_flow_api.g_varchar2_table(298) := '7661732E686569676874202D2063726F70426F782E68656967687429202F20323B0A0A202020202020746869732E696E697469616C43726F70426F78203D20242E657874656E64287B7D2C2063726F70426F78293B0A202020207D2C0A0A202020206C69';
wwv_flow_api.g_varchar2_table(299) := '6D697443726F70426F783A2066756E6374696F6E2028697353697A654C696D697465642C206973506F736974696F6E4C696D6974656429207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A2020202020207661';
wwv_flow_api.g_varchar2_table(300) := '7220617370656374526174696F203D206F7074696F6E732E617370656374526174696F3B0A20202020202076617220636F6E7461696E6572203D20746869732E636F6E7461696E65723B0A20202020202076617220636F6E7461696E6572576964746820';
wwv_flow_api.g_varchar2_table(301) := '3D20636F6E7461696E65722E77696474683B0A20202020202076617220636F6E7461696E6572486569676874203D20636F6E7461696E65722E6865696768743B0A2020202020207661722063616E766173203D20746869732E63616E7661733B0A202020';
wwv_flow_api.g_varchar2_table(302) := '2020207661722063726F70426F78203D20746869732E63726F70426F783B0A2020202020207661722069734C696D69746564203D20746869732E69734C696D697465643B0A202020202020766172206D696E43726F70426F7857696474683B0A20202020';
wwv_flow_api.g_varchar2_table(303) := '2020766172206D696E43726F70426F784865696768743B0A202020202020766172206D617843726F70426F7857696474683B0A202020202020766172206D617843726F70426F784865696768743B0A0A20202020202069662028697353697A654C696D69';
wwv_flow_api.g_varchar2_table(304) := '74656429207B0A20202020202020206D696E43726F70426F785769647468203D206E756D286F7074696F6E732E6D696E43726F70426F78576964746829207C7C20303B0A20202020202020206D696E43726F70426F78486569676874203D206E756D286F';
wwv_flow_api.g_varchar2_table(305) := '7074696F6E732E6D696E43726F70426F7848656967687429207C7C20303B0A0A20202020202020202F2F20546865206D696E2F6D617843726F70426F7857696474682F486569676874206D757374206265206C657373207468616E20636F6E7461696E65';
wwv_flow_api.g_varchar2_table(306) := '7257696474682F4865696768740A20202020202020206D696E43726F70426F785769647468203D206D696E286D696E43726F70426F7857696474682C20636F6E7461696E65725769647468293B0A20202020202020206D696E43726F70426F7848656967';
wwv_flow_api.g_varchar2_table(307) := '6874203D206D696E286D696E43726F70426F784865696768742C20636F6E7461696E6572486569676874293B0A20202020202020206D617843726F70426F785769647468203D206D696E28636F6E7461696E657257696474682C2069734C696D69746564';
wwv_flow_api.g_varchar2_table(308) := '203F2063616E7661732E7769647468203A20636F6E7461696E65725769647468293B0A20202020202020206D617843726F70426F78486569676874203D206D696E28636F6E7461696E65724865696768742C2069734C696D69746564203F2063616E7661';
wwv_flow_api.g_varchar2_table(309) := '732E686569676874203A20636F6E7461696E6572486569676874293B0A0A202020202020202069662028617370656374526174696F29207B0A20202020202020202020696620286D696E43726F70426F785769647468202626206D696E43726F70426F78';
wwv_flow_api.g_varchar2_table(310) := '48656967687429207B0A202020202020202020202020696620286D696E43726F70426F78486569676874202A20617370656374526174696F203E206D696E43726F70426F78576964746829207B0A20202020202020202020202020206D696E43726F7042';
wwv_flow_api.g_varchar2_table(311) := '6F78486569676874203D206D696E43726F70426F785769647468202F20617370656374526174696F3B0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020206D696E43726F70426F785769647468203D206D696E4372';
wwv_flow_api.g_varchar2_table(312) := '6F70426F78486569676874202A20617370656374526174696F3B0A2020202020202020202020207D0A202020202020202020207D20656C736520696620286D696E43726F70426F78576964746829207B0A2020202020202020202020206D696E43726F70';
wwv_flow_api.g_varchar2_table(313) := '426F78486569676874203D206D696E43726F70426F785769647468202F20617370656374526174696F3B0A202020202020202020207D20656C736520696620286D696E43726F70426F7848656967687429207B0A2020202020202020202020206D696E43';
wwv_flow_api.g_varchar2_table(314) := '726F70426F785769647468203D206D696E43726F70426F78486569676874202A20617370656374526174696F3B0A202020202020202020207D0A0A20202020202020202020696620286D617843726F70426F78486569676874202A206173706563745261';
wwv_flow_api.g_varchar2_table(315) := '74696F203E206D617843726F70426F78576964746829207B0A2020202020202020202020206D617843726F70426F78486569676874203D206D617843726F70426F785769647468202F20617370656374526174696F3B0A202020202020202020207D2065';
wwv_flow_api.g_varchar2_table(316) := '6C7365207B0A2020202020202020202020206D617843726F70426F785769647468203D206D617843726F70426F78486569676874202A20617370656374526174696F3B0A202020202020202020207D0A20202020202020207D0A0A20202020202020202F';
wwv_flow_api.g_varchar2_table(317) := '2F20546865206D696E57696474682F486569676874206D757374206265206C657373207468616E206D617857696474682F4865696768740A202020202020202063726F70426F782E6D696E5769647468203D206D696E286D696E43726F70426F78576964';
wwv_flow_api.g_varchar2_table(318) := '74682C206D617843726F70426F785769647468293B0A202020202020202063726F70426F782E6D696E486569676874203D206D696E286D696E43726F70426F784865696768742C206D617843726F70426F78486569676874293B0A202020202020202063';
wwv_flow_api.g_varchar2_table(319) := '726F70426F782E6D61785769647468203D206D617843726F70426F7857696474683B0A202020202020202063726F70426F782E6D6178486569676874203D206D617843726F70426F784865696768743B0A2020202020207D0A0A20202020202069662028';
wwv_flow_api.g_varchar2_table(320) := '6973506F736974696F6E4C696D6974656429207B0A20202020202020206966202869734C696D6974656429207B0A2020202020202020202063726F70426F782E6D696E4C656674203D206D617828302C2063616E7661732E6C656674293B0A2020202020';
wwv_flow_api.g_varchar2_table(321) := '202020202063726F70426F782E6D696E546F70203D206D617828302C2063616E7661732E746F70293B0A2020202020202020202063726F70426F782E6D61784C656674203D206D696E28636F6E7461696E657257696474682C2063616E7661732E6C6566';
wwv_flow_api.g_varchar2_table(322) := '74202B2063616E7661732E776964746829202D2063726F70426F782E77696474683B0A2020202020202020202063726F70426F782E6D6178546F70203D206D696E28636F6E7461696E65724865696768742C2063616E7661732E746F70202B2063616E76';
wwv_flow_api.g_varchar2_table(323) := '61732E68656967687429202D2063726F70426F782E6865696768743B0A20202020202020207D20656C7365207B0A2020202020202020202063726F70426F782E6D696E4C656674203D20303B0A2020202020202020202063726F70426F782E6D696E546F';
wwv_flow_api.g_varchar2_table(324) := '70203D20303B0A2020202020202020202063726F70426F782E6D61784C656674203D20636F6E7461696E65725769647468202D2063726F70426F782E77696474683B0A2020202020202020202063726F70426F782E6D6178546F70203D20636F6E746169';
wwv_flow_api.g_varchar2_table(325) := '6E6572486569676874202D2063726F70426F782E6865696768743B0A20202020202020207D0A2020202020207D0A202020207D2C0A0A2020202072656E64657243726F70426F783A2066756E6374696F6E202829207B0A202020202020766172206F7074';
wwv_flow_api.g_varchar2_table(326) := '696F6E73203D20746869732E6F7074696F6E733B0A20202020202076617220636F6E7461696E6572203D20746869732E636F6E7461696E65723B0A20202020202076617220636F6E7461696E65725769647468203D20636F6E7461696E65722E77696474';
wwv_flow_api.g_varchar2_table(327) := '683B0A20202020202076617220636F6E7461696E6572486569676874203D20636F6E7461696E65722E6865696768743B0A2020202020207661722063726F70426F78203D20746869732E63726F70426F783B0A0A2020202020206966202863726F70426F';
wwv_flow_api.g_varchar2_table(328) := '782E7769647468203E2063726F70426F782E6D61785769647468207C7C2063726F70426F782E7769647468203C2063726F70426F782E6D696E576964746829207B0A202020202020202063726F70426F782E6C656674203D2063726F70426F782E6F6C64';
wwv_flow_api.g_varchar2_table(329) := '4C6566743B0A2020202020207D0A0A2020202020206966202863726F70426F782E686569676874203E2063726F70426F782E6D6178486569676874207C7C2063726F70426F782E686569676874203C2063726F70426F782E6D696E48656967687429207B';
wwv_flow_api.g_varchar2_table(330) := '0A202020202020202063726F70426F782E746F70203D2063726F70426F782E6F6C64546F703B0A2020202020207D0A0A20202020202063726F70426F782E7769647468203D206D696E286D61782863726F70426F782E77696474682C2063726F70426F78';
wwv_flow_api.g_varchar2_table(331) := '2E6D696E5769647468292C2063726F70426F782E6D61785769647468293B0A20202020202063726F70426F782E686569676874203D206D696E286D61782863726F70426F782E6865696768742C2063726F70426F782E6D696E486569676874292C206372';
wwv_flow_api.g_varchar2_table(332) := '6F70426F782E6D6178486569676874293B0A0A202020202020746869732E6C696D697443726F70426F782866616C73652C2074727565293B0A0A20202020202063726F70426F782E6F6C644C656674203D2063726F70426F782E6C656674203D206D696E';
wwv_flow_api.g_varchar2_table(333) := '286D61782863726F70426F782E6C6566742C2063726F70426F782E6D696E4C656674292C2063726F70426F782E6D61784C656674293B0A20202020202063726F70426F782E6F6C64546F70203D2063726F70426F782E746F70203D206D696E286D617828';
wwv_flow_api.g_varchar2_table(334) := '63726F70426F782E746F702C2063726F70426F782E6D696E546F70292C2063726F70426F782E6D6178546F70293B0A0A202020202020696620286F7074696F6E732E6D6F7661626C65202626206F7074696F6E732E63726F70426F784D6F7661626C6529';
wwv_flow_api.g_varchar2_table(335) := '207B0A0A20202020202020202F2F205475726E20746F206D6F7665207468652063616E766173207768656E207468652063726F7020626F7820697320657175616C20746F2074686520636F6E7461696E65720A2020202020202020746869732E24666163';
wwv_flow_api.g_varchar2_table(336) := '652E6461746128444154415F414354494F4E2C202863726F70426F782E7769647468203D3D3D20636F6E7461696E657257696474682026262063726F70426F782E686569676874203D3D3D20636F6E7461696E657248656967687429203F20414354494F';
wwv_flow_api.g_varchar2_table(337) := '4E5F4D4F5645203A20414354494F4E5F414C4C293B0A2020202020207D0A0A202020202020746869732E2463726F70426F782E637373287B0A202020202020202077696474683A2063726F70426F782E77696474682C0A20202020202020206865696768';
wwv_flow_api.g_varchar2_table(338) := '743A2063726F70426F782E6865696768742C0A20202020202020206C6566743A2063726F70426F782E6C6566742C0A2020202020202020746F703A2063726F70426F782E746F700A2020202020207D293B0A0A20202020202069662028746869732E6973';
wwv_flow_api.g_varchar2_table(339) := '43726F7070656420262620746869732E69734C696D6974656429207B0A2020202020202020746869732E6C696D697443616E76617328747275652C2074727565293B0A2020202020207D0A0A2020202020206966202821746869732E697344697361626C';
wwv_flow_api.g_varchar2_table(340) := '656429207B0A2020202020202020746869732E6F757470757428293B0A2020202020207D0A202020207D2C0A0A202020206F75747075743A2066756E6374696F6E202829207B0A202020202020746869732E7072657669657728293B0A0A202020202020';
wwv_flow_api.g_varchar2_table(341) := '69662028746869732E6973436F6D706C6574656429207B0A2020202020202020746869732E74726967676572284556454E545F43524F502C20746869732E676574446174612829293B0A2020202020207D20656C7365206966202821746869732E697342';
wwv_flow_api.g_varchar2_table(342) := '75696C7429207B0A0A20202020202020202F2F204F6E6C792074726967676572206F6E652063726F70206576656E74206265666F726520636F6D706C6574650A2020202020202020746869732E24656C656D656E742E6F6E65284556454E545F4255494C';
wwv_flow_api.g_varchar2_table(343) := '542C20242E70726F78792866756E6374696F6E202829207B0A20202020202020202020746869732E74726967676572284556454E545F43524F502C20746869732E676574446174612829293B0A20202020202020207D2C207468697329293B0A20202020';
wwv_flow_api.g_varchar2_table(344) := '20207D0A202020207D2C0A0A20202020696E6974507265766965773A2066756E6374696F6E202829207B0A2020202020207661722063726F73734F726967696E203D2067657443726F73734F726967696E28746869732E63726F73734F726967696E293B';
wwv_flow_api.g_varchar2_table(345) := '0A2020202020207661722075726C203D2063726F73734F726967696E203F20746869732E63726F73734F726967696E55726C203A20746869732E75726C3B0A0A202020202020746869732E2470726576696577203D202428746869732E6F7074696F6E73';
wwv_flow_api.g_varchar2_table(346) := '2E70726576696577293B0A202020202020746869732E2476696577426F782E68746D6C28273C696D6727202B2063726F73734F726967696E202B2027207372633D2227202B2075726C202B2027223E27293B0A202020202020746869732E247072657669';
wwv_flow_api.g_varchar2_table(347) := '65772E656163682866756E6374696F6E202829207B0A2020202020202020766172202474686973203D20242874686973293B0A0A20202020202020202F2F205361766520746865206F726967696E616C2073697A6520666F72207265636F7665720A2020';
wwv_flow_api.g_varchar2_table(348) := '20202020202024746869732E6461746128444154415F505245564945572C207B0A2020202020202020202077696474683A2024746869732E776964746828292C0A202020202020202020206865696768743A2024746869732E68656967687428292C0A20';
wwv_flow_api.g_varchar2_table(349) := '20202020202020202068746D6C3A2024746869732E68746D6C28290A20202020202020207D293B0A0A20202020202020202F2A2A0A2020202020202020202A204F7665727269646520696D6720656C656D656E74207374796C65730A2020202020202020';
wwv_flow_api.g_varchar2_table(350) := '202A204164642060646973706C61793A626C6F636B6020746F2061766F6964206D617267696E20746F702069737375650A2020202020202020202A20284F63637572206F6E6C79207768656E206D617267696E2D746F70203C3D202D686569676874290A';
wwv_flow_api.g_varchar2_table(351) := '2020202020202020202A2F0A202020202020202024746869732E68746D6C280A20202020202020202020273C696D6727202B2063726F73734F726967696E202B2027207372633D2227202B2075726C202B202722207374796C653D2227202B0A20202020';
wwv_flow_api.g_varchar2_table(352) := '20202020202027646973706C61793A626C6F636B3B77696474683A313030253B6865696768743A6175746F3B27202B0A20202020202020202020276D696E2D77696474683A3021696D706F7274616E743B6D696E2D6865696768743A3021696D706F7274';
wwv_flow_api.g_varchar2_table(353) := '616E743B27202B0A20202020202020202020276D61782D77696474683A6E6F6E6521696D706F7274616E743B6D61782D6865696768743A6E6F6E6521696D706F7274616E743B27202B0A2020202020202020202027696D6167652D6F7269656E74617469';
wwv_flow_api.g_varchar2_table(354) := '6F6E3A3064656721696D706F7274616E743B223E270A2020202020202020293B0A2020202020207D293B0A202020207D2C0A0A202020207265736574507265766965773A2066756E6374696F6E202829207B0A202020202020746869732E247072657669';
wwv_flow_api.g_varchar2_table(355) := '65772E656163682866756E6374696F6E202829207B0A2020202020202020766172202474686973203D20242874686973293B0A20202020202020207661722064617461203D2024746869732E6461746128444154415F50524556494557293B0A0A202020';
wwv_flow_api.g_varchar2_table(356) := '202020202024746869732E637373287B0A2020202020202020202077696474683A20646174612E77696474682C0A202020202020202020206865696768743A20646174612E6865696768740A20202020202020207D292E68746D6C28646174612E68746D';
wwv_flow_api.g_varchar2_table(357) := '6C292E72656D6F76654461746128444154415F50524556494557293B0A2020202020207D293B0A202020207D2C0A0A20202020707265766965773A2066756E6374696F6E202829207B0A20202020202076617220696D616765203D20746869732E696D61';
wwv_flow_api.g_varchar2_table(358) := '67653B0A2020202020207661722063616E766173203D20746869732E63616E7661733B0A2020202020207661722063726F70426F78203D20746869732E63726F70426F783B0A2020202020207661722063726F70426F785769647468203D2063726F7042';
wwv_flow_api.g_varchar2_table(359) := '6F782E77696474683B0A2020202020207661722063726F70426F78486569676874203D2063726F70426F782E6865696768743B0A202020202020766172207769647468203D20696D6167652E77696474683B0A2020202020207661722068656967687420';
wwv_flow_api.g_varchar2_table(360) := '3D20696D6167652E6865696768743B0A202020202020766172206C656674203D2063726F70426F782E6C656674202D2063616E7661732E6C656674202D20696D6167652E6C6566743B0A20202020202076617220746F70203D2063726F70426F782E746F';
wwv_flow_api.g_varchar2_table(361) := '70202D2063616E7661732E746F70202D20696D6167652E746F703B0A0A2020202020206966202821746869732E697343726F70706564207C7C20746869732E697344697361626C656429207B0A202020202020202072657475726E3B0A2020202020207D';
wwv_flow_api.g_varchar2_table(362) := '0A0A202020202020746869732E2476696577426F782E66696E642827696D6727292E637373287B0A202020202020202077696474683A2077696474682C0A20202020202020206865696768743A206865696768742C0A20202020202020206D617267696E';
wwv_flow_api.g_varchar2_table(363) := '4C6566743A202D6C6566742C0A20202020202020206D617267696E546F703A202D746F702C0A20202020202020207472616E73666F726D3A206765745472616E73666F726D28696D616765290A2020202020207D293B0A0A202020202020746869732E24';
wwv_flow_api.g_varchar2_table(364) := '707265766965772E656163682866756E6374696F6E202829207B0A2020202020202020766172202474686973203D20242874686973293B0A20202020202020207661722064617461203D2024746869732E6461746128444154415F50524556494557293B';
wwv_flow_api.g_varchar2_table(365) := '0A2020202020202020766172206F726967696E616C5769647468203D20646174612E77696474683B0A2020202020202020766172206F726967696E616C486569676874203D20646174612E6865696768743B0A2020202020202020766172206E65775769';
wwv_flow_api.g_varchar2_table(366) := '647468203D206F726967696E616C57696474683B0A2020202020202020766172206E6577486569676874203D206F726967696E616C4865696768743B0A202020202020202076617220726174696F203D20313B0A0A20202020202020206966202863726F';
wwv_flow_api.g_varchar2_table(367) := '70426F78576964746829207B0A20202020202020202020726174696F203D206F726967696E616C5769647468202F2063726F70426F7857696474683B0A202020202020202020206E6577486569676874203D2063726F70426F78486569676874202A2072';
wwv_flow_api.g_varchar2_table(368) := '6174696F3B0A20202020202020207D0A0A20202020202020206966202863726F70426F78486569676874202626206E6577486569676874203E206F726967696E616C48656967687429207B0A20202020202020202020726174696F203D206F726967696E';
wwv_flow_api.g_varchar2_table(369) := '616C486569676874202F2063726F70426F784865696768743B0A202020202020202020206E65775769647468203D2063726F70426F785769647468202A20726174696F3B0A202020202020202020206E6577486569676874203D206F726967696E616C48';
wwv_flow_api.g_varchar2_table(370) := '65696768743B0A20202020202020207D0A0A202020202020202024746869732E637373287B0A2020202020202020202077696474683A206E657757696474682C0A202020202020202020206865696768743A206E65774865696768740A20202020202020';
wwv_flow_api.g_varchar2_table(371) := '207D292E66696E642827696D6727292E637373287B0A2020202020202020202077696474683A207769647468202A20726174696F2C0A202020202020202020206865696768743A20686569676874202A20726174696F2C0A202020202020202020206D61';
wwv_flow_api.g_varchar2_table(372) := '7267696E4C6566743A202D6C656674202A20726174696F2C0A202020202020202020206D617267696E546F703A202D746F70202A20726174696F2C0A202020202020202020207472616E73666F726D3A206765745472616E73666F726D28696D61676529';
wwv_flow_api.g_varchar2_table(373) := '0A20202020202020207D293B0A2020202020207D293B0A202020207D2C0A0A2020202062696E643A2066756E6374696F6E202829207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A2020202020207661722024';
wwv_flow_api.g_varchar2_table(374) := '74686973203D20746869732E24656C656D656E743B0A202020202020766172202463726F70706572203D20746869732E2463726F707065723B0A0A20202020202069662028242E697346756E6374696F6E286F7074696F6E732E63726F70737461727429';
wwv_flow_api.g_varchar2_table(375) := '29207B0A202020202020202024746869732E6F6E284556454E545F43524F505F53544152542C206F7074696F6E732E63726F707374617274293B0A2020202020207D0A0A20202020202069662028242E697346756E6374696F6E286F7074696F6E732E63';
wwv_flow_api.g_varchar2_table(376) := '726F706D6F76652929207B0A202020202020202024746869732E6F6E284556454E545F43524F505F4D4F56452C206F7074696F6E732E63726F706D6F7665293B0A2020202020207D0A0A20202020202069662028242E697346756E6374696F6E286F7074';
wwv_flow_api.g_varchar2_table(377) := '696F6E732E63726F70656E642929207B0A202020202020202024746869732E6F6E284556454E545F43524F505F454E442C206F7074696F6E732E63726F70656E64293B0A2020202020207D0A0A20202020202069662028242E697346756E6374696F6E28';
wwv_flow_api.g_varchar2_table(378) := '6F7074696F6E732E63726F702929207B0A202020202020202024746869732E6F6E284556454E545F43524F502C206F7074696F6E732E63726F70293B0A2020202020207D0A0A20202020202069662028242E697346756E6374696F6E286F7074696F6E73';
wwv_flow_api.g_varchar2_table(379) := '2E7A6F6F6D2929207B0A202020202020202024746869732E6F6E284556454E545F5A4F4F4D2C206F7074696F6E732E7A6F6F6D293B0A2020202020207D0A0A2020202020202463726F707065722E6F6E284556454E545F4D4F5553455F444F574E2C2024';
wwv_flow_api.g_varchar2_table(380) := '2E70726F787928746869732E63726F7053746172742C207468697329293B0A0A202020202020696620286F7074696F6E732E7A6F6F6D61626C65202626206F7074696F6E732E7A6F6F6D4F6E576865656C29207B0A20202020202020202463726F707065';
wwv_flow_api.g_varchar2_table(381) := '722E6F6E284556454E545F574845454C2C20242E70726F787928746869732E776865656C2C207468697329293B0A2020202020207D0A0A202020202020696620286F7074696F6E732E746F67676C65447261674D6F64654F6E44626C636C69636B29207B';
wwv_flow_api.g_varchar2_table(382) := '0A20202020202020202463726F707065722E6F6E284556454E545F44424C434C49434B2C20242E70726F787928746869732E64626C636C69636B2C207468697329293B0A2020202020207D0A0A20202020202024646F63756D656E742E0A202020202020';
wwv_flow_api.g_varchar2_table(383) := '20206F6E284556454E545F4D4F5553455F4D4F56452C2028746869732E5F63726F704D6F7665203D2070726F787928746869732E63726F704D6F76652C20746869732929292E0A20202020202020206F6E284556454E545F4D4F5553455F55502C202874';
wwv_flow_api.g_varchar2_table(384) := '6869732E5F63726F70456E64203D2070726F787928746869732E63726F70456E642C20746869732929293B0A0A202020202020696620286F7074696F6E732E726573706F6E7369766529207B0A20202020202020202477696E646F772E6F6E284556454E';
wwv_flow_api.g_varchar2_table(385) := '545F524553495A452C2028746869732E5F726573697A65203D2070726F787928746869732E726573697A652C20746869732929293B0A2020202020207D0A202020207D2C0A0A20202020756E62696E643A2066756E6374696F6E202829207B0A20202020';
wwv_flow_api.g_varchar2_table(386) := '2020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A202020202020766172202474686973203D20746869732E24656C656D656E743B0A202020202020766172202463726F70706572203D20746869732E2463726F707065723B0A0A';
wwv_flow_api.g_varchar2_table(387) := '20202020202069662028242E697346756E6374696F6E286F7074696F6E732E63726F7073746172742929207B0A202020202020202024746869732E6F6666284556454E545F43524F505F53544152542C206F7074696F6E732E63726F707374617274293B';
wwv_flow_api.g_varchar2_table(388) := '0A2020202020207D0A0A20202020202069662028242E697346756E6374696F6E286F7074696F6E732E63726F706D6F76652929207B0A202020202020202024746869732E6F6666284556454E545F43524F505F4D4F56452C206F7074696F6E732E63726F';
wwv_flow_api.g_varchar2_table(389) := '706D6F7665293B0A2020202020207D0A0A20202020202069662028242E697346756E6374696F6E286F7074696F6E732E63726F70656E642929207B0A202020202020202024746869732E6F6666284556454E545F43524F505F454E442C206F7074696F6E';
wwv_flow_api.g_varchar2_table(390) := '732E63726F70656E64293B0A2020202020207D0A0A20202020202069662028242E697346756E6374696F6E286F7074696F6E732E63726F702929207B0A202020202020202024746869732E6F6666284556454E545F43524F502C206F7074696F6E732E63';
wwv_flow_api.g_varchar2_table(391) := '726F70293B0A2020202020207D0A0A20202020202069662028242E697346756E6374696F6E286F7074696F6E732E7A6F6F6D2929207B0A202020202020202024746869732E6F6666284556454E545F5A4F4F4D2C206F7074696F6E732E7A6F6F6D293B0A';
wwv_flow_api.g_varchar2_table(392) := '2020202020207D0A0A2020202020202463726F707065722E6F6666284556454E545F4D4F5553455F444F574E2C20746869732E63726F705374617274293B0A0A202020202020696620286F7074696F6E732E7A6F6F6D61626C65202626206F7074696F6E';
wwv_flow_api.g_varchar2_table(393) := '732E7A6F6F6D4F6E576865656C29207B0A20202020202020202463726F707065722E6F6666284556454E545F574845454C2C20746869732E776865656C293B0A2020202020207D0A0A202020202020696620286F7074696F6E732E746F67676C65447261';
wwv_flow_api.g_varchar2_table(394) := '674D6F64654F6E44626C636C69636B29207B0A20202020202020202463726F707065722E6F6666284556454E545F44424C434C49434B2C20746869732E64626C636C69636B293B0A2020202020207D0A0A20202020202024646F63756D656E742E0A2020';
wwv_flow_api.g_varchar2_table(395) := '2020202020206F6666284556454E545F4D4F5553455F4D4F56452C20746869732E5F63726F704D6F7665292E0A20202020202020206F6666284556454E545F4D4F5553455F55502C20746869732E5F63726F70456E64293B0A0A20202020202069662028';
wwv_flow_api.g_varchar2_table(396) := '6F7074696F6E732E726573706F6E7369766529207B0A20202020202020202477696E646F772E6F6666284556454E545F524553495A452C20746869732E5F726573697A65293B0A2020202020207D0A202020207D2C0A0A20202020726573697A653A2066';
wwv_flow_api.g_varchar2_table(397) := '756E6374696F6E202829207B0A20202020202076617220726573746F7265203D20746869732E6F7074696F6E732E726573746F72653B0A2020202020207661722024636F6E7461696E6572203D20746869732E24636F6E7461696E65723B0A2020202020';
wwv_flow_api.g_varchar2_table(398) := '2076617220636F6E7461696E6572203D20746869732E636F6E7461696E65723B0A2020202020207661722063616E766173446174613B0A2020202020207661722063726F70426F78446174613B0A20202020202076617220726174696F3B0A0A20202020';
wwv_flow_api.g_varchar2_table(399) := '20202F2F20436865636B2060636F6E7461696E657260206973206E656365737361727920666F72204945380A20202020202069662028746869732E697344697361626C6564207C7C2021636F6E7461696E657229207B0A20202020202020207265747572';
wwv_flow_api.g_varchar2_table(400) := '6E3B0A2020202020207D0A0A202020202020726174696F203D2024636F6E7461696E65722E77696474682829202F20636F6E7461696E65722E77696474683B0A0A2020202020202F2F20526573697A65207768656E207769647468206368616E67656420';
wwv_flow_api.g_varchar2_table(401) := '6F7220686569676874206368616E6765640A20202020202069662028726174696F20213D3D2031207C7C2024636F6E7461696E65722E686569676874282920213D3D20636F6E7461696E65722E68656967687429207B0A20202020202020206966202872';
wwv_flow_api.g_varchar2_table(402) := '6573746F726529207B0A2020202020202020202063616E76617344617461203D20746869732E67657443616E7661734461746128293B0A2020202020202020202063726F70426F7844617461203D20746869732E67657443726F70426F78446174612829';
wwv_flow_api.g_varchar2_table(403) := '3B0A20202020202020207D0A0A2020202020202020746869732E72656E64657228293B0A0A202020202020202069662028726573746F726529207B0A20202020202020202020746869732E73657443616E7661734461746128242E656163682863616E76';
wwv_flow_api.g_varchar2_table(404) := '6173446174612C2066756E6374696F6E2028692C206E29207B0A20202020202020202020202063616E766173446174615B695D203D206E202A20726174696F3B0A202020202020202020207D29293B0A20202020202020202020746869732E7365744372';
wwv_flow_api.g_varchar2_table(405) := '6F70426F784461746128242E656163682863726F70426F78446174612C2066756E6374696F6E2028692C206E29207B0A20202020202020202020202063726F70426F78446174615B695D203D206E202A20726174696F3B0A202020202020202020207D29';
wwv_flow_api.g_varchar2_table(406) := '293B0A20202020202020207D0A2020202020207D0A202020207D2C0A0A2020202064626C636C69636B3A2066756E6374696F6E202829207B0A20202020202069662028746869732E697344697361626C656429207B0A202020202020202072657475726E';
wwv_flow_api.g_varchar2_table(407) := '3B0A2020202020207D0A0A20202020202069662028746869732E2464726167426F782E686173436C61737328434C4153535F43524F502929207B0A2020202020202020746869732E736574447261674D6F646528414354494F4E5F4D4F5645293B0A2020';
wwv_flow_api.g_varchar2_table(408) := '202020207D20656C7365207B0A2020202020202020746869732E736574447261674D6F646528414354494F4E5F43524F50293B0A2020202020207D0A202020207D2C0A0A20202020776865656C3A2066756E6374696F6E20286576656E7429207B0A2020';
wwv_flow_api.g_varchar2_table(409) := '202020207661722065203D206576656E742E6F726967696E616C4576656E74207C7C206576656E743B0A20202020202076617220726174696F203D206E756D28746869732E6F7074696F6E732E776865656C5A6F6F6D526174696F29207C7C20302E313B';
wwv_flow_api.g_varchar2_table(410) := '0A2020202020207661722064656C7461203D20313B0A0A20202020202069662028746869732E697344697361626C656429207B0A202020202020202072657475726E3B0A2020202020207D0A0A2020202020206576656E742E70726576656E7444656661';
wwv_flow_api.g_varchar2_table(411) := '756C7428293B0A0A2020202020202F2F204C696D697420776865656C20737065656420746F2070726576656E74207A6F6F6D20746F6F20666173740A20202020202069662028746869732E776865656C696E6729207B0A20202020202020207265747572';
wwv_flow_api.g_varchar2_table(412) := '6E3B0A2020202020207D0A0A202020202020746869732E776865656C696E67203D20747275653B0A0A20202020202073657454696D656F757428242E70726F78792866756E6374696F6E202829207B0A2020202020202020746869732E776865656C696E';
wwv_flow_api.g_varchar2_table(413) := '67203D2066616C73653B0A2020202020207D2C2074686973292C203530293B0A0A20202020202069662028652E64656C74615929207B0A202020202020202064656C7461203D20652E64656C746159203E2030203F2031203A202D313B0A202020202020';
wwv_flow_api.g_varchar2_table(414) := '7D20656C73652069662028652E776865656C44656C746129207B0A202020202020202064656C7461203D202D652E776865656C44656C7461202F203132303B0A2020202020207D20656C73652069662028652E64657461696C29207B0A20202020202020';
wwv_flow_api.g_varchar2_table(415) := '2064656C7461203D20652E64657461696C203E2030203F2031203A202D313B0A2020202020207D0A0A202020202020746869732E7A6F6F6D282D64656C7461202A20726174696F2C206576656E74293B0A202020207D2C0A0A2020202063726F70537461';
wwv_flow_api.g_varchar2_table(416) := '72743A2066756E6374696F6E20286576656E7429207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A202020202020766172206F726967696E616C4576656E74203D206576656E742E6F726967696E616C457665';
wwv_flow_api.g_varchar2_table(417) := '6E743B0A20202020202076617220746F7563686573203D206F726967696E616C4576656E74202626206F726967696E616C4576656E742E746F75636865733B0A2020202020207661722065203D206576656E743B0A20202020202076617220746F756368';
wwv_flow_api.g_varchar2_table(418) := '65734C656E6774683B0A20202020202076617220616374696F6E3B0A0A20202020202069662028746869732E697344697361626C656429207B0A202020202020202072657475726E3B0A2020202020207D0A0A20202020202069662028746F7563686573';
wwv_flow_api.g_varchar2_table(419) := '29207B0A2020202020202020746F75636865734C656E677468203D20746F75636865732E6C656E6774683B0A0A202020202020202069662028746F75636865734C656E677468203E203129207B0A20202020202020202020696620286F7074696F6E732E';
wwv_flow_api.g_varchar2_table(420) := '7A6F6F6D61626C65202626206F7074696F6E732E7A6F6F6D4F6E546F75636820262620746F75636865734C656E677468203D3D3D203229207B0A20202020202020202020202065203D20746F75636865735B315D3B0A2020202020202020202020207468';
wwv_flow_api.g_varchar2_table(421) := '69732E73746172745832203D20652E70616765583B0A202020202020202020202020746869732E73746172745932203D20652E70616765593B0A202020202020202020202020616374696F6E203D20414354494F4E5F5A4F4F4D3B0A2020202020202020';
wwv_flow_api.g_varchar2_table(422) := '20207D20656C7365207B0A20202020202020202020202072657475726E3B0A202020202020202020207D0A20202020202020207D0A0A202020202020202065203D20746F75636865735B305D3B0A2020202020207D0A0A202020202020616374696F6E20';
wwv_flow_api.g_varchar2_table(423) := '3D20616374696F6E207C7C202428652E746172676574292E6461746128444154415F414354494F4E293B0A0A202020202020696620285245474558505F414354494F4E532E7465737428616374696F6E2929207B0A202020202020202069662028746869';
wwv_flow_api.g_varchar2_table(424) := '732E74726967676572284556454E545F43524F505F53544152542C207B0A202020202020202020206F726967696E616C4576656E743A206F726967696E616C4576656E742C0A20202020202020202020616374696F6E3A20616374696F6E0A2020202020';
wwv_flow_api.g_varchar2_table(425) := '2020207D292E697344656661756C7450726576656E746564282929207B0A2020202020202020202072657475726E3B0A20202020202020207D0A0A20202020202020206576656E742E70726576656E7444656661756C7428293B0A0A2020202020202020';
wwv_flow_api.g_varchar2_table(426) := '746869732E616374696F6E203D20616374696F6E3B0A2020202020202020746869732E63726F7070696E67203D2066616C73653B0A0A20202020202020202F2F20494538202068617320606576656E742E70616765582F59602C20627574206E6F742060';
wwv_flow_api.g_varchar2_table(427) := '6576656E742E6F726967696E616C4576656E742E70616765582F59600A20202020202020202F2F20494531302068617320606576656E742E6F726967696E616C4576656E742E70616765582F59602C20627574206E6F7420606576656E742E7061676558';
wwv_flow_api.g_varchar2_table(428) := '2F59600A2020202020202020746869732E737461727458203D20652E7061676558207C7C206F726967696E616C4576656E74202626206F726967696E616C4576656E742E70616765583B0A2020202020202020746869732E737461727459203D20652E70';
wwv_flow_api.g_varchar2_table(429) := '61676559207C7C206F726967696E616C4576656E74202626206F726967696E616C4576656E742E70616765593B0A0A202020202020202069662028616374696F6E203D3D3D20414354494F4E5F43524F5029207B0A20202020202020202020746869732E';
wwv_flow_api.g_varchar2_table(430) := '63726F7070696E67203D20747275653B0A20202020202020202020746869732E2464726167426F782E616464436C61737328434C4153535F4D4F44414C293B0A20202020202020207D0A2020202020207D0A202020207D2C0A0A2020202063726F704D6F';
wwv_flow_api.g_varchar2_table(431) := '76653A2066756E6374696F6E20286576656E7429207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A202020202020766172206F726967696E616C4576656E74203D206576656E742E6F726967696E616C457665';
wwv_flow_api.g_varchar2_table(432) := '6E743B0A20202020202076617220746F7563686573203D206F726967696E616C4576656E74202626206F726967696E616C4576656E742E746F75636865733B0A2020202020207661722065203D206576656E743B0A20202020202076617220616374696F';
wwv_flow_api.g_varchar2_table(433) := '6E203D20746869732E616374696F6E3B0A20202020202076617220746F75636865734C656E6774683B0A0A20202020202069662028746869732E697344697361626C656429207B0A202020202020202072657475726E3B0A2020202020207D0A0A202020';
wwv_flow_api.g_varchar2_table(434) := '20202069662028746F756368657329207B0A2020202020202020746F75636865734C656E677468203D20746F75636865732E6C656E6774683B0A0A202020202020202069662028746F75636865734C656E677468203E203129207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(435) := '2020696620286F7074696F6E732E7A6F6F6D61626C65202626206F7074696F6E732E7A6F6F6D4F6E546F75636820262620746F75636865734C656E677468203D3D3D203229207B0A20202020202020202020202065203D20746F75636865735B315D3B0A';
wwv_flow_api.g_varchar2_table(436) := '202020202020202020202020746869732E656E645832203D20652E70616765583B0A202020202020202020202020746869732E656E645932203D20652E70616765593B0A202020202020202020207D20656C7365207B0A20202020202020202020202072';
wwv_flow_api.g_varchar2_table(437) := '657475726E3B0A202020202020202020207D0A20202020202020207D0A0A202020202020202065203D20746F75636865735B305D3B0A2020202020207D0A0A20202020202069662028616374696F6E29207B0A202020202020202069662028746869732E';
wwv_flow_api.g_varchar2_table(438) := '74726967676572284556454E545F43524F505F4D4F56452C207B0A202020202020202020206F726967696E616C4576656E743A206F726967696E616C4576656E742C0A20202020202020202020616374696F6E3A20616374696F6E0A2020202020202020';
wwv_flow_api.g_varchar2_table(439) := '7D292E697344656661756C7450726576656E746564282929207B0A2020202020202020202072657475726E3B0A20202020202020207D0A0A20202020202020206576656E742E70726576656E7444656661756C7428293B0A0A2020202020202020746869';
wwv_flow_api.g_varchar2_table(440) := '732E656E6458203D20652E7061676558207C7C206F726967696E616C4576656E74202626206F726967696E616C4576656E742E70616765583B0A2020202020202020746869732E656E6459203D20652E7061676559207C7C206F726967696E616C457665';
wwv_flow_api.g_varchar2_table(441) := '6E74202626206F726967696E616C4576656E742E70616765593B0A0A2020202020202020746869732E6368616E676528652E73686966744B65792C20616374696F6E203D3D3D20414354494F4E5F5A4F4F4D203F206576656E74203A206E756C6C293B0A';
wwv_flow_api.g_varchar2_table(442) := '2020202020207D0A202020207D2C0A0A2020202063726F70456E643A2066756E6374696F6E20286576656E7429207B0A202020202020766172206F726967696E616C4576656E74203D206576656E742E6F726967696E616C4576656E743B0A2020202020';
wwv_flow_api.g_varchar2_table(443) := '2076617220616374696F6E203D20746869732E616374696F6E3B0A0A20202020202069662028746869732E697344697361626C656429207B0A202020202020202072657475726E3B0A2020202020207D0A0A20202020202069662028616374696F6E2920';
wwv_flow_api.g_varchar2_table(444) := '7B0A20202020202020206576656E742E70726576656E7444656661756C7428293B0A0A202020202020202069662028746869732E63726F7070696E6729207B0A20202020202020202020746869732E63726F7070696E67203D2066616C73653B0A202020';
wwv_flow_api.g_varchar2_table(445) := '20202020202020746869732E2464726167426F782E746F67676C65436C61737328434C4153535F4D4F44414C2C20746869732E697343726F7070656420262620746869732E6F7074696F6E732E6D6F64616C293B0A20202020202020207D0A0A20202020';
wwv_flow_api.g_varchar2_table(446) := '20202020746869732E616374696F6E203D2027273B0A0A2020202020202020746869732E74726967676572284556454E545F43524F505F454E442C207B0A202020202020202020206F726967696E616C4576656E743A206F726967696E616C4576656E74';
wwv_flow_api.g_varchar2_table(447) := '2C0A20202020202020202020616374696F6E3A20616374696F6E0A20202020202020207D293B0A2020202020207D0A202020207D2C0A0A202020206368616E67653A2066756E6374696F6E202873686966744B65792C206576656E7429207B0A20202020';
wwv_flow_api.g_varchar2_table(448) := '2020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A20202020202076617220617370656374526174696F203D206F7074696F6E732E617370656374526174696F3B0A20202020202076617220616374696F6E203D20746869732E61';
wwv_flow_api.g_varchar2_table(449) := '6374696F6E3B0A20202020202076617220636F6E7461696E6572203D20746869732E636F6E7461696E65723B0A2020202020207661722063616E766173203D20746869732E63616E7661733B0A2020202020207661722063726F70426F78203D20746869';
wwv_flow_api.g_varchar2_table(450) := '732E63726F70426F783B0A202020202020766172207769647468203D2063726F70426F782E77696474683B0A20202020202076617220686569676874203D2063726F70426F782E6865696768743B0A202020202020766172206C656674203D2063726F70';
wwv_flow_api.g_varchar2_table(451) := '426F782E6C6566743B0A20202020202076617220746F70203D2063726F70426F782E746F703B0A202020202020766172207269676874203D206C656674202B2077696474683B0A20202020202076617220626F74746F6D203D20746F70202B2068656967';
wwv_flow_api.g_varchar2_table(452) := '68743B0A202020202020766172206D696E4C656674203D20303B0A202020202020766172206D696E546F70203D20303B0A202020202020766172206D61785769647468203D20636F6E7461696E65722E77696474683B0A202020202020766172206D6178';
wwv_flow_api.g_varchar2_table(453) := '486569676874203D20636F6E7461696E65722E6865696768743B0A2020202020207661722072656E64657261626C65203D20747275653B0A202020202020766172206F66667365743B0A2020202020207661722072616E67653B0A0A2020202020202F2F';
wwv_flow_api.g_varchar2_table(454) := '204C6F636B696E672061737065637420726174696F20696E202266726565206D6F64652220627920686F6C64696E67207368696674206B6579202823323539290A2020202020206966202821617370656374526174696F2026262073686966744B657929';
wwv_flow_api.g_varchar2_table(455) := '207B0A2020202020202020617370656374526174696F203D20776964746820262620686569676874203F207769647468202F20686569676874203A20313B0A2020202020207D0A0A20202020202069662028746869732E6C696D6974656429207B0A2020';
wwv_flow_api.g_varchar2_table(456) := '2020202020206D696E4C656674203D2063726F70426F782E6D696E4C6566743B0A20202020202020206D696E546F70203D2063726F70426F782E6D696E546F703B0A20202020202020206D61785769647468203D206D696E4C656674202B206D696E2863';
wwv_flow_api.g_varchar2_table(457) := '6F6E7461696E65722E77696474682C2063616E7661732E7769647468293B0A20202020202020206D6178486569676874203D206D696E546F70202B206D696E28636F6E7461696E65722E6865696768742C2063616E7661732E686569676874293B0A2020';
wwv_flow_api.g_varchar2_table(458) := '202020207D0A0A20202020202072616E6765203D207B0A2020202020202020783A20746869732E656E6458202D20746869732E7374617274582C0A2020202020202020793A20746869732E656E6459202D20746869732E7374617274590A202020202020';
wwv_flow_api.g_varchar2_table(459) := '7D3B0A0A20202020202069662028617370656374526174696F29207B0A202020202020202072616E67652E58203D2072616E67652E79202A20617370656374526174696F3B0A202020202020202072616E67652E59203D2072616E67652E78202F206173';
wwv_flow_api.g_varchar2_table(460) := '70656374526174696F3B0A2020202020207D0A0A2020202020207377697463682028616374696F6E29207B0A20202020202020202F2F204D6F76652063726F7020626F780A20202020202020206361736520414354494F4E5F414C4C3A0A202020202020';
wwv_flow_api.g_varchar2_table(461) := '202020206C656674202B3D2072616E67652E783B0A20202020202020202020746F70202B3D2072616E67652E793B0A20202020202020202020627265616B3B0A0A20202020202020202F2F20526573697A652063726F7020626F780A2020202020202020';
wwv_flow_api.g_varchar2_table(462) := '6361736520414354494F4E5F454153543A0A202020202020202020206966202872616E67652E78203E3D203020262620287269676874203E3D206D61785769647468207C7C20617370656374526174696F2026260A20202020202020202020202028746F';
wwv_flow_api.g_varchar2_table(463) := '70203C3D206D696E546F70207C7C20626F74746F6D203E3D206D6178486569676874292929207B0A0A20202020202020202020202072656E64657261626C65203D2066616C73653B0A202020202020202020202020627265616B3B0A2020202020202020';
wwv_flow_api.g_varchar2_table(464) := '20207D0A0A202020202020202020207769647468202B3D2072616E67652E783B0A0A2020202020202020202069662028617370656374526174696F29207B0A202020202020202020202020686569676874203D207769647468202F206173706563745261';
wwv_flow_api.g_varchar2_table(465) := '74696F3B0A202020202020202020202020746F70202D3D2072616E67652E59202F20323B0A202020202020202020207D0A0A20202020202020202020696620287769647468203C203029207B0A202020202020202020202020616374696F6E203D204143';
wwv_flow_api.g_varchar2_table(466) := '54494F4E5F574553543B0A2020202020202020202020207769647468203D20303B0A202020202020202020207D0A0A20202020202020202020627265616B3B0A0A20202020202020206361736520414354494F4E5F4E4F5254483A0A2020202020202020';
wwv_flow_api.g_varchar2_table(467) := '20206966202872616E67652E79203C3D20302026262028746F70203C3D206D696E546F70207C7C20617370656374526174696F2026260A202020202020202020202020286C656674203C3D206D696E4C656674207C7C207269676874203E3D206D617857';
wwv_flow_api.g_varchar2_table(468) := '69647468292929207B0A0A20202020202020202020202072656E64657261626C65203D2066616C73653B0A202020202020202020202020627265616B3B0A202020202020202020207D0A0A20202020202020202020686569676874202D3D2072616E6765';
wwv_flow_api.g_varchar2_table(469) := '2E793B0A20202020202020202020746F70202B3D2072616E67652E793B0A0A2020202020202020202069662028617370656374526174696F29207B0A2020202020202020202020207769647468203D20686569676874202A20617370656374526174696F';
wwv_flow_api.g_varchar2_table(470) := '3B0A2020202020202020202020206C656674202B3D2072616E67652E58202F20323B0A202020202020202020207D0A0A2020202020202020202069662028686569676874203C203029207B0A202020202020202020202020616374696F6E203D20414354';
wwv_flow_api.g_varchar2_table(471) := '494F4E5F534F5554483B0A202020202020202020202020686569676874203D20303B0A202020202020202020207D0A0A20202020202020202020627265616B3B0A0A20202020202020206361736520414354494F4E5F574553543A0A2020202020202020';
wwv_flow_api.g_varchar2_table(472) := '20206966202872616E67652E78203C3D203020262620286C656674203C3D206D696E4C656674207C7C20617370656374526174696F2026260A20202020202020202020202028746F70203C3D206D696E546F70207C7C20626F74746F6D203E3D206D6178';
wwv_flow_api.g_varchar2_table(473) := '486569676874292929207B0A0A20202020202020202020202072656E64657261626C65203D2066616C73653B0A202020202020202020202020627265616B3B0A202020202020202020207D0A0A202020202020202020207769647468202D3D2072616E67';
wwv_flow_api.g_varchar2_table(474) := '652E783B0A202020202020202020206C656674202B3D2072616E67652E783B0A0A2020202020202020202069662028617370656374526174696F29207B0A202020202020202020202020686569676874203D207769647468202F20617370656374526174';
wwv_flow_api.g_varchar2_table(475) := '696F3B0A202020202020202020202020746F70202B3D2072616E67652E59202F20323B0A202020202020202020207D0A0A20202020202020202020696620287769647468203C203029207B0A202020202020202020202020616374696F6E203D20414354';
wwv_flow_api.g_varchar2_table(476) := '494F4E5F454153543B0A2020202020202020202020207769647468203D20303B0A202020202020202020207D0A0A20202020202020202020627265616B3B0A0A20202020202020206361736520414354494F4E5F534F5554483A0A202020202020202020';
wwv_flow_api.g_varchar2_table(477) := '206966202872616E67652E79203E3D20302026262028626F74746F6D203E3D206D6178486569676874207C7C20617370656374526174696F2026260A202020202020202020202020286C656674203C3D206D696E4C656674207C7C207269676874203E3D';
wwv_flow_api.g_varchar2_table(478) := '206D61785769647468292929207B0A0A20202020202020202020202072656E64657261626C65203D2066616C73653B0A202020202020202020202020627265616B3B0A202020202020202020207D0A0A20202020202020202020686569676874202B3D20';
wwv_flow_api.g_varchar2_table(479) := '72616E67652E793B0A0A2020202020202020202069662028617370656374526174696F29207B0A2020202020202020202020207769647468203D20686569676874202A20617370656374526174696F3B0A2020202020202020202020206C656674202D3D';
wwv_flow_api.g_varchar2_table(480) := '2072616E67652E58202F20323B0A202020202020202020207D0A0A2020202020202020202069662028686569676874203C203029207B0A202020202020202020202020616374696F6E203D20414354494F4E5F4E4F5254483B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(481) := '2020686569676874203D20303B0A202020202020202020207D0A0A20202020202020202020627265616B3B0A0A20202020202020206361736520414354494F4E5F4E4F5254485F454153543A0A2020202020202020202069662028617370656374526174';
wwv_flow_api.g_varchar2_table(482) := '696F29207B0A2020202020202020202020206966202872616E67652E79203C3D20302026262028746F70203C3D206D696E546F70207C7C207269676874203E3D206D617857696474682929207B0A202020202020202020202020202072656E6465726162';
wwv_flow_api.g_varchar2_table(483) := '6C65203D2066616C73653B0A2020202020202020202020202020627265616B3B0A2020202020202020202020207D0A0A202020202020202020202020686569676874202D3D2072616E67652E793B0A202020202020202020202020746F70202B3D207261';
wwv_flow_api.g_varchar2_table(484) := '6E67652E793B0A2020202020202020202020207769647468203D20686569676874202A20617370656374526174696F3B0A202020202020202020207D20656C7365207B0A2020202020202020202020206966202872616E67652E78203E3D203029207B0A';
wwv_flow_api.g_varchar2_table(485) := '2020202020202020202020202020696620287269676874203C206D6178576964746829207B0A202020202020202020202020202020207769647468202B3D2072616E67652E783B0A20202020202020202020202020207D20656C7365206966202872616E';
wwv_flow_api.g_varchar2_table(486) := '67652E79203C3D203020262620746F70203C3D206D696E546F7029207B0A2020202020202020202020202020202072656E64657261626C65203D2066616C73653B0A20202020202020202020202020207D0A2020202020202020202020207D20656C7365';
wwv_flow_api.g_varchar2_table(487) := '207B0A20202020202020202020202020207769647468202B3D2072616E67652E783B0A2020202020202020202020207D0A0A2020202020202020202020206966202872616E67652E79203C3D203029207B0A202020202020202020202020202069662028';
wwv_flow_api.g_varchar2_table(488) := '746F70203E206D696E546F7029207B0A20202020202020202020202020202020686569676874202D3D2072616E67652E793B0A20202020202020202020202020202020746F70202B3D2072616E67652E793B0A20202020202020202020202020207D0A20';
wwv_flow_api.g_varchar2_table(489) := '20202020202020202020207D20656C7365207B0A2020202020202020202020202020686569676874202D3D2072616E67652E793B0A2020202020202020202020202020746F70202B3D2072616E67652E793B0A2020202020202020202020207D0A202020';
wwv_flow_api.g_varchar2_table(490) := '202020202020207D0A0A20202020202020202020696620287769647468203C203020262620686569676874203C203029207B0A202020202020202020202020616374696F6E203D20414354494F4E5F534F5554485F574553543B0A202020202020202020';
wwv_flow_api.g_varchar2_table(491) := '202020686569676874203D20303B0A2020202020202020202020207769647468203D20303B0A202020202020202020207D20656C736520696620287769647468203C203029207B0A202020202020202020202020616374696F6E203D20414354494F4E5F';
wwv_flow_api.g_varchar2_table(492) := '4E4F5254485F574553543B0A2020202020202020202020207769647468203D20303B0A202020202020202020207D20656C73652069662028686569676874203C203029207B0A202020202020202020202020616374696F6E203D20414354494F4E5F534F';
wwv_flow_api.g_varchar2_table(493) := '5554485F454153543B0A202020202020202020202020686569676874203D20303B0A202020202020202020207D0A0A20202020202020202020627265616B3B0A0A20202020202020206361736520414354494F4E5F4E4F5254485F574553543A0A202020';
wwv_flow_api.g_varchar2_table(494) := '2020202020202069662028617370656374526174696F29207B0A2020202020202020202020206966202872616E67652E79203C3D20302026262028746F70203C3D206D696E546F70207C7C206C656674203C3D206D696E4C6566742929207B0A20202020';
wwv_flow_api.g_varchar2_table(495) := '2020202020202020202072656E64657261626C65203D2066616C73653B0A2020202020202020202020202020627265616B3B0A2020202020202020202020207D0A0A202020202020202020202020686569676874202D3D2072616E67652E793B0A202020';
wwv_flow_api.g_varchar2_table(496) := '202020202020202020746F70202B3D2072616E67652E793B0A2020202020202020202020207769647468203D20686569676874202A20617370656374526174696F3B0A2020202020202020202020206C656674202B3D2072616E67652E583B0A20202020';
wwv_flow_api.g_varchar2_table(497) := '2020202020207D20656C7365207B0A2020202020202020202020206966202872616E67652E78203C3D203029207B0A2020202020202020202020202020696620286C656674203E206D696E4C65667429207B0A2020202020202020202020202020202077';
wwv_flow_api.g_varchar2_table(498) := '69647468202D3D2072616E67652E783B0A202020202020202020202020202020206C656674202B3D2072616E67652E783B0A20202020202020202020202020207D20656C7365206966202872616E67652E79203C3D203020262620746F70203C3D206D69';
wwv_flow_api.g_varchar2_table(499) := '6E546F7029207B0A2020202020202020202020202020202072656E64657261626C65203D2066616C73653B0A20202020202020202020202020207D0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020207769647468';
wwv_flow_api.g_varchar2_table(500) := '202D3D2072616E67652E783B0A20202020202020202020202020206C656674202B3D2072616E67652E783B0A2020202020202020202020207D0A0A2020202020202020202020206966202872616E67652E79203C3D203029207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(501) := '202020202069662028746F70203E206D696E546F7029207B0A20202020202020202020202020202020686569676874202D3D2072616E67652E793B0A20202020202020202020202020202020746F70202B3D2072616E67652E793B0A2020202020202020';
wwv_flow_api.g_varchar2_table(502) := '2020202020207D0A2020202020202020202020207D20656C7365207B0A2020202020202020202020202020686569676874202D3D2072616E67652E793B0A2020202020202020202020202020746F70202B3D2072616E67652E793B0A2020202020202020';
wwv_flow_api.g_varchar2_table(503) := '202020207D0A202020202020202020207D0A0A20202020202020202020696620287769647468203C203020262620686569676874203C203029207B0A202020202020202020202020616374696F6E203D20414354494F4E5F534F5554485F454153543B0A';
wwv_flow_api.g_varchar2_table(504) := '202020202020202020202020686569676874203D20303B0A2020202020202020202020207769647468203D20303B0A202020202020202020207D20656C736520696620287769647468203C203029207B0A202020202020202020202020616374696F6E20';
wwv_flow_api.g_varchar2_table(505) := '3D20414354494F4E5F4E4F5254485F454153543B0A2020202020202020202020207769647468203D20303B0A202020202020202020207D20656C73652069662028686569676874203C203029207B0A202020202020202020202020616374696F6E203D20';
wwv_flow_api.g_varchar2_table(506) := '414354494F4E5F534F5554485F574553543B0A202020202020202020202020686569676874203D20303B0A202020202020202020207D0A0A20202020202020202020627265616B3B0A0A20202020202020206361736520414354494F4E5F534F5554485F';
wwv_flow_api.g_varchar2_table(507) := '574553543A0A2020202020202020202069662028617370656374526174696F29207B0A2020202020202020202020206966202872616E67652E78203C3D203020262620286C656674203C3D206D696E4C656674207C7C20626F74746F6D203E3D206D6178';
wwv_flow_api.g_varchar2_table(508) := '4865696768742929207B0A202020202020202020202020202072656E64657261626C65203D2066616C73653B0A2020202020202020202020202020627265616B3B0A2020202020202020202020207D0A0A2020202020202020202020207769647468202D';
wwv_flow_api.g_varchar2_table(509) := '3D2072616E67652E783B0A2020202020202020202020206C656674202B3D2072616E67652E783B0A202020202020202020202020686569676874203D207769647468202F20617370656374526174696F3B0A202020202020202020207D20656C7365207B';
wwv_flow_api.g_varchar2_table(510) := '0A2020202020202020202020206966202872616E67652E78203C3D203029207B0A2020202020202020202020202020696620286C656674203E206D696E4C65667429207B0A202020202020202020202020202020207769647468202D3D2072616E67652E';
wwv_flow_api.g_varchar2_table(511) := '783B0A202020202020202020202020202020206C656674202B3D2072616E67652E783B0A20202020202020202020202020207D20656C7365206966202872616E67652E79203E3D203020262620626F74746F6D203E3D206D617848656967687429207B0A';
wwv_flow_api.g_varchar2_table(512) := '2020202020202020202020202020202072656E64657261626C65203D2066616C73653B0A20202020202020202020202020207D0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020207769647468202D3D2072616E67';
wwv_flow_api.g_varchar2_table(513) := '652E783B0A20202020202020202020202020206C656674202B3D2072616E67652E783B0A2020202020202020202020207D0A0A2020202020202020202020206966202872616E67652E79203E3D203029207B0A2020202020202020202020202020696620';
wwv_flow_api.g_varchar2_table(514) := '28626F74746F6D203C206D617848656967687429207B0A20202020202020202020202020202020686569676874202B3D2072616E67652E793B0A20202020202020202020202020207D0A2020202020202020202020207D20656C7365207B0A2020202020';
wwv_flow_api.g_varchar2_table(515) := '202020202020202020686569676874202B3D2072616E67652E793B0A2020202020202020202020207D0A202020202020202020207D0A0A20202020202020202020696620287769647468203C203020262620686569676874203C203029207B0A20202020';
wwv_flow_api.g_varchar2_table(516) := '2020202020202020616374696F6E203D20414354494F4E5F4E4F5254485F454153543B0A202020202020202020202020686569676874203D20303B0A2020202020202020202020207769647468203D20303B0A202020202020202020207D20656C736520';
wwv_flow_api.g_varchar2_table(517) := '696620287769647468203C203029207B0A202020202020202020202020616374696F6E203D20414354494F4E5F534F5554485F454153543B0A2020202020202020202020207769647468203D20303B0A202020202020202020207D20656C736520696620';
wwv_flow_api.g_varchar2_table(518) := '28686569676874203C203029207B0A202020202020202020202020616374696F6E203D20414354494F4E5F4E4F5254485F574553543B0A202020202020202020202020686569676874203D20303B0A202020202020202020207D0A0A2020202020202020';
wwv_flow_api.g_varchar2_table(519) := '2020627265616B3B0A0A20202020202020206361736520414354494F4E5F534F5554485F454153543A0A2020202020202020202069662028617370656374526174696F29207B0A2020202020202020202020206966202872616E67652E78203E3D203020';
wwv_flow_api.g_varchar2_table(520) := '262620287269676874203E3D206D61785769647468207C7C20626F74746F6D203E3D206D61784865696768742929207B0A202020202020202020202020202072656E64657261626C65203D2066616C73653B0A2020202020202020202020202020627265';
wwv_flow_api.g_varchar2_table(521) := '616B3B0A2020202020202020202020207D0A0A2020202020202020202020207769647468202B3D2072616E67652E783B0A202020202020202020202020686569676874203D207769647468202F20617370656374526174696F3B0A202020202020202020';
wwv_flow_api.g_varchar2_table(522) := '207D20656C7365207B0A2020202020202020202020206966202872616E67652E78203E3D203029207B0A2020202020202020202020202020696620287269676874203C206D6178576964746829207B0A2020202020202020202020202020202077696474';
wwv_flow_api.g_varchar2_table(523) := '68202B3D2072616E67652E783B0A20202020202020202020202020207D20656C7365206966202872616E67652E79203E3D203020262620626F74746F6D203E3D206D617848656967687429207B0A2020202020202020202020202020202072656E646572';
wwv_flow_api.g_varchar2_table(524) := '61626C65203D2066616C73653B0A20202020202020202020202020207D0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020207769647468202B3D2072616E67652E783B0A2020202020202020202020207D0A0A2020';
wwv_flow_api.g_varchar2_table(525) := '202020202020202020206966202872616E67652E79203E3D203029207B0A202020202020202020202020202069662028626F74746F6D203C206D617848656967687429207B0A20202020202020202020202020202020686569676874202B3D2072616E67';
wwv_flow_api.g_varchar2_table(526) := '652E793B0A20202020202020202020202020207D0A2020202020202020202020207D20656C7365207B0A2020202020202020202020202020686569676874202B3D2072616E67652E793B0A2020202020202020202020207D0A202020202020202020207D';
wwv_flow_api.g_varchar2_table(527) := '0A0A20202020202020202020696620287769647468203C203020262620686569676874203C203029207B0A202020202020202020202020616374696F6E203D20414354494F4E5F4E4F5254485F574553543B0A2020202020202020202020206865696768';
wwv_flow_api.g_varchar2_table(528) := '74203D20303B0A2020202020202020202020207769647468203D20303B0A202020202020202020207D20656C736520696620287769647468203C203029207B0A202020202020202020202020616374696F6E203D20414354494F4E5F534F5554485F5745';
wwv_flow_api.g_varchar2_table(529) := '53543B0A2020202020202020202020207769647468203D20303B0A202020202020202020207D20656C73652069662028686569676874203C203029207B0A202020202020202020202020616374696F6E203D20414354494F4E5F4E4F5254485F45415354';
wwv_flow_api.g_varchar2_table(530) := '3B0A202020202020202020202020686569676874203D20303B0A202020202020202020207D0A0A20202020202020202020627265616B3B0A0A20202020202020202F2F204D6F76652063616E7661730A20202020202020206361736520414354494F4E5F';
wwv_flow_api.g_varchar2_table(531) := '4D4F56453A0A20202020202020202020746869732E6D6F76652872616E67652E782C2072616E67652E79293B0A2020202020202020202072656E64657261626C65203D2066616C73653B0A20202020202020202020627265616B3B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(532) := '202F2F205A6F6F6D2063616E7661730A20202020202020206361736520414354494F4E5F5A4F4F4D3A0A20202020202020202020746869732E7A6F6F6D282866756E6374696F6E202878312C2079312C2078322C20793229207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(533) := '202020766172207A31203D2073717274287831202A207831202B207931202A207931293B0A202020202020202020202020766172207A32203D2073717274287832202A207832202B207932202A207932293B0A0A20202020202020202020202072657475';
wwv_flow_api.g_varchar2_table(534) := '726E20287A32202D207A3129202F207A313B0A202020202020202020207D29280A20202020202020202020202061627328746869732E737461727458202D20746869732E73746172745832292C0A20202020202020202020202061627328746869732E73';
wwv_flow_api.g_varchar2_table(535) := '7461727459202D20746869732E73746172745932292C0A20202020202020202020202061627328746869732E656E6458202D20746869732E656E645832292C0A20202020202020202020202061627328746869732E656E6459202D20746869732E656E64';
wwv_flow_api.g_varchar2_table(536) := '5932290A20202020202020202020292C206576656E74293B0A20202020202020202020746869732E73746172745832203D20746869732E656E6458323B0A20202020202020202020746869732E73746172745932203D20746869732E656E6459323B0A20';
wwv_flow_api.g_varchar2_table(537) := '20202020202020202072656E64657261626C65203D2066616C73653B0A20202020202020202020627265616B3B0A0A20202020202020202F2F204372656174652063726F7020626F780A20202020202020206361736520414354494F4E5F43524F503A0A';
wwv_flow_api.g_varchar2_table(538) := '20202020202020202020696620282172616E67652E78207C7C202172616E67652E7929207B0A20202020202020202020202072656E64657261626C65203D2066616C73653B0A202020202020202020202020627265616B3B0A202020202020202020207D';
wwv_flow_api.g_varchar2_table(539) := '0A0A202020202020202020206F6666736574203D20746869732E2463726F707065722E6F666673657428293B0A202020202020202020206C656674203D20746869732E737461727458202D206F66667365742E6C6566743B0A2020202020202020202074';
wwv_flow_api.g_varchar2_table(540) := '6F70203D20746869732E737461727459202D206F66667365742E746F703B0A202020202020202020207769647468203D2063726F70426F782E6D696E57696474683B0A20202020202020202020686569676874203D2063726F70426F782E6D696E486569';
wwv_flow_api.g_varchar2_table(541) := '6768743B0A0A202020202020202020206966202872616E67652E78203E203029207B0A202020202020202020202020616374696F6E203D2072616E67652E79203E2030203F20414354494F4E5F534F5554485F45415354203A20414354494F4E5F4E4F52';
wwv_flow_api.g_varchar2_table(542) := '54485F454153543B0A202020202020202020207D20656C7365206966202872616E67652E78203C203029207B0A2020202020202020202020206C656674202D3D2077696474683B0A202020202020202020202020616374696F6E203D2072616E67652E79';
wwv_flow_api.g_varchar2_table(543) := '203E2030203F20414354494F4E5F534F5554485F57455354203A20414354494F4E5F4E4F5254485F574553543B0A202020202020202020207D0A0A202020202020202020206966202872616E67652E79203C203029207B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(544) := '746F70202D3D206865696768743B0A202020202020202020207D0A0A202020202020202020202F2F2053686F77207468652063726F7020626F782069662069732068696464656E0A202020202020202020206966202821746869732E697343726F707065';
wwv_flow_api.g_varchar2_table(545) := '6429207B0A202020202020202020202020746869732E2463726F70426F782E72656D6F7665436C61737328434C4153535F48494444454E293B0A202020202020202020202020746869732E697343726F70706564203D20747275653B0A0A202020202020';
wwv_flow_api.g_varchar2_table(546) := '20202020202069662028746869732E6C696D6974656429207B0A2020202020202020202020202020746869732E6C696D697443726F70426F7828747275652C2074727565293B0A2020202020202020202020207D0A202020202020202020207D0A0A2020';
wwv_flow_api.g_varchar2_table(547) := '2020202020202020627265616B3B0A0A20202020202020202F2F204E6F2064656661756C740A2020202020207D0A0A2020202020206966202872656E64657261626C6529207B0A202020202020202063726F70426F782E7769647468203D207769647468';
wwv_flow_api.g_varchar2_table(548) := '3B0A202020202020202063726F70426F782E686569676874203D206865696768743B0A202020202020202063726F70426F782E6C656674203D206C6566743B0A202020202020202063726F70426F782E746F70203D20746F703B0A202020202020202074';
wwv_flow_api.g_varchar2_table(549) := '6869732E616374696F6E203D20616374696F6E3B0A0A2020202020202020746869732E72656E64657243726F70426F7828293B0A2020202020207D0A0A2020202020202F2F204F766572726964650A202020202020746869732E737461727458203D2074';
wwv_flow_api.g_varchar2_table(550) := '6869732E656E64583B0A202020202020746869732E737461727459203D20746869732E656E64593B0A202020207D2C0A0A202020202F2F2053686F77207468652063726F7020626F78206D616E75616C6C790A2020202063726F703A2066756E6374696F';
wwv_flow_api.g_varchar2_table(551) := '6E202829207B0A2020202020206966202821746869732E69734275696C74207C7C20746869732E697344697361626C656429207B0A202020202020202072657475726E3B0A2020202020207D0A0A2020202020206966202821746869732E697343726F70';
wwv_flow_api.g_varchar2_table(552) := '70656429207B0A2020202020202020746869732E697343726F70706564203D20747275653B0A2020202020202020746869732E6C696D697443726F70426F7828747275652C2074727565293B0A0A202020202020202069662028746869732E6F7074696F';
wwv_flow_api.g_varchar2_table(553) := '6E732E6D6F64616C29207B0A20202020202020202020746869732E2464726167426F782E616464436C61737328434C4153535F4D4F44414C293B0A20202020202020207D0A0A2020202020202020746869732E2463726F70426F782E72656D6F7665436C';
wwv_flow_api.g_varchar2_table(554) := '61737328434C4153535F48494444454E293B0A2020202020207D0A0A202020202020746869732E73657443726F70426F784461746128746869732E696E697469616C43726F70426F78293B0A202020207D2C0A0A202020202F2F20526573657420746865';
wwv_flow_api.g_varchar2_table(555) := '20696D61676520616E642063726F7020626F7820746F20746865697220696E697469616C207374617465730A2020202072657365743A2066756E6374696F6E202829207B0A2020202020206966202821746869732E69734275696C74207C7C2074686973';
wwv_flow_api.g_varchar2_table(556) := '2E697344697361626C656429207B0A202020202020202072657475726E3B0A2020202020207D0A0A202020202020746869732E696D616765203D20242E657874656E64287B7D2C20746869732E696E697469616C496D616765293B0A2020202020207468';
wwv_flow_api.g_varchar2_table(557) := '69732E63616E766173203D20242E657874656E64287B7D2C20746869732E696E697469616C43616E766173293B0A202020202020746869732E63726F70426F78203D20242E657874656E64287B7D2C20746869732E696E697469616C43726F70426F7829';
wwv_flow_api.g_varchar2_table(558) := '3B0A0A202020202020746869732E72656E64657243616E76617328293B0A0A20202020202069662028746869732E697343726F7070656429207B0A2020202020202020746869732E72656E64657243726F70426F7828293B0A2020202020207D0A202020';
wwv_flow_api.g_varchar2_table(559) := '207D2C0A0A202020202F2F20436C656172207468652063726F7020626F780A20202020636C6561723A2066756E6374696F6E202829207B0A2020202020206966202821746869732E697343726F70706564207C7C20746869732E697344697361626C6564';
wwv_flow_api.g_varchar2_table(560) := '29207B0A202020202020202072657475726E3B0A2020202020207D0A0A202020202020242E657874656E6428746869732E63726F70426F782C207B0A20202020202020206C6566743A20302C0A2020202020202020746F703A20302C0A20202020202020';
wwv_flow_api.g_varchar2_table(561) := '2077696474683A20302C0A20202020202020206865696768743A20300A2020202020207D293B0A0A202020202020746869732E697343726F70706564203D2066616C73653B0A202020202020746869732E72656E64657243726F70426F7828293B0A0A20';
wwv_flow_api.g_varchar2_table(562) := '2020202020746869732E6C696D697443616E76617328747275652C2074727565293B0A0A2020202020202F2F2052656E6465722063616E7661732061667465722063726F7020626F782072656E64657265640A202020202020746869732E72656E646572';
wwv_flow_api.g_varchar2_table(563) := '43616E76617328293B0A0A202020202020746869732E2464726167426F782E72656D6F7665436C61737328434C4153535F4D4F44414C293B0A202020202020746869732E2463726F70426F782E616464436C61737328434C4153535F48494444454E293B';
wwv_flow_api.g_varchar2_table(564) := '0A202020207D2C0A0A202020202F2A2A0A20202020202A205265706C6163652074686520696D61676527732073726320616E642072656275696C64207468652063726F707065720A20202020202A0A20202020202A2040706172616D207B537472696E67';
wwv_flow_api.g_varchar2_table(565) := '7D2075726C0A20202020202A2F0A202020207265706C6163653A2066756E6374696F6E202875726C29207B0A2020202020206966202821746869732E697344697361626C65642026262075726C29207B0A202020202020202069662028746869732E6973';
wwv_flow_api.g_varchar2_table(566) := '496D6729207B0A20202020202020202020746869732E69735265706C61636564203D20747275653B0A20202020202020202020746869732E24656C656D656E742E617474722827737263272C2075726C293B0A20202020202020207D0A0A202020202020';
wwv_flow_api.g_varchar2_table(567) := '20202F2F20436C6561722070726576696F757320646174610A2020202020202020746869732E6F7074696F6E732E64617461203D206E756C6C3B0A2020202020202020746869732E6C6F61642875726C293B0A2020202020207D0A202020207D2C0A0A20';
wwv_flow_api.g_varchar2_table(568) := '2020202F2F20456E61626C652028756E667265657A6529207468652063726F707065720A20202020656E61626C653A2066756E6374696F6E202829207B0A20202020202069662028746869732E69734275696C7429207B0A202020202020202074686973';
wwv_flow_api.g_varchar2_table(569) := '2E697344697361626C6564203D2066616C73653B0A2020202020202020746869732E2463726F707065722E72656D6F7665436C61737328434C4153535F44495341424C4544293B0A2020202020207D0A202020207D2C0A0A202020202F2F204469736162';
wwv_flow_api.g_varchar2_table(570) := '6C652028667265657A6529207468652063726F707065720A2020202064697361626C653A2066756E6374696F6E202829207B0A20202020202069662028746869732E69734275696C7429207B0A2020202020202020746869732E697344697361626C6564';
wwv_flow_api.g_varchar2_table(571) := '203D20747275653B0A2020202020202020746869732E2463726F707065722E616464436C61737328434C4153535F44495341424C4544293B0A2020202020207D0A202020207D2C0A0A202020202F2F2044657374726F79207468652063726F7070657220';
wwv_flow_api.g_varchar2_table(572) := '616E642072656D6F76652074686520696E7374616E63652066726F6D2074686520696D6167650A2020202064657374726F793A2066756E6374696F6E202829207B0A202020202020766172202474686973203D20746869732E24656C656D656E743B0A0A';
wwv_flow_api.g_varchar2_table(573) := '20202020202069662028746869732E69734C6F6164656429207B0A202020202020202069662028746869732E6973496D6720262620746869732E69735265706C6163656429207B0A2020202020202020202024746869732E617474722827737263272C20';
wwv_flow_api.g_varchar2_table(574) := '746869732E6F726967696E616C55726C293B0A20202020202020207D0A0A2020202020202020746869732E756E6275696C6428293B0A202020202020202024746869732E72656D6F7665436C61737328434C4153535F48494444454E293B0A2020202020';
wwv_flow_api.g_varchar2_table(575) := '207D20656C7365207B0A202020202020202069662028746869732E6973496D6729207B0A2020202020202020202024746869732E6F6666284556454E545F4C4F41442C20746869732E7374617274293B0A20202020202020207D20656C73652069662028';
wwv_flow_api.g_varchar2_table(576) := '746869732E24636C6F6E6529207B0A20202020202020202020746869732E24636C6F6E652E72656D6F766528293B0A20202020202020207D0A2020202020207D0A0A20202020202024746869732E72656D6F766544617461284E414D455350414345293B';
wwv_flow_api.g_varchar2_table(577) := '0A202020207D2C0A0A202020202F2A2A0A20202020202A204D6F7665207468652063616E76617320776974682072656C6174697665206F6666736574730A20202020202A0A20202020202A2040706172616D207B4E756D6265727D206F6666736574580A';
wwv_flow_api.g_varchar2_table(578) := '20202020202A2040706172616D207B4E756D6265727D206F66667365745920286F7074696F6E616C290A20202020202A2F0A202020206D6F76653A2066756E6374696F6E20286F6666736574582C206F66667365745929207B0A20202020202076617220';
wwv_flow_api.g_varchar2_table(579) := '63616E766173203D20746869732E63616E7661733B0A0A202020202020746869732E6D6F7665546F280A20202020202020206973556E646566696E6564286F66667365745829203F206F666673657458203A2063616E7661732E6C656674202B206E756D';
wwv_flow_api.g_varchar2_table(580) := '286F666673657458292C0A20202020202020206973556E646566696E6564286F66667365745929203F206F666673657459203A2063616E7661732E746F70202B206E756D286F666673657459290A202020202020293B0A202020207D2C0A0A202020202F';
wwv_flow_api.g_varchar2_table(581) := '2A2A0A20202020202A204D6F7665207468652063616E76617320746F20616E206162736F6C75746520706F696E740A20202020202A0A20202020202A2040706172616D207B4E756D6265727D20780A20202020202A2040706172616D207B4E756D626572';
wwv_flow_api.g_varchar2_table(582) := '7D207920286F7074696F6E616C290A20202020202A2F0A202020206D6F7665546F3A2066756E6374696F6E2028782C207929207B0A2020202020207661722063616E766173203D20746869732E63616E7661733B0A202020202020766172206973436861';
wwv_flow_api.g_varchar2_table(583) := '6E676564203D2066616C73653B0A0A2020202020202F2F20496620227922206973206E6F742070726573656E742C206974732064656661756C742076616C7565206973202278220A202020202020696620286973556E646566696E656428792929207B0A';
wwv_flow_api.g_varchar2_table(584) := '202020202020202079203D20783B0A2020202020207D0A0A20202020202078203D206E756D2878293B0A20202020202079203D206E756D2879293B0A0A20202020202069662028746869732E69734275696C742026262021746869732E69734469736162';
wwv_flow_api.g_varchar2_table(585) := '6C656420262620746869732E6F7074696F6E732E6D6F7661626C6529207B0A20202020202020206966202869734E756D62657228782929207B0A2020202020202020202063616E7661732E6C656674203D20783B0A202020202020202020206973436861';
wwv_flow_api.g_varchar2_table(586) := '6E676564203D20747275653B0A20202020202020207D0A0A20202020202020206966202869734E756D62657228792929207B0A2020202020202020202063616E7661732E746F70203D20793B0A2020202020202020202069734368616E676564203D2074';
wwv_flow_api.g_varchar2_table(587) := '7275653B0A20202020202020207D0A0A20202020202020206966202869734368616E67656429207B0A20202020202020202020746869732E72656E64657243616E7661732874727565293B0A20202020202020207D0A2020202020207D0A202020207D2C';
wwv_flow_api.g_varchar2_table(588) := '0A0A202020202F2A2A0A20202020202A205A6F6F6D207468652063616E766173207769746820612072656C617469766520726174696F0A20202020202A0A20202020202A2040706172616D207B4E756D6265727D20726174696F0A20202020202A204070';
wwv_flow_api.g_varchar2_table(589) := '6172616D207B6A5175657279204576656E747D205F6576656E74202870726976617465290A20202020202A2F0A202020207A6F6F6D3A2066756E6374696F6E2028726174696F2C205F6576656E7429207B0A2020202020207661722063616E766173203D';
wwv_flow_api.g_varchar2_table(590) := '20746869732E63616E7661733B0A0A202020202020726174696F203D206E756D28726174696F293B0A0A20202020202069662028726174696F203C203029207B0A2020202020202020726174696F203D202031202F202831202D20726174696F293B0A20';
wwv_flow_api.g_varchar2_table(591) := '20202020207D20656C7365207B0A2020202020202020726174696F203D2031202B20726174696F3B0A2020202020207D0A0A202020202020746869732E7A6F6F6D546F2863616E7661732E7769647468202A20726174696F202F2063616E7661732E6E61';
wwv_flow_api.g_varchar2_table(592) := '747572616C57696474682C205F6576656E74293B0A202020207D2C0A0A202020202F2A2A0A20202020202A205A6F6F6D207468652063616E76617320746F20616E206162736F6C75746520726174696F0A20202020202A0A20202020202A204070617261';
wwv_flow_api.g_varchar2_table(593) := '6D207B4E756D6265727D20726174696F0A20202020202A2040706172616D207B6A5175657279204576656E747D205F6576656E74202870726976617465290A20202020202A2F0A202020207A6F6F6D546F3A2066756E6374696F6E2028726174696F2C20';
wwv_flow_api.g_varchar2_table(594) := '5F6576656E7429207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A2020202020207661722063616E766173203D20746869732E63616E7661733B0A202020202020766172207769647468203D2063616E766173';
wwv_flow_api.g_varchar2_table(595) := '2E77696474683B0A20202020202076617220686569676874203D2063616E7661732E6865696768743B0A202020202020766172206E61747572616C5769647468203D2063616E7661732E6E61747572616C57696474683B0A202020202020766172206E61';
wwv_flow_api.g_varchar2_table(596) := '747572616C486569676874203D2063616E7661732E6E61747572616C4865696768743B0A202020202020766172206F726967696E616C4576656E743B0A202020202020766172206E657757696474683B0A202020202020766172206E6577486569676874';
wwv_flow_api.g_varchar2_table(597) := '3B0A202020202020766172206F66667365743B0A2020202020207661722063656E7465723B0A0A202020202020726174696F203D206E756D28726174696F293B0A0A20202020202069662028726174696F203E3D203020262620746869732E6973427569';
wwv_flow_api.g_varchar2_table(598) := '6C742026262021746869732E697344697361626C6564202626206F7074696F6E732E7A6F6F6D61626C6529207B0A20202020202020206E65775769647468203D206E61747572616C5769647468202A20726174696F3B0A20202020202020206E65774865';
wwv_flow_api.g_varchar2_table(599) := '69676874203D206E61747572616C486569676874202A20726174696F3B0A0A2020202020202020696620285F6576656E7429207B0A202020202020202020206F726967696E616C4576656E74203D205F6576656E742E6F726967696E616C4576656E743B';
wwv_flow_api.g_varchar2_table(600) := '0A20202020202020207D0A0A202020202020202069662028746869732E74726967676572284556454E545F5A4F4F4D2C207B0A202020202020202020206F726967696E616C4576656E743A206F726967696E616C4576656E742C0A202020202020202020';
wwv_flow_api.g_varchar2_table(601) := '206F6C64526174696F3A207769647468202F206E61747572616C57696474682C0A20202020202020202020726174696F3A206E65775769647468202F206E61747572616C57696474680A20202020202020207D292E697344656661756C7450726576656E';
wwv_flow_api.g_varchar2_table(602) := '746564282929207B0A2020202020202020202072657475726E3B0A20202020202020207D0A0A2020202020202020696620286F726967696E616C4576656E7429207B0A202020202020202020206F6666736574203D20746869732E2463726F707065722E';
wwv_flow_api.g_varchar2_table(603) := '6F666673657428293B0A2020202020202020202063656E746572203D206F726967696E616C4576656E742E746F7563686573203F20676574546F756368657343656E746572286F726967696E616C4576656E742E746F756368657329203A207B0A202020';
wwv_flow_api.g_varchar2_table(604) := '20202020202020202070616765583A205F6576656E742E7061676558207C7C206F726967696E616C4576656E742E7061676558207C7C20302C0A20202020202020202020202070616765593A205F6576656E742E7061676559207C7C206F726967696E61';
wwv_flow_api.g_varchar2_table(605) := '6C4576656E742E7061676559207C7C20300A202020202020202020207D3B0A0A202020202020202020202F2F205A6F6F6D2066726F6D207468652074726967676572696E6720706F696E74206F6620746865206576656E740A2020202020202020202063';
wwv_flow_api.g_varchar2_table(606) := '616E7661732E6C656674202D3D20286E65775769647468202D20776964746829202A20280A202020202020202020202020282863656E7465722E7061676558202D206F66667365742E6C65667429202D2063616E7661732E6C65667429202F2077696474';
wwv_flow_api.g_varchar2_table(607) := '680A20202020202020202020293B0A2020202020202020202063616E7661732E746F70202D3D20286E6577486569676874202D2068656967687429202A20280A202020202020202020202020282863656E7465722E7061676559202D206F66667365742E';
wwv_flow_api.g_varchar2_table(608) := '746F7029202D2063616E7661732E746F7029202F206865696768740A20202020202020202020293B0A20202020202020207D20656C7365207B0A0A202020202020202020202F2F205A6F6F6D2066726F6D207468652063656E746572206F662074686520';
wwv_flow_api.g_varchar2_table(609) := '63616E7661730A2020202020202020202063616E7661732E6C656674202D3D20286E65775769647468202D20776964746829202F20323B0A2020202020202020202063616E7661732E746F70202D3D20286E6577486569676874202D2068656967687429';
wwv_flow_api.g_varchar2_table(610) := '202F20323B0A20202020202020207D0A0A202020202020202063616E7661732E7769647468203D206E657757696474683B0A202020202020202063616E7661732E686569676874203D206E65774865696768743B0A2020202020202020746869732E7265';
wwv_flow_api.g_varchar2_table(611) := '6E64657243616E7661732874727565293B0A2020202020207D0A202020207D2C0A0A202020202F2A2A0A20202020202A20526F74617465207468652063616E766173207769746820612072656C6174697665206465677265650A20202020202A0A202020';
wwv_flow_api.g_varchar2_table(612) := '20202A2040706172616D207B4E756D6265727D206465677265650A20202020202A2F0A20202020726F746174653A2066756E6374696F6E202864656772656529207B0A202020202020746869732E726F74617465546F2828746869732E696D6167652E72';
wwv_flow_api.g_varchar2_table(613) := '6F74617465207C7C203029202B206E756D2864656772656529293B0A202020207D2C0A0A202020202F2A2A0A20202020202A20526F74617465207468652063616E76617320746F20616E206162736F6C757465206465677265650A20202020202A206874';
wwv_flow_api.g_varchar2_table(614) := '7470733A2F2F646576656C6F7065722E6D6F7A696C6C612E6F72672F656E2D55532F646F63732F5765622F4353532F7472616E73666F726D2D66756E6374696F6E23726F7461746528290A20202020202A0A20202020202A2040706172616D207B4E756D';
wwv_flow_api.g_varchar2_table(615) := '6265727D206465677265650A20202020202A2F0A20202020726F74617465546F3A2066756E6374696F6E202864656772656529207B0A202020202020646567726565203D206E756D28646567726565293B0A0A2020202020206966202869734E756D6265';
wwv_flow_api.g_varchar2_table(616) := '72286465677265652920262620746869732E69734275696C742026262021746869732E697344697361626C656420262620746869732E6F7074696F6E732E726F74617461626C6529207B0A2020202020202020746869732E696D6167652E726F74617465';
wwv_flow_api.g_varchar2_table(617) := '203D206465677265652025203336303B0A2020202020202020746869732E6973526F7461746564203D20747275653B0A2020202020202020746869732E72656E64657243616E7661732874727565293B0A2020202020207D0A202020207D2C0A0A202020';
wwv_flow_api.g_varchar2_table(618) := '202F2A2A0A20202020202A205363616C652074686520696D6167650A20202020202A2068747470733A2F2F646576656C6F7065722E6D6F7A696C6C612E6F72672F656E2D55532F646F63732F5765622F4353532F7472616E73666F726D2D66756E637469';
wwv_flow_api.g_varchar2_table(619) := '6F6E237363616C6528290A20202020202A0A20202020202A2040706172616D207B4E756D6265727D207363616C65580A20202020202A2040706172616D207B4E756D6265727D207363616C655920286F7074696F6E616C290A20202020202A2F0A202020';
wwv_flow_api.g_varchar2_table(620) := '207363616C653A2066756E6374696F6E20287363616C65582C207363616C655929207B0A20202020202076617220696D616765203D20746869732E696D6167653B0A2020202020207661722069734368616E676564203D2066616C73653B0A0A20202020';
wwv_flow_api.g_varchar2_table(621) := '20202F2F20496620227363616C655922206973206E6F742070726573656E742C206974732064656661756C742076616C756520697320227363616C6558220A202020202020696620286973556E646566696E6564287363616C65592929207B0A20202020';
wwv_flow_api.g_varchar2_table(622) := '202020207363616C6559203D207363616C65583B0A2020202020207D0A0A2020202020207363616C6558203D206E756D287363616C6558293B0A2020202020207363616C6559203D206E756D287363616C6559293B0A0A20202020202069662028746869';
wwv_flow_api.g_varchar2_table(623) := '732E69734275696C742026262021746869732E697344697361626C656420262620746869732E6F7074696F6E732E7363616C61626C6529207B0A20202020202020206966202869734E756D626572287363616C65582929207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(624) := '696D6167652E7363616C6558203D207363616C65583B0A2020202020202020202069734368616E676564203D20747275653B0A20202020202020207D0A0A20202020202020206966202869734E756D626572287363616C65592929207B0A202020202020';
wwv_flow_api.g_varchar2_table(625) := '20202020696D6167652E7363616C6559203D207363616C65593B0A2020202020202020202069734368616E676564203D20747275653B0A20202020202020207D0A0A20202020202020206966202869734368616E67656429207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(626) := '20746869732E72656E646572496D6167652874727565293B0A20202020202020207D0A2020202020207D0A202020207D2C0A0A202020202F2A2A0A20202020202A205363616C6520746865206162736369737361206F662074686520696D6167650A2020';
wwv_flow_api.g_varchar2_table(627) := '2020202A0A20202020202A2040706172616D207B4E756D6265727D207363616C65580A20202020202A2F0A202020207363616C65583A2066756E6374696F6E20287363616C655829207B0A202020202020766172207363616C6559203D20746869732E69';
wwv_flow_api.g_varchar2_table(628) := '6D6167652E7363616C65593B0A0A202020202020746869732E7363616C65287363616C65582C2069734E756D626572287363616C655929203F207363616C6559203A2031293B0A202020207D2C0A0A202020202F2A2A0A20202020202A205363616C6520';
wwv_flow_api.g_varchar2_table(629) := '746865206F7264696E617465206F662074686520696D6167650A20202020202A0A20202020202A2040706172616D207B4E756D6265727D207363616C65590A20202020202A2F0A202020207363616C65593A2066756E6374696F6E20287363616C655929';
wwv_flow_api.g_varchar2_table(630) := '207B0A202020202020766172207363616C6558203D20746869732E696D6167652E7363616C65583B0A0A202020202020746869732E7363616C652869734E756D626572287363616C655829203F207363616C6558203A20312C207363616C6559293B0A20';
wwv_flow_api.g_varchar2_table(631) := '2020207D2C0A0A202020202F2A2A0A20202020202A20476574207468652063726F70706564206172656120706F736974696F6E20616E642073697A652064617461202862617365206F6E20746865206F726967696E616C20696D616765290A2020202020';
wwv_flow_api.g_varchar2_table(632) := '2A0A20202020202A2040706172616D207B426F6F6C65616E7D206973526F756E64656420286F7074696F6E616C290A20202020202A204072657475726E207B4F626A6563747D20646174610A20202020202A2F0A20202020676574446174613A2066756E';
wwv_flow_api.g_varchar2_table(633) := '6374696F6E20286973526F756E64656429207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A20202020202076617220696D616765203D20746869732E696D6167653B0A2020202020207661722063616E766173';
wwv_flow_api.g_varchar2_table(634) := '203D20746869732E63616E7661733B0A2020202020207661722063726F70426F78203D20746869732E63726F70426F783B0A20202020202076617220726174696F3B0A20202020202076617220646174613B0A0A20202020202069662028746869732E69';
wwv_flow_api.g_varchar2_table(635) := '734275696C7420262620746869732E697343726F7070656429207B0A202020202020202064617461203D207B0A20202020202020202020783A2063726F70426F782E6C656674202D2063616E7661732E6C6566742C0A20202020202020202020793A2063';
wwv_flow_api.g_varchar2_table(636) := '726F70426F782E746F70202D2063616E7661732E746F702C0A2020202020202020202077696474683A2063726F70426F782E77696474682C0A202020202020202020206865696768743A2063726F70426F782E6865696768740A20202020202020207D3B';
wwv_flow_api.g_varchar2_table(637) := '0A0A2020202020202020726174696F203D20696D6167652E7769647468202F20696D6167652E6E61747572616C57696474683B0A0A2020202020202020242E6561636828646174612C2066756E6374696F6E2028692C206E29207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(638) := '20206E203D206E202F20726174696F3B0A20202020202020202020646174615B695D203D206973526F756E646564203F20726F756E64286E29203A206E3B0A20202020202020207D293B0A0A2020202020207D20656C7365207B0A202020202020202064';
wwv_flow_api.g_varchar2_table(639) := '617461203D207B0A20202020202020202020783A20302C0A20202020202020202020793A20302C0A2020202020202020202077696474683A20302C0A202020202020202020206865696768743A20300A20202020202020207D3B0A2020202020207D0A0A';
wwv_flow_api.g_varchar2_table(640) := '202020202020696620286F7074696F6E732E726F74617461626C6529207B0A2020202020202020646174612E726F74617465203D20696D6167652E726F74617465207C7C20303B0A2020202020207D0A0A202020202020696620286F7074696F6E732E73';
wwv_flow_api.g_varchar2_table(641) := '63616C61626C6529207B0A2020202020202020646174612E7363616C6558203D20696D6167652E7363616C6558207C7C20313B0A2020202020202020646174612E7363616C6559203D20696D6167652E7363616C6559207C7C20313B0A2020202020207D';
wwv_flow_api.g_varchar2_table(642) := '0A0A20202020202072657475726E20646174613B0A202020207D2C0A0A202020202F2A2A0A20202020202A20536574207468652063726F70706564206172656120706F736974696F6E20616E642073697A652077697468206E657720646174610A202020';
wwv_flow_api.g_varchar2_table(643) := '20202A0A20202020202A2040706172616D207B4F626A6563747D20646174610A20202020202A2F0A20202020736574446174613A2066756E6374696F6E20286461746129207B0A202020202020766172206F7074696F6E73203D20746869732E6F707469';
wwv_flow_api.g_varchar2_table(644) := '6F6E733B0A20202020202076617220696D616765203D20746869732E696D6167653B0A2020202020207661722063616E766173203D20746869732E63616E7661733B0A2020202020207661722063726F70426F7844617461203D207B7D3B0A2020202020';
wwv_flow_api.g_varchar2_table(645) := '20766172206973526F74617465643B0A2020202020207661722069735363616C65643B0A20202020202076617220726174696F3B0A0A20202020202069662028242E697346756E6374696F6E28646174612929207B0A202020202020202064617461203D';
wwv_flow_api.g_varchar2_table(646) := '20646174612E63616C6C28746869732E656C656D656E74293B0A2020202020207D0A0A20202020202069662028746869732E69734275696C742026262021746869732E697344697361626C656420262620242E6973506C61696E4F626A65637428646174';
wwv_flow_api.g_varchar2_table(647) := '612929207B0A2020202020202020696620286F7074696F6E732E726F74617461626C6529207B0A202020202020202020206966202869734E756D62657228646174612E726F746174652920262620646174612E726F7461746520213D3D20696D6167652E';
wwv_flow_api.g_varchar2_table(648) := '726F7461746529207B0A202020202020202020202020696D6167652E726F74617465203D20646174612E726F746174653B0A202020202020202020202020746869732E6973526F7461746564203D206973526F7461746564203D20747275653B0A202020';
wwv_flow_api.g_varchar2_table(649) := '202020202020207D0A20202020202020207D0A0A2020202020202020696620286F7074696F6E732E7363616C61626C6529207B0A202020202020202020206966202869734E756D62657228646174612E7363616C65582920262620646174612E7363616C';
wwv_flow_api.g_varchar2_table(650) := '655820213D3D20696D6167652E7363616C655829207B0A202020202020202020202020696D6167652E7363616C6558203D20646174612E7363616C65583B0A20202020202020202020202069735363616C6564203D20747275653B0A2020202020202020';
wwv_flow_api.g_varchar2_table(651) := '20207D0A0A202020202020202020206966202869734E756D62657228646174612E7363616C65592920262620646174612E7363616C655920213D3D20696D6167652E7363616C655929207B0A202020202020202020202020696D6167652E7363616C6559';
wwv_flow_api.g_varchar2_table(652) := '203D20646174612E7363616C65593B0A20202020202020202020202069735363616C6564203D20747275653B0A202020202020202020207D0A20202020202020207D0A0A2020202020202020696620286973526F746174656429207B0A20202020202020';
wwv_flow_api.g_varchar2_table(653) := '202020746869732E72656E64657243616E76617328293B0A20202020202020207D20656C7365206966202869735363616C656429207B0A20202020202020202020746869732E72656E646572496D61676528293B0A20202020202020207D0A0A20202020';
wwv_flow_api.g_varchar2_table(654) := '20202020726174696F203D20696D6167652E7769647468202F20696D6167652E6E61747572616C57696474683B0A0A20202020202020206966202869734E756D62657228646174612E782929207B0A2020202020202020202063726F70426F7844617461';
wwv_flow_api.g_varchar2_table(655) := '2E6C656674203D20646174612E78202A20726174696F202B2063616E7661732E6C6566743B0A20202020202020207D0A0A20202020202020206966202869734E756D62657228646174612E792929207B0A2020202020202020202063726F70426F784461';
wwv_flow_api.g_varchar2_table(656) := '74612E746F70203D20646174612E79202A20726174696F202B2063616E7661732E746F703B0A20202020202020207D0A0A20202020202020206966202869734E756D62657228646174612E77696474682929207B0A2020202020202020202063726F7042';
wwv_flow_api.g_varchar2_table(657) := '6F78446174612E7769647468203D20646174612E7769647468202A20726174696F3B0A20202020202020207D0A0A20202020202020206966202869734E756D62657228646174612E6865696768742929207B0A2020202020202020202063726F70426F78';
wwv_flow_api.g_varchar2_table(658) := '446174612E686569676874203D20646174612E686569676874202A20726174696F3B0A20202020202020207D0A0A2020202020202020746869732E73657443726F70426F78446174612863726F70426F7844617461293B0A2020202020207D0A20202020';
wwv_flow_api.g_varchar2_table(659) := '7D2C0A0A202020202F2A2A0A20202020202A204765742074686520636F6E7461696E65722073697A6520646174610A20202020202A0A20202020202A204072657475726E207B4F626A6563747D20646174610A20202020202A2F0A20202020676574436F';
wwv_flow_api.g_varchar2_table(660) := '6E7461696E6572446174613A2066756E6374696F6E202829207B0A20202020202072657475726E20746869732E69734275696C74203F20746869732E636F6E7461696E6572203A207B7D3B0A202020207D2C0A0A202020202F2A2A0A20202020202A2047';
wwv_flow_api.g_varchar2_table(661) := '65742074686520696D61676520706F736974696F6E20616E642073697A6520646174610A20202020202A0A20202020202A204072657475726E207B4F626A6563747D20646174610A20202020202A2F0A20202020676574496D616765446174613A206675';
wwv_flow_api.g_varchar2_table(662) := '6E6374696F6E202829207B0A20202020202072657475726E20746869732E69734C6F61646564203F20746869732E696D616765203A207B7D3B0A202020207D2C0A0A202020202F2A2A0A20202020202A20476574207468652063616E76617320706F7369';
wwv_flow_api.g_varchar2_table(663) := '74696F6E20616E642073697A6520646174610A20202020202A0A20202020202A204072657475726E207B4F626A6563747D20646174610A20202020202A2F0A2020202067657443616E766173446174613A2066756E6374696F6E202829207B0A20202020';
wwv_flow_api.g_varchar2_table(664) := '20207661722063616E766173203D20746869732E63616E7661733B0A2020202020207661722064617461203D207B7D3B0A0A20202020202069662028746869732E69734275696C7429207B0A2020202020202020242E65616368285B0A20202020202020';
wwv_flow_api.g_varchar2_table(665) := '202020276C656674272C0A2020202020202020202027746F70272C0A20202020202020202020277769647468272C0A2020202020202020202027686569676874272C0A20202020202020202020276E61747572616C5769647468272C0A20202020202020';
wwv_flow_api.g_varchar2_table(666) := '202020276E61747572616C486569676874270A20202020202020205D2C2066756E6374696F6E2028692C206E29207B0A20202020202020202020646174615B6E5D203D2063616E7661735B6E5D3B0A20202020202020207D293B0A2020202020207D0A0A';
wwv_flow_api.g_varchar2_table(667) := '20202020202072657475726E20646174613B0A202020207D2C0A0A202020202F2A2A0A20202020202A20536574207468652063616E76617320706F736974696F6E20616E642073697A652077697468206E657720646174610A20202020202A0A20202020';
wwv_flow_api.g_varchar2_table(668) := '202A2040706172616D207B4F626A6563747D20646174610A20202020202A2F0A2020202073657443616E766173446174613A2066756E6374696F6E20286461746129207B0A2020202020207661722063616E766173203D20746869732E63616E7661733B';
wwv_flow_api.g_varchar2_table(669) := '0A20202020202076617220617370656374526174696F203D2063616E7661732E617370656374526174696F3B0A0A20202020202069662028242E697346756E6374696F6E28646174612929207B0A202020202020202064617461203D20646174612E6361';
wwv_flow_api.g_varchar2_table(670) := '6C6C28746869732E24656C656D656E74293B0A2020202020207D0A0A20202020202069662028746869732E69734275696C742026262021746869732E697344697361626C656420262620242E6973506C61696E4F626A65637428646174612929207B0A20';
wwv_flow_api.g_varchar2_table(671) := '202020202020206966202869734E756D62657228646174612E6C6566742929207B0A2020202020202020202063616E7661732E6C656674203D20646174612E6C6566743B0A20202020202020207D0A0A20202020202020206966202869734E756D626572';
wwv_flow_api.g_varchar2_table(672) := '28646174612E746F702929207B0A2020202020202020202063616E7661732E746F70203D20646174612E746F703B0A20202020202020207D0A0A20202020202020206966202869734E756D62657228646174612E77696474682929207B0A202020202020';
wwv_flow_api.g_varchar2_table(673) := '2020202063616E7661732E7769647468203D20646174612E77696474683B0A2020202020202020202063616E7661732E686569676874203D20646174612E7769647468202F20617370656374526174696F3B0A20202020202020207D20656C7365206966';
wwv_flow_api.g_varchar2_table(674) := '202869734E756D62657228646174612E6865696768742929207B0A2020202020202020202063616E7661732E686569676874203D20646174612E6865696768743B0A2020202020202020202063616E7661732E7769647468203D20646174612E68656967';
wwv_flow_api.g_varchar2_table(675) := '6874202A20617370656374526174696F3B0A20202020202020207D0A0A2020202020202020746869732E72656E64657243616E7661732874727565293B0A2020202020207D0A202020207D2C0A0A202020202F2A2A0A20202020202A2047657420746865';
wwv_flow_api.g_varchar2_table(676) := '2063726F7020626F7820706F736974696F6E20616E642073697A6520646174610A20202020202A0A20202020202A204072657475726E207B4F626A6563747D20646174610A20202020202A2F0A2020202067657443726F70426F78446174613A2066756E';
wwv_flow_api.g_varchar2_table(677) := '6374696F6E202829207B0A2020202020207661722063726F70426F78203D20746869732E63726F70426F783B0A20202020202076617220646174613B0A0A20202020202069662028746869732E69734275696C7420262620746869732E697343726F7070';
wwv_flow_api.g_varchar2_table(678) := '656429207B0A202020202020202064617461203D207B0A202020202020202020206C6566743A2063726F70426F782E6C6566742C0A20202020202020202020746F703A2063726F70426F782E746F702C0A2020202020202020202077696474683A206372';
wwv_flow_api.g_varchar2_table(679) := '6F70426F782E77696474682C0A202020202020202020206865696768743A2063726F70426F782E6865696768740A20202020202020207D3B0A2020202020207D0A0A20202020202072657475726E2064617461207C7C207B7D3B0A202020207D2C0A0A20';
wwv_flow_api.g_varchar2_table(680) := '2020202F2A2A0A20202020202A20536574207468652063726F7020626F7820706F736974696F6E20616E642073697A652077697468206E657720646174610A20202020202A0A20202020202A2040706172616D207B4F626A6563747D20646174610A2020';
wwv_flow_api.g_varchar2_table(681) := '2020202A2F0A2020202073657443726F70426F78446174613A2066756E6374696F6E20286461746129207B0A2020202020207661722063726F70426F78203D20746869732E63726F70426F783B0A20202020202076617220617370656374526174696F20';
wwv_flow_api.g_varchar2_table(682) := '3D20746869732E6F7074696F6E732E617370656374526174696F3B0A20202020202076617220697357696474684368616E6765643B0A2020202020207661722069734865696768744368616E6765643B0A0A20202020202069662028242E697346756E63';
wwv_flow_api.g_varchar2_table(683) := '74696F6E28646174612929207B0A202020202020202064617461203D20646174612E63616C6C28746869732E24656C656D656E74293B0A2020202020207D0A0A20202020202069662028746869732E69734275696C7420262620746869732E697343726F';
wwv_flow_api.g_varchar2_table(684) := '707065642026262021746869732E697344697361626C656420262620242E6973506C61696E4F626A65637428646174612929207B0A0A20202020202020206966202869734E756D62657228646174612E6C6566742929207B0A2020202020202020202063';
wwv_flow_api.g_varchar2_table(685) := '726F70426F782E6C656674203D20646174612E6C6566743B0A20202020202020207D0A0A20202020202020206966202869734E756D62657228646174612E746F702929207B0A2020202020202020202063726F70426F782E746F70203D20646174612E74';
wwv_flow_api.g_varchar2_table(686) := '6F703B0A20202020202020207D0A0A20202020202020206966202869734E756D62657228646174612E77696474682929207B0A20202020202020202020697357696474684368616E676564203D20747275653B0A2020202020202020202063726F70426F';
wwv_flow_api.g_varchar2_table(687) := '782E7769647468203D20646174612E77696474683B0A20202020202020207D0A0A20202020202020206966202869734E756D62657228646174612E6865696768742929207B0A2020202020202020202069734865696768744368616E676564203D207472';
wwv_flow_api.g_varchar2_table(688) := '75653B0A2020202020202020202063726F70426F782E686569676874203D20646174612E6865696768743B0A20202020202020207D0A0A202020202020202069662028617370656374526174696F29207B0A202020202020202020206966202869735769';
wwv_flow_api.g_varchar2_table(689) := '6474684368616E67656429207B0A20202020202020202020202063726F70426F782E686569676874203D2063726F70426F782E7769647468202F20617370656374526174696F3B0A202020202020202020207D20656C7365206966202869734865696768';
wwv_flow_api.g_varchar2_table(690) := '744368616E67656429207B0A20202020202020202020202063726F70426F782E7769647468203D2063726F70426F782E686569676874202A20617370656374526174696F3B0A202020202020202020207D0A20202020202020207D0A0A20202020202020';
wwv_flow_api.g_varchar2_table(691) := '20746869732E72656E64657243726F70426F7828293B0A2020202020207D0A202020207D2C0A0A202020202F2A2A0A20202020202A2047657420612063616E76617320647261776E207468652063726F7070656420696D6167650A20202020202A0A2020';
wwv_flow_api.g_varchar2_table(692) := '2020202A2040706172616D207B4F626A6563747D206F7074696F6E7320286F7074696F6E616C290A20202020202A204072657475726E207B48544D4C43616E766173456C656D656E747D2063616E7661730A20202020202A2F0A2020202067657443726F';
wwv_flow_api.g_varchar2_table(693) := '7070656443616E7661733A2066756E6374696F6E20286F7074696F6E7329207B0A202020202020766172206F726967696E616C57696474683B0A202020202020766172206F726967696E616C4865696768743B0A2020202020207661722063616E766173';
wwv_flow_api.g_varchar2_table(694) := '57696474683B0A2020202020207661722063616E7661734865696768743B0A202020202020766172207363616C656457696474683B0A202020202020766172207363616C65644865696768743B0A202020202020766172207363616C6564526174696F3B';
wwv_flow_api.g_varchar2_table(695) := '0A20202020202076617220617370656374526174696F3B0A2020202020207661722063616E7661733B0A20202020202076617220636F6E746578743B0A20202020202076617220646174613B0A0A2020202020206966202821746869732E69734275696C';
wwv_flow_api.g_varchar2_table(696) := '74207C7C2021746869732E697343726F70706564207C7C2021535550504F52545F43414E56415329207B0A202020202020202072657475726E3B0A2020202020207D0A0A2020202020206966202821242E6973506C61696E4F626A656374286F7074696F';
wwv_flow_api.g_varchar2_table(697) := '6E732929207B0A20202020202020206F7074696F6E73203D207B7D3B0A2020202020207D0A0A20202020202064617461203D20746869732E6765744461746128293B0A2020202020206F726967696E616C5769647468203D20646174612E77696474683B';
wwv_flow_api.g_varchar2_table(698) := '0A2020202020206F726967696E616C486569676874203D20646174612E6865696768743B0A202020202020617370656374526174696F203D206F726967696E616C5769647468202F206F726967696E616C4865696768743B0A0A20202020202069662028';
wwv_flow_api.g_varchar2_table(699) := '242E6973506C61696E4F626A656374286F7074696F6E732929207B0A20202020202020207363616C65645769647468203D206F7074696F6E732E77696474683B0A20202020202020207363616C6564486569676874203D206F7074696F6E732E68656967';
wwv_flow_api.g_varchar2_table(700) := '68743B0A0A2020202020202020696620287363616C6564576964746829207B0A202020202020202020207363616C6564486569676874203D207363616C65645769647468202F20617370656374526174696F3B0A202020202020202020207363616C6564';
wwv_flow_api.g_varchar2_table(701) := '526174696F203D207363616C65645769647468202F206F726967696E616C57696474683B0A20202020202020207D20656C736520696620287363616C656448656967687429207B0A202020202020202020207363616C65645769647468203D207363616C';
wwv_flow_api.g_varchar2_table(702) := '6564486569676874202A20617370656374526174696F3B0A202020202020202020207363616C6564526174696F203D207363616C6564486569676874202F206F726967696E616C4865696768743B0A20202020202020207D0A2020202020207D0A0A2020';
wwv_flow_api.g_varchar2_table(703) := '202020202F2F205468652063616E76617320656C656D656E742077696C6C2075736520604D6174682E666C6F6F7260206F6E206120666C6F6174206E756D6265722C20736F20666C6F6F722066697273740A20202020202063616E766173576964746820';
wwv_flow_api.g_varchar2_table(704) := '3D20666C6F6F72287363616C65645769647468207C7C206F726967696E616C5769647468293B0A20202020202063616E766173486569676874203D20666C6F6F72287363616C6564486569676874207C7C206F726967696E616C486569676874293B0A0A';
wwv_flow_api.g_varchar2_table(705) := '20202020202063616E766173203D202428273C63616E7661733E27295B305D3B0A20202020202063616E7661732E7769647468203D2063616E76617357696474683B0A20202020202063616E7661732E686569676874203D2063616E7661734865696768';
wwv_flow_api.g_varchar2_table(706) := '743B0A202020202020636F6E74657874203D2063616E7661732E676574436F6E746578742827326427293B0A0A202020202020696620286F7074696F6E732E66696C6C436F6C6F7229207B0A2020202020202020636F6E746578742E66696C6C5374796C';
wwv_flow_api.g_varchar2_table(707) := '65203D206F7074696F6E732E66696C6C436F6C6F723B0A2020202020202020636F6E746578742E66696C6C5265637428302C20302C2063616E76617357696474682C2063616E766173486569676874293B0A2020202020207D0A0A2020202020202F2F20';
wwv_flow_api.g_varchar2_table(708) := '68747470733A2F2F646576656C6F7065722E6D6F7A696C6C612E6F72672F656E2D55532F646F63732F5765622F4150492F43616E76617352656E646572696E67436F6E7465787432442E64726177496D6167650A202020202020636F6E746578742E6472';
wwv_flow_api.g_varchar2_table(709) := '6177496D6167652E6170706C7928636F6E746578742C202866756E6374696F6E202829207B0A202020202020202076617220736F75726365203D20676574536F7572636543616E76617328746869732E24636C6F6E655B305D2C20746869732E696D6167';
wwv_flow_api.g_varchar2_table(710) := '65293B0A202020202020202076617220736F757263655769647468203D20736F757263652E77696474683B0A202020202020202076617220736F75726365486569676874203D20736F757263652E6865696768743B0A2020202020202020766172206172';
wwv_flow_api.g_varchar2_table(711) := '6773203D205B736F757263655D3B0A0A20202020202020202F2F20536F757263652063616E7661730A20202020202020207661722073726358203D20646174612E783B0A20202020202020207661722073726359203D20646174612E793B0A2020202020';
wwv_flow_api.g_varchar2_table(712) := '2020207661722073726357696474683B0A2020202020202020766172207372634865696768743B0A0A20202020202020202F2F2044657374696E6174696F6E2063616E7661730A202020202020202076617220647374583B0A2020202020202020766172';
wwv_flow_api.g_varchar2_table(713) := '20647374593B0A20202020202020207661722064737457696474683B0A2020202020202020766172206473744865696768743B0A0A20202020202020206966202873726358203C3D202D6F726967696E616C5769647468207C7C2073726358203E20736F';
wwv_flow_api.g_varchar2_table(714) := '75726365576964746829207B0A2020202020202020202073726358203D207372635769647468203D2064737458203D206473745769647468203D20303B0A20202020202020207D20656C7365206966202873726358203C3D203029207B0A202020202020';
wwv_flow_api.g_varchar2_table(715) := '2020202064737458203D202D737263583B0A2020202020202020202073726358203D20303B0A202020202020202020207372635769647468203D206473745769647468203D206D696E28736F7572636557696474682C206F726967696E616C5769647468';
wwv_flow_api.g_varchar2_table(716) := '202B2073726358293B0A20202020202020207D20656C7365206966202873726358203C3D20736F75726365576964746829207B0A2020202020202020202064737458203D20303B0A202020202020202020207372635769647468203D2064737457696474';
wwv_flow_api.g_varchar2_table(717) := '68203D206D696E286F726967696E616C57696474682C20736F757263655769647468202D2073726358293B0A20202020202020207D0A0A2020202020202020696620287372635769647468203C3D2030207C7C2073726359203C3D202D6F726967696E61';
wwv_flow_api.g_varchar2_table(718) := '6C486569676874207C7C2073726359203E20736F7572636548656967687429207B0A2020202020202020202073726359203D20737263486569676874203D2064737459203D20647374486569676874203D20303B0A20202020202020207D20656C736520';
wwv_flow_api.g_varchar2_table(719) := '6966202873726359203C3D203029207B0A2020202020202020202064737459203D202D737263593B0A2020202020202020202073726359203D20303B0A20202020202020202020737263486569676874203D20647374486569676874203D206D696E2873';
wwv_flow_api.g_varchar2_table(720) := '6F757263654865696768742C206F726967696E616C486569676874202B2073726359293B0A20202020202020207D20656C7365206966202873726359203C3D20736F7572636548656967687429207B0A2020202020202020202064737459203D20303B0A';
wwv_flow_api.g_varchar2_table(721) := '20202020202020202020737263486569676874203D20647374486569676874203D206D696E286F726967696E616C4865696768742C20736F75726365486569676874202D2073726359293B0A20202020202020207D0A0A20202020202020202F2F20416C';
wwv_flow_api.g_varchar2_table(722) := '6C20746865206E756D65726963616C20706172616D65746572732073686F756C6420626520696E746567657220666F72206064726177496D61676560202823343736290A2020202020202020617267732E7075736828666C6F6F722873726358292C2066';
wwv_flow_api.g_varchar2_table(723) := '6C6F6F722873726359292C20666C6F6F72287372635769647468292C20666C6F6F722873726348656967687429293B0A0A20202020202020202F2F205363616C652064657374696E6174696F6E2073697A65730A2020202020202020696620287363616C';
wwv_flow_api.g_varchar2_table(724) := '6564526174696F29207B0A2020202020202020202064737458202A3D207363616C6564526174696F3B0A2020202020202020202064737459202A3D207363616C6564526174696F3B0A202020202020202020206473745769647468202A3D207363616C65';
wwv_flow_api.g_varchar2_table(725) := '64526174696F3B0A20202020202020202020647374486569676874202A3D207363616C6564526174696F3B0A20202020202020207D0A0A20202020202020202F2F2041766F69642022496E64657853697A654572726F722220696E20494520616E642046';
wwv_flow_api.g_varchar2_table(726) := '697265666F780A2020202020202020696620286473745769647468203E203020262620647374486569676874203E203029207B0A20202020202020202020617267732E7075736828666C6F6F722864737458292C20666C6F6F722864737459292C20666C';
wwv_flow_api.g_varchar2_table(727) := '6F6F72286473745769647468292C20666C6F6F722864737448656967687429293B0A20202020202020207D0A0A202020202020202072657475726E20617267733B0A2020202020207D292E63616C6C287468697329293B0A0A2020202020207265747572';
wwv_flow_api.g_varchar2_table(728) := '6E2063616E7661733B0A202020207D2C0A0A202020202F2A2A0A20202020202A204368616E6765207468652061737065637420726174696F206F66207468652063726F7020626F780A20202020202A0A20202020202A2040706172616D207B4E756D6265';
wwv_flow_api.g_varchar2_table(729) := '727D20617370656374526174696F0A20202020202A2F0A20202020736574417370656374526174696F3A2066756E6374696F6E2028617370656374526174696F29207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E73';
wwv_flow_api.g_varchar2_table(730) := '3B0A0A2020202020206966202821746869732E697344697361626C656420262620216973556E646566696E656428617370656374526174696F2929207B0A0A20202020202020202F2F2030202D3E204E614E0A20202020202020206F7074696F6E732E61';
wwv_flow_api.g_varchar2_table(731) := '7370656374526174696F203D206D617828302C20617370656374526174696F29207C7C204E614E3B0A0A202020202020202069662028746869732E69734275696C7429207B0A20202020202020202020746869732E696E697443726F70426F7828293B0A';
wwv_flow_api.g_varchar2_table(732) := '0A2020202020202020202069662028746869732E697343726F7070656429207B0A202020202020202020202020746869732E72656E64657243726F70426F7828293B0A202020202020202020207D0A20202020202020207D0A2020202020207D0A202020';
wwv_flow_api.g_varchar2_table(733) := '207D2C0A0A202020202F2A2A0A20202020202A204368616E6765207468652064726167206D6F64650A20202020202A0A20202020202A2040706172616D207B537472696E677D206D6F646520286F7074696F6E616C290A20202020202A2F0A2020202073';
wwv_flow_api.g_varchar2_table(734) := '6574447261674D6F64653A2066756E6374696F6E20286D6F646529207B0A202020202020766172206F7074696F6E73203D20746869732E6F7074696F6E733B0A2020202020207661722063726F707061626C653B0A202020202020766172206D6F766162';
wwv_flow_api.g_varchar2_table(735) := '6C653B0A0A20202020202069662028746869732E69734C6F616465642026262021746869732E697344697361626C656429207B0A202020202020202063726F707061626C65203D206D6F6465203D3D3D20414354494F4E5F43524F503B0A202020202020';
wwv_flow_api.g_varchar2_table(736) := '20206D6F7661626C65203D206F7074696F6E732E6D6F7661626C65202626206D6F6465203D3D3D20414354494F4E5F4D4F56453B0A20202020202020206D6F6465203D202863726F707061626C65207C7C206D6F7661626C6529203F206D6F6465203A20';
wwv_flow_api.g_varchar2_table(737) := '414354494F4E5F4E4F4E453B0A0A2020202020202020746869732E2464726167426F782E0A202020202020202020206461746128444154415F414354494F4E2C206D6F6465292E0A20202020202020202020746F67676C65436C61737328434C4153535F';
wwv_flow_api.g_varchar2_table(738) := '43524F502C2063726F707061626C65292E0A20202020202020202020746F67676C65436C61737328434C4153535F4D4F56452C206D6F7661626C65293B0A0A202020202020202069662028216F7074696F6E732E63726F70426F784D6F7661626C652920';
wwv_flow_api.g_varchar2_table(739) := '7B0A0A202020202020202020202F2F2053796E632064726167206D6F646520746F2063726F7020626F78207768656E206974206973206E6F74206D6F7661626C652823333030290A20202020202020202020746869732E24666163652E0A202020202020';
wwv_flow_api.g_varchar2_table(740) := '2020202020206461746128444154415F414354494F4E2C206D6F6465292E0A202020202020202020202020746F67676C65436C61737328434C4153535F43524F502C2063726F707061626C65292E0A202020202020202020202020746F67676C65436C61';
wwv_flow_api.g_varchar2_table(741) := '737328434C4153535F4D4F56452C206D6F7661626C65293B0A20202020202020207D0A2020202020207D0A202020207D0A20207D3B0A0A202043726F707065722E44454641554C5453203D207B0A0A202020202F2F20446566696E652074686520766965';
wwv_flow_api.g_varchar2_table(742) := '77206D6F6465206F66207468652063726F707065720A20202020766965774D6F64653A20302C202F2F20302C20312C20322C20330A0A202020202F2F20446566696E6520746865206472616767696E67206D6F6465206F66207468652063726F70706572';
wwv_flow_api.g_varchar2_table(743) := '0A20202020647261674D6F64653A202763726F70272C202F2F202763726F70272C20276D6F766527206F7220276E6F6E65270A0A202020202F2F20446566696E65207468652061737065637420726174696F206F66207468652063726F7020626F780A20';
wwv_flow_api.g_varchar2_table(744) := '202020617370656374526174696F3A204E614E2C0A0A202020202F2F20416E206F626A6563742077697468207468652070726576696F75732063726F7070696E6720726573756C7420646174610A20202020646174613A206E756C6C2C0A0A202020202F';
wwv_flow_api.g_varchar2_table(745) := '2F2041206A51756572792073656C6563746F7220666F7220616464696E6720657874726120636F6E7461696E65727320746F20707265766965770A20202020707265766965773A2027272C0A0A202020202F2F2052652D72656E64657220746865206372';
wwv_flow_api.g_varchar2_table(746) := '6F70706572207768656E20726573697A65207468652077696E646F770A20202020726573706F6E736976653A20747275652C0A0A202020202F2F20526573746F7265207468652063726F70706564206172656120616674657220726573697A6520746865';
wwv_flow_api.g_varchar2_table(747) := '2077696E646F770A20202020726573746F72653A20747275652C0A0A202020202F2F20436865636B206966207468652063757272656E7420696D61676520697320612063726F73732D6F726967696E20696D6167650A20202020636865636B43726F7373';
wwv_flow_api.g_varchar2_table(748) := '4F726967696E3A20747275652C0A0A202020202F2F20436865636B207468652063757272656E7420696D61676527732045786966204F7269656E746174696F6E20696E666F726D6174696F6E0A20202020636865636B4F7269656E746174696F6E3A2074';
wwv_flow_api.g_varchar2_table(749) := '7275652C0A0A202020202F2F2053686F772074686520626C61636B206D6F64616C0A202020206D6F64616C3A20747275652C0A0A202020202F2F2053686F772074686520646173686564206C696E657320666F722067756964696E670A20202020677569';
wwv_flow_api.g_varchar2_table(750) := '6465733A20747275652C0A0A202020202F2F2053686F77207468652063656E74657220696E64696361746F7220666F722067756964696E670A2020202063656E7465723A20747275652C0A0A202020202F2F2053686F7720746865207768697465206D6F';
wwv_flow_api.g_varchar2_table(751) := '64616C20746F20686967686C69676874207468652063726F7020626F780A20202020686967686C696768743A20747275652C0A0A202020202F2F2053686F77207468652067726964206261636B67726F756E640A202020206261636B67726F756E643A20';
wwv_flow_api.g_varchar2_table(752) := '747275652C0A0A202020202F2F20456E61626C6520746F2063726F702074686520696D616765206175746F6D61746963616C6C79207768656E20696E697469616C697A650A202020206175746F43726F703A20747275652C0A0A202020202F2F20446566';
wwv_flow_api.g_varchar2_table(753) := '696E65207468652070657263656E74616765206F66206175746F6D617469632063726F7070696E672061726561207768656E20696E697469616C697A65730A202020206175746F43726F70417265613A20302E382C0A0A202020202F2F20456E61626C65';
wwv_flow_api.g_varchar2_table(754) := '20746F206D6F76652074686520696D6167650A202020206D6F7661626C653A20747275652C0A0A202020202F2F20456E61626C6520746F20726F746174652074686520696D6167650A20202020726F74617461626C653A20747275652C0A0A202020202F';
wwv_flow_api.g_varchar2_table(755) := '2F20456E61626C6520746F207363616C652074686520696D6167650A202020207363616C61626C653A20747275652C0A0A202020202F2F20456E61626C6520746F207A6F6F6D2074686520696D6167650A202020207A6F6F6D61626C653A20747275652C';
wwv_flow_api.g_varchar2_table(756) := '0A0A202020202F2F20456E61626C6520746F207A6F6F6D2074686520696D616765206279206472616767696E6720746F7563680A202020207A6F6F6D4F6E546F7563683A20747275652C0A0A202020202F2F20456E61626C6520746F207A6F6F6D207468';
wwv_flow_api.g_varchar2_table(757) := '6520696D61676520627920776865656C696E67206D6F7573650A202020207A6F6F6D4F6E576865656C3A20747275652C0A0A202020202F2F20446566696E65207A6F6F6D20726174696F207768656E207A6F6F6D2074686520696D616765206279207768';
wwv_flow_api.g_varchar2_table(758) := '65656C696E67206D6F7573650A20202020776865656C5A6F6F6D526174696F3A20302E312C0A0A202020202F2F20456E61626C6520746F206D6F7665207468652063726F7020626F780A2020202063726F70426F784D6F7661626C653A20747275652C0A';
wwv_flow_api.g_varchar2_table(759) := '0A202020202F2F20456E61626C6520746F20726573697A65207468652063726F7020626F780A2020202063726F70426F78526573697A61626C653A20747275652C0A0A202020202F2F20546F67676C652064726167206D6F6465206265747765656E2022';
wwv_flow_api.g_varchar2_table(760) := '63726F702220616E6420226D6F766522207768656E20636C69636B207477696365206F6E207468652063726F707065720A20202020746F67676C65447261674D6F64654F6E44626C636C69636B3A20747275652C0A0A202020202F2F2053697A65206C69';
wwv_flow_api.g_varchar2_table(761) := '6D69746174696F6E0A202020206D696E43616E76617357696474683A20302C0A202020206D696E43616E7661734865696768743A20302C0A202020206D696E43726F70426F7857696474683A20302C0A202020206D696E43726F70426F78486569676874';
wwv_flow_api.g_varchar2_table(762) := '3A20302C0A202020206D696E436F6E7461696E657257696474683A203230302C0A202020206D696E436F6E7461696E65724865696768743A203130302C0A0A202020202F2F2053686F727463757473206F66206576656E74730A202020206275696C643A';
wwv_flow_api.g_varchar2_table(763) := '206E756C6C2C0A202020206275696C743A206E756C6C2C0A2020202063726F7073746172743A206E756C6C2C0A2020202063726F706D6F76653A206E756C6C2C0A2020202063726F70656E643A206E756C6C2C0A2020202063726F703A206E756C6C2C0A';
wwv_flow_api.g_varchar2_table(764) := '202020207A6F6F6D3A206E756C6C0A20207D3B0A0A202043726F707065722E73657444656661756C7473203D2066756E6374696F6E20286F7074696F6E7329207B0A20202020242E657874656E642843726F707065722E44454641554C54532C206F7074';
wwv_flow_api.g_varchar2_table(765) := '696F6E73293B0A20207D3B0A0A202043726F707065722E54454D504C415445203D20280A20202020273C64697620636C6173733D2263726F707065722D636F6E7461696E6572223E27202B0A202020202020273C64697620636C6173733D2263726F7070';
wwv_flow_api.g_varchar2_table(766) := '65722D777261702D626F78223E27202B0A2020202020202020273C64697620636C6173733D2263726F707065722D63616E766173223E3C2F6469763E27202B0A202020202020273C2F6469763E27202B0A202020202020273C64697620636C6173733D22';
wwv_flow_api.g_varchar2_table(767) := '63726F707065722D647261672D626F78223E3C2F6469763E27202B0A202020202020273C64697620636C6173733D2263726F707065722D63726F702D626F78223E27202B0A2020202020202020273C7370616E20636C6173733D2263726F707065722D76';
wwv_flow_api.g_varchar2_table(768) := '6965772D626F78223E3C2F7370616E3E27202B0A2020202020202020273C7370616E20636C6173733D2263726F707065722D646173686564206461736865642D68223E3C2F7370616E3E27202B0A2020202020202020273C7370616E20636C6173733D22';
wwv_flow_api.g_varchar2_table(769) := '63726F707065722D646173686564206461736865642D76223E3C2F7370616E3E27202B0A2020202020202020273C7370616E20636C6173733D2263726F707065722D63656E746572223E3C2F7370616E3E27202B0A2020202020202020273C7370616E20';
wwv_flow_api.g_varchar2_table(770) := '636C6173733D2263726F707065722D66616365223E3C2F7370616E3E27202B0A2020202020202020273C7370616E20636C6173733D2263726F707065722D6C696E65206C696E652D652220646174612D616374696F6E3D2265223E3C2F7370616E3E2720';
wwv_flow_api.g_varchar2_table(771) := '2B0A2020202020202020273C7370616E20636C6173733D2263726F707065722D6C696E65206C696E652D6E2220646174612D616374696F6E3D226E223E3C2F7370616E3E27202B0A2020202020202020273C7370616E20636C6173733D2263726F707065';
wwv_flow_api.g_varchar2_table(772) := '722D6C696E65206C696E652D772220646174612D616374696F6E3D2277223E3C2F7370616E3E27202B0A2020202020202020273C7370616E20636C6173733D2263726F707065722D6C696E65206C696E652D732220646174612D616374696F6E3D227322';
wwv_flow_api.g_varchar2_table(773) := '3E3C2F7370616E3E27202B0A2020202020202020273C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D652220646174612D616374696F6E3D2265223E3C2F7370616E3E27202B0A2020202020202020273C7370616E2063';
wwv_flow_api.g_varchar2_table(774) := '6C6173733D2263726F707065722D706F696E7420706F696E742D6E2220646174612D616374696F6E3D226E223E3C2F7370616E3E27202B0A2020202020202020273C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D7722';
wwv_flow_api.g_varchar2_table(775) := '20646174612D616374696F6E3D2277223E3C2F7370616E3E27202B0A2020202020202020273C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D732220646174612D616374696F6E3D2273223E3C2F7370616E3E27202B0A';
wwv_flow_api.g_varchar2_table(776) := '2020202020202020273C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D6E652220646174612D616374696F6E3D226E65223E3C2F7370616E3E27202B0A2020202020202020273C7370616E20636C6173733D2263726F70';
wwv_flow_api.g_varchar2_table(777) := '7065722D706F696E7420706F696E742D6E772220646174612D616374696F6E3D226E77223E3C2F7370616E3E27202B0A2020202020202020273C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D73772220646174612D61';
wwv_flow_api.g_varchar2_table(778) := '6374696F6E3D227377223E3C2F7370616E3E27202B0A2020202020202020273C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D73652220646174612D616374696F6E3D227365223E3C2F7370616E3E27202B0A20202020';
wwv_flow_api.g_varchar2_table(779) := '2020273C2F6469763E27202B0A20202020273C2F6469763E270A2020293B0A0A20202F2F205361766520746865206F746865722063726F707065720A202043726F707065722E6F74686572203D20242E666E2E63726F707065723B0A0A20202F2F205265';
wwv_flow_api.g_varchar2_table(780) := '676973746572206173206A517565727920706C7567696E0A2020242E666E2E63726F70706572203D2066756E6374696F6E20286F7074696F6E29207B0A202020207661722061726773203D20746F417272617928617267756D656E74732C2031293B0A20';
wwv_flow_api.g_varchar2_table(781) := '20202076617220726573756C743B0A0A20202020746869732E656163682866756E6374696F6E202829207B0A202020202020766172202474686973203D20242874686973293B0A2020202020207661722064617461203D2024746869732E64617461284E';
wwv_flow_api.g_varchar2_table(782) := '414D455350414345293B0A202020202020766172206F7074696F6E733B0A20202020202076617220666E3B0A0A20202020202069662028216461746129207B0A2020202020202020696620282F64657374726F792F2E74657374286F7074696F6E292920';
wwv_flow_api.g_varchar2_table(783) := '7B0A2020202020202020202072657475726E3B0A20202020202020207D0A0A20202020202020206F7074696F6E73203D20242E657874656E64287B7D2C2024746869732E6461746128292C20242E6973506C61696E4F626A656374286F7074696F6E2920';
wwv_flow_api.g_varchar2_table(784) := '2626206F7074696F6E293B0A202020202020202024746869732E64617461284E414D4553504143452C202864617461203D206E65772043726F7070657228746869732C206F7074696F6E732929293B0A2020202020207D0A0A2020202020206966202874';
wwv_flow_api.g_varchar2_table(785) := '7970656F66206F7074696F6E203D3D3D2027737472696E672720262620242E697346756E6374696F6E28666E203D20646174615B6F7074696F6E5D2929207B0A2020202020202020726573756C74203D20666E2E6170706C7928646174612C2061726773';
wwv_flow_api.g_varchar2_table(786) := '293B0A2020202020207D0A202020207D293B0A0A2020202072657475726E206973556E646566696E656428726573756C7429203F2074686973203A20726573756C743B0A20207D3B0A0A2020242E666E2E63726F707065722E436F6E7374727563746F72';
wwv_flow_api.g_varchar2_table(787) := '203D2043726F707065723B0A2020242E666E2E63726F707065722E73657444656661756C7473203D2043726F707065722E73657444656661756C74733B0A0A20202F2F204E6F20636F6E666C6963740A2020242E666E2E63726F707065722E6E6F436F6E';
wwv_flow_api.g_varchar2_table(788) := '666C696374203D2066756E6374696F6E202829207B0A20202020242E666E2E63726F70706572203D2043726F707065722E6F746865723B0A2020202072657475726E20746869733B0A20207D3B0A0A7D293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(56080226996500515)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_file_name=>'js/cropper.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A210A202A2043726F707065722076322E322E350A202A2068747470733A2F2F6769746875622E636F6D2F66656E677975616E6368656E2F63726F707065720A202A0A202A20436F707972696768742028632920323031342D323031362046656E6779';
wwv_flow_api.g_varchar2_table(2) := '75616E204368656E20616E6420636F6E7472696275746F72730A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A0A202A20446174653A20323031362D30312D31385430353A34323A35302E3830305A0A202A2F';
wwv_flow_api.g_varchar2_table(3) := '0A2166756E6374696F6E2874297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279225D2C74293A7428226F626A656374223D3D747970656F66206578706F7274733F';
wwv_flow_api.g_varchar2_table(4) := '7265717569726528226A717565727922293A6A5175657279297D2866756E6374696F6E2874297B2275736520737472696374223B66756E6374696F6E20692874297B72657475726E226E756D626572223D3D747970656F66207426262169734E614E2874';
wwv_flow_api.g_varchar2_table(5) := '297D66756E6374696F6E20652874297B72657475726E22756E646566696E6564223D3D747970656F6620747D66756E6374696F6E207328742C65297B76617220733D5B5D3B72657475726E20692865292626732E707573682865292C732E736C6963652E';
wwv_flow_api.g_varchar2_table(6) := '6170706C7928742C73297D66756E6374696F6E206128742C69297B76617220653D7328617267756D656E74732C32293B72657475726E2066756E6374696F6E28297B72657475726E20742E6170706C7928692C652E636F6E636174287328617267756D65';
wwv_flow_api.g_varchar2_table(7) := '6E74732929297D7D66756E6374696F6E206F2874297B76617220693D742E6D61746368282F5E2868747470733F3A295C2F5C2F285B5E5C3A5C2F5C3F235D2B293A3F285C642A292F69293B72657475726E2069262628695B315D213D3D432E70726F746F';
wwv_flow_api.g_varchar2_table(8) := '636F6C7C7C695B325D213D3D432E686F73746E616D657C7C695B335D213D3D432E706F7274297D66756E6374696F6E20682874297B76617220693D2274696D657374616D703D222B286E65772044617465292E67657454696D6528293B72657475726E20';
wwv_flow_api.g_varchar2_table(9) := '742B282D313D3D3D742E696E6465784F6628223F22293F223F223A222622292B697D66756E6374696F6E206E2874297B72657475726E20743F272063726F73734F726967696E3D22272B742B2722273A22227D66756E6374696F6E207228742C69297B76';
wwv_flow_api.g_varchar2_table(10) := '617220653B72657475726E20742E6E61747572616C57696474683F6928742E6E61747572616C57696474682C742E6E61747572616C486569676874293A28653D646F63756D656E742E637265617465456C656D656E742822696D6722292C652E6F6E6C6F';
wwv_flow_api.g_varchar2_table(11) := '61643D66756E6374696F6E28297B6928746869732E77696474682C746869732E686569676874297D2C766F696428652E7372633D742E73726329297D66756E6374696F6E20702874297B76617220653D5B5D2C733D742E726F746174652C613D742E7363';
wwv_flow_api.g_varchar2_table(12) := '616C65582C6F3D742E7363616C65593B72657475726E20692873292626652E707573682822726F7461746528222B732B226465672922292C69286129262669286F292626652E7075736828227363616C6528222B612B222C222B6F2B222922292C652E6C';
wwv_flow_api.g_varchar2_table(13) := '656E6774683F652E6A6F696E28222022293A226E6F6E65227D66756E6374696F6E206C28742C69297B76617220652C732C613D777428742E64656772656529253138302C6F3D28613E39303F3138302D613A61292A4D6174682E50492F3138302C683D78';
wwv_flow_api.g_varchar2_table(14) := '74286F292C6E3D4374286F292C723D742E77696474682C703D742E6865696768742C6C3D742E617370656374526174696F3B72657475726E20693F28653D722F286E2B682F6C292C733D652F6C293A28653D722A6E2B702A682C733D722A682B702A6E29';
wwv_flow_api.g_varchar2_table(15) := '2C7B77696474683A652C6865696768743A737D7D66756E6374696F6E206328652C73297B76617220612C6F2C682C6E3D7428223C63616E7661733E22295B305D2C723D6E2E676574436F6E746578742822326422292C703D302C633D302C643D732E6E61';
wwv_flow_api.g_varchar2_table(16) := '747572616C57696474682C673D732E6E61747572616C4865696768742C753D732E726F746174652C663D732E7363616C65582C6D3D732E7363616C65592C763D69286629262669286D2926262831213D3D667C7C31213D3D6D292C773D69287529262630';
wwv_flow_api.g_varchar2_table(17) := '213D3D752C783D777C7C762C433D642C623D673B72657475726E2076262628613D642F322C6F3D672F32292C77262628683D6C287B77696474683A642C6865696768743A672C6465677265653A757D292C433D682E77696474682C623D682E6865696768';
wwv_flow_api.g_varchar2_table(18) := '742C613D682E77696474682F322C6F3D682E6865696768742F32292C6E2E77696474683D432C6E2E6865696768743D622C78262628703D2D642F322C633D2D672F322C722E7361766528292C722E7472616E736C61746528612C6F29292C772626722E72';
wwv_flow_api.g_varchar2_table(19) := '6F7461746528752A4D6174682E50492F313830292C762626722E7363616C6528662C6D292C722E64726177496D61676528652C79742870292C79742863292C79742864292C7974286729292C782626722E726573746F726528292C6E7D66756E6374696F';
wwv_flow_api.g_varchar2_table(20) := '6E20642869297B76617220653D692E6C656E6774682C733D302C613D303B72657475726E2065262628742E6561636828692C66756E6374696F6E28742C69297B732B3D692E70616765582C612B3D692E70616765597D292C732F3D652C612F3D65292C7B';
wwv_flow_api.g_varchar2_table(21) := '70616765583A732C70616765593A617D7D66756E6374696F6E206728742C692C65297B76617220732C613D22223B666F7228733D692C652B3D693B653E733B732B2B29612B3D447428742E67657455696E7438287329293B72657475726E20617D66756E';
wwv_flow_api.g_varchar2_table(22) := '6374696F6E20752874297B76617220692C652C732C612C6F2C682C6E2C722C702C6C2C633D6E657720792874292C643D632E627974654C656E6774683B6966283235353D3D3D632E67657455696E743828302926263231363D3D3D632E67657455696E74';
wwv_flow_api.g_varchar2_table(23) := '3828312929666F7228703D323B643E703B297B6966283235353D3D3D632E67657455696E743828702926263232353D3D3D632E67657455696E743828702B3129297B6E3D703B627265616B7D702B2B7D6966286E262628653D6E2B342C733D6E2B31302C';
wwv_flow_api.g_varchar2_table(24) := '2245786966223D3D3D6728632C652C3429262628683D632E67657455696E7431362873292C6F3D31383736313D3D3D682C286F7C7C31393738393D3D3D6829262634323D3D3D632E67657455696E74313628732B322C6F29262628613D632E6765745569';
wwv_flow_api.g_varchar2_table(25) := '6E74333228732B342C6F292C613E3D38262628723D732B61292929292C7229666F7228643D632E67657455696E74313628722C6F292C6C3D303B643E6C3B6C2B2B29696628703D722B31322A6C2B322C3237343D3D3D632E67657455696E74313628702C';
wwv_flow_api.g_varchar2_table(26) := '6F29297B702B3D382C693D632E67657455696E74313628702C6F292C632E73657455696E74313628702C312C6F293B627265616B7D72657475726E20697D66756E6374696F6E20662874297B76617220692C653D742E7265706C61636528562C2222292C';
wwv_flow_api.g_varchar2_table(27) := '733D61746F622865292C613D732E6C656E6774682C6F3D6E657720622861292C683D6E65772042286F293B666F7228693D303B613E693B692B2B29685B695D3D732E63686172436F646541742869293B72657475726E206F7D66756E6374696F6E206D28';
wwv_flow_api.g_varchar2_table(28) := '74297B76617220692C653D6E657720422874292C733D652E6C656E6774682C613D22223B666F7228693D303B733E693B692B2B29612B3D447428655B695D293B72657475726E22646174613A696D6167652F6A7065673B6261736536342C222B44286129';
wwv_flow_api.g_varchar2_table(29) := '7D66756E6374696F6E207628692C65297B746869732E24656C656D656E743D742869292C746869732E6F7074696F6E733D742E657874656E64287B7D2C762E44454641554C54532C742E6973506C61696E4F626A656374286529262665292C746869732E';
wwv_flow_api.g_varchar2_table(30) := '69734C6F616465643D21312C746869732E69734275696C743D21312C746869732E6973436F6D706C657465643D21312C746869732E6973526F74617465643D21312C746869732E697343726F707065643D21312C746869732E697344697361626C65643D';
wwv_flow_api.g_varchar2_table(31) := '21312C746869732E69735265706C616365643D21312C746869732E69734C696D697465643D21312C746869732E776865656C696E673D21312C746869732E6973496D673D21312C746869732E6F726967696E616C55726C3D22222C746869732E63616E76';
wwv_flow_api.g_varchar2_table(32) := '61733D6E756C6C2C746869732E63726F70426F783D6E756C6C2C746869732E696E697428297D76617220773D742877696E646F77292C783D7428646F63756D656E74292C433D77696E646F772E6C6F636174696F6E2C623D77696E646F772E4172726179';
wwv_flow_api.g_varchar2_table(33) := '4275666665722C423D77696E646F772E55696E743841727261792C793D77696E646F772E44617461566965772C443D77696E646F772E62746F612C243D2263726F70706572222C4C3D2263726F707065722D6D6F64616C222C543D2263726F707065722D';
wwv_flow_api.g_varchar2_table(34) := '68696465222C583D2263726F707065722D68696464656E222C593D2263726F707065722D696E76697369626C65222C6B3D2263726F707065722D6D6F7665222C4D3D2263726F707065722D63726F70222C573D2263726F707065722D64697361626C6564';
wwv_flow_api.g_varchar2_table(35) := '222C523D2263726F707065722D6267222C483D226D6F757365646F776E20746F756368737461727420706F696E746572646F776E204D53506F696E746572446F776E222C7A3D226D6F7573656D6F766520746F7563686D6F766520706F696E7465726D6F';
wwv_flow_api.g_varchar2_table(36) := '7665204D53506F696E7465724D6F7665222C4F3D226D6F757365757020746F756368656E6420746F75636863616E63656C20706F696E746572757020706F696E74657263616E63656C204D53506F696E7465725570204D53506F696E74657243616E6365';
wwv_flow_api.g_varchar2_table(37) := '6C222C453D22776865656C206D6F757365776865656C20444F4D4D6F7573655363726F6C6C222C503D2264626C636C69636B222C553D226C6F61642E222B242C493D226572726F722E222B242C463D22726573697A652E222B242C6A3D226275696C642E';
wwv_flow_api.g_varchar2_table(38) := '222B242C533D226275696C742E222B242C413D2263726F7073746172742E222B242C4E3D2263726F706D6F76652E222B242C5F3D2263726F70656E642E222B242C713D2263726F702E222B242C5A3D227A6F6F6D2E222B242C4B3D2F657C777C737C6E7C';
wwv_flow_api.g_varchar2_table(39) := '73657C73777C6E657C6E777C616C6C7C63726F707C6D6F76657C7A6F6F6D2F2C513D2F5E646174615C3A2F2C563D2F5E646174615C3A285B5E5C3B5D2B295C3B6261736536342C2F2C473D2F5E646174615C3A696D6167655C2F6A7065672E2A3B626173';
wwv_flow_api.g_varchar2_table(40) := '6536342C2F2C4A3D2270726576696577222C74743D22616374696F6E222C69743D2265222C65743D2277222C73743D2273222C61743D226E222C6F743D227365222C68743D227377222C6E743D226E65222C72743D226E77222C70743D22616C6C222C6C';
wwv_flow_api.g_varchar2_table(41) := '743D2263726F70222C63743D226D6F7665222C64743D227A6F6F6D222C67743D226E6F6E65222C75743D742E697346756E6374696F6E287428223C63616E7661733E22295B305D2E676574436F6E74657874292C66743D4E756D6265722C6D743D4D6174';
wwv_flow_api.g_varchar2_table(42) := '682E6D696E2C76743D4D6174682E6D61782C77743D4D6174682E6162732C78743D4D6174682E73696E2C43743D4D6174682E636F732C62743D4D6174682E737172742C42743D4D6174682E726F756E642C79743D4D6174682E666C6F6F722C44743D5374';
wwv_flow_api.g_varchar2_table(43) := '72696E672E66726F6D43686172436F64653B762E70726F746F747970653D7B636F6E7374727563746F723A762C696E69743A66756E6374696F6E28297B76617220742C693D746869732E24656C656D656E743B696628692E69732822696D672229297B69';
wwv_flow_api.g_varchar2_table(44) := '6628746869732E6973496D673D21302C746869732E6F726967696E616C55726C3D743D692E61747472282273726322292C21742972657475726E3B743D692E70726F70282273726322297D656C736520692E6973282263616E7661732229262675742626';
wwv_flow_api.g_varchar2_table(45) := '28743D695B305D2E746F4461746155524C2829293B746869732E6C6F61642874297D2C747269676765723A66756E6374696F6E28692C65297B76617220733D742E4576656E7428692C65293B72657475726E20746869732E24656C656D656E742E747269';
wwv_flow_api.g_varchar2_table(46) := '676765722873292C737D2C6C6F61643A66756E6374696F6E2869297B76617220652C732C613D746869732E6F7074696F6E732C6F3D746869732E24656C656D656E743B696628692626286F2E6F6E65286A2C612E6275696C64292C21746869732E747269';
wwv_flow_api.g_varchar2_table(47) := '67676572286A292E697344656661756C7450726576656E746564282929297B696628746869732E75726C3D692C746869732E696D6167653D7B7D2C21612E636865636B4F7269656E746174696F6E7C7C21622972657475726E20746869732E636C6F6E65';
wwv_flow_api.g_varchar2_table(48) := '28293B696628653D742E70726F787928746869732E726561642C74686973292C512E746573742869292972657475726E20472E746573742869293F652866286929293A746869732E636C6F6E6528293B733D6E657720584D4C4874747052657175657374';
wwv_flow_api.g_varchar2_table(49) := '2C732E6F6E6572726F723D732E6F6E61626F72743D742E70726F78792866756E6374696F6E28297B746869732E636C6F6E6528297D2C74686973292C732E6F6E6C6F61643D66756E6374696F6E28297B6528746869732E726573706F6E7365297D2C732E';
wwv_flow_api.g_varchar2_table(50) := '6F70656E2822676574222C69292C732E726573706F6E7365547970653D226172726179627566666572222C732E73656E6428297D7D2C726561643A66756E6374696F6E2874297B76617220692C652C732C613D746869732E6F7074696F6E732C6F3D7528';
wwv_flow_api.g_varchar2_table(51) := '74292C683D746869732E696D6167653B6966286F3E312973776974636828746869732E75726C3D6D2874292C6F297B6361736520323A653D2D313B627265616B3B6361736520333A693D2D3138303B627265616B3B6361736520343A733D2D313B627265';
wwv_flow_api.g_varchar2_table(52) := '616B3B6361736520353A693D39302C733D2D313B627265616B3B6361736520363A693D39303B627265616B3B6361736520373A693D39302C653D2D313B627265616B3B6361736520383A693D2D39307D612E726F74617461626C65262628682E726F7461';
wwv_flow_api.g_varchar2_table(53) := '74653D69292C612E7363616C61626C65262628682E7363616C65583D652C682E7363616C65593D73292C746869732E636C6F6E6528297D2C636C6F6E653A66756E6374696F6E28297B76617220692C652C733D746869732E6F7074696F6E732C613D7468';
wwv_flow_api.g_varchar2_table(54) := '69732E24656C656D656E742C723D746869732E75726C2C703D22223B732E636865636B43726F73734F726967696E26266F287229262628703D612E70726F70282263726F73734F726967696E22292C703F693D723A28703D22616E6F6E796D6F7573222C';
wwv_flow_api.g_varchar2_table(55) := '693D6828722929292C746869732E63726F73734F726967696E3D702C746869732E63726F73734F726967696E55726C3D692C746869732E24636C6F6E653D653D7428223C696D67222B6E2870292B27207372633D22272B28697C7C72292B27223E27292C';
wwv_flow_api.g_varchar2_table(56) := '746869732E6973496D673F615B305D2E636F6D706C6574653F746869732E737461727428293A612E6F6E6528552C742E70726F787928746869732E73746172742C7468697329293A652E6F6E6528552C742E70726F787928746869732E73746172742C74';
wwv_flow_api.g_varchar2_table(57) := '68697329292E6F6E6528492C742E70726F787928746869732E73746F702C7468697329292E616464436C6173732854292E696E7365727441667465722861297D2C73746172743A66756E6374696F6E28297B76617220693D746869732E24656C656D656E';
wwv_flow_api.g_varchar2_table(58) := '742C653D746869732E24636C6F6E653B746869732E6973496D677C7C28652E6F666628492C746869732E73746F70292C693D65292C7228695B305D2C742E70726F78792866756E6374696F6E28692C65297B742E657874656E6428746869732E696D6167';
wwv_flow_api.g_varchar2_table(59) := '652C7B6E61747572616C57696474683A692C6E61747572616C4865696768743A652C617370656374526174696F3A692F657D292C746869732E69734C6F616465643D21302C746869732E6275696C6428297D2C7468697329297D2C73746F703A66756E63';
wwv_flow_api.g_varchar2_table(60) := '74696F6E28297B746869732E24636C6F6E652E72656D6F766528292C746869732E24636C6F6E653D6E756C6C7D2C6275696C643A66756E6374696F6E28297B76617220692C652C732C613D746869732E6F7074696F6E732C6F3D746869732E24656C656D';
wwv_flow_api.g_varchar2_table(61) := '656E742C683D746869732E24636C6F6E653B746869732E69734C6F61646564262628746869732E69734275696C742626746869732E756E6275696C6428292C746869732E24636F6E7461696E65723D6F2E706172656E7428292C746869732E2463726F70';
wwv_flow_api.g_varchar2_table(62) := '7065723D693D7428762E54454D504C415445292C746869732E2463616E7661733D692E66696E6428222E63726F707065722D63616E76617322292E617070656E642868292C746869732E2464726167426F783D692E66696E6428222E63726F707065722D';
wwv_flow_api.g_varchar2_table(63) := '647261672D626F7822292C746869732E2463726F70426F783D653D692E66696E6428222E63726F707065722D63726F702D626F7822292C746869732E2476696577426F783D692E66696E6428222E63726F707065722D766965772D626F7822292C746869';
wwv_flow_api.g_varchar2_table(64) := '732E24666163653D733D652E66696E6428222E63726F707065722D6661636522292C6F2E616464436C6173732858292E61667465722869292C746869732E6973496D677C7C682E72656D6F7665436C6173732854292C746869732E696E69745072657669';
wwv_flow_api.g_varchar2_table(65) := '657728292C746869732E62696E6428292C612E617370656374526174696F3D767428302C612E617370656374526174696F297C7C4E614E2C612E766965774D6F64653D767428302C6D7428332C427428612E766965774D6F64652929297C7C302C612E61';
wwv_flow_api.g_varchar2_table(66) := '75746F43726F703F28746869732E697343726F707065643D21302C612E6D6F64616C2626746869732E2464726167426F782E616464436C617373284C29293A652E616464436C6173732858292C612E6775696465737C7C652E66696E6428222E63726F70';
wwv_flow_api.g_varchar2_table(67) := '7065722D64617368656422292E616464436C6173732858292C612E63656E7465727C7C652E66696E6428222E63726F707065722D63656E74657222292E616464436C6173732858292C612E63726F70426F784D6F7661626C652626732E616464436C6173';
wwv_flow_api.g_varchar2_table(68) := '73286B292E646174612874742C7074292C612E686967686C696768747C7C732E616464436C6173732859292C612E6261636B67726F756E642626692E616464436C6173732852292C612E63726F70426F78526573697A61626C657C7C652E66696E642822';
wwv_flow_api.g_varchar2_table(69) := '2E63726F707065722D6C696E652C202E63726F707065722D706F696E7422292E616464436C6173732858292C746869732E736574447261674D6F646528612E647261674D6F6465292C746869732E72656E64657228292C746869732E69734275696C743D';
wwv_flow_api.g_varchar2_table(70) := '21302C746869732E7365744461746128612E64617461292C6F2E6F6E6528532C612E6275696C74292C73657454696D656F757428742E70726F78792866756E6374696F6E28297B746869732E747269676765722853292C746869732E6973436F6D706C65';
wwv_flow_api.g_varchar2_table(71) := '7465643D21307D2C74686973292C3029297D2C756E6275696C643A66756E6374696F6E28297B746869732E69734275696C74262628746869732E69734275696C743D21312C746869732E6973436F6D706C657465643D21312C746869732E696E69746961';
wwv_flow_api.g_varchar2_table(72) := '6C496D6167653D6E756C6C2C746869732E696E697469616C43616E7661733D6E756C6C2C746869732E696E697469616C43726F70426F783D6E756C6C2C746869732E636F6E7461696E65723D6E756C6C2C746869732E63616E7661733D6E756C6C2C7468';
wwv_flow_api.g_varchar2_table(73) := '69732E63726F70426F783D6E756C6C2C746869732E756E62696E6428292C746869732E72657365745072657669657728292C746869732E24707265766965773D6E756C6C2C746869732E2476696577426F783D6E756C6C2C746869732E2463726F70426F';
wwv_flow_api.g_varchar2_table(74) := '783D6E756C6C2C746869732E2464726167426F783D6E756C6C2C746869732E2463616E7661733D6E756C6C2C746869732E24636F6E7461696E65723D6E756C6C2C746869732E2463726F707065722E72656D6F766528292C746869732E2463726F707065';
wwv_flow_api.g_varchar2_table(75) := '723D6E756C6C297D2C72656E6465723A66756E6374696F6E28297B746869732E696E6974436F6E7461696E657228292C746869732E696E697443616E76617328292C746869732E696E697443726F70426F7828292C746869732E72656E64657243616E76';
wwv_flow_api.g_varchar2_table(76) := '617328292C746869732E697343726F707065642626746869732E72656E64657243726F70426F7828297D2C696E6974436F6E7461696E65723A66756E6374696F6E28297B76617220743D746869732E6F7074696F6E732C693D746869732E24656C656D65';
wwv_flow_api.g_varchar2_table(77) := '6E742C653D746869732E24636F6E7461696E65722C733D746869732E2463726F707065723B732E616464436C6173732858292C692E72656D6F7665436C6173732858292C732E63737328746869732E636F6E7461696E65723D7B77696474683A76742865';
wwv_flow_api.g_varchar2_table(78) := '2E776964746828292C667428742E6D696E436F6E7461696E65725769647468297C7C323030292C6865696768743A767428652E68656967687428292C667428742E6D696E436F6E7461696E6572486569676874297C7C313030297D292C692E616464436C';
wwv_flow_api.g_varchar2_table(79) := '6173732858292C732E72656D6F7665436C6173732858297D2C696E697443616E7661733A66756E6374696F6E28297B76617220692C653D746869732E6F7074696F6E732E766965774D6F64652C733D746869732E636F6E7461696E65722C613D732E7769';
wwv_flow_api.g_varchar2_table(80) := '6474682C6F3D732E6865696768742C683D746869732E696D6167652C6E3D682E6E61747572616C57696474682C723D682E6E61747572616C4865696768742C703D39303D3D3D777428682E726F74617465292C6C3D703F723A6E2C633D703F6E3A722C64';
wwv_flow_api.g_varchar2_table(81) := '3D6C2F632C673D612C753D6F3B6F2A643E613F333D3D3D653F673D6F2A643A753D612F643A333D3D3D653F753D612F643A673D6F2A642C693D7B6E61747572616C57696474683A6C2C6E61747572616C4865696768743A632C617370656374526174696F';
wwv_flow_api.g_varchar2_table(82) := '3A642C77696474683A672C6865696768743A757D2C692E6F6C644C6566743D692E6C6566743D28612D67292F322C692E6F6C64546F703D692E746F703D286F2D75292F322C746869732E63616E7661733D692C746869732E69734C696D697465643D313D';
wwv_flow_api.g_varchar2_table(83) := '3D3D657C7C323D3D3D652C746869732E6C696D697443616E7661732821302C2130292C746869732E696E697469616C496D6167653D742E657874656E64287B7D2C68292C746869732E696E697469616C43616E7661733D742E657874656E64287B7D2C69';
wwv_flow_api.g_varchar2_table(84) := '297D2C6C696D697443616E7661733A66756E6374696F6E28742C69297B76617220652C732C612C6F2C683D746869732E6F7074696F6E732C6E3D682E766965774D6F64652C723D746869732E636F6E7461696E65722C703D722E77696474682C6C3D722E';
wwv_flow_api.g_varchar2_table(85) := '6865696768742C633D746869732E63616E7661732C643D632E617370656374526174696F2C673D746869732E63726F70426F782C753D746869732E697343726F707065642626673B74262628653D667428682E6D696E43616E7661735769647468297C7C';
wwv_flow_api.g_varchar2_table(86) := '302C733D667428682E6D696E43616E766173486569676874297C7C302C6E2626286E3E313F28653D767428652C70292C733D767428732C6C292C333D3D3D6E262628732A643E653F653D732A643A733D652F6429293A653F653D767428652C753F672E77';
wwv_flow_api.g_varchar2_table(87) := '696474683A30293A733F733D767428732C753F672E6865696768743A30293A75262628653D672E77696474682C733D672E6865696768742C732A643E653F653D732A643A733D652F6429292C652626733F732A643E653F733D652F643A653D732A643A65';
wwv_flow_api.g_varchar2_table(88) := '3F733D652F643A73262628653D732A64292C632E6D696E57696474683D652C632E6D696E4865696768743D732C632E6D617857696474683D312F302C632E6D61784865696768743D312F30292C692626286E3F28613D702D632E77696474682C6F3D6C2D';
wwv_flow_api.g_varchar2_table(89) := '632E6865696768742C632E6D696E4C6566743D6D7428302C61292C632E6D696E546F703D6D7428302C6F292C632E6D61784C6566743D767428302C61292C632E6D6178546F703D767428302C6F292C752626746869732E69734C696D6974656426262863';
wwv_flow_api.g_varchar2_table(90) := '2E6D696E4C6566743D6D7428672E6C6566742C672E6C6566742B672E77696474682D632E7769647468292C632E6D696E546F703D6D7428672E746F702C672E746F702B672E6865696768742D632E686569676874292C632E6D61784C6566743D672E6C65';
wwv_flow_api.g_varchar2_table(91) := '66742C632E6D6178546F703D672E746F702C323D3D3D6E262628632E77696474683E3D70262628632E6D696E4C6566743D6D7428302C61292C632E6D61784C6566743D767428302C6129292C632E6865696768743E3D6C262628632E6D696E546F703D6D';
wwv_flow_api.g_varchar2_table(92) := '7428302C6F292C632E6D6178546F703D767428302C6F29292929293A28632E6D696E4C6566743D2D632E77696474682C632E6D696E546F703D2D632E6865696768742C632E6D61784C6566743D702C632E6D6178546F703D6C29297D2C72656E64657243';
wwv_flow_api.g_varchar2_table(93) := '616E7661733A66756E6374696F6E2874297B76617220692C652C733D746869732E63616E7661732C613D746869732E696D6167652C6F3D612E726F746174652C683D612E6E61747572616C57696474682C6E3D612E6E61747572616C4865696768743B74';
wwv_flow_api.g_varchar2_table(94) := '6869732E6973526F7461746564262628746869732E6973526F74617465643D21312C653D6C287B77696474683A612E77696474682C6865696768743A612E6865696768742C6465677265653A6F7D292C693D652E77696474682F652E6865696768742C69';
wwv_flow_api.g_varchar2_table(95) := '213D3D732E617370656374526174696F262628732E6C6566742D3D28652E77696474682D732E7769647468292F322C732E746F702D3D28652E6865696768742D732E686569676874292F322C732E77696474683D652E77696474682C732E686569676874';
wwv_flow_api.g_varchar2_table(96) := '3D652E6865696768742C732E617370656374526174696F3D692C732E6E61747572616C57696474683D682C732E6E61747572616C4865696768743D6E2C6F25313830262628653D6C287B77696474683A682C6865696768743A6E2C6465677265653A6F7D';
wwv_flow_api.g_varchar2_table(97) := '292C732E6E61747572616C57696474683D652E77696474682C732E6E61747572616C4865696768743D652E686569676874292C746869732E6C696D697443616E7661732821302C21312929292C28732E77696474683E732E6D617857696474687C7C732E';
wwv_flow_api.g_varchar2_table(98) := '77696474683C732E6D696E576964746829262628732E6C6566743D732E6F6C644C656674292C28732E6865696768743E732E6D61784865696768747C7C732E6865696768743C732E6D696E48656967687429262628732E746F703D732E6F6C64546F7029';
wwv_flow_api.g_varchar2_table(99) := '2C732E77696474683D6D7428767428732E77696474682C732E6D696E5769647468292C732E6D61785769647468292C732E6865696768743D6D7428767428732E6865696768742C732E6D696E486569676874292C732E6D6178486569676874292C746869';
wwv_flow_api.g_varchar2_table(100) := '732E6C696D697443616E7661732821312C2130292C732E6F6C644C6566743D732E6C6566743D6D7428767428732E6C6566742C732E6D696E4C656674292C732E6D61784C656674292C732E6F6C64546F703D732E746F703D6D7428767428732E746F702C';
wwv_flow_api.g_varchar2_table(101) := '732E6D696E546F70292C732E6D6178546F70292C746869732E2463616E7661732E637373287B77696474683A732E77696474682C6865696768743A732E6865696768742C6C6566743A732E6C6566742C746F703A732E746F707D292C746869732E72656E';
wwv_flow_api.g_varchar2_table(102) := '646572496D61676528292C746869732E697343726F707065642626746869732E69734C696D697465642626746869732E6C696D697443726F70426F782821302C2130292C742626746869732E6F757470757428297D2C72656E646572496D6167653A6675';
wwv_flow_api.g_varchar2_table(103) := '6E6374696F6E2869297B76617220652C733D746869732E63616E7661732C613D746869732E696D6167653B612E726F74617465262628653D6C287B77696474683A732E77696474682C6865696768743A732E6865696768742C6465677265653A612E726F';
wwv_flow_api.g_varchar2_table(104) := '746174652C617370656374526174696F3A612E617370656374526174696F7D2C213029292C742E657874656E6428612C653F7B77696474683A652E77696474682C6865696768743A652E6865696768742C6C6566743A28732E77696474682D652E776964';
wwv_flow_api.g_varchar2_table(105) := '7468292F322C746F703A28732E6865696768742D652E686569676874292F327D3A7B77696474683A732E77696474682C6865696768743A732E6865696768742C6C6566743A302C746F703A307D292C746869732E24636C6F6E652E637373287B77696474';
wwv_flow_api.g_varchar2_table(106) := '683A612E77696474682C6865696768743A612E6865696768742C6D617267696E4C6566743A612E6C6566742C6D617267696E546F703A612E746F702C7472616E73666F726D3A702861297D292C692626746869732E6F757470757428297D2C696E697443';
wwv_flow_api.g_varchar2_table(107) := '726F70426F783A66756E6374696F6E28297B76617220693D746869732E6F7074696F6E732C653D746869732E63616E7661732C733D692E617370656374526174696F2C613D667428692E6175746F43726F7041726561297C7C2E382C6F3D7B7769647468';
wwv_flow_api.g_varchar2_table(108) := '3A652E77696474682C6865696768743A652E6865696768747D3B73262628652E6865696768742A733E652E77696474683F6F2E6865696768743D6F2E77696474682F733A6F2E77696474683D6F2E6865696768742A73292C746869732E63726F70426F78';
wwv_flow_api.g_varchar2_table(109) := '3D6F2C746869732E6C696D697443726F70426F782821302C2130292C6F2E77696474683D6D74287674286F2E77696474682C6F2E6D696E5769647468292C6F2E6D61785769647468292C6F2E6865696768743D6D74287674286F2E6865696768742C6F2E';
wwv_flow_api.g_varchar2_table(110) := '6D696E486569676874292C6F2E6D6178486569676874292C6F2E77696474683D7674286F2E6D696E57696474682C6F2E77696474682A61292C6F2E6865696768743D7674286F2E6D696E4865696768742C6F2E6865696768742A61292C6F2E6F6C644C65';
wwv_flow_api.g_varchar2_table(111) := '66743D6F2E6C6566743D652E6C6566742B28652E77696474682D6F2E7769647468292F322C6F2E6F6C64546F703D6F2E746F703D652E746F702B28652E6865696768742D6F2E686569676874292F322C746869732E696E697469616C43726F70426F783D';
wwv_flow_api.g_varchar2_table(112) := '742E657874656E64287B7D2C6F297D2C6C696D697443726F70426F783A66756E6374696F6E28742C69297B76617220652C732C612C6F2C683D746869732E6F7074696F6E732C6E3D682E617370656374526174696F2C723D746869732E636F6E7461696E';
wwv_flow_api.g_varchar2_table(113) := '65722C703D722E77696474682C6C3D722E6865696768742C633D746869732E63616E7661732C643D746869732E63726F70426F782C673D746869732E69734C696D697465643B74262628653D667428682E6D696E43726F70426F785769647468297C7C30';
wwv_flow_api.g_varchar2_table(114) := '2C733D667428682E6D696E43726F70426F78486569676874297C7C302C653D6D7428652C70292C733D6D7428732C6C292C613D6D7428702C673F632E77696474683A70292C6F3D6D74286C2C673F632E6865696768743A6C292C6E262628652626733F73';
wwv_flow_api.g_varchar2_table(115) := '2A6E3E653F733D652F6E3A653D732A6E3A653F733D652F6E3A73262628653D732A6E292C6F2A6E3E613F6F3D612F6E3A613D6F2A6E292C642E6D696E57696474683D6D7428652C61292C642E6D696E4865696768743D6D7428732C6F292C642E6D617857';
wwv_flow_api.g_varchar2_table(116) := '696474683D612C642E6D61784865696768743D6F292C69262628673F28642E6D696E4C6566743D767428302C632E6C656674292C642E6D696E546F703D767428302C632E746F70292C642E6D61784C6566743D6D7428702C632E6C6566742B632E776964';
wwv_flow_api.g_varchar2_table(117) := '7468292D642E77696474682C642E6D6178546F703D6D74286C2C632E746F702B632E686569676874292D642E686569676874293A28642E6D696E4C6566743D302C642E6D696E546F703D302C642E6D61784C6566743D702D642E77696474682C642E6D61';
wwv_flow_api.g_varchar2_table(118) := '78546F703D6C2D642E68656967687429297D2C72656E64657243726F70426F783A66756E6374696F6E28297B76617220743D746869732E6F7074696F6E732C693D746869732E636F6E7461696E65722C653D692E77696474682C733D692E686569676874';
wwv_flow_api.g_varchar2_table(119) := '2C613D746869732E63726F70426F783B28612E77696474683E612E6D617857696474687C7C612E77696474683C612E6D696E576964746829262628612E6C6566743D612E6F6C644C656674292C28612E6865696768743E612E6D61784865696768747C7C';
wwv_flow_api.g_varchar2_table(120) := '612E6865696768743C612E6D696E48656967687429262628612E746F703D612E6F6C64546F70292C612E77696474683D6D7428767428612E77696474682C612E6D696E5769647468292C612E6D61785769647468292C612E6865696768743D6D74287674';
wwv_flow_api.g_varchar2_table(121) := '28612E6865696768742C612E6D696E486569676874292C612E6D6178486569676874292C746869732E6C696D697443726F70426F782821312C2130292C612E6F6C644C6566743D612E6C6566743D6D7428767428612E6C6566742C612E6D696E4C656674';
wwv_flow_api.g_varchar2_table(122) := '292C612E6D61784C656674292C612E6F6C64546F703D612E746F703D6D7428767428612E746F702C612E6D696E546F70292C612E6D6178546F70292C742E6D6F7661626C652626742E63726F70426F784D6F7661626C652626746869732E24666163652E';
wwv_flow_api.g_varchar2_table(123) := '646174612874742C612E77696474683D3D3D652626612E6865696768743D3D3D733F63743A7074292C746869732E2463726F70426F782E637373287B77696474683A612E77696474682C6865696768743A612E6865696768742C6C6566743A612E6C6566';
wwv_flow_api.g_varchar2_table(124) := '742C746F703A612E746F707D292C746869732E697343726F707065642626746869732E69734C696D697465642626746869732E6C696D697443616E7661732821302C2130292C746869732E697344697361626C65647C7C746869732E6F75747075742829';
wwv_flow_api.g_varchar2_table(125) := '7D2C6F75747075743A66756E6374696F6E28297B746869732E7072657669657728292C746869732E6973436F6D706C657465643F746869732E7472696767657228712C746869732E676574446174612829293A746869732E69734275696C747C7C746869';
wwv_flow_api.g_varchar2_table(126) := '732E24656C656D656E742E6F6E6528532C742E70726F78792866756E6374696F6E28297B746869732E7472696767657228712C746869732E676574446174612829297D2C7468697329297D2C696E6974507265766965773A66756E6374696F6E28297B76';
wwv_flow_api.g_varchar2_table(127) := '617220693D6E28746869732E63726F73734F726967696E292C653D693F746869732E63726F73734F726967696E55726C3A746869732E75726C3B746869732E24707265766965773D7428746869732E6F7074696F6E732E70726576696577292C74686973';
wwv_flow_api.g_varchar2_table(128) := '2E2476696577426F782E68746D6C28223C696D67222B692B27207372633D22272B652B27223E27292C746869732E24707265766965772E656163682866756E6374696F6E28297B76617220733D742874686973293B732E64617461284A2C7B7769647468';
wwv_flow_api.g_varchar2_table(129) := '3A732E776964746828292C6865696768743A732E68656967687428292C68746D6C3A732E68746D6C28297D292C732E68746D6C28223C696D67222B692B27207372633D22272B652B2722207374796C653D22646973706C61793A626C6F636B3B77696474';
wwv_flow_api.g_varchar2_table(130) := '683A313030253B6865696768743A6175746F3B6D696E2D77696474683A3021696D706F7274616E743B6D696E2D6865696768743A3021696D706F7274616E743B6D61782D77696474683A6E6F6E6521696D706F7274616E743B6D61782D6865696768743A';
wwv_flow_api.g_varchar2_table(131) := '6E6F6E6521696D706F7274616E743B696D6167652D6F7269656E746174696F6E3A3064656721696D706F7274616E743B223E27297D297D2C7265736574507265766965773A66756E6374696F6E28297B746869732E24707265766965772E656163682866';
wwv_flow_api.g_varchar2_table(132) := '756E6374696F6E28297B76617220693D742874686973292C653D692E64617461284A293B692E637373287B77696474683A652E77696474682C6865696768743A652E6865696768747D292E68746D6C28652E68746D6C292E72656D6F766544617461284A';
wwv_flow_api.g_varchar2_table(133) := '297D297D2C707265766965773A66756E6374696F6E28297B76617220693D746869732E696D6167652C653D746869732E63616E7661732C733D746869732E63726F70426F782C613D732E77696474682C6F3D732E6865696768742C683D692E7769647468';
wwv_flow_api.g_varchar2_table(134) := '2C6E3D692E6865696768742C723D732E6C6566742D652E6C6566742D692E6C6566742C6C3D732E746F702D652E746F702D692E746F703B746869732E697343726F70706564262621746869732E697344697361626C6564262628746869732E2476696577';
wwv_flow_api.g_varchar2_table(135) := '426F782E66696E642822696D6722292E637373287B77696474683A682C6865696768743A6E2C6D617267696E4C6566743A2D722C6D617267696E546F703A2D6C2C7472616E73666F726D3A702869297D292C746869732E24707265766965772E65616368';
wwv_flow_api.g_varchar2_table(136) := '2866756E6374696F6E28297B76617220653D742874686973292C733D652E64617461284A292C633D732E77696474682C643D732E6865696768742C673D632C753D642C663D313B61262628663D632F612C753D6F2A66292C6F2626753E64262628663D64';
wwv_flow_api.g_varchar2_table(137) := '2F6F2C673D612A662C753D64292C652E637373287B77696474683A672C6865696768743A757D292E66696E642822696D6722292E637373287B77696474683A682A662C6865696768743A6E2A662C6D617267696E4C6566743A2D722A662C6D617267696E';
wwv_flow_api.g_varchar2_table(138) := '546F703A2D6C2A662C7472616E73666F726D3A702869297D297D29297D2C62696E643A66756E6374696F6E28297B76617220693D746869732E6F7074696F6E732C653D746869732E24656C656D656E742C733D746869732E2463726F707065723B742E69';
wwv_flow_api.g_varchar2_table(139) := '7346756E6374696F6E28692E63726F707374617274292626652E6F6E28412C692E63726F707374617274292C742E697346756E6374696F6E28692E63726F706D6F7665292626652E6F6E284E2C692E63726F706D6F7665292C742E697346756E6374696F';
wwv_flow_api.g_varchar2_table(140) := '6E28692E63726F70656E64292626652E6F6E285F2C692E63726F70656E64292C742E697346756E6374696F6E28692E63726F70292626652E6F6E28712C692E63726F70292C742E697346756E6374696F6E28692E7A6F6F6D292626652E6F6E285A2C692E';
wwv_flow_api.g_varchar2_table(141) := '7A6F6F6D292C732E6F6E28482C742E70726F787928746869732E63726F7053746172742C7468697329292C692E7A6F6F6D61626C652626692E7A6F6F6D4F6E576865656C2626732E6F6E28452C742E70726F787928746869732E776865656C2C74686973';
wwv_flow_api.g_varchar2_table(142) := '29292C692E746F67676C65447261674D6F64654F6E44626C636C69636B2626732E6F6E28502C742E70726F787928746869732E64626C636C69636B2C7468697329292C782E6F6E287A2C746869732E5F63726F704D6F76653D6128746869732E63726F70';
wwv_flow_api.g_varchar2_table(143) := '4D6F76652C7468697329292E6F6E284F2C746869732E5F63726F70456E643D6128746869732E63726F70456E642C7468697329292C692E726573706F6E736976652626772E6F6E28462C746869732E5F726573697A653D6128746869732E726573697A65';
wwv_flow_api.g_varchar2_table(144) := '2C7468697329297D2C756E62696E643A66756E6374696F6E28297B76617220693D746869732E6F7074696F6E732C653D746869732E24656C656D656E742C733D746869732E2463726F707065723B742E697346756E6374696F6E28692E63726F70737461';
wwv_flow_api.g_varchar2_table(145) := '7274292626652E6F666628412C692E63726F707374617274292C742E697346756E6374696F6E28692E63726F706D6F7665292626652E6F6666284E2C692E63726F706D6F7665292C742E697346756E6374696F6E28692E63726F70656E64292626652E6F';
wwv_flow_api.g_varchar2_table(146) := '6666285F2C692E63726F70656E64292C742E697346756E6374696F6E28692E63726F70292626652E6F666628712C692E63726F70292C742E697346756E6374696F6E28692E7A6F6F6D292626652E6F6666285A2C692E7A6F6F6D292C732E6F666628482C';
wwv_flow_api.g_varchar2_table(147) := '746869732E63726F705374617274292C692E7A6F6F6D61626C652626692E7A6F6F6D4F6E576865656C2626732E6F666628452C746869732E776865656C292C692E746F67676C65447261674D6F64654F6E44626C636C69636B2626732E6F666628502C74';
wwv_flow_api.g_varchar2_table(148) := '6869732E64626C636C69636B292C782E6F6666287A2C746869732E5F63726F704D6F7665292E6F6666284F2C746869732E5F63726F70456E64292C692E726573706F6E736976652626772E6F666628462C746869732E5F726573697A65297D2C72657369';
wwv_flow_api.g_varchar2_table(149) := '7A653A66756E6374696F6E28297B76617220692C652C732C613D746869732E6F7074696F6E732E726573746F72652C6F3D746869732E24636F6E7461696E65722C683D746869732E636F6E7461696E65723B21746869732E697344697361626C65642626';
wwv_flow_api.g_varchar2_table(150) := '68262628733D6F2E776964746828292F682E77696474682C2831213D3D737C7C6F2E6865696768742829213D3D682E6865696768742926262861262628693D746869732E67657443616E7661734461746128292C653D746869732E67657443726F70426F';
wwv_flow_api.g_varchar2_table(151) := '78446174612829292C746869732E72656E64657228292C61262628746869732E73657443616E7661734461746128742E6561636828692C66756E6374696F6E28742C65297B695B745D3D652A737D29292C746869732E73657443726F70426F7844617461';
wwv_flow_api.g_varchar2_table(152) := '28742E6561636828652C66756E6374696F6E28742C69297B655B745D3D692A737D29292929297D2C64626C636C69636B3A66756E6374696F6E28297B746869732E697344697361626C65647C7C28746869732E2464726167426F782E686173436C617373';
wwv_flow_api.g_varchar2_table(153) := '284D293F746869732E736574447261674D6F6465286374293A746869732E736574447261674D6F6465286C7429297D2C776865656C3A66756E6374696F6E2869297B76617220653D692E6F726967696E616C4576656E747C7C692C733D66742874686973';
wwv_flow_api.g_varchar2_table(154) := '2E6F7074696F6E732E776865656C5A6F6F6D526174696F297C7C2E312C613D313B746869732E697344697361626C65647C7C28692E70726576656E7444656661756C7428292C746869732E776865656C696E677C7C28746869732E776865656C696E673D';
wwv_flow_api.g_varchar2_table(155) := '21302C73657454696D656F757428742E70726F78792866756E6374696F6E28297B746869732E776865656C696E673D21317D2C74686973292C3530292C652E64656C7461593F613D652E64656C7461593E303F313A2D313A652E776865656C44656C7461';
wwv_flow_api.g_varchar2_table(156) := '3F613D2D652E776865656C44656C74612F3132303A652E64657461696C262628613D652E64657461696C3E303F313A2D31292C746869732E7A6F6F6D282D612A732C692929297D2C63726F7053746172743A66756E6374696F6E2869297B76617220652C';
wwv_flow_api.g_varchar2_table(157) := '732C613D746869732E6F7074696F6E732C6F3D692E6F726967696E616C4576656E742C683D6F26266F2E746F75636865732C6E3D693B69662821746869732E697344697361626C6564297B69662868297B696628653D682E6C656E6774682C653E31297B';
wwv_flow_api.g_varchar2_table(158) := '69662821612E7A6F6F6D61626C657C7C21612E7A6F6F6D4F6E546F7563687C7C32213D3D652972657475726E3B6E3D685B315D2C746869732E737461727458323D6E2E70616765582C746869732E737461727459323D6E2E70616765592C733D64747D6E';
wwv_flow_api.g_varchar2_table(159) := '3D685B305D7D696628733D737C7C74286E2E746172676574292E64617461287474292C4B2E74657374287329297B696628746869732E7472696767657228412C7B6F726967696E616C4576656E743A6F2C616374696F6E3A737D292E697344656661756C';
wwv_flow_api.g_varchar2_table(160) := '7450726576656E74656428292972657475726E3B692E70726576656E7444656661756C7428292C746869732E616374696F6E3D732C746869732E63726F7070696E673D21312C746869732E7374617274583D6E2E70616765587C7C6F26266F2E70616765';
wwv_flow_api.g_varchar2_table(161) := '582C746869732E7374617274593D6E2E70616765597C7C6F26266F2E70616765592C733D3D3D6C74262628746869732E63726F7070696E673D21302C746869732E2464726167426F782E616464436C617373284C29297D7D7D2C63726F704D6F76653A66';
wwv_flow_api.g_varchar2_table(162) := '756E6374696F6E2874297B76617220692C653D746869732E6F7074696F6E732C733D742E6F726967696E616C4576656E742C613D732626732E746F75636865732C6F3D742C683D746869732E616374696F6E3B69662821746869732E697344697361626C';
wwv_flow_api.g_varchar2_table(163) := '6564297B69662861297B696628693D612E6C656E6774682C693E31297B69662821652E7A6F6F6D61626C657C7C21652E7A6F6F6D4F6E546F7563687C7C32213D3D692972657475726E3B6F3D615B315D2C746869732E656E6458323D6F2E70616765582C';
wwv_flow_api.g_varchar2_table(164) := '746869732E656E6459323D6F2E70616765597D6F3D615B305D7D69662868297B696628746869732E74726967676572284E2C7B6F726967696E616C4576656E743A732C616374696F6E3A687D292E697344656661756C7450726576656E74656428292972';
wwv_flow_api.g_varchar2_table(165) := '657475726E3B742E70726576656E7444656661756C7428292C746869732E656E64583D6F2E70616765587C7C732626732E70616765582C746869732E656E64593D6F2E70616765597C7C732626732E70616765592C746869732E6368616E6765286F2E73';
wwv_flow_api.g_varchar2_table(166) := '686966744B65792C683D3D3D64743F743A6E756C6C297D7D7D2C63726F70456E643A66756E6374696F6E2874297B76617220693D742E6F726967696E616C4576656E742C653D746869732E616374696F6E3B746869732E697344697361626C65647C7C65';
wwv_flow_api.g_varchar2_table(167) := '262628742E70726576656E7444656661756C7428292C746869732E63726F7070696E67262628746869732E63726F7070696E673D21312C746869732E2464726167426F782E746F67676C65436C617373284C2C746869732E697343726F70706564262674';
wwv_flow_api.g_varchar2_table(168) := '6869732E6F7074696F6E732E6D6F64616C29292C746869732E616374696F6E3D22222C746869732E74726967676572285F2C7B6F726967696E616C4576656E743A692C616374696F6E3A657D29297D2C6368616E67653A66756E6374696F6E28742C6929';
wwv_flow_api.g_varchar2_table(169) := '7B76617220652C732C613D746869732E6F7074696F6E732C6F3D612E617370656374526174696F2C683D746869732E616374696F6E2C6E3D746869732E636F6E7461696E65722C723D746869732E63616E7661732C703D746869732E63726F70426F782C';
wwv_flow_api.g_varchar2_table(170) := '6C3D702E77696474682C633D702E6865696768742C643D702E6C6566742C673D702E746F702C753D642B6C2C663D672B632C6D3D302C763D302C773D6E2E77696474682C783D6E2E6865696768742C433D21303B73776974636828216F2626742626286F';
wwv_flow_api.g_varchar2_table(171) := '3D6C2626633F6C2F633A31292C746869732E6C696D697465642626286D3D702E6D696E4C6566742C763D702E6D696E546F702C773D6D2B6D74286E2E77696474682C722E7769647468292C783D762B6D74286E2E6865696768742C722E68656967687429';
wwv_flow_api.g_varchar2_table(172) := '292C733D7B783A746869732E656E64582D746869732E7374617274582C793A746869732E656E64592D746869732E7374617274597D2C6F262628732E583D732E792A6F2C732E593D732E782F6F292C68297B636173652070743A642B3D732E782C672B3D';
wwv_flow_api.g_varchar2_table(173) := '732E793B627265616B3B636173652069743A696628732E783E3D30262628753E3D777C7C6F262628763E3D677C7C663E3D782929297B433D21313B627265616B7D6C2B3D732E782C6F262628633D6C2F6F2C672D3D732E592F32292C303E6C262628683D';
wwv_flow_api.g_varchar2_table(174) := '65742C6C3D30293B627265616B3B636173652061743A696628732E793C3D30262628763E3D677C7C6F2626286D3E3D647C7C753E3D772929297B433D21313B627265616B7D632D3D732E792C672B3D732E792C6F2626286C3D632A6F2C642B3D732E582F';
wwv_flow_api.g_varchar2_table(175) := '32292C303E63262628683D73742C633D30293B627265616B3B636173652065743A696628732E783C3D302626286D3E3D647C7C6F262628763E3D677C7C663E3D782929297B433D21313B627265616B7D6C2D3D732E782C642B3D732E782C6F262628633D';
wwv_flow_api.g_varchar2_table(176) := '6C2F6F2C672B3D732E592F32292C303E6C262628683D69742C6C3D30293B627265616B3B636173652073743A696628732E793E3D30262628663E3D787C7C6F2626286D3E3D647C7C753E3D772929297B433D21313B627265616B7D632B3D732E792C6F26';
wwv_flow_api.g_varchar2_table(177) := '26286C3D632A6F2C642D3D732E582F32292C303E63262628683D61742C633D30293B627265616B3B63617365206E743A6966286F297B696628732E793C3D30262628763E3D677C7C753E3D7729297B433D21313B627265616B7D632D3D732E792C672B3D';
wwv_flow_api.g_varchar2_table(178) := '732E792C6C3D632A6F7D656C736520732E783E3D303F773E753F6C2B3D732E783A732E793C3D302626763E3D67262628433D2131293A6C2B3D732E782C732E793C3D303F673E76262628632D3D732E792C672B3D732E79293A28632D3D732E792C672B3D';
wwv_flow_api.g_varchar2_table(179) := '732E79293B303E6C2626303E633F28683D68742C633D302C6C3D30293A303E6C3F28683D72742C6C3D30293A303E63262628683D6F742C633D30293B627265616B3B636173652072743A6966286F297B696628732E793C3D30262628763E3D677C7C6D3E';
wwv_flow_api.g_varchar2_table(180) := '3D6429297B433D21313B627265616B7D632D3D732E792C672B3D732E792C6C3D632A6F2C642B3D732E587D656C736520732E783C3D303F643E6D3F286C2D3D732E782C642B3D732E78293A732E793C3D302626763E3D67262628433D2131293A286C2D3D';
wwv_flow_api.g_varchar2_table(181) := '732E782C642B3D732E78292C732E793C3D303F673E76262628632D3D732E792C672B3D732E79293A28632D3D732E792C672B3D732E79293B303E6C2626303E633F28683D6F742C633D302C6C3D30293A303E6C3F28683D6E742C6C3D30293A303E632626';
wwv_flow_api.g_varchar2_table(182) := '28683D68742C633D30293B627265616B3B636173652068743A6966286F297B696628732E783C3D302626286D3E3D647C7C663E3D7829297B433D21313B627265616B7D6C2D3D732E782C642B3D732E782C633D6C2F6F7D656C736520732E783C3D303F64';
wwv_flow_api.g_varchar2_table(183) := '3E6D3F286C2D3D732E782C642B3D732E78293A732E793E3D302626663E3D78262628433D2131293A286C2D3D732E782C642B3D732E78292C732E793E3D303F783E66262628632B3D732E79293A632B3D732E793B303E6C2626303E633F28683D6E742C63';
wwv_flow_api.g_varchar2_table(184) := '3D302C6C3D30293A303E6C3F28683D6F742C6C3D30293A303E63262628683D72742C633D30293B627265616B3B63617365206F743A6966286F297B696628732E783E3D30262628753E3D777C7C663E3D7829297B433D21313B627265616B7D6C2B3D732E';
wwv_flow_api.g_varchar2_table(185) := '782C633D6C2F6F7D656C736520732E783E3D303F773E753F6C2B3D732E783A732E793E3D302626663E3D78262628433D2131293A6C2B3D732E782C732E793E3D303F783E66262628632B3D732E79293A632B3D732E793B303E6C2626303E633F28683D72';
wwv_flow_api.g_varchar2_table(186) := '742C633D302C6C3D30293A303E6C3F28683D68742C6C3D30293A303E63262628683D6E742C633D30293B627265616B3B636173652063743A746869732E6D6F766528732E782C732E79292C433D21313B627265616B3B636173652064743A746869732E7A';
wwv_flow_api.g_varchar2_table(187) := '6F6F6D2866756E6374696F6E28742C692C652C73297B76617220613D627428742A742B692A69292C6F3D627428652A652B732A73293B72657475726E286F2D61292F617D28777428746869732E7374617274582D746869732E73746172745832292C7774';
wwv_flow_api.g_varchar2_table(188) := '28746869732E7374617274592D746869732E73746172745932292C777428746869732E656E64582D746869732E656E645832292C777428746869732E656E64592D746869732E656E64593229292C69292C746869732E737461727458323D746869732E65';
wwv_flow_api.g_varchar2_table(189) := '6E6458322C746869732E737461727459323D746869732E656E6459322C433D21313B627265616B3B63617365206C743A69662821732E787C7C21732E79297B433D21313B627265616B7D653D746869732E2463726F707065722E6F666673657428292C64';
wwv_flow_api.g_varchar2_table(190) := '3D746869732E7374617274582D652E6C6566742C673D746869732E7374617274592D652E746F702C6C3D702E6D696E57696474682C633D702E6D696E4865696768742C732E783E303F683D732E793E303F6F743A6E743A732E783C30262628642D3D6C2C';
wwv_flow_api.g_varchar2_table(191) := '683D732E793E303F68743A7274292C732E793C30262628672D3D63292C746869732E697343726F707065647C7C28746869732E2463726F70426F782E72656D6F7665436C6173732858292C746869732E697343726F707065643D21302C746869732E6C69';
wwv_flow_api.g_varchar2_table(192) := '6D697465642626746869732E6C696D697443726F70426F782821302C213029297D43262628702E77696474683D6C2C702E6865696768743D632C702E6C6566743D642C702E746F703D672C746869732E616374696F6E3D682C746869732E72656E646572';
wwv_flow_api.g_varchar2_table(193) := '43726F70426F782829292C746869732E7374617274583D746869732E656E64582C746869732E7374617274593D746869732E656E64597D2C63726F703A66756E6374696F6E28297B746869732E69734275696C74262621746869732E697344697361626C';
wwv_flow_api.g_varchar2_table(194) := '6564262628746869732E697343726F707065647C7C28746869732E697343726F707065643D21302C746869732E6C696D697443726F70426F782821302C2130292C746869732E6F7074696F6E732E6D6F64616C2626746869732E2464726167426F782E61';
wwv_flow_api.g_varchar2_table(195) := '6464436C617373284C292C746869732E2463726F70426F782E72656D6F7665436C617373285829292C746869732E73657443726F70426F784461746128746869732E696E697469616C43726F70426F7829297D2C72657365743A66756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(196) := '7B746869732E69734275696C74262621746869732E697344697361626C6564262628746869732E696D6167653D742E657874656E64287B7D2C746869732E696E697469616C496D616765292C746869732E63616E7661733D742E657874656E64287B7D2C';
wwv_flow_api.g_varchar2_table(197) := '746869732E696E697469616C43616E766173292C746869732E63726F70426F783D742E657874656E64287B7D2C746869732E696E697469616C43726F70426F78292C746869732E72656E64657243616E76617328292C746869732E697343726F70706564';
wwv_flow_api.g_varchar2_table(198) := '2626746869732E72656E64657243726F70426F782829297D2C636C6561723A66756E6374696F6E28297B746869732E697343726F70706564262621746869732E697344697361626C6564262628742E657874656E6428746869732E63726F70426F782C7B';
wwv_flow_api.g_varchar2_table(199) := '6C6566743A302C746F703A302C77696474683A302C6865696768743A307D292C746869732E697343726F707065643D21312C746869732E72656E64657243726F70426F7828292C746869732E6C696D697443616E7661732821302C2130292C746869732E';
wwv_flow_api.g_varchar2_table(200) := '72656E64657243616E76617328292C746869732E2464726167426F782E72656D6F7665436C617373284C292C746869732E2463726F70426F782E616464436C617373285829297D2C7265706C6163653A66756E6374696F6E2874297B21746869732E6973';
wwv_flow_api.g_varchar2_table(201) := '44697361626C6564262674262628746869732E6973496D67262628746869732E69735265706C616365643D21302C746869732E24656C656D656E742E617474722822737263222C7429292C746869732E6F7074696F6E732E646174613D6E756C6C2C7468';
wwv_flow_api.g_varchar2_table(202) := '69732E6C6F6164287429297D2C656E61626C653A66756E6374696F6E28297B746869732E69734275696C74262628746869732E697344697361626C65643D21312C746869732E2463726F707065722E72656D6F7665436C617373285729297D2C64697361';
wwv_flow_api.g_varchar2_table(203) := '626C653A66756E6374696F6E28297B746869732E69734275696C74262628746869732E697344697361626C65643D21302C746869732E2463726F707065722E616464436C617373285729297D2C64657374726F793A66756E6374696F6E28297B76617220';
wwv_flow_api.g_varchar2_table(204) := '743D746869732E24656C656D656E743B746869732E69734C6F616465643F28746869732E6973496D672626746869732E69735265706C616365642626742E617474722822737263222C746869732E6F726967696E616C55726C292C746869732E756E6275';
wwv_flow_api.g_varchar2_table(205) := '696C6428292C742E72656D6F7665436C617373285829293A746869732E6973496D673F742E6F666628552C746869732E7374617274293A746869732E24636C6F6E652626746869732E24636C6F6E652E72656D6F766528292C742E72656D6F7665446174';
wwv_flow_api.g_varchar2_table(206) := '612824297D2C6D6F76653A66756E6374696F6E28742C69297B76617220733D746869732E63616E7661733B746869732E6D6F7665546F28652874293F743A732E6C6566742B66742874292C652869293F693A732E746F702B6674286929297D2C6D6F7665';
wwv_flow_api.g_varchar2_table(207) := '546F3A66756E6374696F6E28742C73297B76617220613D746869732E63616E7661732C6F3D21313B65287329262628733D74292C743D66742874292C733D66742873292C746869732E69734275696C74262621746869732E697344697361626C65642626';
wwv_flow_api.g_varchar2_table(208) := '746869732E6F7074696F6E732E6D6F7661626C6526262869287429262628612E6C6566743D742C6F3D2130292C69287329262628612E746F703D732C6F3D2130292C6F2626746869732E72656E64657243616E76617328213029297D2C7A6F6F6D3A6675';
wwv_flow_api.g_varchar2_table(209) := '6E6374696F6E28742C69297B76617220653D746869732E63616E7661733B743D66742874292C743D303E743F312F28312D74293A312B742C746869732E7A6F6F6D546F28652E77696474682A742F652E6E61747572616C57696474682C69297D2C7A6F6F';
wwv_flow_api.g_varchar2_table(210) := '6D546F3A66756E6374696F6E28742C69297B76617220652C732C612C6F2C682C6E3D746869732E6F7074696F6E732C723D746869732E63616E7661732C703D722E77696474682C6C3D722E6865696768742C633D722E6E61747572616C57696474682C67';
wwv_flow_api.g_varchar2_table(211) := '3D722E6E61747572616C4865696768743B696628743D66742874292C743E3D302626746869732E69734275696C74262621746869732E697344697361626C656426266E2E7A6F6F6D61626C65297B696628733D632A742C613D672A742C69262628653D69';
wwv_flow_api.g_varchar2_table(212) := '2E6F726967696E616C4576656E74292C746869732E74726967676572285A2C7B6F726967696E616C4576656E743A652C6F6C64526174696F3A702F632C726174696F3A732F637D292E697344656661756C7450726576656E74656428292972657475726E';
wwv_flow_api.g_varchar2_table(213) := '3B653F286F3D746869732E2463726F707065722E6F666673657428292C683D652E746F75636865733F6428652E746F7563686573293A7B70616765583A692E70616765587C7C652E70616765587C7C302C70616765593A692E70616765597C7C652E7061';
wwv_flow_api.g_varchar2_table(214) := '6765597C7C307D2C722E6C6566742D3D28732D70292A2828682E70616765582D6F2E6C6566742D722E6C656674292F70292C722E746F702D3D28612D6C292A2828682E70616765592D6F2E746F702D722E746F70292F6C29293A28722E6C6566742D3D28';
wwv_flow_api.g_varchar2_table(215) := '732D70292F322C722E746F702D3D28612D6C292F32292C722E77696474683D732C722E6865696768743D612C746869732E72656E64657243616E766173282130297D7D2C726F746174653A66756E6374696F6E2874297B746869732E726F74617465546F';
wwv_flow_api.g_varchar2_table(216) := '2828746869732E696D6167652E726F746174657C7C30292B6674287429297D2C726F74617465546F3A66756E6374696F6E2874297B743D66742874292C692874292626746869732E69734275696C74262621746869732E697344697361626C6564262674';
wwv_flow_api.g_varchar2_table(217) := '6869732E6F7074696F6E732E726F74617461626C65262628746869732E696D6167652E726F746174653D74253336302C746869732E6973526F74617465643D21302C746869732E72656E64657243616E76617328213029297D2C7363616C653A66756E63';
wwv_flow_api.g_varchar2_table(218) := '74696F6E28742C73297B76617220613D746869732E696D6167652C6F3D21313B65287329262628733D74292C743D66742874292C733D66742873292C746869732E69734275696C74262621746869732E697344697361626C65642626746869732E6F7074';
wwv_flow_api.g_varchar2_table(219) := '696F6E732E7363616C61626C6526262869287429262628612E7363616C65583D742C6F3D2130292C69287329262628612E7363616C65593D732C6F3D2130292C6F2626746869732E72656E646572496D61676528213029297D2C7363616C65583A66756E';
wwv_flow_api.g_varchar2_table(220) := '6374696F6E2874297B76617220653D746869732E696D6167652E7363616C65593B746869732E7363616C6528742C692865293F653A31297D2C7363616C65593A66756E6374696F6E2874297B76617220653D746869732E696D6167652E7363616C65583B';
wwv_flow_api.g_varchar2_table(221) := '746869732E7363616C6528692865293F653A312C74297D2C676574446174613A66756E6374696F6E2869297B76617220652C732C613D746869732E6F7074696F6E732C6F3D746869732E696D6167652C683D746869732E63616E7661732C6E3D74686973';
wwv_flow_api.g_varchar2_table(222) := '2E63726F70426F783B72657475726E20746869732E69734275696C742626746869732E697343726F707065643F28733D7B783A6E2E6C6566742D682E6C6566742C793A6E2E746F702D682E746F702C77696474683A6E2E77696474682C6865696768743A';
wwv_flow_api.g_varchar2_table(223) := '6E2E6865696768747D2C653D6F2E77696474682F6F2E6E61747572616C57696474682C742E6561636828732C66756E6374696F6E28742C61297B612F3D652C735B745D3D693F42742861293A617D29293A733D7B783A302C793A302C77696474683A302C';
wwv_flow_api.g_varchar2_table(224) := '6865696768743A307D2C612E726F74617461626C65262628732E726F746174653D6F2E726F746174657C7C30292C612E7363616C61626C65262628732E7363616C65583D6F2E7363616C65587C7C312C732E7363616C65593D6F2E7363616C65597C7C31';
wwv_flow_api.g_varchar2_table(225) := '292C737D2C736574446174613A66756E6374696F6E2865297B76617220732C612C6F2C683D746869732E6F7074696F6E732C6E3D746869732E696D6167652C723D746869732E63616E7661732C703D7B7D3B742E697346756E6374696F6E286529262628';
wwv_flow_api.g_varchar2_table(226) := '653D652E63616C6C28746869732E656C656D656E7429292C746869732E69734275696C74262621746869732E697344697361626C65642626742E6973506C61696E4F626A656374286529262628682E726F74617461626C6526266928652E726F74617465';
wwv_flow_api.g_varchar2_table(227) := '292626652E726F74617465213D3D6E2E726F746174652626286E2E726F746174653D652E726F746174652C746869732E6973526F74617465643D733D2130292C682E7363616C61626C652626286928652E7363616C6558292626652E7363616C6558213D';
wwv_flow_api.g_varchar2_table(228) := '3D6E2E7363616C65582626286E2E7363616C65583D652E7363616C65582C613D2130292C6928652E7363616C6559292626652E7363616C6559213D3D6E2E7363616C65592626286E2E7363616C65593D652E7363616C65592C613D213029292C733F7468';
wwv_flow_api.g_varchar2_table(229) := '69732E72656E64657243616E76617328293A612626746869732E72656E646572496D61676528292C6F3D6E2E77696474682F6E2E6E61747572616C57696474682C6928652E7829262628702E6C6566743D652E782A6F2B722E6C656674292C6928652E79';
wwv_flow_api.g_varchar2_table(230) := '29262628702E746F703D652E792A6F2B722E746F70292C6928652E776964746829262628702E77696474683D652E77696474682A6F292C6928652E68656967687429262628702E6865696768743D652E6865696768742A6F292C746869732E7365744372';
wwv_flow_api.g_varchar2_table(231) := '6F70426F7844617461287029297D2C676574436F6E7461696E6572446174613A66756E6374696F6E28297B72657475726E20746869732E69734275696C743F746869732E636F6E7461696E65723A7B7D7D2C676574496D616765446174613A66756E6374';
wwv_flow_api.g_varchar2_table(232) := '696F6E28297B72657475726E20746869732E69734C6F616465643F746869732E696D6167653A7B7D7D2C67657443616E766173446174613A66756E6374696F6E28297B76617220693D746869732E63616E7661732C653D7B7D3B72657475726E20746869';
wwv_flow_api.g_varchar2_table(233) := '732E69734275696C742626742E65616368285B226C656674222C22746F70222C227769647468222C22686569676874222C226E61747572616C5769647468222C226E61747572616C486569676874225D2C66756E6374696F6E28742C73297B655B735D3D';
wwv_flow_api.g_varchar2_table(234) := '695B735D7D292C657D2C73657443616E766173446174613A66756E6374696F6E2865297B76617220733D746869732E63616E7661732C613D732E617370656374526174696F3B742E697346756E6374696F6E286529262628653D652E63616C6C28746869';
wwv_flow_api.g_varchar2_table(235) := '732E24656C656D656E7429292C746869732E69734275696C74262621746869732E697344697361626C65642626742E6973506C61696E4F626A6563742865292626286928652E6C65667429262628732E6C6566743D652E6C656674292C6928652E746F70';
wwv_flow_api.g_varchar2_table(236) := '29262628732E746F703D652E746F70292C6928652E7769647468293F28732E77696474683D652E77696474682C732E6865696768743D652E77696474682F61293A6928652E68656967687429262628732E6865696768743D652E6865696768742C732E77';
wwv_flow_api.g_varchar2_table(237) := '696474683D652E6865696768742A61292C746869732E72656E64657243616E76617328213029297D2C67657443726F70426F78446174613A66756E6374696F6E28297B76617220742C693D746869732E63726F70426F783B72657475726E20746869732E';
wwv_flow_api.g_varchar2_table(238) := '69734275696C742626746869732E697343726F70706564262628743D7B6C6566743A692E6C6566742C746F703A692E746F702C77696474683A692E77696474682C6865696768743A692E6865696768747D292C747C7C7B7D7D2C73657443726F70426F78';
wwv_flow_api.g_varchar2_table(239) := '446174613A66756E6374696F6E2865297B76617220732C612C6F3D746869732E63726F70426F782C683D746869732E6F7074696F6E732E617370656374526174696F3B742E697346756E6374696F6E286529262628653D652E63616C6C28746869732E24';
wwv_flow_api.g_varchar2_table(240) := '656C656D656E7429292C746869732E69734275696C742626746869732E697343726F70706564262621746869732E697344697361626C65642626742E6973506C61696E4F626A6563742865292626286928652E6C656674292626286F2E6C6566743D652E';
wwv_flow_api.g_varchar2_table(241) := '6C656674292C6928652E746F70292626286F2E746F703D652E746F70292C6928652E776964746829262628733D21302C6F2E77696474683D652E7769647468292C6928652E68656967687429262628613D21302C6F2E6865696768743D652E6865696768';
wwv_flow_api.g_varchar2_table(242) := '74292C68262628733F6F2E6865696768743D6F2E77696474682F683A612626286F2E77696474683D6F2E6865696768742A6829292C746869732E72656E64657243726F70426F782829297D2C67657443726F7070656443616E7661733A66756E6374696F';
wwv_flow_api.g_varchar2_table(243) := '6E2869297B76617220652C732C612C6F2C682C6E2C722C702C6C2C642C673B72657475726E20746869732E69734275696C742626746869732E697343726F70706564262675743F28742E6973506C61696E4F626A6563742869297C7C28693D7B7D292C67';
wwv_flow_api.g_varchar2_table(244) := '3D746869732E6765744461746128292C653D672E77696474682C733D672E6865696768742C703D652F732C742E6973506C61696E4F626A656374286929262628683D692E77696474682C6E3D692E6865696768742C683F286E3D682F702C723D682F6529';
wwv_flow_api.g_varchar2_table(245) := '3A6E262628683D6E2A702C723D6E2F7329292C613D797428687C7C65292C6F3D7974286E7C7C73292C6C3D7428223C63616E7661733E22295B305D2C6C2E77696474683D612C6C2E6865696768743D6F2C643D6C2E676574436F6E746578742822326422';
wwv_flow_api.g_varchar2_table(246) := '292C692E66696C6C436F6C6F72262628642E66696C6C5374796C653D692E66696C6C436F6C6F722C642E66696C6C5265637428302C302C612C6F29292C642E64726177496D6167652E6170706C7928642C66756E6374696F6E28297B76617220742C692C';
wwv_flow_api.g_varchar2_table(247) := '612C6F2C682C6E2C703D6328746869732E24636C6F6E655B305D2C746869732E696D616765292C6C3D702E77696474682C643D702E6865696768742C753D5B705D2C663D672E782C6D3D672E793B72657475726E2D653E3D667C7C663E6C3F663D743D61';
wwv_flow_api.g_varchar2_table(248) := '3D683D303A303E3D663F28613D2D662C663D302C743D683D6D74286C2C652B6629293A6C3E3D66262628613D302C743D683D6D7428652C6C2D6629292C303E3D747C7C2D733E3D6D7C7C6D3E643F6D3D693D6F3D6E3D303A303E3D6D3F286F3D2D6D2C6D';
wwv_flow_api.g_varchar2_table(249) := '3D302C693D6E3D6D7428642C732B6D29293A643E3D6D2626286F3D302C693D6E3D6D7428732C642D6D29292C752E707573682879742866292C7974286D292C79742874292C7974286929292C72262628612A3D722C6F2A3D722C682A3D722C6E2A3D7229';
wwv_flow_api.g_varchar2_table(250) := '2C683E3026266E3E302626752E707573682879742861292C7974286F292C79742868292C7974286E29292C757D2E63616C6C287468697329292C6C293A766F696420307D2C736574417370656374526174696F3A66756E6374696F6E2874297B76617220';
wwv_flow_api.g_varchar2_table(251) := '693D746869732E6F7074696F6E733B746869732E697344697361626C65647C7C652874297C7C28692E617370656374526174696F3D767428302C74297C7C4E614E2C746869732E69734275696C74262628746869732E696E697443726F70426F7828292C';
wwv_flow_api.g_varchar2_table(252) := '746869732E697343726F707065642626746869732E72656E64657243726F70426F78282929297D2C736574447261674D6F64653A66756E6374696F6E2874297B76617220692C652C733D746869732E6F7074696F6E733B746869732E69734C6F61646564';
wwv_flow_api.g_varchar2_table(253) := '262621746869732E697344697361626C6564262628693D743D3D3D6C742C653D732E6D6F7661626C652626743D3D3D63742C743D697C7C653F743A67742C746869732E2464726167426F782E646174612874742C74292E746F67676C65436C617373284D';
wwv_flow_api.g_varchar2_table(254) := '2C69292E746F67676C65436C617373286B2C65292C732E63726F70426F784D6F7661626C657C7C746869732E24666163652E646174612874742C74292E746F67676C65436C617373284D2C69292E746F67676C65436C617373286B2C6529297D7D2C762E';
wwv_flow_api.g_varchar2_table(255) := '44454641554C54533D7B766965774D6F64653A302C647261674D6F64653A2263726F70222C617370656374526174696F3A4E614E2C646174613A6E756C6C2C707265766965773A22222C726573706F6E736976653A21302C726573746F72653A21302C63';
wwv_flow_api.g_varchar2_table(256) := '6865636B43726F73734F726967696E3A21302C636865636B4F7269656E746174696F6E3A21302C6D6F64616C3A21302C6775696465733A21302C63656E7465723A21302C686967686C696768743A21302C6261636B67726F756E643A21302C6175746F43';
wwv_flow_api.g_varchar2_table(257) := '726F703A21302C6175746F43726F70417265613A2E382C6D6F7661626C653A21302C726F74617461626C653A21302C7363616C61626C653A21302C7A6F6F6D61626C653A21302C7A6F6F6D4F6E546F7563683A21302C7A6F6F6D4F6E576865656C3A2130';
wwv_flow_api.g_varchar2_table(258) := '2C776865656C5A6F6F6D526174696F3A2E312C63726F70426F784D6F7661626C653A21302C63726F70426F78526573697A61626C653A21302C746F67676C65447261674D6F64654F6E44626C636C69636B3A21302C6D696E43616E76617357696474683A';
wwv_flow_api.g_varchar2_table(259) := '302C6D696E43616E7661734865696768743A302C6D696E43726F70426F7857696474683A302C6D696E43726F70426F784865696768743A302C6D696E436F6E7461696E657257696474683A3230302C6D696E436F6E7461696E65724865696768743A3130';
wwv_flow_api.g_varchar2_table(260) := '302C6275696C643A6E756C6C2C6275696C743A6E756C6C2C63726F7073746172743A6E756C6C2C63726F706D6F76653A6E756C6C2C63726F70656E643A6E756C6C2C63726F703A6E756C6C2C7A6F6F6D3A6E756C6C7D2C762E73657444656661756C7473';
wwv_flow_api.g_varchar2_table(261) := '3D66756E6374696F6E2869297B742E657874656E6428762E44454641554C54532C69297D2C762E54454D504C4154453D273C64697620636C6173733D2263726F707065722D636F6E7461696E6572223E3C64697620636C6173733D2263726F707065722D';
wwv_flow_api.g_varchar2_table(262) := '777261702D626F78223E3C64697620636C6173733D2263726F707065722D63616E766173223E3C2F6469763E3C2F6469763E3C64697620636C6173733D2263726F707065722D647261672D626F78223E3C2F6469763E3C64697620636C6173733D226372';
wwv_flow_api.g_varchar2_table(263) := '6F707065722D63726F702D626F78223E3C7370616E20636C6173733D2263726F707065722D766965772D626F78223E3C2F7370616E3E3C7370616E20636C6173733D2263726F707065722D646173686564206461736865642D68223E3C2F7370616E3E3C';
wwv_flow_api.g_varchar2_table(264) := '7370616E20636C6173733D2263726F707065722D646173686564206461736865642D76223E3C2F7370616E3E3C7370616E20636C6173733D2263726F707065722D63656E746572223E3C2F7370616E3E3C7370616E20636C6173733D2263726F70706572';
wwv_flow_api.g_varchar2_table(265) := '2D66616365223E3C2F7370616E3E3C7370616E20636C6173733D2263726F707065722D6C696E65206C696E652D652220646174612D616374696F6E3D2265223E3C2F7370616E3E3C7370616E20636C6173733D2263726F707065722D6C696E65206C696E';
wwv_flow_api.g_varchar2_table(266) := '652D6E2220646174612D616374696F6E3D226E223E3C2F7370616E3E3C7370616E20636C6173733D2263726F707065722D6C696E65206C696E652D772220646174612D616374696F6E3D2277223E3C2F7370616E3E3C7370616E20636C6173733D226372';
wwv_flow_api.g_varchar2_table(267) := '6F707065722D6C696E65206C696E652D732220646174612D616374696F6E3D2273223E3C2F7370616E3E3C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D652220646174612D616374696F6E3D2265223E3C2F7370616E';
wwv_flow_api.g_varchar2_table(268) := '3E3C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D6E2220646174612D616374696F6E3D226E223E3C2F7370616E3E3C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D77222064617461';
wwv_flow_api.g_varchar2_table(269) := '2D616374696F6E3D2277223E3C2F7370616E3E3C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D732220646174612D616374696F6E3D2273223E3C2F7370616E3E3C7370616E20636C6173733D2263726F707065722D70';
wwv_flow_api.g_varchar2_table(270) := '6F696E7420706F696E742D6E652220646174612D616374696F6E3D226E65223E3C2F7370616E3E3C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D6E772220646174612D616374696F6E3D226E77223E3C2F7370616E3E';
wwv_flow_api.g_varchar2_table(271) := '3C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D73772220646174612D616374696F6E3D227377223E3C2F7370616E3E3C7370616E20636C6173733D2263726F707065722D706F696E7420706F696E742D736522206461';
wwv_flow_api.g_varchar2_table(272) := '74612D616374696F6E3D227365223E3C2F7370616E3E3C2F6469763E3C2F6469763E272C762E6F746865723D742E666E2E63726F707065722C742E666E2E63726F707065723D66756E6374696F6E2869297B76617220612C6F3D7328617267756D656E74';
wwv_flow_api.g_varchar2_table(273) := '732C31293B72657475726E20746869732E656163682866756E6374696F6E28297B76617220652C732C683D742874686973292C6E3D682E646174612824293B696628216E297B6966282F64657374726F792F2E746573742869292972657475726E3B653D';
wwv_flow_api.g_varchar2_table(274) := '742E657874656E64287B7D2C682E6461746128292C742E6973506C61696E4F626A656374286929262669292C682E6461746128242C6E3D6E6577207628746869732C6529297D22737472696E67223D3D747970656F6620692626742E697346756E637469';
wwv_flow_api.g_varchar2_table(275) := '6F6E28733D6E5B695D29262628613D732E6170706C79286E2C6F29297D292C652861293F746869733A617D2C742E666E2E63726F707065722E436F6E7374727563746F723D762C742E666E2E63726F707065722E73657444656661756C74733D762E7365';
wwv_flow_api.g_varchar2_table(276) := '7444656661756C74732C742E666E2E63726F707065722E6E6F436F6E666C6963743D66756E6374696F6E28297B72657475726E20742E666E2E63726F707065723D762E6F746865722C746869737D7D293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(56080628497500516)
,p_plugin_id=>wwv_flow_api.id(56064276942500481)
,p_file_name=>'js/cropper.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
