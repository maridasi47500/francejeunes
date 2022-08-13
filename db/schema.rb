# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_05_212715) do

  create_table "accesscodes", force: :cascade do |t|
    t.string "code"
    t.integer "member_id"
    t.integer "buycode_id"
  end

  create_table "alerts", force: :cascade do |t|
    t.integer "member_id"
    t.boolean "article"
    t.boolean "musique"
    t.boolean "forum"
    t.boolean "image"
    t.boolean "rencontres"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.text "content"
    t.integer "member_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image"
    t.integer "category_id"
    t.boolean "noprivate"
  end

  create_table "articlestars", force: :cascade do |t|
    t.integer "star"
    t.integer "member_id"
    t.integer "article_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url"
    t.integer "member_id"
  end

  create_table "buycodes", force: :cascade do |t|
    t.string "email"
    t.string "cvc"
    t.date "ccexp"
    t.string "ccname"
    t.integer "cardnumber"
    t.float "price"
    t.integer "member_id"
    t.boolean "rememberemail"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "nb"
    t.string "url"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "member_id"
    t.integer "article_id"
    t.text "content"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
  end

  create_table "dedicaces", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "member_id"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "departements", force: :cascade do |t|
    t.string "name"
    t.integer "no"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "forumcats", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "forumcommentaires", force: :cascade do |t|
    t.integer "forum_id"
    t.integer "member_id"
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "forums", force: :cascade do |t|
    t.integer "forumsubcat_id"
    t.integer "member_id"
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "forumsubcats", force: :cascade do |t|
    t.integer "forumcat_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer "sousrubimage_id"
    t.string "title"
    t.string "image"
    t.integer "member_id"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "members", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username", default: "", null: false
    t.string "lastname", default: "", null: false
    t.string "firstname", default: "", null: false
    t.string "sex", default: "", null: false
    t.string "city_id", default: "", null: false
    t.string "country_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "dateofbirth"
    t.integer "departement_id"
    t.string "couple"
    t.string "image"
    t.string "aime"
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "member_id"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "paragraphes", force: :cascade do |t|
    t.integer "article_id"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.integer "member_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "privateforums", force: :cascade do |t|
    t.text "content"
    t.string "title"
    t.integer "member_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "updatemember_id"
  end

  create_table "privatemessages", force: :cascade do |t|
    t.integer "privateforum_id"
    t.text "content"
    t.string "title"
    t.integer "member_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "image"
    t.string "name"
    t.time "dispo"
    t.string "price"
  end

  create_table "rubriqueimages", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "songs", force: :cascade do |t|
    t.string "title"
    t.integer "artist_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "member_id"
    t.text "content"
    t.integer "contentmember_id"
    t.string "url"
    t.string "youtubelink_id"
    t.integer "videomember_id"
  end

  create_table "sousrubimages", force: :cascade do |t|
    t.integer "rubriqueimage_id"
    t.string "name"
    t.string "image"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "vuearticles", force: :cascade do |t|
    t.integer "article_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "member_id"
  end

  create_table "vuefiches", force: :cascade do |t|
    t.integer "vuemember_id"
    t.integer "member_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "vueforums", force: :cascade do |t|
    t.integer "member_id"
    t.integer "forum_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "vuesongs", force: :cascade do |t|
    t.integer "member_id"
    t.integer "song_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "webeauties", force: :cascade do |t|
    t.integer "beautymember_id"
    t.integer "member_id"
    t.integer "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
