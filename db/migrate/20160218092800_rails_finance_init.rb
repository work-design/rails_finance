class RailsFinanceInit < ActiveRecord::Migration[5.0]
  def change

    create_table "expense_members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.bigint "expense_id"
      t.bigint "member_id"
      t.bigint "payment_method_id"
      t.decimal "amount", precision: 10, scale: 2
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "state"
      t.string "note"
      t.decimal "advance", precision: 10, scale: 2
      t.index ["expense_id"], name: "index_expense_members_on_expense_id"
      t.index ["member_id"], name: "index_expense_members_on_member_id"
      t.index ["payment_method_id"], name: "index_expense_members_on_payment_method_id"
    end

    create_table "expenses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.bigint "creator_id"
      t.string "type"
      t.string "subject"
      t.string "state"
      t.decimal "amount", precision: 10, scale: 2
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "note", limit: 4096
      t.integer "invoices_count"
      t.bigint "financial_taxon_id"
      t.integer "payment_method_id"
      t.integer "payout_id"
      t.bigint "verifier_id"
      t.index ["creator_id"], name: "index_expenses_on_creator_id"
      t.index ["financial_taxon_id"], name: "index_expenses_on_financial_taxon_id"
      t.index ["verifier_id"], name: "index_expenses_on_verifier_id"
    end

    create_table "financial_taxon_hierarchies", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
      t.integer "ancestor_id", null: false
      t.integer "descendant_id", null: false
      t.integer "generations", null: false
      t.index ["ancestor_id", "descendant_id", "generations"], name: "financial_taxon_anc_desc_idx", unique: true
      t.index ["descendant_id"], name: "financial_taxon_desc_idx"
    end

    create_table "financial_taxons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.string "name"
      t.integer "position", default: 1
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "parent_id"
      t.bigint "verifier_id"
      t.boolean "take_stock", default: false
      t.boolean "individual", default: false
      t.index ["parent_id"], name: "index_financial_taxons_on_parent_id"
      t.index ["verifier_id"], name: "index_financial_taxons_on_verifier_id"
    end

    create_table "payouts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
      t.string "type"
      t.decimal "requested_amount", precision: 10, scale: 2
      t.string "payout_uuid"
      t.string "state"
      t.string "to_bank"
      t.string "to_name"
      t.string "to_identifier"
      t.datetime "paid_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.decimal "actual_amount", precision: 10, scale: 2
      t.bigint "operator_id"
      t.integer "payment_method_id"
      t.string "payable_type"
      t.bigint "payable_id"
      t.boolean "advance", default: false
      t.index ["operator_id"], name: "index_payouts_on_operator_id"
      t.index ["payable_type", "payable_id"], name: "index_payouts_on_payable_type_and_payable_id"
    end


  end
end
