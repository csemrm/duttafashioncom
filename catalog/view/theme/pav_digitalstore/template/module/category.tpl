<?php if ($categories) { ?>

<div>
    <div class="mainnav-wrap">
        <div class="navbar navbar-inverse "> 
            <nav id="mainmenutop" class="pav-megamenu" role="navigation"> 
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse3" data-target=".navbar-ex3-collapse">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                </div>

                <div class="collapse3 navbar-collapse navbar-ex3-collapse products_menu">
                    <ul class="menu">
                        <?php foreach ($categories as $category) { ?>

                        <?php // if ($category['children']) { ?>			
                        <li class="parent"><a href="<?php echo $category['href']; ?>"><?php echo $category['name']; ?></a>
                                <!--b class="caret"></b>
                            </a>
                        </li>
                            <?php //} else { ?>
                            <!--li ><a href="<?php echo $category['href']; ?>"><?php echo $category['name']; ?></a>
                                <?php //} ?>
                                <?php  if ($category['children']) { ?>
                                <!ul class="dropdown-menu">
                                    <?php for ($i = 0; $i < count($category['children']);) { ?>

                                    <?php $j = $i + ceil(count($category['children']) / $category['column']); ?>
                                    <?php for (; $i < $j; $i++) { ?>
                                    <?php if (isset($category['children'][$i])) { ?>
                                    <li><a href="<?php echo $category['children'][$i]['href']; ?>"><?php echo $category['children'][$i]['name']; ?></a></li>
                                    <?php } ?>
                                    <?php } ?>

                                    <?php } ?>
                                </ul>
                                <?php } ?>
                            </li-->
                            <?php } ?>
                    </ul>
                </div>
            </nav>

        </div>

    </div>


</div>

<?php } ?>