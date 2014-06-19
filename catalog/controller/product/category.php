<?php

class ControllerProductCategory extends Controller {

    public function index() {
        $this->language->load('product/category');

        $this->load->model('catalog/category');

        $this->load->model('catalog/product');

        $this->load->model('tool/image');

        if (isset($this->request->get['filter'])) {
            $filter = $this->request->get['filter'];
        } else {
            $filter = '';
        }
        if (isset($this->request->get['product_id'])) {
            $selected_product_id = $this->request->get['product_id'];
        } else {
            $selected_product_id = '';
        }
        if (isset($this->request->get['sort'])) {
            $sort = $this->request->get['sort'];
        } else {
            $sort = 'p.sort_order';
        }

        if (isset($this->request->get['order'])) {
            $order = $this->request->get['order'];
        } else {
            $order = 'ASC';
        }

        if (isset($this->request->get['page'])) {
            $page = $this->request->get['page'];
        } else {
            $page = 1;
        }

        if (isset($this->request->get['limit'])) {
            $limit = $this->request->get['limit'];
        } else {
            $limit = $this->config->get('config_catalog_limit');
        }

        $this->data['breadcrumbs'] = array();

        $this->data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/home'),
            'separator' => false
        );

        if (isset($this->request->get['path'])) {
            $url = '';

            if (isset($this->request->get['sort'])) {
                $url .= '&sort=' . $this->request->get['sort'];
            }

            if (isset($this->request->get['order'])) {
                $url .= '&order=' . $this->request->get['order'];
            }

            if (isset($this->request->get['limit'])) {
                $url .= '&limit=' . $this->request->get['limit'];
            }

            $path = '';

            $parts = explode('_', (string) $this->request->get['path']);

            $category_id = (int) array_pop($parts);

            foreach ($parts as $path_id) {
                if (!$path) {
                    $path = (int) $path_id;
                } else {
                    $path .= '_' . (int) $path_id;
                }

                $category_info = $this->model_catalog_category->getCategory($path_id);

                if ($category_info) {
                    $this->data['breadcrumbs'][] = array(
                        'text' => $category_info['name'],
                        'href' => $this->url->link('product/category', 'path=' . $path . $url),
                        'separator' => $this->language->get('text_separator')
                    );
                }
            }
        } else {
            $categories = $this->model_catalog_category->getCategories();

            $path = $category_id = $categories[0]['category_id'];
        }

        $category_info = $this->model_catalog_category->getCategory($category_id);

        if ($category_info) {
            $this->document->setTitle($category_info['name']);
            $this->document->setDescription($category_info['meta_description']);
            $this->document->setKeywords($category_info['meta_keyword']);
            $this->document->addScript('catalog/view/javascript/jquery/jquery.total-storage.min.js');
            $this->document->addScript('catalog/view/javascript/jquery/jquery.jcarousel.min.js');
            if (file_exists('catalog/view/theme/' . $this->config->get('config_template') . '/stylesheet/carousel.css')) {
                $this->document->addStyle('catalog/view/theme/' . $this->config->get('config_template') . '/stylesheet/carousel.css');
            } else {
                $this->document->addStyle('catalog/view/theme/default/stylesheet/carousel.css');
            }

            $this->data['heading_title'] = $category_info['name'];
            $this->data['selected_product_id'] = $selected_product_id;
            $this->data['text_select'] = $this->language->get('text_select');
            $this->data['text_refine'] = $this->language->get('text_refine');
            $this->data['text_empty'] = $this->language->get('text_empty');
            $this->data['text_quantity'] = $this->language->get('text_quantity');
            $this->data['text_manufacturer'] = $this->language->get('text_manufacturer');
            $this->data['text_model'] = $this->language->get('text_model');
            $this->data['text_price'] = $this->language->get('text_price');
            $this->data['text_tax'] = $this->language->get('text_tax');
            $this->data['text_points'] = $this->language->get('text_points');
            $this->data['text_compare'] = sprintf($this->language->get('text_compare'), (isset($this->session->data['compare']) ? count($this->session->data['compare']) : 0));
            $this->data['text_display'] = $this->language->get('text_display');
            $this->data['text_list'] = $this->language->get('text_list');
            $this->data['text_grid'] = $this->language->get('text_grid');
            $this->data['text_sort'] = $this->language->get('text_sort');
            $this->data['text_limit'] = $this->language->get('text_limit');
            $this->data['text_reward'] = $this->language->get('text_reward');
            $this->data['text_discount'] = $this->language->get('text_discount');
            $this->data['text_stock'] = $this->language->get('text_stock');
            $this->data['text_option'] = $this->language->get('text_option');
            $this->data['text_qty'] = $this->language->get('text_qty');
            $this->data['button_cart'] = $this->language->get('button_cart');
            $this->data['button_wishlist'] = $this->language->get('button_wishlist');
            $this->data['button_compare'] = $this->language->get('button_compare');
            $this->data['button_continue'] = $this->language->get('button_continue');

            // Set the last category breadcrumb		
            $url = '';

            if (isset($this->request->get['sort'])) {
                $url .= '&sort=' . $this->request->get['sort'];
            }

            if (isset($this->request->get['order'])) {
                $url .= '&order=' . $this->request->get['order'];
            }

            if (isset($this->request->get['page'])) {
                $url .= '&page=' . $this->request->get['page'];
            }

            if (isset($this->request->get['limit'])) {
                $url .= '&limit=' . $this->request->get['limit'];
            }

            $this->data['breadcrumbs'][] = array(
                'text' => $category_info['name'],
                'href' => $this->url->link('product/category', 'path=' . $path),
                'separator' => $this->language->get('text_separator')
            );

            if ($category_info['image']) {
                $this->data['thumb'] = $this->model_tool_image->resize($category_info['image'], $this->config->get('config_image_category_width'), $this->config->get('config_image_category_height'));
            } else {
                $this->data['thumb'] = '';
            }

            $this->data['description'] = html_entity_decode($category_info['description'], ENT_QUOTES, 'UTF-8');
            $this->data['compare'] = $this->url->link('product/compare');

            $url = '';

            if (isset($this->request->get['filter'])) {
                $url .= '&filter=' . $this->request->get['filter'];
            }

            if (isset($this->request->get['sort'])) {
                $url .= '&sort=' . $this->request->get['sort'];
            }

            if (isset($this->request->get['order'])) {
                $url .= '&order=' . $this->request->get['order'];
            }

            if (isset($this->request->get['limit'])) {
                $url .= '&limit=' . $this->request->get['limit'];
            }

            $this->data['categories'] = array();

            $results = $this->model_catalog_category->getCategories($category_id);

            foreach ($results as $result) {
                $data = array(
                    'filter_category_id' => $result['category_id'],
                    'filter_sub_category' => true
                );

                $product_total = $this->model_catalog_product->getTotalProducts($data);

                $this->data['categories'][] = array(
                    'name' => $result['name'] . ($this->config->get('config_product_count') ? ' (' . $product_total . ')' : ''),
                    'href' => $this->url->link('product/category', 'path=' . $this->request->get['path'] . '_' . $result['category_id'] . $url)
                );
            }

            $this->data['products'] = array();

            $data = array(
                'filter_category_id' => $category_id,
                'filter_filter' => $filter,
                'sort' => $sort,
                'order' => $order,
                'start' => ($page - 1) * $limit,
                'limit' => $limit
            );

            $product_total = $this->model_catalog_product->getTotalProducts($data);

            $results = $this->model_catalog_product->getProducts($data);

            foreach ($results as $result) {
//                            $this->redirect($this->url->link('product/product', 'product_id=' . $result['product_id']));
                if ($result['image']) {
                    $image = $this->model_tool_image->resize($result['image'], $this->config->get('config_image_product_width'), $this->config->get('config_image_product_height'));
                } else {
                    $image = false;
                }

                if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
                    $price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')));
                } else {
                    $price = false;
                }

                if ((float) $result['special']) {
                    $special = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')));
                } else {
                    $special = false;
                }

                if ($this->config->get('config_tax')) {
                    $tax = $this->currency->format((float) $result['special'] ? $result['special'] : $result['price']);
                } else {
                    $tax = false;
                }

                if ($this->config->get('config_review_status')) {
                    $rating = (int) $result['rating'];
                } else {
                    $rating = false;
                }
                $text_minimum = sprintf($this->language->get('text_minimum'), $result['minimum']);
                $tab_review = sprintf($this->language->get('tab_review'), $result['reviews']);
                $manufacturer = $result['manufacturer'];
                $model = $result['model'];
                $reward = $result['reward'];
                $points = $result['points'];
                if ($result['quantity'] <= 0) {
                    $stock = $result['stock_status'];
                } elseif ($this->config->get('config_stock_display')) {
                    $stock = $result['quantity'];
                } else {
                    $stock = $this->language->get('text_instock');
                }
                if ($result['image']) {
                    $popup = $this->model_tool_image->resize($result['image'], $this->config->get('config_image_popup_width'), $this->config->get('config_image_popup_height'));
                } else {
                    $popup = '';
                }
                $images = array();

                $productImagesResults = $this->model_catalog_product->getProductImages($result['product_id']);

                foreach ($productImagesResults as $imagesResult) {
                    $images[] = array(
                        'popup' => $this->model_tool_image->resize($imagesResult['image'], $this->config->get('config_image_popup_width'), $this->config->get('config_image_popup_height')),
                        'thumb' => $this->model_tool_image->resize($imagesResult['image'], $this->config->get('config_image_additional_width'), $this->config->get('config_image_additional_height'))
                    );
                }
                $productDiscounts = $this->model_catalog_product->getProductDiscounts($result['product_id']);

                $discounts = array();

                foreach ($productDiscounts as $discount) {
                    $discounts[] = array(
                        'quantity' => $discount['quantity'],
                        'price' => $this->currency->format($this->tax->calculate($discount['price'], $result['tax_class_id'], $this->config->get('config_tax')))
                    );
                }

                $options = array();

                foreach ($this->model_catalog_product->getProductOptions($result['product_id']) as $option) {
                    if ($option['type'] == 'select' || $option['type'] == 'radio' || $option['type'] == 'checkbox' || $option['type'] == 'image') {
                        $option_value_data = array();

                        foreach ($option['option_value'] as $option_value) {
                            if (!$option_value['subtract'] || ($option_value['quantity'] > 0)) {
                                if ((($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) && (float) $option_value['price']) {
                                    $price = $this->currency->format($this->tax->calculate($option_value['price'], $result['tax_class_id'], $this->config->get('config_tax')));
                                } else {
                                    $price = false;
                                }

                                $option_value_data[] = array(
                                    'product_option_value_id' => $option_value['product_option_value_id'],
                                    'option_value_id' => $option_value['option_value_id'],
                                    'name' => $option_value['name'],
                                    'image' => $this->model_tool_image->resize($option_value['image'], 50, 50),
                                    'price' => $price,
                                    'price_prefix' => $option_value['price_prefix']
                                );
                            }
                        }

                        $options[] = array(
                            'product_option_id' => $option['product_option_id'],
                            'option_id' => $option['option_id'],
                            'name' => $option['name'],
                            'type' => $option['type'],
                            'option_value' => $option_value_data,
                            'required' => $option['required']
                        );
                    } elseif ($option['type'] == 'text' || $option['type'] == 'textarea' || $option['type'] == 'file' || $option['type'] == 'date' || $option['type'] == 'datetime' || $option['type'] == 'time') {
                        $options[] = array(
                            'product_option_id' => $option['product_option_id'],
                            'option_id' => $option['option_id'],
                            'name' => $option['name'],
                            'type' => $option['type'],
                            'option_value' => $option['option_value'],
                            'required' => $option['required']
                        );
                    }
                }

                if ($result['minimum']) {
                    $minimum = $result['minimum'];
                } else {
                    $minimum = 1;
                }

                $review_status = $this->config->get('config_review_status');
                $reviews = sprintf($this->language->get('text_reviews'), (int) $result['reviews']);
                $rating = (int) $result['rating'];
                $description = html_entity_decode($result['description'], ENT_QUOTES, 'UTF-8');
                $attribute_groups = $this->model_catalog_product->getProductAttributes($result['product_id']);
                $tags = array();

                if ($result['tag']) {
                    $resulttags = explode(',', $result['tag']);

                    foreach ($resulttags as $tag) {
                        $tags[] = array(
                            'tag' => trim($tag),
                            'href' => $this->url->link('product/search', 'tag=' . trim($tag))
                        );
                    }
                }
                $profiles = $this->model_catalog_product->getProfiles($result['product_id']);

                $this->data['products'][] = array(
                    'product_id' => $result['product_id'],
                    'heading_title' => $result['name'],
                    'thumb' => $image,
                    'name' => $result['name'],
                    'description' => utf8_substr(strip_tags(html_entity_decode($result['description'], ENT_QUOTES, 'UTF-8')), 0, 100) . '..',
                    'price' => $price,
                    'special' => $special,
                    'tax' => $tax,
                    'rating' => $result['rating'],
                    'reviews' => sprintf($this->language->get('text_reviews'), (int) $result['reviews']),
                    'href' => $this->url->link('product/product', 'path=' . $this->request->get['path'] . '&product_id=' . $result['product_id'] . $url),
                    'text_minimum' => $text_minimum,
                    'tab_review' => $tab_review,
                    'manufacturer' => $manufacturer,
                    'model' => $model,
                    'reward' => $reward,
                    'points' => $points,
                    'stock' => $stock,
                    'popup' => $popup,
                    'images' => $images,
                    'discounts' => $discounts,
                    'options' => $options,
                    'minimum' => $minimum,
                    'reviews' => $reviews,
                    'discounts' => $discounts,
                    'rating' => $rating,
                    'description' => $description,
                    'attribute_groups' => $attribute_groups,
                    'tags' => $tags,
                    'review_status' => $review_status,
                    'profiles' => $profiles,
                );
            }

            $url = '';

            if (isset($this->request->get['filter'])) {
                $url .= '&filter=' . $this->request->get['filter'];
            }

            if (isset($this->request->get['limit'])) {
                $url .= '&limit=' . $this->request->get['limit'];
            }

            $this->data['sorts'] = array();

            $this->data['sorts'][] = array(
                'text' => $this->language->get('text_default'),
                'value' => 'p.sort_order-ASC',
                'href' => $this->url->link('product/category', 'path=' . $this->request->get['path'] . '&sort=p.sort_order&order=ASC' . $url)
            );

            $this->data['sorts'][] = array(
                'text' => $this->language->get('text_name_asc'),
                'value' => 'pd.name-ASC',
                'href' => $this->url->link('product/category', 'path=' . $this->request->get['path'] . '&sort=pd.name&order=ASC' . $url)
            );

            $this->data['sorts'][] = array(
                'text' => $this->language->get('text_name_desc'),
                'value' => 'pd.name-DESC',
                'href' => $this->url->link('product/category', 'path=' . $this->request->get['path'] . '&sort=pd.name&order=DESC' . $url)
            );

            $this->data['sorts'][] = array(
                'text' => $this->language->get('text_price_asc'),
                'value' => 'p.price-ASC',
                'href' => $this->url->link('product/category', 'path=' . $this->request->get['path'] . '&sort=p.price&order=ASC' . $url)
            );

            $this->data['sorts'][] = array(
                'text' => $this->language->get('text_price_desc'),
                'value' => 'p.price-DESC',
                'href' => $this->url->link('product/category', 'path=' . $this->request->get['path'] . '&sort=p.price&order=DESC' . $url)
            );

            if ($this->config->get('config_review_status')) {
                $this->data['sorts'][] = array(
                    'text' => $this->language->get('text_rating_desc'),
                    'value' => 'rating-DESC',
                    'href' => $this->url->link('product/category', 'path=' . $this->request->get['path'] . '&sort=rating&order=DESC' . $url)
                );

                $this->data['sorts'][] = array(
                    'text' => $this->language->get('text_rating_asc'),
                    'value' => 'rating-ASC',
                    'href' => $this->url->link('product/category', 'path=' . $this->request->get['path'] . '&sort=rating&order=ASC' . $url)
                );
            }

            $this->data['sorts'][] = array(
                'text' => $this->language->get('text_model_asc'),
                'value' => 'p.model-ASC',
                'href' => $this->url->link('product/category', 'path=' . $this->request->get['path'] . '&sort=p.model&order=ASC' . $url)
            );

            $this->data['sorts'][] = array(
                'text' => $this->language->get('text_model_desc'),
                'value' => 'p.model-DESC',
                'href' => $this->url->link('product/category', 'path=' . $this->request->get['path'] . '&sort=p.model&order=DESC' . $url)
            );

            $url = '';

            if (isset($this->request->get['filter'])) {
                $url .= '&filter=' . $this->request->get['filter'];
            }

            if (isset($this->request->get['sort'])) {
                $url .= '&sort=' . $this->request->get['sort'];
            }

            if (isset($this->request->get['order'])) {
                $url .= '&order=' . $this->request->get['order'];
            }

            $this->data['limits'] = array();

            $limits = array_unique(array($this->config->get('config_catalog_limit'), 25, 50, 75, 100));

            sort($limits);

            foreach ($limits as $value) {
                $this->data['limits'][] = array(
                    'text' => $value,
                    'value' => $value,
                    'href' => $this->url->link('product/category', 'path=' . $this->request->get['path'] . $url . '&limit=' . $value)
                );
            }

            $url = '';

            if (isset($this->request->get['filter'])) {
                $url .= '&filter=' . $this->request->get['filter'];
            }

            if (isset($this->request->get['sort'])) {
                $url .= '&sort=' . $this->request->get['sort'];
            }

            if (isset($this->request->get['order'])) {
                $url .= '&order=' . $this->request->get['order'];
            }

            if (isset($this->request->get['limit'])) {
                $url .= '&limit=' . $this->request->get['limit'];
            }

            $pagination = new Pagination();
            $pagination->total = $product_total;
            $pagination->page = $page;
            $pagination->limit = $limit;
            $pagination->text = $this->language->get('text_pagination');
            $pagination->url = $this->url->link('product/category', 'path=' . $this->request->get['path'] . $url . '&page={page}');

            $this->data['pagination'] = $pagination->render();

            $this->data['sort'] = $sort;
            $this->data['order'] = $order;
            $this->data['limit'] = $limit;

            $this->data['continue'] = $this->url->link('common/home');

            if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/product/category.tpl')) {
                $this->template = $this->config->get('config_template') . '/template/product/category.tpl';
            } else {
                $this->template = 'default/template/product/category.tpl';
            }

            $this->children = array(
                'common/column_left',
                'common/column_right',
                'common/content_top',
                'common/content_bottom',
                'common/footer',
                'common/header'
            );

            $this->response->setOutput($this->render());
        } else {
            $url = '';

            if (isset($this->request->get['path'])) {
                $url .= '&path=' . $this->request->get['path'];
            }

            if (isset($this->request->get['filter'])) {
                $url .= '&filter=' . $this->request->get['filter'];
            }

            if (isset($this->request->get['sort'])) {
                $url .= '&sort=' . $this->request->get['sort'];
            }

            if (isset($this->request->get['order'])) {
                $url .= '&order=' . $this->request->get['order'];
            }

            if (isset($this->request->get['page'])) {
                $url .= '&page=' . $this->request->get['page'];
            }

            if (isset($this->request->get['limit'])) {
                $url .= '&limit=' . $this->request->get['limit'];
            }

            $this->data['breadcrumbs'][] = array(
                'text' => $this->language->get('text_error'),
                'href' => $this->url->link('product/category', $url),
                'separator' => $this->language->get('text_separator')
            );

            $this->document->setTitle($this->language->get('text_error'));

            $this->data['heading_title'] = $this->language->get('text_error');

            $this->data['text_error'] = $this->language->get('text_error');

            $this->data['button_continue'] = $this->language->get('button_continue');

            $this->data['continue'] = $this->url->link('common/home');

            $this->response->addHeader($this->request->server['SERVER_PROTOCOL'] . '/1.1 404 Not Found');

            if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/error/not_found.tpl')) {
                $this->template = $this->config->get('config_template') . '/template/error/not_found.tpl';
            } else {
                $this->template = 'default/template/error/not_found.tpl';
            }

            $this->children = array(
                'common/column_left',
                'common/column_right',
                'common/content_top',
                'common/content_bottom',
                'common/footer',
                'common/header'
            );

            $this->response->setOutput($this->render());
        }
    }

}

?>