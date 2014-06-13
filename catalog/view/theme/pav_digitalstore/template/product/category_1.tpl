<?php require( DIR_TEMPLATE.$this->config->get('config_template')."/template/common/config.tpl" ); 
$themeConfig = $this->config->get('themecontrol');
$categoryConfig = array(
'listing_products_columns'           => 0,
'listing_products_columns_small'     => 2,
'listing_products_columns_minismall' => 1,
'cateogry_display_mode'              => 'grid',
'category_pzoom'                     => 1,
'quickview'                          => 0,
'show_swap_image'                    => 0,
);
$categoryConfig     = array_merge($categoryConfig, $themeConfig );
$DISPLAY_MODE 	    = $categoryConfig['cateogry_display_mode'];
$MAX_ITEM_ROW       = $themeConfig['listing_products_columns']?$themeConfig['listing_products_columns']:3; 
$MAX_ITEM_ROW_SMALL = $categoryConfig['listing_products_columns_small'] ;
$MAX_ITEM_ROW_MINI  = $categoryConfig['listing_products_columns_minismall'];
$categoryPzoom 	    = $categoryConfig['category_pzoom'];
$quickview          = $categoryConfig['quickview'];
$swapimg            = $categoryConfig['show_swap_image'];

$themeConfig = $this->config->get('themecontrol');
$productConfig = array(
'product_enablezoom'         => 1,
'product_zoommode'           => 'basic',
'product_zoomeasing'         => 1,
'product_zoomlensshape'      => "round",
'product_zoomlenssize'       => "150",
'product_zoomgallery'        => 0,
'enable_product_customtab'   => 0,
'product_customtab_name'     => '',
'product_customtab_content'  => '',
'product_related_column'     => 0,
);
$languageID = $this->config->get('config_language_id');
$productConfig = array_merge( $productConfig, $themeConfig ); 
?>
<?php echo $header; ?>
<?php require( DIR_TEMPLATE.$this->config->get('config_template')."/template/common/breadcrumb.tpl" );  ?>	

<?php if( $SPAN[0] ): ?>
<aside class="col-lg-<?php echo $SPAN[0];?> col-md-<?php echo $SPAN[0];?> col-sm-12 col-xs-12">
    <?php echo $column_left; ?>
</aside>	
<?php endif; ?> 
<section class="col-lg-<?php echo $SPAN[1];?> col-md-<?php echo $SPAN[1];?> col-sm-12 col-xs-12">
    <div id="content"><?php echo $content_top; ?>

        <?php if ($products) { ?>
         
        <div class="product-list"> <div class="products-block">
                <?php
                $cols = $MAX_ITEM_ROW ;
                $span = floor(12/$cols);
                $small = floor(12/$MAX_ITEM_ROW_SMALL);
                $mini = floor(12/$MAX_ITEM_ROW_MINI);
                foreach ($products as $i => $product) { ?>
                <?php if( $i++%$cols == 0 ) { ?>
                <div class="row products-item">
                    <?php } ?>
                    <div class="col-xs-6 col-lg-<?php echo $span;?> col-sm-<?php echo $small;?> col-xs-<?php echo $mini;?>">
                        <div class="product-block clearfix ">	
                            <div class="product-info">
                                <div class="row">

                                    <?php if ($product['thumb'] || $product['images']) { ?>
                                    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-12 image-container">
                                        <?php if ($product['thumb']) { ?>
                                        <div class="image">
                                            <?php if( $product['special'] )  { ?>
                                            <div class="product-label-special label"><?php echo $this->language->get( 'text_sale' ); ?></div>
                                            <?php } ?>
                                            <a href="<?php echo $product['popup']; ?>" title="<?php echo $product['heading_title']; ?>" class="colorbox">
                                                <img src="<?php echo $product['thumb']; ?>" title="<?php echo $product['heading_title']; ?>" alt="<?php echo $product['heading_title']; ?>" id="image"  data-zoom-image="<?php echo $product['popup']; ?>" class="product-image-zoom"/></a></div>
                                        <?php } ?>
                                        <?php if ($product['images']) { ?>
                                        <div class="image-additional slide carousel" id="image-additional"><div class="carousel-inner">
                                                <?php 
                                                if( $productConfig['product_zoomgallery'] == 'slider' && $product['thumb'] ) {  
                                                $eimages = array( 0=> array( 'popup'=>$product['popup'],'thumb'=> $product['thumb'] )  ); 
                                                $images = array_merge( $eimages, $product['images'] );
                                                }
                                                $icols = 3; $ii= 0;
                                                foreach ($images as  $image) { ?>
                                                <?php if( (++$ii)%$icols == 1 ) { ?>
                                                <div class="item">
                                                    <?php } ?>

                                                    <a href="<?php echo $image['popup']; ?>" title="<?php echo $product['heading_title']; ?>" class="colorbox" data-zoom-image="<?php echo $image['popup']; ?>" data-image="<?php echo $image['popup']; ?>">
                                                        <img src="<?php echo $image['thumb']; ?>" style="max-width:<?php echo $this->config->get('config_image_additional_width');?>px"  title="<?php echo $product['heading_title']; ?>" alt="<?php echo $product['heading_title']; ?>" data-zoom-image="<?php echo $image['popup']; ?>" class="product-image-zoom" />
                                                    </a>
                                                    <?php if( $ii%$icols == 0 || $ii==count($images) ) { ?>
                                                </div>
                                                <?php } ?>
                                                <?php } ?>
                                            </div>
                                            <div class="carousel-control left fa fa-angle-left" href="#image-additional" data-slide="prev"></div>
                                            <div class="carousel-control right fa fa-angle-right" href="#image-additional" data-slide="next"></div>
                                        </div>
                                        <script type="text/javascript">
                                                    $('#image-additional .item:first').addClass('active');
                                                    $('#image-additional').carousel({interval: false})
                                        </script>

                                        <?php } ?>

                                    </div>
                                    <?php } ?>
                                    <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12">
                                        <h1><?php echo $product['heading_title']; ?></h1>

                                        <?php if ($product['price']) { ?>
                                        <div class="price"><?php //echo $text_price; ?>
                                            <?php if (!$product['special']) { ?>
                                            <?php echo $product['price']; ?>
                                            <?php } else { ?>
                                            <span class="price-old"><?php echo $product['price']; ?></span> <span class="price-new"><?php echo $product['special']; ?></span>
                                            <?php } ?>
                                            <br />
                                            <?php if ($product['tax']) { ?>
                                            <span class="price-tax"><?php echo $text_tax; ?> <?php echo $product['tax']; ?></span><br />
                                            <?php } ?>
                                            <?php if ($product['points']) { ?>
                                            <span class="reward"><small><?php echo $text_points; ?> <?php echo $product['points']; ?></small></span><br />
                                            <?php } ?>
                                            <?php if ($product['discounts']) { ?>
                                            <div class="discount">
                                                <?php foreach ($product['discounts'] as $discount) { ?>
                                                <?php echo sprintf($text_discount, $discount['quantity'], $discount['price']); ?><br />
                                                <?php } ?>
                                            </div>
                                            <?php } ?>
                                        </div>
                                        <?php } ?>


                                        <div class="description">
                                            <?php if ($product['manufacturer']) { ?>
                                            <span><?php echo $text_manufacturer; ?></span> <a href="<?php echo $product['manufacturer']; ?>"><?php echo $product['manufacturer']; ?></a><br />
                                            <?php } ?>
                                            <span><?php echo $text_model; ?></span> <?php echo $product['model']; ?><br />
                                            <?php if ($product['reward']) { ?>
                                            <span><?php echo $text_reward; ?></span> <?php echo $product['reward']; ?><br />
                                            <?php } ?>
                                            <span><?php echo $text_stock; ?></span> <?php echo $product['stock']; ?>
                                            <?php echo $product['description']; ?>
                                        </div>


                                        <div class="product-extra clearfix">
                                            <div class="quantity-adder pull-left">
                                                <?php echo $text_qty; ?>
                                                <input class="form-control" type="text" name="quantity" size="2" value="<?php echo $product['minimum']; ?>" />
                                                <span class="add-up add-action">+</span> 
                                                <span class="add-down add-action">-</span>
                                            </div>
                                            <div class="product-action product-block">
                                                <input type="hidden" name="product_id" size="2" value="<?php echo $product['product_id']; ?>" />
                                                &nbsp;
                                                <div class="cart pull-left"><input type="button" value="<?php echo $button_cart; ?>" id="button-cart" class="button" /></div>
                                                <div class="wishlist-compare pull-left">
                                                    <!-- <span>&nbsp;&nbsp;<?php //echo $text_or; ?>&nbsp;&nbsp;</span> -->
                                                    <span class="wishlist"><a class="fa fa-heart" onclick="addToWishList('<?php echo  $product['product_id']; ?>');" data-placement="top" data-toggle="tooltip" data-original-title="<?php echo $button_wishlist; ?>"><span><?php echo $button_wishlist; ?></span></a></span>
                                                    <span class="compare"><a class="fa fa-retweet" onclick="addToCompare('<?php echo $product['product_id']; ?>');" data-placement="top" data-toggle="tooltip" data-original-title="<?php echo $button_compare; ?>"><span><?php echo $button_compare; ?></span></a></span>
                                                </div>
                                            </div>
                                        </div>
                                        <?php if ($product['minimum'] > 1) { ?>
                                        <div class="minimum"><?php echo $text_minimum; ?></div>
                                        <?php } ?>
                                        <?php if ($product['profiles']): ?>
                                        <div class="option">
                                            <h2><span class="required">*</span><?php echo $text_payment_profile ?></h2>
                                            <select class="form-control" name="profile_id">
                                                <option value=""><?php echo $text_select; ?></option>
                                                <?php foreach ($product['profiles'] as $profile): ?>
                                                <option value="<?php echo $profile['profile_id'] ?>"><?php echo $profile['name'] ?></option>
                                                <?php endforeach; ?>
                                            </select>
                                            <br />
                                            <span id="profile-description"></span>
                                            <br />
                                        </div>
                                        <?php endif; ?>



                                        <?php if ($product['options']) { ?>
                                        <div class="options">
                                            <h2><?php echo $text_option; ?></h2>
                                            <?php foreach ($product['options'] as $option) { ?>
                                            <?php if ($option['type'] == 'select') { ?>
                                            <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
                                                <?php if ($option['required']) { ?>
                                                <span class="required">*</span>
                                                <?php } ?>
                                                <label><?php echo $option['name']; ?>:</label>
                                                <select class="form-control" name="option[<?php echo $option['product_option_id']; ?>]">
                                                    <option value=""><?php echo $text_select; ?></option>
                                                    <?php foreach ($option['option_value'] as $option_value) { ?>
                                                    <option value="<?php echo $option_value['product_option_value_id']; ?>"><?php echo $option_value['name']; ?>
                                                        <?php if ($option_value['price']) { ?>
                                                        (<?php echo $option_value['price_prefix']; ?><?php echo $option_value['price']; ?>)
                                                        <?php } ?>
                                                    </option>
                                                    <?php } ?>
                                                </select>
                                            </div>
                                            <?php } ?>
                                            <?php if ($option['type'] == 'radio') { ?>
                                            <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
                                                <?php if ($option['required']) { ?>
                                                <span class="required">*</span>
                                                <?php } ?>
                                                <label><?php echo $option['name']; ?>:</label>
                                                <?php foreach ($option['option_value'] as $option_value) { ?>
                                                <div class="radio"><input type="radio" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option_value['product_option_value_id']; ?>" id="option-value-<?php echo $option_value['product_option_value_id']; ?>" />
                                                    <label for="option-value-<?php echo $option_value['product_option_value_id']; ?>"><?php echo $option_value['name']; ?>
                                                        <?php if ($option_value['price']) { ?>
                                                        (<?php echo $option_value['price_prefix']; ?><?php echo $option_value['price']; ?>)
                                                        <?php } ?>
                                                    </label>
                                                </div>
                                                <?php } ?>
                                            </div>
                                            <?php } ?>
                                            <?php if ($option['type'] == 'checkbox') { ?>
                                            <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
                                                <?php if ($option['required']) { ?>
                                                <span class="required">*</span>
                                                <?php } ?>
                                                <label><?php echo $option['name']; ?>:</label>
                                                <?php foreach ($option['option_value'] as $option_value) { ?>
                                                <div class="checkbox"><input type="checkbox" name="option[<?php echo $option['product_option_id']; ?>][]" value="<?php echo $option_value['product_option_value_id']; ?>" id="option-value-<?php echo $option_value['product_option_value_id']; ?>" />
                                                    <label for="option-value-<?php echo $option_value['product_option_value_id']; ?>"><?php echo $option_value['name']; ?>
                                                        <?php if ($option_value['price']) { ?>
                                                        (<?php echo $option_value['price_prefix']; ?><?php echo $option_value['price']; ?>)
                                                        <?php } ?>
                                                    </label>
                                                </div>
                                                <?php } ?>
                                            </div>
                                            <?php } ?>
                                            <?php if ($option['type'] == 'image') { ?>
                                            <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
                                                <?php if ($option['required']) { ?>
                                                <span class="required">*</span>
                                                <?php } ?>
                                                <label><?php echo $option['name']; ?>:</label>
                                                <table class="option-image">
                                                    <?php foreach ($option['option_value'] as $option_value) { ?>
                                                    <tr>
                                                        <td style="width: 1px;"><input type="radio" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option_value['product_option_value_id']; ?>" id="option-value-<?php echo $option_value['product_option_value_id']; ?>" /></td>
                                                        <td><label for="option-value-<?php echo $option_value['product_option_value_id']; ?>"><img src="<?php echo $option_value['image']; ?>" alt="<?php echo $option_value['name'] . ($option_value['price'] ? ' ' . $option_value['price_prefix'] . $option_value['price'] : ''); ?>" /></label></td>
                                                        <td><label for="option-value-<?php echo $option_value['product_option_value_id']; ?>"><?php echo $option_value['name']; ?>
                                                                <?php if ($option_value['price']) { ?>
                                                                (<?php echo $option_value['price_prefix']; ?><?php echo $option_value['price']; ?>)
                                                                <?php } ?>
                                                            </label></td>
                                                    </tr>
                                                    <?php } ?>
                                                </table>
                                            </div>
                                            <?php } ?>
                                            <?php if ($option['type'] == 'text') { ?>
                                            <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
                                                <?php if ($option['required']) { ?>
                                                <span class="required">*</span>
                                                <?php } ?>
                                                <label><?php echo $option['name']; ?>:</label>
                                                <input class="form-control" type="text" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option['option_value']; ?>" />
                                            </div>
                                            <?php } ?>
                                            <?php if ($option['type'] == 'textarea') { ?>
                                            <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
                                                <?php if ($option['required']) { ?>
                                                <span class="required">*</span>
                                                <?php } ?>
                                                <label><?php echo $option['name']; ?>:</label>
                                                <textarea class="form-control" name="option[<?php echo $option['product_option_id']; ?>]" cols="40" rows="5"><?php echo $option['option_value']; ?></textarea>
                                            </div>
                                            <?php } ?>
                                            <?php if ($option['type'] == 'file') { ?>
                                            <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
                                                <?php if ($option['required']) { ?>
                                                <span class="required">*</span>
                                                <?php } ?>
                                                <label><?php echo $option['name']; ?>:</label>
                                                <input class="btn btn-theme-primary" type="button" value="<?php echo $button_upload; ?>" id="button-option-<?php echo $option['product_option_id']; ?>" class="button">
                                                    <input type="hidden" name="option[<?php echo $option['product_option_id']; ?>]" value="" />
                                            </div>
                                            <?php } ?>
                                            <?php if ($option['type'] == 'date') { ?>
                                            <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
                                                <?php if ($option['required']) { ?>
                                                <span class="required">*</span>
                                                <?php } ?>
                                                <label><?php echo $option['name']; ?>:</label>
                                                <input class="form-control" type="text" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option['option_value']; ?>" class="date" />
                                            </div>
                                            <?php } ?>
                                            <?php if ($option['type'] == 'datetime') { ?>
                                            <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
                                                <?php if ($option['required']) { ?>
                                                <span class="required">*</span>
                                                <?php } ?>
                                                <label><?php echo $option['name']; ?>:</label>
                                                <input class="form-control" type="text" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option['option_value']; ?>" class="datetime" />
                                            </div>
                                            <?php } ?>
                                            <?php if ($option['type'] == 'time') { ?>
                                            <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
                                                <?php if ($option['required']) { ?>
                                                <span class="required">*</span>
                                                <?php } ?>
                                                <label><?php echo $option['name']; ?>:</label>
                                                <input class="form-control" type="text" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option['option_value']; ?>" class="time" />
                                            </div>
                                            <?php } ?>
                                            <?php } ?>
                                        </div>
                                        <?php } ?>

                                        <?php if ($product['tags']) { ?>
                                        <div class="tags"><b><?php echo $text_tags; ?></b>
                                            <?php for ($i = 0; $i < count($product['tags']); $i++) { ?>
                                            <?php if ($i < (count($tags) - 1)) { ?>
                                            <a href="<?php echo $tags[$i]['href']; ?>"><?php echo $tags[$i]['tag']; ?></a>,
                                            <?php } else { ?>
                                            <a href="<?php echo $tags[$i]['href']; ?>"><?php echo $tags[$i]['tag']; ?></a>
                                            <?php } ?>
                                            <?php } ?>
                                        </div>
                                        <?php } ?>


                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <?php if( $i%$cols == 0 || $i==count($products) ) { ?>
                </div>
                <?php } ?>

                <?php } ?>
            </div>
        </div>
        <script type="text/javascript">
                    $(document).ready(function() {
            $('.pav-colorbox').colorbox({
            width: '890px',
                    height: '750px',
                    overlayClose: true,
                    opacity: 0.5,
                    iframe: true,
            });
            });        </script>


        <div class="pagination"><?php echo $pagination; ?></div>
        <?php } ?>
        <?php if (!$categories && !$products) { ?>
        <div class="content"><?php echo $text_empty; ?></div>
        <div class="buttons">
            <div class="right"><a href="<?php echo $continue; ?>" class="button"><?php echo $button_continue; ?></a></div>
        </div>
        <?php } ?>
        <?php echo $content_bottom; ?></div>
    <script type="text/javascript"><!--
    function display(view) {
                if (view == 'list') {
                $('.product-grid').attr('class', 'product-list');
                        $('.products-block  .product-block').each(function(index, element) {

                $(element).parent().addClass("col-fullwidth");
                });
                        $('.display').html('<span style="float: left;"><?php echo $text_display; ?></span><a class="list active fa fa-th-list"><em><?php echo $text_list; ?></em></a><a class="grid fa fa-th-large"  onclick="display(\'grid\');"><em><?php echo $text_grid; ?></em></a>');
                        $.totalStorage('display', 'list');
                } else {
                $('.product-list').attr('class', 'product-grid');
                        $('.products-block  .product-block').each(function(index, element) {
                $(element).parent().removeClass("col-fullwidth");
                });
                        $('.display').html('<span style="float: left;"><?php echo $text_display; ?></span><a class="list fa fa-th-list" onclick="display(\'list\');"></span><em><?php echo $text_list; ?></em></a><a class="grid active fa fa-th-large"><em><?php echo $text_grid; ?></em></a>');
                        $.totalStorage('display', 'grid');
                }
                }

        view = $.totalStorage('display');
                if (view) {
        display(view);
        } else {
        display('<?php echo $DISPLAY_MODE;?>');
        }
//--></script> 
    <?php if( $categoryPzoom ) {  ?>
    <script type="text/javascript"><!--
        $(document).ready(function() {
        $('.colorbox').colorbox({
        overlayClose: true,
                opacity: 0.5,
                rel: false,
                onLoad: function() {
                $("#cboxNext").remove(0);
                        $("#cboxPrevious").remove(0);
                        $("#cboxCurrent").remove(0);
                }
        });
        });
//--></script>
    <?php } ?>
</section> 

<?php if( $SPAN[2] ): ?>
<aside class="col-lg-<?php echo $SPAN[2];?> col-md-<?php echo $SPAN[2];?> col-sm-12 col-xs-12">	
    <?php echo $column_right; ?>
</aside>
<?php endif; ?>

<?php echo $footer; ?>