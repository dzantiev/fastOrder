<?php  
class ControllerModulefastOrder extends Controller {
	protected $polya = array
	(
		'name'    => array('name'=>'Имя','type'=>'text','orderPoleName'=>'firstname'),
		'family'  => array('name'=>'Фамилие','type'=>'text','orderPoleName'=>'lastname'),
		'phone'   => array('name'=>'Телефон','type'=>'text','orderPoleName'=>'telephone'),
		'email'   => array('name'=>'Email','type'=>'text','orderPoleName'=>'email'),
		'city'    => array('name'=>'Город','type'=>'text','orderPoleName'=>'city'),
		'address' => array('name'=>'Адрес','type'=>'textarea','orderPoleName'=>'address'),
		'comment' => array('name'=>'Комментарий','type'=>'textarea','orderPoleName'=>'comment')
	);
	protected function index()
	{
		if($_REQUEST['route'] != 'checkout/checkout')
			return false;

		$this->data['fastOrderError'] = false;
		$this->data['fastOrderSuccess'] = false;
		if(!empty($_POST['checkout']))
		{
			if(!$this->validate())
				$this->data['fastOrderError'] = true;
			else
			{
				$this->makeOrder();
				$this->data['fastOrderSuccess'] = true;
			}
		}

		$this->data['formdata'] = $this->config->get('fastOrder_data');
		$this->data['polya'] = $this->polya;

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/module/test.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/module/fastOrder.tpl';
		} else {
			$this->template = 'default/template/module/fastOrder.tpl';
		}		
		$this->render();
	}

	private function validate()
	{
		$fData = $this->config->get('fastOrder_data');
		foreach($fData['polya'] as $key => $poleName)
		{
			if(!empty($fData['polereq'][$key]) && $fData['polereq'][$key] == 'on' && empty($_POST[$poleName]))
				return false;
		}
		return true;
	}
	private function makeOrder()
	{
		// confirm
			$fData = $this->config->get('fastOrder_data');
			$formData = array
			(
				'firstname' => '',
				'lastname'  => '',
				'address'   => '',
				'telephone'     => '',
				'email'     => 'noemail@no.com',
				'city'      => '',
				'comment'   => '',
			);
			foreach ($fData['polya'] as $key => $pole)
			{
				$formData[$this->polya[$pole]['orderPoleName']] = $this->request->post[$pole];
			}

			$shipping_address = array
			(
				'firstname'      => $formData['firstname'],
				'lastname'       => $formData['lastname'],
				'company'        => '',
				'address_1'      => $formData['address'],
				'address_2'      => '',
				'postcode'       => '',
				'city'           => $formData['city'],
				'country_id'     => '176',
				'zone_id'        => '',
				'country'        => 'Российская Федерация',
				'iso_code_2'     => 'RU',
				'iso_code_3'     => 'RUS',
				'address_format' => '',
				'zone'           => '',
				'zone_code'      => ''
			);
			$payment_address = array
			(
				'firstname'       => $formData['firstname'],
				'lastname'        => $formData['lastname'],
				'company'         => '',
				'company_id'      => '',
				'tax_id'          => '',
				'address_1'       => $formData['address'],
				'address_2'       => '',
				'postcode'        => '',
				'city'            => $formData['city'],
				'country_id'      => '176',
				'zone_id'         => '',
				'country'         => 'Российская Федерация',
				'iso_code_2'      => 'RU',
				'iso_code_3'      => 'RUS',
				'address_format'  => '',
				'zone'            => '',
				'zone_code'       => ''	
			);
			$this->session->data['payment_method'] = array
			(
				'code'       => 'cod',
				'title'      => 'Оплата при доставке',
				'sort_order' => '5'
			);
			$products = $this->cart->getProducts();

			$total_data = array();
			$total = 0;
			$taxes = $this->cart->getTaxes();
			 
			$this->load->model('setting/extension');
			
			$sort_order = array(); 
			
			$results = $this->model_setting_extension->getExtensions('total');
			foreach ($results as $key => $value)
			{
				$sort_order[$key] = $this->config->get($value['code'] . '_sort_order');
			}
			
			array_multisort($sort_order, SORT_ASC, $results);
			
			foreach ($results as $result) {
				if ($this->config->get($result['code'] . '_status')) {
					$this->load->model('total/' . $result['code']);
		
					$this->{'model_total_' . $result['code']}->getTotal($total_data, $total, $taxes);
				}
			}
			
			$sort_order = array(); 
		  
			foreach ($total_data as $key => $value) {
				$sort_order[$key] = $value['sort_order'];
			}
	
			array_multisort($sort_order, SORT_ASC, $total_data);
	
			$this->language->load('checkout/checkout');
			
			$data = array();
			
			$data['invoice_prefix'] = $this->config->get('config_invoice_prefix');
			$data['store_id'] = $this->config->get('config_store_id');
			$data['store_name'] = $this->config->get('config_name');
			
			if ($data['store_id'])
			{
				$data['store_url'] = $this->config->get('config_url');		
			}
			else
			{
				$data['store_url'] = HTTP_SERVER;	
			}

			$data['customer_id']       = 0;
			$data['customer_group_id'] = 1;
			$data['firstname']         = $formData['firstname'];
			$data['lastname']          = $formData['lastname'];
			$data['email']             = $formData['email'];
			$data['telephone']         = $formData['telephone'];
			$data['fax']               = '';
			
			$data['payment_firstname']      = $payment_address['firstname'];
			$data['payment_lastname']       = $payment_address['lastname'];	
			$data['payment_company']        = $payment_address['company'];	
			$data['payment_company_id']     = $payment_address['company_id'];	
			$data['payment_tax_id']         = $payment_address['tax_id'];	
			$data['payment_address_1']      = $payment_address['address_1'];
			$data['payment_address_2']      = $payment_address['address_2'];
			$data['payment_city']           = $payment_address['city'];
			$data['payment_postcode']       = $payment_address['postcode'];
			$data['payment_zone']           = $payment_address['zone'];
			$data['payment_zone_id']        = $payment_address['zone_id'];
			$data['payment_country']        = $payment_address['country'];
			$data['payment_country_id']     = $payment_address['country_id'];
			$data['payment_address_format'] = $payment_address['address_format'];

			$data['payment_method'] = 'Оплата при доставке';
			$data['payment_code'] = 'cod';

			$data['shipping_firstname']      = $shipping_address['firstname'];
			$data['shipping_lastname']       = $shipping_address['lastname'];	
			$data['shipping_company']        = $shipping_address['company'];	
			$data['shipping_address_1']      = $shipping_address['address_1'];
			$data['shipping_address_2']      = $shipping_address['address_2'];
			$data['shipping_city']           = $shipping_address['city'];
			$data['shipping_postcode']       = $shipping_address['postcode'];
			$data['shipping_zone']           = $shipping_address['zone'];
			$data['shipping_zone_id']        = $shipping_address['zone_id'];
			$data['shipping_country']        = $shipping_address['country'];
			$data['shipping_country_id']     = $shipping_address['country_id'];
			$data['shipping_address_format'] = $shipping_address['address_format'];

			$data['shipping_method'] = 'Фиксированная стоимость доставки';
			$data['shipping_code'] = 'flat.flat';

			$product_data = array();
			foreach ($this->cart->getProducts() as $product)
			{
				$option_data = array();
	
				foreach ($product['option'] as $option)
				{
					if ($option['type'] != 'file')
					{
						$value = $option['option_value'];	
					}
					else
					{
						$value = $this->encryption->decrypt($option['option_value']);
					}	
					
					$option_data[] = array(
						'product_option_id'       => $option['product_option_id'],
						'product_option_value_id' => $option['product_option_value_id'],
						'option_id'               => $option['option_id'],
						'option_value_id'         => $option['option_value_id'],								   
						'name'                    => $option['name'],
						'value'                   => $value,
						'type'                    => $option['type']
					);					
				}
	 
				$product_data[] = array(
					'product_id' => $product['product_id'],
					'name'       => $product['name'],
					'model'      => $product['model'],
					'option'     => $option_data,
					'download'   => $product['download'],
					'quantity'   => $product['quantity'],
					'subtract'   => $product['subtract'],
					'price'      => $product['price'],
					'total'      => $product['total'],
					'tax'        => $this->tax->getTax($product['price'], $product['tax_class_id']),
					'reward'     => $product['reward']
				); 
			}

			$voucher_data = array();

			$data['products'] = $product_data;
			$data['vouchers'] = $voucher_data;
			$data['totals']   = $total_data;
			$data['comment']  = 'test comment';
			$data['total']    = $total;

			$data['affiliate_id'] = 0;
			$data['commission'] = 0;

			$data['language_id']    = $this->config->get('config_language_id');
			$data['currency_id']    = $this->currency->getId();
			$data['currency_code']  = $this->currency->getCode();
			$data['currency_value'] = $this->currency->getValue($this->currency->getCode());
			$data['ip']             = $this->request->server['REMOTE_ADDR'];

			$data['forwarded_ip'] = '';

			$data['user_agent'] = $this->request->server['HTTP_USER_AGENT'];
			$data['accept_language'] = $this->request->server['HTTP_ACCEPT_LANGUAGE'];

			$this->load->model('checkout/order');
			
			$order_id = $this->model_checkout_order->addOrder($data);

			/*unset($this->session->data['shipping_method']);
			unset($this->session->data['shipping_methods']);*/

		$this->load->model('checkout/order');
		$this->model_checkout_order->confirm($order_id, $this->config->get('cod_order_status_id'));
		$this->cart->clear();

	}
}
?>