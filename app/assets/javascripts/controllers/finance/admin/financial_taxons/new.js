import 'rails_taxon/form'
$('#financial_taxon_verifier_id').dropdown({
  apiSettings: {
    url: '/my/member/search?q={query}',
  },
  fields: {
    name: 'name',
    value: 'id'
  }
})
