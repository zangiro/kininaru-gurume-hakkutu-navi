# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_17_051902) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "area_tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "post_id"
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "dishes", force: :cascade do |t|
    t.string "introduction"
    t.text "description", null: false
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_dishes_on_post_id"
  end

  create_table "genre_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_likes_on_post_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "outher_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "playlists", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "post_area_tags", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "area_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_tag_id"], name: "index_post_area_tags_on_area_tag_id"
    t.index ["post_id"], name: "index_post_area_tags_on_post_id"
  end

  create_table "post_genre_tags", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "genre_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_tag_id"], name: "index_post_genre_tags_on_genre_tag_id"
    t.index ["post_id"], name: "index_post_genre_tags_on_post_id"
  end

  create_table "post_outher_tags", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "outher_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["outher_tag_id"], name: "index_post_outher_tags_on_outher_tag_id"
    t.index ["post_id"], name: "index_post_outher_tags_on_post_id"
  end

  create_table "post_playlists", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "playlist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_post_playlists_on_playlist_id"
    t.index ["post_id"], name: "index_post_playlists_on_post_id"
  end

  create_table "post_taste_tags", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "taste_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_taste_tags_on_post_id"
    t.index ["taste_tag_id"], name: "index_post_taste_tags_on_taste_tag_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.string "source"
    t.string "store_url"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "taste_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "name", null: false
    t.boolean "is_public", null: false
    t.string "introduction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  create_table "view_histories", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_view_histories_on_post_id"
    t.index ["user_id"], name: "index_view_histories_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "dishes", "posts"
  add_foreign_key "likes", "posts"
  add_foreign_key "likes", "users"
  add_foreign_key "playlists", "users"
  add_foreign_key "post_area_tags", "area_tags"
  add_foreign_key "post_area_tags", "posts"
  add_foreign_key "post_genre_tags", "genre_tags"
  add_foreign_key "post_genre_tags", "posts"
  add_foreign_key "post_outher_tags", "outher_tags"
  add_foreign_key "post_outher_tags", "posts"
  add_foreign_key "post_playlists", "playlists"
  add_foreign_key "post_playlists", "posts"
  add_foreign_key "post_taste_tags", "posts"
  add_foreign_key "post_taste_tags", "taste_tags"
  add_foreign_key "posts", "users"
  add_foreign_key "view_histories", "posts"
  add_foreign_key "view_histories", "users"
end
