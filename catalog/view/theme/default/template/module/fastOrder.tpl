<div class="box">
  <div class="box-heading">Быстрое оформление </div>
  <div class="box-content fastorder">
		<?php
		if($fastOrderError)
		{
			echo '<div class="message error">'.$formdata['errorMessage'].'</div>';
		}
		if($fastOrderSuccess)
		{
			echo '<div class="message success">'.$formdata['successMessage'].'</div>';
		}
		else
		{
			?><form action="" method="POST"><?php
				if(!empty($formdata['polya']))
				{
					foreach ($formdata['polya'] as $key => $pole)
					{
						$required = '';
						$requiredStar = '';
						if(!empty($formdata['polereq'][$key]) && $formdata['polereq'][$key] == 'on')
						{
							$required = 'required="true"';
							$requiredStar = '<span class="red">*</span>';
						}

						$_value = '';
						if(!empty($_POST[$pole]))
							$_value = $_POST[$pole];

						if($polya[$pole]['type']=='text')
						{
							
							?><div class="line">
								<label><b><?=$polya[$pole]['name']?><?=$requiredStar?>:</b></label>
								<input type="text" <?=$required?> name="<?=$pole?>" value="<?=$_value?>" />
							</div><?php
						}
						elseif($polya[$pole]['type']=='textarea')
						{
							?><div class="line">
								<label><b><?=$polya[$pole]['name']?><?=$requiredStar?>:</b></label>
								<textarea name="<?=$pole?>" <?=$required?>><?=$_value?></textarea>
							</div><?php
						}
					}
				}
				?>
				<div class="line subm">
					<input type="hidden" name="checkout" value="y" />
					<input type="submit" value="Оформить" />
				</div>
			</form><?php
		}
		?>
  </div>
</div>
<style>
.fastorder label{
	display: block;
	margin-bottom:5px;
}
.fastorder input[type="text"]{
	background: #fff;
	width:400px;
	padding:3px;
}
.fastorder textarea{
	background: #fff;
	width:400px;
	padding:3px;
	height:100px;
}
.fastorder .line{
	width:500px;
	margin:0 auto;
	margin-bottom:10px;
}
.fastorder .red{
	color:red;
}

</style>