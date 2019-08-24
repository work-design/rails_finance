$('[data-title="expense_item_member"]').dropdown({
  apiSettings: {
    url: '/my/member/search?q={query}',
  },
  fields: {
    name: 'name',
    value: 'id'
  }
});

$('[data-title="expense_item_financial_taxon"]').dropdown({
  placeholder: true
});

$('#expense_financial_taxon_id').dropdown({
  onChange: function (value, text, $selectedItem) {
    var search_url = new URL(window.location.origin);
    search_url.pathname = 'my/expenses/financial_taxons';
    search_url.search = $.param({financial_taxon_id: value});

    var data = new FormData(this.form);
    data.delete('_method');

    Rails.ajax({url: search_url, type: 'POST', body: data});
  }
});

$('[name*="expense[expense_items_attributes]["]').filter('[name$="][price]"]').on('change', function() {
  var names = this.id.split('_');
  names.pop();
  var _quantity = names.concat('quantity').join('_');
  var _budget = names.concat('budget').join('_');
  var quantity = document.getElementById(_quantity);
  document.getElementById(_budget).value = (this.value * quantity.value).toFixed(2);
});

$('[name*="expense[expense_items_attributes]["]').filter('[name$="][quantity]"]').on('change', function() {
  var names = this.id.split('_');
  names.pop();
  var _price = names.concat('price').join('_');
  var _budget = names.concat('budget').join('_');
  var price = document.getElementById(_price);
  document.getElementById(_budget).value = (this.value * price.value).toFixed(2);
});
