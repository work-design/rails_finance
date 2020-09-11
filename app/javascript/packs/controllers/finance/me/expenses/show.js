$('#expense_payment_method_id').dropdown()
$('[data-title="expense_member_member"]').dropdown({
  apiSettings: {
    url: '/my/member/search?q={query}',
  },
  fields: {
    name: 'name',
    value: 'id'
  }
})
