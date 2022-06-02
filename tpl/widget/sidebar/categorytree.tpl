[{if $oxcmp_categories}]
[{assign var="categories" value=$oxcmp_categories->getClickRoot()}]
[{assign var="act" value=$oxcmp_categories->getClickCat()}]
[{if $categories}]
[{assign var="deepLevel" value=$oView->getDeepLevel()}]
<nav class="categoryBox">
    <ul class="oxcattree" id="tree">
    [{function name="tree" categories=$categories}]
        [{assign var="deepLevel" value=$deepLevel+1}]
        [{assign var="oContentCat" value=$oView->getContentCategory()}]
        [{foreach from=$categories item=_cat}]
            [{if $_cat->getIsVisible()}]
                [{* CMS category *}]
                [{if $_cat->getContentCats() && $deepLevel > 1}]
                    [{foreach from=$_cat->getContentCats() item=_oCont}]
                    <li class="[{if $oContentCat==$_oCont->getId()}] active [{/if}] end" >
                        <a href="[{$_oCont->getLink()}]"><i></i>[{$_oCont->oxcontents__oxtitle->value}]</a>
                    </li>
                    [{/foreach}]
                [{/if}]
                [{* subcategories *}]
                <li class="[{if !$oContentCat && $act && $act->getId()==$_cat->getId()}]active[{elseif $_cat->expanded}]exp[{/if}][{if !$_cat->hasVisibleSubCats}] end[{/if}]">
                    <a href="[{$_cat->getLink()}]"><i><span></span></i>[{$_cat->oxcategories__oxtitle->value}] [{if $oView->showCategoryArticlesCount() && ($_cat->getNrOfArticles() > 0)}] ([{$_cat->getNrOfArticles()}])[{/if}]</a>
                    [{if $_cat->getSubCats() && $_cat->expanded}]
                        <ul>[{oxcattree categories=$_cat->getSubCats()}]</ul>
                    [{/if}]
                </li>
            [{/if}]
        [{/foreach}]
    [{/function}]
    </ul>
    [{block name="categorytree_extended"}]
    [{/block}]
</nav>
[{/if}]
[{/if}]
