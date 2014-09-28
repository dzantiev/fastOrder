<?php echo $header; ?>
<div id="content">
	<div class="breadcrumb">
		<?php foreach ($breadcrumbs as $breadcrumb) { ?>
		<?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
		<?php } ?>
	</div>
	<?php if ($error_warning) { ?>
	<div class="warning"><?php echo $error_warning; ?></div>
	<?php } ?>
	<div class="box">
		<div class="heading">
			<h1><img src="view/image/module.png" alt="" /> <?php echo $heading_title; ?></h1>
			<a href="http://prootime.ru/?fromproj=fastOrder01" class="proologo" target="_blank"><img src="http://upfile.prootime.ru/proolabs.png" alt="ProoLabs" width="77px"></a>
			<div class="buttons"> <a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a><a onclick="location = '<?php echo $cancel; ?>';" class="button"><?php echo $button_cancel; ?></a></div>
		</div>
		<div class="content">
			<form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
			<h3>Настройки модуля</h3>
			<table id="modulesettings" class="list">
				<tbody id="module-row0">
					<tr>
						<td>
						<label><b>Сообщение об успешном оформлении заказа:</b></label>
						<textarea name="fastOrder_data[successMessage]"><?php
						if(!empty($fastOrder_data['successMessage']))
						{
							echo $fastOrder_data['successMessage'];
						}
						else
						{
							echo "Ваш заказ успешно оформлен, наши менеджеры свяжутся с вами в ближайшее время.";
						}
						?></textarea></td>
					</tr>
					<tr>
						<td>
							<label><b>Сообщение об ошибке:</b></label>
							<textarea name="fastOrder_data[errorMessage]"><?php
						if(!empty($fastOrder_data['errorMessage']))
						{
							echo $fastOrder_data['errorMessage'];
						}
						else
						{
							echo "Не все поля были запонены корректно.";
						}
						?></textarea>
						</td>
					</tr>
					<?php
					$optionsTemplate = '';
					foreach ($polya as $key => $pole)
					{
						$optionsTemplate .= '<option value="'.$key.'">'.$pole.'</option>';
					}
					if(!empty($fastOrder_data['polya']))
					{
						foreach ($fastOrder_data['polya'] as $key => $pole)
						{
							$checked = '';
							if(!empty($fastOrder_data['polereq'][$key]) && $fastOrder_data['polereq'][$key] == 'on')
								$checked = 'checked="true"';
							echo '<tr><td><input type="checkbox" title="Обязательное поле" class="reqinp" '.$checked.' name="fastOrder_data[polereq]['.$key.']" value="on"/><select name="fastOrder_data[polya][]">';
							foreach ($polya as $sub_key => $sub_pole)
							{
								$_selected = '';
								if($sub_key == $pole)
									$_selected = 'selected="true"';
								echo '<option value="'.$sub_key.'" '.$_selected.'>'.$sub_pole.'</option>';
							}
							echo '</select><a href="javascript:void(0);" onclick="removePole(this)" class="delete">удалить</a></td></tr>';
						}
					}
					?>
					<tr class="addpolerow">
						<td style="text-align:center;">
							<a href="javascript:addPole()" class="add">добавить</a>
						</td>
					</tr>
				</tfoot>
			</table>
			<h3>Страницы на котрых выводится быстрое оформление</h3>
				<table id="module" class="list">
					<thead>
						<tr>
							<td class="left"><?php echo $entry_layout; ?></td>
							<td class="left"><?php echo $entry_position; ?></td>
							<td class="left"><?php echo $entry_status; ?></td>
							<td class="right"><?php echo $entry_sort_order; ?></td>
							<td></td>
						</tr>
					</thead>
					<?php $module_row = 0; ?>
					<?php foreach ($modules as $module) { ?>
					<tbody id="module-row<?php echo $module_row; ?>">
						<tr>
							<td class="left"><select name="fastOrder_module[<?php echo $module_row; ?>][layout_id]">
									<?php foreach ($layouts as $layout) { ?>
									<?php if ($layout['layout_id'] == $module['layout_id']) { ?>
									<option value="<?php echo $layout['layout_id']; ?>" selected="selected"><?php echo $layout['name']; ?></option>
									<?php } else { ?>
									<option value="<?php echo $layout['layout_id']; ?>"><?php echo $layout['name']; ?></option>
									<?php } ?>
									<?php } ?>
								</select></td>
							<td class="left"><select name="fastOrder_module[<?php echo $module_row; ?>][position]">
									<?php if ($module['position'] == 'content_top') { ?>
									<option value="content_top" selected="selected"><?php echo $text_content_top; ?></option>
									<?php } else { ?>
									<option value="content_top"><?php echo $text_content_top; ?></option>
									<?php } ?>
									<?php if ($module['position'] == 'content_bottom') { ?>
									<option value="content_bottom" selected="selected"><?php echo $text_content_bottom; ?></option>
									<?php } else { ?>
									<option value="content_bottom"><?php echo $text_content_bottom; ?></option>
									<?php } ?>
									<?php if ($module['position'] == 'column_left') { ?>
									<option value="column_left" selected="selected"><?php echo $text_column_left; ?></option>
									<?php } else { ?>
									<option value="column_left"><?php echo $text_column_left; ?></option>
									<?php } ?>
									<?php if ($module['position'] == 'column_right') { ?>
									<option value="column_right" selected="selected"><?php echo $text_column_right; ?></option>
									<?php } else { ?>
									<option value="column_right"><?php echo $text_column_right; ?></option>
									<?php } ?>
								</select></td>
							<td class="left"><select name="fastOrder_module[<?php echo $module_row; ?>][status]">
									<?php if ($module['status']) { ?>
									<option value="1" selected="selected"><?php echo $text_enabled; ?></option>
									<option value="0"><?php echo $text_disabled; ?></option>
									<?php } else { ?>
									<option value="1"><?php echo $text_enabled; ?></option>
									<option value="0" selected="selected"><?php echo $text_disabled; ?></option>
									<?php } ?>
								</select></td>
							<td class="right"><input type="text" name="fastOrder_module[<?php echo $module_row; ?>][sort_order]" value="<?php echo $module['sort_order']; ?>" size="3" /></td>
							<td class="left"><a onclick="$('#module-row<?php echo $module_row; ?>').remove();" class="button"><?php echo $button_remove; ?></a></td>
						</tr>
					</tbody>
					<?php $module_row++; ?>
					<?php } ?>
					<tfoot>
						<tr>
							<td colspan="4"></td>
							<td class="left"><a onclick="addModule();" class="button"><?php echo $button_add_module; ?></a></td>
						</tr>
					</tfoot>
				</table>
			</form>
		</div>
	</div>
</div>
<script type="text/javascript"><!--
var module_row = <?php echo $module_row; ?>;

function addModule() {	
	html  = '<tbody id="module-row' + module_row + '">';
	html += '  <tr>';
	html += '    <td class="left"><select name="fastOrder_module[' + module_row + '][layout_id]">';
	<?php foreach ($layouts as $layout) { ?>
	html += '      <option value="<?php echo $layout['layout_id']; ?>"><?php echo addslashes($layout['name']); ?></option>';
	<?php } ?>
	html += '    </select></td>';
	html += '    <td class="left"><select name="fastOrder_module[' + module_row + '][position]">';
	html += '      <option value="content_top"><?php echo $text_content_top; ?></option>';
	html += '      <option value="content_bottom"><?php echo $text_content_bottom; ?></option>';
	html += '      <option value="column_left"><?php echo $text_column_left; ?></option>';
	html += '      <option value="column_right"><?php echo $text_column_right; ?></option>';
	html += '    </select></td>';
	html += '    <td class="left"><select name="fastOrder_module[' + module_row + '][status]">';
		html += '      <option value="1" selected="selected"><?php echo $text_enabled; ?></option>';
		html += '      <option value="0"><?php echo $text_disabled; ?></option>';
		html += '    </select></td>';
	html += '    <td class="right"><input type="text" name="fastOrder_module[' + module_row + '][sort_order]" value="" size="3" /></td>';
	html += '    <td class="left"><a onclick="$(\'#module-row' + module_row + '\').remove();" class="button"><?php echo $button_remove; ?></a></td>';
	html += '  </tr>';
	html += '</tbody>';

	$('#module tfoot').before(html);

	module_row++;
}
function addPole()
{
	var countpl = $('.reqinp').size()-1;
	$('.addpolerow').before('<tr> <td><input type="checkbox" title="Обязательное поле" class="reqinp" name="fastOrder_data[polereq]['+countpl+']" value="on"/><select name="fastOrder_data[polya][]"><?=$optionsTemplate?></select> <a href="javascript:void(0);" onclick="removePole(this)" class="delete">удалить</a> </td> </tr>');
}
function removePole(instance)
{
	$(instance).parents('td').parents('tr').remove();
}
//--></script> 
<style>
	table#modulesettings{
	    width:500px;
	    margin:0 auto;
	    margin-bottom:40px;
	}
	table#modulesettings td{
	    padding:10px;
	}
	table#modulesettings td textarea{
	    width:470px;
	    padding:5px;
	    border:1px solid #bbb;
	}
	table#modulesettings td .reqinp{
		margin-right:10px;
	}
	table#modulesettings td select{
	    width:375px;
	    margin-right:30px;
	}
	table#modulesettings td .delete{
	    color:red;
	}
	a.proologo{
	    margin-left:24px;
	    line-height:52px;
	}
</style>
<?php echo $footer; ?>