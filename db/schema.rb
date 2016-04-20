# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160420024207) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                   default: 0,  null: false
    t.integer  "organization_id"
    t.integer  "user_id"
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["organization_id", "user_id"], name: "index_accounts_on_organization_id_and_user_id", unique: true, using: :btree
  add_index "accounts", ["organization_id"], name: "index_accounts_on_organization_id", using: :btree
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree
  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id", null: false
    t.integer  "lead_id",     null: false
    t.integer  "message_id",  null: false
    t.string   "body",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "answers", ["lead_id"], name: "index_answers_on_lead_id", using: :btree
  add_index "answers", ["message_id"], name: "index_answers_on_message_id", unique: true, using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "inquiries", force: :cascade do |t|
    t.integer  "message_id",  null: false
    t.integer  "lead_id",     null: false
    t.integer  "question_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "inquiries", ["lead_id", "question_id"], name: "index_by_search_lead_and_search_question", unique: true, using: :btree
  add_index "inquiries", ["lead_id"], name: "index_inquiries_on_lead_id", using: :btree
  add_index "inquiries", ["message_id"], name: "index_inquiries_on_message_id", using: :btree
  add_index "inquiries", ["question_id"], name: "index_inquiries_on_question_id", using: :btree

  create_table "leads", force: :cascade do |t|
    t.integer  "user_id",         null: false
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "leads", ["organization_id", "user_id"], name: "index_leads_on_organization_id_and_user_id", unique: true, using: :btree
  add_index "leads", ["organization_id"], name: "index_leads_on_organization_id", using: :btree
  add_index "leads", ["user_id"], name: "index_leads_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "sid",             null: false
    t.text     "media_url"
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "messages", ["organization_id"], name: "index_messages_on_organization_id", using: :btree
  add_index "messages", ["sid"], name: "index_messages_on_sid", unique: true, using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",               null: false
    t.string   "twilio_account_sid"
    t.string   "twilio_auth_token"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name", unique: true, using: :btree

  create_table "phones", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.string   "title",           null: false
    t.string   "number",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "phones", ["organization_id"], name: "index_phones_on_organization_id", unique: true, using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "label",                       null: false
    t.string   "body",                        null: false
    t.string   "summary",                     null: false
    t.integer  "category",        default: 0, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "organization_id",             null: false
  end

  add_index "questions", ["organization_id"], name: "index_questions_on_organization_id", using: :btree

  create_table "referrals", force: :cascade do |t|
    t.integer  "lead_id",     null: false
    t.integer  "referrer_id", null: false
    t.integer  "message_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "referrals", ["lead_id"], name: "index_referrals_on_lead_id", using: :btree
  add_index "referrals", ["message_id"], name: "index_referrals_on_message_id", using: :btree
  add_index "referrals", ["referrer_id"], name: "index_referrals_on_referrer_id", using: :btree

  create_table "referrers", force: :cascade do |t|
    t.integer  "user_id",         null: false
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "referrers", ["organization_id", "user_id"], name: "index_referrers_on_organization_id_and_user_id", unique: true, using: :btree
  add_index "referrers", ["organization_id"], name: "index_referrers_on_organization_id", using: :btree
  add_index "referrers", ["user_id"], name: "index_referrers_on_user_id", using: :btree

  create_table "search_leads", force: :cascade do |t|
    t.integer  "search_id",  null: false
    t.integer  "lead_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "search_leads", ["lead_id"], name: "index_search_leads_on_lead_id", using: :btree
  add_index "search_leads", ["search_id", "lead_id"], name: "index_search_leads_on_search_id_and_lead_id", unique: true, using: :btree
  add_index "search_leads", ["search_id"], name: "index_search_leads_on_search_id", using: :btree

  create_table "search_questions", force: :cascade do |t|
    t.integer  "search_id",            null: false
    t.integer  "question_id",          null: false
    t.integer  "next_question_id"
    t.integer  "previous_question_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "search_questions", ["next_question_id"], name: "index_search_questions_on_next_question_id", using: :btree
  add_index "search_questions", ["previous_question_id"], name: "index_search_questions_on_previous_question_id", using: :btree
  add_index "search_questions", ["question_id"], name: "index_search_questions_on_question_id", using: :btree
  add_index "search_questions", ["search_id", "question_id"], name: "index_search_questions_on_search_id_and_question_id", unique: true, using: :btree
  add_index "search_questions", ["search_id"], name: "index_search_questions_on_search_id", using: :btree

  create_table "searches", force: :cascade do |t|
    t.integer  "account_id", null: false
    t.string   "label",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "searches", ["account_id"], name: "index_searches_on_account_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id",         null: false
    t.integer  "organization_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "subscriptions", ["organization_id", "user_id"], name: "index_subscriptions_on_organization_id_and_user_id", unique: true, where: "(deleted_at IS NULL)", using: :btree
  add_index "subscriptions", ["organization_id"], name: "index_subscriptions_on_organization_id", where: "(deleted_at IS NULL)", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", where: "(deleted_at IS NULL)", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",   default: ""
    t.string   "last_name",    default: ""
    t.string   "phone_number",              null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "users", ["phone_number"], name: "index_users_on_phone_number", unique: true, using: :btree

  add_foreign_key "accounts", "organizations"
  add_foreign_key "accounts", "users"
  add_foreign_key "answers", "leads"
  add_foreign_key "answers", "messages"
  add_foreign_key "answers", "questions"
  add_foreign_key "inquiries", "leads"
  add_foreign_key "inquiries", "messages"
  add_foreign_key "inquiries", "questions"
  add_foreign_key "leads", "organizations"
  add_foreign_key "leads", "users"
  add_foreign_key "messages", "organizations"
  add_foreign_key "phones", "organizations"
  add_foreign_key "questions", "organizations"
  add_foreign_key "referrals", "leads"
  add_foreign_key "referrals", "messages"
  add_foreign_key "referrals", "referrers"
  add_foreign_key "referrers", "organizations"
  add_foreign_key "referrers", "users"
  add_foreign_key "search_leads", "leads"
  add_foreign_key "search_leads", "searches"
  add_foreign_key "search_questions", "questions"
  add_foreign_key "search_questions", "searches"
  add_foreign_key "searches", "accounts"
  add_foreign_key "subscriptions", "organizations"
  add_foreign_key "subscriptions", "users"
end
