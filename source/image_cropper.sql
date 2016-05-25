/*-------------------------------------
 * Apex Image Cropper functions
 * Version: 1.0 (2016-05-24)
 * Author:  Maxime Tremblay
 *-------------------------------------
 */

--
-- Function that initialize the image cropper plugin
function render_image_cropper(p_dynamic_action in apex_plugin.t_dynamic_action,
                              p_plugin         in apex_plugin.t_plugin)
return apex_plugin.t_dynamic_action_render_result is
    l_result                   apex_plugin.t_dynamic_action_render_result;

    -- plugin attributes
    l_showSpinner              p_plugin.attribute_01%type  := p_plugin.attribute_01;

    -- dynamic action attributes
    l_viewMode                 p_dynamic_action.attribute_01%type  := p_dynamic_action.attribute_01;
    l_dragMode                 p_dynamic_action.attribute_02%type  := p_dynamic_action.attribute_02;
    l_aspectRatio              p_dynamic_action.attribute_03%type  := p_dynamic_action.attribute_03;
    l_previewSelector          p_dynamic_action.attribute_04%type  := sys.htf.escape_sc(p_dynamic_action.attribute_04);
    l_minContainerWidth        p_dynamic_action.attribute_05%type  := p_dynamic_action.attribute_05;
    l_minContainerHeight       p_dynamic_action.attribute_06%type  := p_dynamic_action.attribute_06;
    l_minCanvasWidth           p_dynamic_action.attribute_07%type  := p_dynamic_action.attribute_07;
    l_minCanvasHeight          p_dynamic_action.attribute_08%type  := p_dynamic_action.attribute_08;
    l_minCropBoxWidth          p_dynamic_action.attribute_09%type  := p_dynamic_action.attribute_09;
    l_minCropBoxHeight         p_dynamic_action.attribute_10%type  := p_dynamic_action.attribute_10;
    l_saveSelector             p_dynamic_action.attribute_12%type  := sys.htf.escape_sc(p_dynamic_action.attribute_12);
    l_croppedImageWidth        p_dynamic_action.attribute_13%type  := p_dynamic_action.attribute_13;
    l_croppedImageHeight       p_dynamic_action.attribute_14%type  := p_dynamic_action.attribute_14;

    l_min_file                 varchar2(4)  := '.min';
    l_logging                  varchar2(10) := 'false';
begin
    -- Debug
    if apex_application.g_debug then
        apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,
                                              p_dynamic_action => p_dynamic_action);
        l_logging  := 'true';
        l_min_file := '';
    end if;

    -- add javascript files
    apex_javascript.add_library(p_name      => 'cropper' || l_min_file,
                                p_directory => p_plugin.file_prefix || 'js/');
    apex_javascript.add_library(p_name      => 'apexCropper' || l_min_file,
                                p_directory => p_plugin.file_prefix || 'js/');

    -- add css files
    apex_css.add_file(p_name      => 'cropper' || l_min_file,
                      p_directory => p_plugin.file_prefix || 'css/');

    -- function that initialize the image cropper
    l_result.javascript_function := 'apexCropper.apexCropperInit';
    l_result.attribute_01        := '{' || apex_javascript.add_attribute('ajaxIdentifier', apex_plugin.get_ajax_identifier) ||
                                           apex_javascript.add_attribute('logging', l_logging) ||
                                           apex_javascript.add_attribute('viewMode', l_viewMode) ||
                                           apex_javascript.add_attribute('dragMode', l_dragMode) ||
                                           apex_javascript.add_attribute('aspectRatio', l_aspectRatio) ||
                                           apex_javascript.add_attribute('previewSelector', l_previewSelector) ||
                                           apex_javascript.add_attribute('minContainerWidth', l_minContainerWidth) ||
                                           apex_javascript.add_attribute('minContainerHeight', l_minContainerHeight) ||
                                           apex_javascript.add_attribute('minCanvasWidth', l_minCanvasWidth) ||
                                           apex_javascript.add_attribute('minCanvasHeight', l_minCanvasHeight) ||
                                           apex_javascript.add_attribute('minCropBoxWidth', l_minCropBoxWidth) ||
                                           apex_javascript.add_attribute('minCropBoxHeight', l_minCropBoxHeight) ||
                                           apex_javascript.add_attribute('saveSelector', l_saveSelector) ||
                                           apex_javascript.add_attribute('croppedImageWidth', l_croppedImageWidth) ||
                                           apex_javascript.add_attribute('croppedImageHeight', l_croppedImageHeight) ||
                                           apex_javascript.add_attribute('showSpinner', l_showSpinner, false, false) ||
                                           '}';

    return l_result;
end render_image_cropper;

--
-- AJAX function that runs the PLSQL code which saves the cropped
-- image to database tables or collections.
function ajax_image_cropper(p_dynamic_action in apex_plugin.t_dynamic_action,
                            p_plugin         in apex_plugin.t_plugin)
return apex_plugin.t_dynamic_action_ajax_result is
    -- plugin attributes
    l_plsql_code  p_plugin.attribute_11%type  := p_dynamic_action.attribute_11;
begin
    -- execute PL/SQL
    apex_plugin_util.execute_plsql_code(p_plsql_code => l_plsql_code);

    return null;
end ajax_image_cropper;